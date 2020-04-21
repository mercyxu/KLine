//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "BTStockChartViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "BTBiModel.h"
#import "BTDealMarketModel.h"
#import "BTMarketModel.h"
#import "LineKFullScreenViewController.h"
#import "UIViewController+INMOChildViewControlers.h"
#import "Y_KLineModel.h"
#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
#import "BTScreenshotsPopView.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH MAX(KScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define KHeaderHeight 100+410+10

typedef NS_ENUM(NSInteger, KLineTimeType) {
    KLineTimeTypeMinute = 100,
    KLineTimeTypeMinute5,
    KLineTimeTypeMinute15,
    KLineTimeTypeMinute30,
    KLineTimeTypeHour,
    KLineTimeTypeHour4,
    KLineTimeTypeDay,
    KLineTimeTypeWeek,
    KLineTimeTypeMonth,
    KLineTimeTypeOther
};
static NSString *const contentCellID = @"contentCellID";
static NSString *const dealCellID = @"dealCellID";
static NSString *const biInfoCellID = @"biInfoCellID";
static NSString *const biInfoDesCellID = @"biInfoDesCellID";
static NSString *const depthCellID = @"depthCellID";
@interface BTStockChartViewController ()<Y_StockChartViewDataSource,Y_StockChartViewDelegate,UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Y_StockChartView *lineKView;

@property (assign, nonatomic) BOOL isShowKLineFullScreenViewController;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@property (strong, nonatomic) UILabel *price;

@property (strong, nonatomic) UILabel *zfLabel;

@property (strong, nonatomic) UILabel *rightL;

//分段选择
@property (nonatomic, assign) NSInteger biInfoType;
//成交数组
@property (nonatomic, strong) NSMutableArray *dealArray;
//币种简介标题
@property (nonatomic, strong) NSArray *biInfoTitleArray;
//币种简介描述
@property (nonatomic, strong) NSArray *biInfoDesArray;
//筛选面板
@property (nonatomic, assign) BOOL isShowBiBan;
//头部model
@property (nonatomic, strong) BTMarketModel *marketModel;
//币列表
@property (nonatomic, strong) NSMutableArray *marketModelArr;
//是否收藏
//@property (nonatomic, assign) BOOL isCollect;
//收藏按钮
@property (nonatomic, strong) UIButton *collect;

@property (nonatomic, strong) SRWebSocket *ws1;

@property (nonatomic, strong) SRWebSocket *ws2;

@property (nonatomic, strong) SRWebSocket *ws3;

@property (nonatomic, strong) SRWebSocket *ws4;

@property (nonatomic, strong) SRWebSocket *ws5;
//全屏K线
@property (nonatomic, strong) LineKFullScreenViewController *lineKFullScreenViewController;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic,assign) BOOL isHidden;

@end

@implementation BTStockChartViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}

