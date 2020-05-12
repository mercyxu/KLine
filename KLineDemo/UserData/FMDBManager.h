//
//  FMDBManager.h
//  iOS
//
//  Created by iOS on 2018/7/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <FMDatabase.h>

@interface FMDBManager : NSObject

singleton_interface(FMDBManager);

/**
 *  1. 数据库
 */
@property (strong, nonatomic) FMDatabase *database;

- (void)initDataBase;

- (void)deleteDataOfsymbol;

- (void)insertSymbolToDatabaseWithSymbolArr:(NSArray *)arr;

- (NSMutableArray *)symbolFromDatabase;
@end
