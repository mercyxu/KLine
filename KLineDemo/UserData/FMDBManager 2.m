//
//  FMDBManager.m
//  Bhex
//
//  Created by BHEX on 2018/7/10.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "FMDBManager.h"

@implementation FMDBManager
singleton_implementation(FMDBManager)

#pragma mark - 1. 初始化数据库
- (void)initDataBase {
    
    // 1. 打印路径
    NSString * homePath=NSHomeDirectory();
    NSString * docPath=[homePath stringByAppendingPathComponent:@"Documents"];
    NSString * fileName=[docPath stringByAppendingPathComponent:@"myLoad.db"];
    
    // 2. 打开数据库 没有就创建一个
    self.database = [FMDatabase databaseWithPath:fileName];
    [self.database open];
}

- (void)insertSymbolToDatabaseWithSymbolArr:(NSArray *)arr {
    
    if (!self.database.isOpen) {
        [self initDataBase];
    }
    
    [self.database  beginTransaction];
    NSString * sql_create=@"create table if not exists SymbolTable(orgId text, symbolId text, symbolName text, exchangeId text, quoteTokenName text, baseTokenId text, baseTokenName text, quoteTokenId text, basePrecision text, quotePrecision text, minTradeQuantity text, minTradeAmount text, minPricePrecision text, digitMerge text, canTrade text)";
    [self.database executeUpdate:sql_create];
    
    NSString * sql_delete=@"delete from SymbolTable";
    [self.database executeUpdate:sql_delete];
    
    int i = 0;
    while (i < arr.count) {
        NSDictionary *dic = arr[i];
        [self.database executeUpdate:@"insert into SymbolTable (symbolId, symbolName, exchangeId, orgId, baseTokenId, baseTokenName, quoteTokenId, quoteTokenName, basePrecision, quotePrecision, minTradeQuantity, minTradeAmount, minPricePrecision, digitMerge, canTrade) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", dic[@"symbolId"], dic[@"symbolName"], dic[@"exchangeId"], dic[@"orgId"], dic[@"baseTokenId"], dic[@"baseTokenName"], dic[@"quoteTokenId"], dic[@"quoteTokenName"], dic[@"basePrecision"], dic[@"quotePrecision"], dic[@"minTradeQuantity"], dic[@"minTradeAmount"], dic[@"minPricePrecision"], dic[@"digitMerge"], dic[@"canTrade"]];
        i++;
    }
    [self.database commit];
}

- (NSMutableArray *)symbolFromDatabase {
    if (!self.database.isOpen) {
        [self initDataBase];
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSString * sql = @"select * from SymbolTable";
    FMResultSet *result = [self.database executeQuery:sql];
    while(result.next) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"orgId"] = [result stringForColumn:@"orgId"];
        dic[@"exchangeId"] = [result stringForColumn:@"exchangeId"];
        dic[@"symbolName"] = [result stringForColumn:@"symbolName"];
        dic[@"symbolId"] = [result stringForColumn:@"symbolId"];
        dic[@"baseTokenId"] = [result stringForColumn:@"baseTokenId"];
        dic[@"baseTokenName"] = [result stringForColumn:@"baseTokenName"];
        dic[@"quoteTokenName"] = [result stringForColumn:@"quoteTokenName"];
        dic[@"quoteTokenId"] = [result stringForColumn:@"quoteTokenId"];
        dic[@"basePrecision"] = [result stringForColumn:@"basePrecision"];
        dic[@"quotePrecision"] = [result stringForColumn:@"quotePrecision"];
        dic[@"minTradeQuantity"] = [result stringForColumn:@"minTradeQuantity"];
        dic[@"minTradeAmount"] = [result stringForColumn:@"minTradeAmount"];
        dic[@"minPricePrecision"] = [result stringForColumn:@"minPricePrecision"];
        dic[@"digitMerge"] = [result stringForColumn:@"digitMerge"];
        dic[@"canTrade"] = [result stringForColumn:@"canTrade"];
        [arr addObject:dic];
    }
    return arr;
}


#pragma mark - 3. 插入币对到数据库
- (NSMutableArray *)selectSymbolFromDatabase {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 1. 查询数据库
    FMResultSet *resultSet = [self.database executeQuery:@"select * from symbol_list"];
    while ( [resultSet next] ) {
        [dataArray addObject:[resultSet stringForColumn:@"symbolId"]];
    }
    return dataArray;
}

#pragma mark - 4. 删除币对列表数据
- (void)deleteDataOfsymbol {

    NSString *deleteData = [NSString stringWithFormat:@"delete from symbol_list"];
    BOOL success = [self.database executeUpdate:deleteData];
    if (success) {
        NSLog(@"币对列表删除成功");
    }
}
@end