- (void)dealloc
{
    if (self.ws1){
        [self.ws1 close];
        self.ws1 = nil;
    }
    
    if (self.ws2){
        [self.ws2 close];
        self.ws2 = nil;
    }
    
    if (self.ws3){
        [self.ws3 close];
        self.ws3 = nil;
    }
    
    if (self.ws4){
        [self.ws4 close];
        self.ws4 = nil;
    }
    
    if (self.ws5){
        [self.ws5 close];
        self.ws5 = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dealArray
{
    if (_dealArray == nil) {
        _dealArray = [[NSMutableArray alloc] init];
    }
    return _dealArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全屏" style:UIBarButtonItemStylePlain target:self action:@selector(full)];
    
    self.view.backgroundColor = RGB(13, 23, 35);
    self.currentIndex = -1;
    self.isHidden = YES;
     //导航栏
    [self setupNavView];
    //初始化tableView
    [self setupTableView];
    //初始化头部
    [self setuptopView];
    //加载头部数据
    [self loadBiTopData];
    //加载深度
    [self loadDepthData];

    //最新价推送
    self.ws1 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=LatestDeal_%@_%@_2",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws1.delegate = self;
    [self.ws1 open];
    //最新成交
    self.ws2 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=LatestDeal_%@_%@_4",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws2.delegate = self;
    [self.ws2 open];

    //K线推送
    self.ws3 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=Kline_4_19_%@",URL_pushMain,self.type)]]];
//    self.ws3 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=Kline_%@_%@_15",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws3.delegate = self;
    [self.ws3 open];

    self.ws4 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=%@_%@_18",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws4.delegate = self;
    [self.ws4 open];

    self.ws5 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=%@_%@_19",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId)]]];
    self.ws5.delegate = self;
    [self.ws5 open];

}

#pragma mark - 推送
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    //收到服务端发送过来的消息
    NSDictionary *dict = [NSString dictionaryWithJsonString:message];
    if ([dict[@"type"] integerValue] == 2){ //最新成交

    }else if ([dict[@"type"] integerValue] == 4){ //头部最新价
        

    }else if ([dict[@"type"] integerValue] == 21){
        
        self.dataArray = dict[@"data"][@"datas"][@"data"];
        kWeakSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.groupModel != nil &&weakself.dataArray.count > 0) {
//                NSLog(@"%@",self.dataArray[0]);
                Y_KLineModel *lineModel = [self.groupModel.models lastObject];
                [lineModel initWithArray:self.dataArray[0]];
//                [weakself.lineKView.kLineView reDraw];
//
//                return ;

                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:lineModel.Date.doubleValue/1000 + self.type.integerValue * 60];
                BOOL  isresh  = [weakself compareDate:[NSDate date] withDate:date];
                
                if (!isresh) {
                    lineModel.Date = [NSString stringWithFormat:@"%@",@(lineModel.Date.doubleValue +1)];
                    [self reloadData];
                }else
                {
                    //                NSLog(@"122223312312321321321123");
                }
//                NSString * price = [NSString stringWithFormat:@"%@ ",[EXUnit formatternumber:modle.quote_asset_precision.intValue assess:modle.last]];
                NSString *price = NSStringFormat(@"%@",self.dataArray[0][4]);
                [weakself.lineKView.kLineView.kLineMainView  uploadPrice:price];
                [weakself.lineKView.kLineView drawMainView];
            }
        });
    }else if ([dict[@"type"] integerValue] == 18){
        
        
    }else if ([dict[@"type"] integerValue] == 19){
    }
}

