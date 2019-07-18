//
//  Y-KlineModel.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Y_KLineGroupModel;

typedef NS_ENUM(NSInteger, YCoinType) {
    CoinTypeBTC = 1,   //比特币
    CoinTypeETH,       //以太坊
    CoinTypeNone       //未定义类型
};

@interface Y_KLineModel : NSObject

#pragma 外部初始化

/**
 *  货币类型
 */
@property (nonatomic, assign) YCoinType CoinType;

/**
 *  前一个Model
 */
@property (nonatomic, strong) Y_KLineModel *PreviousKlineModel;

/**
 *  父ModelArray:用来给当前Model索引到Parent数组
 */
@property (nonatomic, strong) Y_KLineGroupModel *ParentGroupModel;


/**
 *  该Model及其之前所有收盘价之和
 */
@property (nonatomic, copy) NSNumber *SumOfLastClose;

/**
 *  该Model及其之前所有成交量之和
 */
@property (nonatomic, copy) NSNumber *SumOfLastVolume;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *Date;

/**
 *  开盘价
 */
@property (nonatomic, copy) NSNumber *Open;


/**
 *  收盘价
 */
//@property (nonatomic, assign) CGFloat Close;
@property (nonatomic, copy) NSNumber *Close;

/**
 *  最高价
 */
//@property (nonatomic, assign) CGFloat High;
@property (nonatomic, copy) NSNumber *High;

/**
 *  最低价
 */
//@property (nonatomic, assign) CGFloat Low;
@property (nonatomic, copy) NSNumber *Low;

/**
 *  成交量
 */
@property (nonatomic, assign) CGFloat Volume;

/**
 *  是否是某个月的第一个交易日
 */
@property (nonatomic, assign) BOOL isFirstTradeDate;

/**
 *  币种精度
 */
@property (nonatomic, assign) int coin;

/**
 *  价格精度
 */
@property (nonatomic, assign) int price;

#pragma 内部自动初始化

//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N


//MA（7）=（C1+C2+……CN）/7
@property (nonatomic, copy) NSNumber *MA7;

//MA（30）=（C1+C2+……CN）/30
@property (nonatomic, copy) NSNumber *MA30;

@property (nonatomic, copy) NSNumber *MA5;

@property (nonatomic, copy) NSNumber *MA10;

@property (nonatomic, copy) NSNumber *MA12;

@property (nonatomic, copy) NSNumber *MA26;

@property (nonatomic, copy) NSNumber *Volume_MA7;

@property (nonatomic, copy) NSNumber *Volume_MA30;

@property (nonatomic, copy) NSNumber *Volume_MA5;

@property (nonatomic, copy) NSNumber *Volume_MA10;

@property (nonatomic, copy) NSNumber *Volume_EMA7;

@property (nonatomic, copy) NSNumber *Volume_EMA30;

@property (nonatomic, copy) NSNumber *Volume_EMA5;

@property (nonatomic, copy) NSNumber *Volume_EMA10;

#pragma BOLL线

@property (nonatomic, copy) NSNumber *MA20;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
@property (nonatomic, copy) NSNumber *BOLL_MD;

// n-1 天的 MA
@property (nonatomic, copy) NSNumber *BOLL_MB;

// MB + k * MD
@property (nonatomic, copy) NSNumber *BOLL_UP;

// MB - k * MD
@property (nonatomic, copy) NSNumber *BOLL_DN;

//  n 个 ( Cn - MA20)的平方和
@property (nonatomic, copy) NSNumber *BOLL_SUBMD_SUM;

// 当前的 ( Cn - MA20)的平方
@property (nonatomic, copy) NSNumber *BOLL_SUBMD;


//#pragma 第一个EMA等于MA；即EMA(n) = MA(n)

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA7;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA30;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA5;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA10;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA12;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA26;

//MACD主要是利用长短期的二条平滑平均线，计算两者之间的差离值，作为研判行情买卖之依据。MACD指标是基于均线的构造原理，对价格收盘价进行平滑处 理(求出算术平均值)后的一种趋向类指标。它主要由两部分组成，即正负差(DIF)、异同平均数(DEA)，其中，正负差是核心，DEA是辅助。DIF是 快速平滑移动平均线(EMA1)和慢速平滑移动平均线(EMA2)的差。

