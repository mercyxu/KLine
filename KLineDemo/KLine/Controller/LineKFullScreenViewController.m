//
//  CFKLineFullScreenViewController.m
//
//  Created by Zhimi on 2018/9/3.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "LineKFullScreenViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "Y_KLineModel.h"
#import "BTBiModel.h"
#import "BTMarketModel.h"
#import "BTDealMarketModel.h"
#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
#import "BTTargetView.h"

@interface LineKFullScreenViewController ()<Y_StockChartViewDelegate,Y_StockChartViewDataSource,SRWebSocketDelegate>


@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UILabel *zfLabel;
@property (strong, nonatomic)  UILabel *highLabel;
@property (strong, nonatomic)  UILabel *lowLabel;
@property (strong, nonatomic)  UILabel *volLabel;

@property (strong, nonatomic)  UIButton *closeButton;
@property (strong, nonatomic)  Y_StockChartView *lineKView;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) Y_KLineGroupModel *groupModel;
@property (nonatomic, assign) int klineRequestID;
@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;

@property (nonatomic, strong) SRWebSocket *ws1;

@property (nonatomic, strong) SRWebSocket *ws3;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LineKFullScreenViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    _lineKView.isFullScreen = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.view.backgroundColor = RGB(21, 32, 54);
    [self setuptopView];
    self.currentIndex = -1;
    _lineKView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 50, KScreenHeight - 50 - SafeAreaBottomHeight, KScreenWidth-50 + 0)];
    _lineKView.backgroundColor = RGB(21, 32, 54);
    _lineKView.isFullScreen = YES;
    _lineKView.itemModels = @[
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"分时") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"5分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"15分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"30分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1小时") type:Y_StockChartcenterViewTypeKline],
//                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"4小时") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"日线") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1周") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1月") type:Y_StockChartcenterViewTypeKline],
//                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"指标") type:Y_StockChartcenterViewTypeOther],
                              ];
    _lineKView.dataSource = self;
    _lineKView.delegate = self;
    [self.view addSubview:_lineKView];
    [self addLinesView];
    
    [self loadBiTopData];
    
    //最新价推送
    self.ws1 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=LatestDeal_%@_%@_4",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws1.delegate = self;
    [self.ws1 open];

    //K线推送
    self.ws3 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=Kline_4_19_%@",URL_pushMain,self.type)]]];
    //    self.ws3 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=Kline_%@_%@_15",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws3.delegate = self;
    [self.ws3 open];
    
    [self addTargetView];
}

#pragma mark - 指标按钮
- (void)addTargetView
{
    BTTargetView *view = [BTTargetView GetTargetView_Frame:CGRectMake(_lineKView.frame.size.width, _lineKView.frame.origin.y, 50, _lineKView.frame.size.height)];
    [self.view addSubview:view];
    view.selectBlock = ^(NSInteger section, NSInteger row, id  _Nullable data) {
        // section: 0主图 1副图
        // row: section:0(0:MA 1:EMA 2:BOLL -1:隐藏) section:1(0:MACD 1:KDJ 2:RSI 3:WR -1:隐藏)
        NSInteger index = 0;
        if (section == 0) {
            
            switch (row) {
                case 0:
                case 1:
                case 2:
                    index = 100 + row + 1;
                    break;
                case -1:
                    index = 104;
                default:
                    break;
            }
            
        }else{
            switch (row) {
                case 0:
                case 1:
                case 2:
                case 3:
                    index = 100 + row + 6;
                    break;
                case -1:
                    index = 110;
                default:
                    break;
            }
        }
        
        [self.lineKView fullScreenTargetClickWithIndex:index];
        
    };
}