//比较两个日期的大小
- (BOOL)compareDate:(NSDate*)stary withDate:(NSDate*)end
{
    NSComparisonResult result = [stary compare: end];
    if (result==NSOrderedSame)
    {
        //相等
//        NSLog(@"1111111");
        return NO;
    }else if (result==NSOrderedAscending)
    {
        //结束时间大于开始时间
//        NSLog(@"22222222");
        return YES;
    }else if (result==NSOrderedDescending)
    {
        //结束时间小于开始时间
//        NSLog(@"333333333");
        return NO;
    }
    return NO;
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight-kTopHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB(13, 23, 35);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (void)setupNavView
{
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = RGB(21, 32, 54);
    [self.view addSubview:navView];
    kWeakSelf(self)
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakself.view);
        make.height.equalTo(@(kTopHeight));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(13, 23, 35);
    [navView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(navView);
        make.height.equalTo(@1);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [backBtn setImage:IMAGE_NAMED(@"app_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    [navView addSubview:collect];
    _collect = collect;
    
    UIButton *full = [UIButton buttonWithType:UIButtonTypeCustom];
    [full setImage:IMAGE_NAMED(@"line_quanp") forState:UIControlStateNormal];
    [navView addSubview:full];
    
//    [full addTapBlock:^(UIButton *btn) {
//
//        [weakself showKLineFullScreenViewController];
//
//    }];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:IMAGE_NAMED(@"line_share") forState:UIControlStateNormal];
    [navView addSubview:share];
    

    [full mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(share.mas_left).offset(-15);
        make.centerY.equalTo(share);
    }];
    
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(full.mas_left).offset(-15);
        make.centerY.equalTo(share);
    }];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setuptopView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGB(21, 32, 54);
    topView.height = KHeaderHeight;
    self.tableView.tableHeaderView = topView;
    
    UIView *biTopInfo = [[UIView alloc] init];
    biTopInfo.backgroundColor = RGB(21, 32, 54);
    [topView addSubview:biTopInfo];
    
    [biTopInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(topView);
        make.height.equalTo(@100);
    }];
    
    _lineKView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 410)];
    _lineKView.backgroundColor = RGB(21, 32, 54);
    _lineKView.isFullScreen = NO;
    _isShowKLineFullScreenViewController = NO;
    _lineKView.itemModels = @[
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"分时") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"15分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1小时") type:Y_StockChartcenterViewTypeKline],
//                              [Y_StockChartViewItemModel itemModelWithTitle:@"4小时" type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"日线") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"更多") type:Y_StockChartcenterViewTypeOther],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"指标") type:Y_StockChartcenterViewTypeOther],
                              ];
    _lineKView.dataSource = self;
    _lineKView.delegate = self;
    [self addLinesView];
    [topView addSubview:self.lineKView];
    
    UILabel *price = [[UILabel alloc] init];
    price.text = NSStringFormat(@"%f",self.biModel.LatestPrice);
    price.textColor = RGB(222, 52, 91);
    price.font = BOLDSYSTEMFONT(24);
    [biTopInfo addSubview:price];
    _price = price;
    
    UILabel *zfLabel = [[UILabel alloc] init];
    zfLabel.textColor = RGB(98, 124, 158);
    zfLabel.text = NSStringFormat(@"≈%fCNY %@",self.biModel.ExchangeAmt * self.biModel.CurrencyRate,self.biModel.Change);
    if (self.biModel.ChangeType == 1) { //涨
        [zfLabel setRangeSize:1 font:14 starIndex:zfLabel.text.length-self.biModel.Change.length index:self.biModel.Change.length rangeColor:RGB(3, 173, 143)];
    }else{
        [zfLabel setRangeSize:1 font:14 starIndex:zfLabel.text.length-self.biModel.Change.length index:self.biModel.Change.length rangeColor:RGB(222, 52, 91)];
    }
    zfLabel.font = FONT_WITH_SIZE(14);
    [biTopInfo addSubview:zfLabel];
    _zfLabel = zfLabel;
    
    UILabel *rightTL = [[UILabel alloc] init];
    rightTL.text = NSStringFormat(@"%@\n%@\n24H",BTLanguage(@"高"),BTLanguage(@"低"));
    rightTL.textColor = RGB(98, 124, 158);
    rightTL.font = FONT_WITH_SIZE(14);
    rightTL.numberOfLines = 3;
    [rightTL setSpace:rightTL.text lineSpace:8 paraSpace:0 alignment:1 kerSpace:0];
    [biTopInfo addSubview:rightTL];

    UILabel *rightL = [[UILabel alloc] init];
    rightL.text = @"--\n--\n--";
    rightL.textColor = RGB(193, 197, 222);
    rightL.font = FONT_WITH_SIZE(14);
    rightL.numberOfLines = 3;
    [rightL setSpace:rightL.text lineSpace:8 paraSpace:0 alignment:3 kerSpace:0];
    [biTopInfo addSubview:rightL];
    _rightL = rightL;
    
    [rightTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.equalTo(rightL);
        make.right.equalTo(rightL.mas_left).offset(-15);
    }];
    
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(biTopInfo).offset(15);
        make.top.equalTo(biTopInfo).offset(17);
    }];
    
    [zfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(price);
        make.top.equalTo(price.mas_bottom).offset(10);
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(biTopInfo).offset(15);
        make.right.equalTo(biTopInfo).offset(-15);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(13, 23, 35);
    [topView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.mas_equalTo(10);
    }];
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

#pragma mark - Y_StockChartViewDataSource

