//
//  DataBaseManager.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/10.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DataBaseManager : NSObject
{
    FMDatabase *_database;
}
+(id)shareInatance;
-(BOOL)creatTabel;
-(BOOL)chargeListInDB;
-(BOOL)saveFileRecordWithBoundle:(NSString *)boundle withNsarry :(NSMutableArray *)lines withType:(NSString *)type withIsCycle:(NSString *)isCycle withPotions:(NSMutableArray *)potions;
-(BOOL)isExistRecordWithID:(NSString *)boundle;
-(NSMutableArray *)getLinesFrom:(NSString *)boundle;
-(NSMutableArray *)getAppsFromDB;
-(NSString *)chargeWhichType:(NSString *)boundle;
-(NSString *)chargeIsCycle:(NSString *)boundle;
-(BOOL)deleteCurrentLines:(NSString *)boundle;
-(NSMutableArray *)getPotionsFrom:(NSString *)boundle;
@end