#pragma mark - 推送
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    //收到服务端发送过来的消息
    NSDictionary *dict = [NSString dictionaryWithJsonString:message];
        if ([dict[@"type"] integerValue] == 4){ //头部最新价
        
        BTDealMarketModel *dealModel = [BTDealMarketModel mj_objectWithKeyValues:dict[@"data"]];
        
        self.priceLabel.text = NSStringFormat(@"%@",dealModel.NewPrice);
        
        if (dealModel.ChangeType == 1) { //涨
            self.priceLabel.textColor = RGB(3, 173, 143);
            self.zfLabel.text = NSStringFormat(@"≈%.4fCNY %@",[dealModel.NewPrice floatValue] * self.marketModel.CurrencyPrice,dealModel.Change);
            [self.zfLabel setRangeSize:1 font:12 starIndex:self.zfLabel.text.length-dealModel.Change.length index:dealModel.Change.length rangeColor:RGB(3, 173, 143)];
        }else{
            self.priceLabel.textColor = RGB(222, 52, 91);
            self.zfLabel.text = NSStringFormat(@"≈%.4fCNY %@",[dealModel.NewPrice floatValue] * self.marketModel.CurrencyPrice,dealModel.Change);
            [self.zfLabel setRangeSize:1 font:12 starIndex:self.zfLabel.text.length-dealModel.Change.length index:dealModel.Change.length rangeColor:RGB(222, 52, 91)];
        }
            self.highLabel.text = NSStringFormat(@"%@ %.4f",BTLanguage(@"高"),dealModel.HighestPrice);
            self.lowLabel.text = NSStringFormat(@"%@ %.4f",BTLanguage(@"低"),dealModel.LowestPrice);
            self.volLabel.text = NSStringFormat(@"24H %.4f",dealModel.DealNum);
            [self.highLabel setFont:FONT_WITH_SIZE(9) starIndex:BTLanguage(@"高").length Index:self.highLabel.text.length-BTLanguage(@"高").length Color:[UIColor whiteColor]];
            [self.lowLabel setFont:FONT_WITH_SIZE(9) starIndex:BTLanguage(@"低").length Index:self.lowLabel.text.length-BTLanguage(@"低").length Color:[UIColor whiteColor]];
            [self.volLabel setFont:FONT_WITH_SIZE(9) starIndex:3 Index:self.volLabel.text.length-3 Color:[UIColor whiteColor]];
    }else if ([dict[@"type"] integerValue] == 21){
        
        self.dataArray = dict[@"data"][@"datas"][@"data"];
        kWeakSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.groupModel != nil &&weakself.dataArray.count > 0) {
                
                Y_KLineModel *lineModel = [weakself.groupModel.models lastObject];
                [lineModel initWithArray:weakself.dataArray[0]];
                //                [weakself.lineKView.kLineView reDraw];
                //
                //                return ;
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:lineModel.Date.doubleValue/1000 + weakself.type.integerValue * 60];
                BOOL  isresh  = [weakself compareDate:[NSDate date] withDate:date];
                
                if (!isresh) {
                    lineModel.Date = [NSString stringWithFormat:@"%@",@(lineModel.Date.doubleValue +1)];
                    [weakself reloadData];
                }else
                {
                    //                NSLog(@"122223312312321321321123");
                }
                NSString *price = NSStringFormat(@"%@",weakself.dataArray[0][4]);
                [weakself.lineKView.kLineView.kLineMainView  uploadPrice:price];
                [weakself.lineKView.kLineView reDraw];
            }
        });
    }
}

//比较两个日期的大小
- (BOOL)compareDate:(NSDate*)stary withDate:(NSDate*)end
{
    NSComparisonResult result = [stary compare: end];
    if (result==NSOrderedSame)
    {
        //相等
        return NO;
    }else if (result==NSOrderedAscending)
    {
        //结束时间大于开始时间
        return YES;
    }else if (result==NSOrderedDescending)
    {
        //结束时间小于开始时间
        return NO;
    }
    return NO;
}

- (void)setuptopView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGB(21, 32, 54);
    topView.frame = CGRectMake(0, 0, KScreenHeight, 50);
    [self.view addSubview:topView];
    
    UIButton *biType = [UIButton buttonWithType:UIButtonTypeCustom];
    [biType setTitle:@"BTC/USDT" forState:UIControlStateNormal];
    biType.titleLabel.font = BOLDSYSTEMFONT(14);
    [biType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topView addSubview:biType];
    
    [biType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(15);
    }];
    
    UILabel *price = [[UILabel alloc] init];
    price.text = NSStringFormat(@"%f",self.biModel.LatestPrice);
    price.textColor = RGB(222, 52, 91);
    price.font = BOLDSYSTEMFONT(14);
    [topView addSubview:price];
    _priceLabel = price;

    UILabel *zfLabel = [[UILabel alloc] init];
    zfLabel.textColor = RGB(136, 143, 158);
    zfLabel.text = NSStringFormat(@"≈%.4fCNY %@",self.biModel.ExchangeAmt * self.biModel.CurrencyRate,self.biModel.Change);
    if (self.biModel.ChangeType == 1) { //涨
        [zfLabel setRangeSize:1 font:12 starIndex:zfLabel.text.length-self.biModel.Change.length index:self.biModel.Change.length rangeColor:RGB(3, 173, 143)];
    }else{
        [zfLabel setRangeSize:1 font:12 starIndex:zfLabel.text.length-self.biModel.Change.length index:self.biModel.Change.length rangeColor:RGB(222, 52, 91)];
    }
    zfLabel.font = FONT_WITH_SIZE(14);
    [topView addSubview:zfLabel];
    _zfLabel = zfLabel;

    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(biType.mas_right).offset(15);
        make.centerY.equalTo(topView);
    }];
    
    [zfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(price.mas_right).offset(10);
        make.centerY.equalTo(topView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:IMAGE_NAMED(@"transaction-takeup-ic") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-15-SafeAreaBottomHeight);
        make.centerY.equalTo(topView);
    }];

    UILabel *high = [[UILabel alloc] init];
    high.textColor = RGB(136, 143, 158);
    high.font = FONT_WITH_SIZE(9);
    [topView addSubview:high];
    _highLabel = high;
    
    UILabel *low = [[UILabel alloc] init];
    low.textColor = RGB(136, 143, 158);
    low.font = FONT_WITH_SIZE(9);
    [topView addSubview:low];
    _lowLabel = low;
    
    UILabel *hour = [[UILabel alloc] init];
    hour.textColor = RGB(136, 143, 158);
    hour.font = FONT_WITH_SIZE(9);
    [topView addSubview:hour];
    _volLabel = hour;
    
    [hour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(closeBtn.mas_left).offset(-15);
    }];
    
    [low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(hour.mas_left).offset(-10);
    }];
    
    [high mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(low.mas_left).offset(-10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(13, 23, 35);
    [topView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(@1);
    }];
}