-(id)stockDatasWithIndex:(NSInteger)index {
    NSString *type;
    switch (index) {
        case 0:type = @"1min";//@"1min";
            break;
        case 1:type = @"15min";//@"15min";
            break;
        case 2:type = @"1hour";//@"1hour";
            break;
        case 3:type = @"1day";//@"1day";
            break;
        case 5:type = @"1min";//@"1min";
            break;
        case 6:type = @"5min";//@"5min";
            break;
        case 7:type = @"30min";//@"30min";
            break;
        case 8:type = @"1week";//@"1week";
            break;
        case 9:type = @"1month";//@"1month";
            break;
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    
    if (self.ws3){
        [self.ws3 close];
        self.ws3 = nil;
    }
    
    //K线推送
    self.ws3 = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSStringFormat(@"%@/coindeal?group=Kline_%@_%@_%@",URL_pushMain,self.biModel.CoinId,self.biModel.CurrencyId,self.type)]]];
    self.ws3.delegate = self;
    [self.ws3 open];
    
    if (index == 0 || index == 1 || index == 2 || index == 3) {
        _lineKView.isMoreTimeDataUpdate = NO;
    }
    else{
        _lineKView.isMoreTimeDataUpdate = YES;
    }
    if(![self.modelsDict objectForKey:type]){
        [self reloadData];
    }
    else{
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}


- (void)loadBiTopData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"CoinId"] = @"4";
    params[@"CurrencyId"] = @"19";
    //获取币币交易详情信息
    
    [FDNetworkHelper POST:@"http://43.231.184.237:8008/api/TradeCenter/GetTradeInfo" parameters:params success:^(id responseObject) {
        
        BTMarketModel *marketModel = [BTMarketModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.marketModel = marketModel;
        self.price.text = [Util depthStrPriceWithPrice:[marketModel.DealMarket.NewPrice floatValue] Count:marketModel.DealMarket.PriceDecimal];
        
        self.zfLabel.text = NSStringFormat(@"≈%fCNY %@",[marketModel.DealMarket.NewPrice floatValue],marketModel.DealMarket.Change);
        if (self.biModel.ChangeType == 1) { //涨
            self.price.textColor = RGB(3, 173, 143);
            [self.zfLabel setRangeSize:1 font:14 starIndex:self.zfLabel.text.length-marketModel.DealMarket.Change.length index:marketModel.DealMarket.Change.length rangeColor:RGB(3, 173, 143)];
        }else{
            self.price.textColor = RGB(222, 52, 91);
            [self.zfLabel setRangeSize:1 font:14 starIndex:self.zfLabel.text.length-marketModel.DealMarket.Change.length index:marketModel.DealMarket.Change.length rangeColor:RGB(222, 52, 91)];
        }
        
        self.rightL.text = NSStringFormat(@"%f\n%f\n%f",marketModel.DealMarket.HighestPrice,marketModel.DealMarket.LowestPrice,marketModel.DealMarket.SumNum);
        
    } failure:^(NSError *error) {
        
    }];
}

//深度
- (void)loadDepthData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"CoinId"] = self.biModel.CoinId;
    params[@"CurrencyId"] = self.biModel.CurrencyId;
    //获取币币交易详情信息
//    [FDNetworkHelper POST:NSStringFormat(@"%@%@",URL_main,URL_GetBuySellDeep) parameters:params success:^(id responseObject) {
//
//
//    } failure:^(NSError *error) {
//
//    }];
}

//最新成交价
- (void)loadNewPriceData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"CoinId"] = self.biModel.CoinId;
    params[@"CurrencyId"] = self.biModel.CurrencyId;
    params[@"TradeType"] = @"3";
    //获取币币交易详情信息
//    [FDNetworkHelper POST:NSStringFormat(@"%@%@",URL_main,URL_GetLatestDealss) parameters:params success:^(id responseObject) {
//        if (KSuccess) {
//            self.dealArray = [BTBuySellFiveModel mj_objectArrayWithKeyValuesArray:KJsonData];
//            [UIView setAnimationsEnabled:NO];
//            [self.tableView reloadData];
////            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            [UIView setAnimationsEnabled:YES];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.biInfoType == 0) {
        return 2;
    }else if (self.biInfoType == 1){
        return self.dealArray.count > 20?20:self.dealArray.count;
    }else{
        return self.biInfoTitleArray.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 0.01;
}