//在现有的技术分析软件中，MACD常用参数是快速平滑移动平均线为12，慢速平滑移动平均线参数为26。此外，MACD还有一个辅助指标——柱状线 (BAR)。在大多数技术分析软件中，柱状线是有颜色的，在低于0轴以下是绿色，高于0轴以上是红色，前者代表趋势较弱，后者代表趋势较强。

//MACD(12,26.9),下面以该参数为例说明计算方法。


//12日EMA的算式为
//EMA（12）=昨日EMA（12）*11/13+C*2/13＝(C－昨日的EMA)×0.1538＋昨日的EMA；   即为MACD指标中的快线-快速平滑移动平均线；
//26日EMA的算式为
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线-慢速平滑移动平均线；

//DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//@property (nonatomic, assign) CGFloat DIF;
@property (nonatomic, copy) NSNumber *DIF;

//今日的DEA值（即MACD值）=前一日DEA*8/10+今日DIF*2/10.
//@property (nonatomic, assign) CGFloat DEA;
@property (nonatomic, copy) NSNumber *DEA;

//EMA（12）=昨日EMA（12）*11/13+C*2/13；   即为MACD指标中的快线；
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线；
//@property (nonatomic, assign) CGFloat MACD;
@property (nonatomic, copy) NSNumber *MACD;


/**
 *  9Clock内最低价
 */
//@property (nonatomic, assign) CGFloat NineClocksMinPrice;
@property (nonatomic, copy) NSNumber *NineClocksMinPrice;


/**
 *  9Clock内最高价
 */
//@property (nonatomic, assign) CGFloat NineClocksMaxPrice;
@property (nonatomic, copy) NSNumber *NineClocksMaxPrice;



//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D
//@property (nonatomic, assign) CGFloat RSV_9;
@property (nonatomic, copy) NSNumber *RSV_9;

//@property (nonatomic, assign) CGFloat KDJ_K;
@property (nonatomic, copy) NSNumber *KDJ_K;

//@property (nonatomic, assign) CGFloat KDJ_D;
@property (nonatomic, copy) NSNumber *KDJ_D;

//@property (nonatomic, assign) CGFloat KDJ_J;
@property (nonatomic, copy) NSNumber *KDJ_J;


//RSI
/*
 RSI的计算公式
 RSI=100×RS/(1+RS) 或者，RSI=100－100÷（1+RS）
 其中 RS=14天内收市价上涨数之和的平均值/14天内收市价下跌数之和的平均值
 举例说明：
 如果最近14天涨跌情形是:第一天升2元，第二天跌2元，第三至第五天各升3元；第六天跌4元 第七天升2元，第八天跌5元；第九天跌6元，第十至十二天各升1元；第十三至十四天各跌3元。
 那么，计算RSI的步骤如下：
 (一)将14天上升的数目相加，除以14，上例中总共上升16元除以14得1.143(精确到小数点后三位)；
 (二)将14天下跌的数目相加，除以14，上例中总共下跌23元除以14得1.643(精确到小数点后三位)；
 (三)求出相对强度RS，即RS=1.143/1.643=0.696(精确到小数点后三位)；
 (四)1+RS=1+0.696=1.696；
 (五)以100除以1+RS，即100/1.696=58.962；
 (六)100-58.962=41.038。    结果14天的强弱指标RS1为41.038。    不同日期的14天RSI值当然是不同的，连接不同的点，即成RSI的轨迹。
 
 */
@property (nonatomic, assign) CGFloat closeDiff;//!< 跟前日的收盘价之差
@property (nonatomic, copy) NSNumber *RSI_6;
@property (nonatomic, copy) NSNumber *RSI_12;
@property (nonatomic, copy) NSNumber *RSI_24;

/*
 WR1一般是10天买卖强弱指标；
 WR2一般是6天买卖强弱指标。
 以N日威廉指标为例，
 WR(N) = 100 * [ HIGH(N)-C ] / [ HIGH(N)-LOW(N) ]
 C：当日收盘价
 HIGH(N)：N日内的最高价
 LOW(n)：N日内的最低价 [1]
*/

/**
 *  14Clock内最低价
 */
@property (nonatomic, copy) NSNumber *FourteenClocksMinPrice;


/**
 *  14Clock内最高价
 */
@property (nonatomic, copy) NSNumber *FourteenClocksMaxPrice;

@property (nonatomic, copy) NSNumber *WR;

//初始化Model
- (void) initWithArray:(NSArray *)arr;

- (void) initWithDict:(NSDictionary *)dict;

//初始化第一条数据
- (void) initFirstModel;

//初始化其他数据
- (void)initData ;

@end