- (void)loadBiTopData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"CoinId"] = @"4";
    params[@"CurrencyId"] = @"19";
    //获取币币交易详情信息
    kWeakSelf(self)
    [FDNetworkHelper POST:@"http://43.231.184.237:8008/api/TradeCenter/GetTradeInfo" parameters:params success:^(id responseObject) {

            BTMarketModel *marketModel = [BTMarketModel mj_objectWithKeyValues:responseObject[@"data"]];
            weakself.priceLabel.text = NSStringFormat(@"%@",marketModel.DealMarket.NewPrice);
            
            weakself.zfLabel.text = NSStringFormat(@"≈%fCNY %@",[marketModel.DealMarket.NewPrice floatValue],marketModel.DealMarket.Change);
            if (weakself.biModel.ChangeType == 1) { //涨
                [weakself.zfLabel setRangeSize:1 font:14 starIndex:self.zfLabel.text.length-marketModel.DealMarket.Change.length index:marketModel.DealMarket.Change.length rangeColor:RGB(3, 173, 143)];
            }else{
                [weakself.zfLabel setRangeSize:1 font:14 starIndex:self.zfLabel.text.length-marketModel.DealMarket.Change.length index:marketModel.DealMarket.Change.length rangeColor:RGB(222, 52, 91)];
            }
            weakself.highLabel.text = NSStringFormat(@"%@ %.2f",BTLanguage(@"高"),marketModel.DealMarket.HighestPrice);
            weakself.lowLabel.text = NSStringFormat(@"%@ %.2f",BTLanguage(@"低"),marketModel.DealMarket.LowestPrice);
            weakself.volLabel.text = NSStringFormat(@"24H %.2f",marketModel.DealMarket.SumNum);

    } failure:^(NSError *error) {
        
    }];

}

- (void)onClickCloseButton:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.onClickBackButton) {
        self.onClickBackButton(self);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict {
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)addLinesView {
    CGFloat white = _lineKView.bounds.size.height /4;
    CGFloat height = _lineKView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineKView.bounds.size.width , 1)];
        hengView.backgroundColor = RGB(24, 36, 52);
        [_lineKView addSubview:hengView];
        [_lineKView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i< 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 47, 1, _lineKView.bounds.size.height - 62)];
        shuView.backgroundColor = RGB(24, 36, 52);
        [_lineKView addSubview:shuView];
        [_lineKView sendSubviewToBack:shuView];
    }
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 245, 73, 20)];
    [logo setImage:IMAGE_NAMED(@"logo")];
    [_lineKView addSubview:logo];
    [_lineKView sendSubviewToBack:logo];
}

- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //    {"tradeType": "3","CoinId": "4","CurrencyId": "19","LineType": 1
    param[@"tradeType"] = @"3";
    param[@"LineType"] = self.type;
    param[@"CoinId"] = @"4";
    param[@"CurrencyId"] = @"19";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Parameters"] = [param mj_JSONString];
    kWeakSelf(self)

    [FDNetworkHelper POST:@"http://43.231.184.237:8008/api/TradeCenter/GetLineData" parameters:params success:^(id responseObject) {

        if (responseObject[@"data"]) {
            if ([responseObject[@"data"][@"datas"][@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"][@"datas"][@"data"] isEqual:[NSNull null]] || responseObject[@"data"][@"datas"][@"data"] == nil) {
                return ;
            }
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"][@"datas"][@"data"]];
            weakself.groupModel = groupModel;
            [weakself.modelsDict setObject:groupModel forKey:weakself.type];
            [weakself.lineKView reloadData];
        }else{
            NSLog(@"%@",responseObject);
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark - Y_StockChartViewDelegate

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType{
//    if (!_isShowKLineFullScreenViewController) {
//        [self showKLineFullScreenViewController];
//    }
}

#pragma mark - Y_StockChartViewDataSource

-(id)stockDatasWithIndex:(NSInteger)index {
    NSString *type;
    switch (index) {
        case 0:type = @"1";//@"1min";
            break;
        case 1:type = @"1";//@"1min";
            break;
        case 2:type = @"5";//@"5m";
            break;
        case 3:type = @"15";//@"15m";
            break;
        case 4:type = @"30";//
            break;
        case 5:type = @"60";//@"1min";
            break;
        case 6:type = @"1440";//@"5min";
            break;
        case 7:type = @"10080";//@"1week";
            break;
        case 8:type = @"43200";//@"1month";
            break;
        default:
            break;
    }

    self.currentIndex = index;
    self.type = type;
    _lineKView.isMoreTimeDataUpdate = NO;
//    if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4) {
//        _lineKView.isMoreTimeDataUpdate = NO;
//    }
//    else{
//        _lineKView.isMoreTimeDataUpdate = YES;
//    }
    if(![self.modelsDict objectForKey:type]){
        [self reloadData];
    }
    else{
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