- (void)addLinesView {
    CGFloat white = _lineKView.bounds.size.height /4;
    CGFloat height = _lineKView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineKView.bounds.size.width , 1)];
        hengView.backgroundColor = RGB(30, 43, 62);
        [_lineKView addSubview:hengView];
        [_lineKView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i < 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 47, 1, _lineKView.bounds.size.height - 62)];
        shuView.backgroundColor = RGB(30, 43, 62);
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
    param[@"type"] = self.type;
    param[@"market"] = @"btc_usdt";
    param[@"size"] = @"1000";
    
    // 使用本地数据显示K线
    BOOL useLocalData = NO;
    if ( useLocalData ) {
        NSArray *responseObject = [Util getLocalJsonDataWithFileName:@"KLineLocalJsonData.json"];
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:self.type];
        [self.lineKView reloadData];
        return;
    }
    
    kWeakSelf(self)
    [FDNetworkHelper GET:@"http://api.bitkk.com/data/v1/kline" parameters:param success:^(id responseObject) {
        
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
        weakself.groupModel = groupModel;
        [weakself.modelsDict setObject:groupModel forKey:weakself.type];
        [weakself.lineKView reloadData];
        
    } failure:^(NSError *error) {
        
    }];


//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    //    {"tradeType": "3","CoinId": "4","CurrencyId": "19","LineType": 1
//    param[@"tradeType"] = @"3";
//    param[@"LineType"] = self.type;
//    param[@"CoinId"] = @"4";
//    param[@"CurrencyId"] = @"19";
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"Parameters"] = [param mj_JSONString];
//    kWeakSelf(self)
//    [FDNetworkHelper POST:@"http://43.231.184.237:8008/api/TradeCenter/GetLineData" parameters:params success:^(id responseObject) {
//
//        if (responseObject[@"data"]) {
//            if ([responseObject[@"data"][@"datas"][@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"][@"datas"][@"data"] isEqual:[NSNull null]] || responseObject[@"data"][@"datas"][@"data"] == nil) {
//                return ;
//            }
//            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"][@"datas"][@"data"]];
//            weakself.groupModel = groupModel;
//            [weakself.modelsDict setObject:groupModel forKey:weakself.type];
//            [weakself.lineKView reloadData];
//        }else{
//            NSLog(@"%@",responseObject);
//        }
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)showKLineFullScreenViewController{
    if (!_lineKFullScreenViewController) {
        _lineKFullScreenViewController = [[LineKFullScreenViewController alloc] init];
    }
    kWeakSelf(self);
    _lineKFullScreenViewController.biModel = self.biModel;
    _lineKFullScreenViewController.marketModel = self.marketModel;
    _lineKFullScreenViewController.onClickBackButton = ^(LineKFullScreenViewController *controller) {
        CGRect tempFrame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight);
        if (weakself.lineKFullScreenViewController.view.frame.origin.x == 0) {
            [UIView animateWithDuration:0.35 animations:^{
                weakself.lineKFullScreenViewController.view.frame = tempFrame;
            } completion:^(BOOL finished) {
                weakself.isShowKLineFullScreenViewController = NO;
                [weakself containerRemoveChildViewController:weakself.lineKFullScreenViewController];
            }];
        }
    };
    _lineKFullScreenViewController.view.frame = CGRectMake(KScreenWidth*2, 0, KScreenWidth, KScreenHeight);
    [_lineKFullScreenViewController.view setNeedsLayout];
    CGRect tempFrame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    if (_lineKFullScreenViewController.view.frame.origin.x > KScreenWidth) {
        [UIView animateWithDuration:0.35 animations:^{
            weakself.lineKFullScreenViewController.view.frame = tempFrame;
        } completion:^(BOOL finished) {
            
        }];
        _isShowKLineFullScreenViewController = YES;
        [self containerAddChildViewController:_lineKFullScreenViewController parentView:self.view];
    }
}

#pragma mark - Y_StockChartViewDelegate

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType{
    if (!_isShowKLineFullScreenViewController) {
        [self showKLineFullScreenViewController];
    }
}

- (void)full
{
    [self showKLineFullScreenViewController];
}

@end
