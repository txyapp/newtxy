//
//  MapTypeDataManager.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface MapTypeDataManager : NSObject
{
    FMDatabase *_database;
}
+(id)shareInatance;
-(BOOL)creatTabel;
-(BOOL)chargeListInDB;
-(void)saveFileRecordwithWhichApp:(NSString *)appBundle withWhichMap:(NSString *)whichMap;
-(NSString *)getWhichMapWith:(NSString *)boundle;
-(BOOL)isExistRecordWithBundle:(NSString *)boundle;
-(BOOL)deleteMapTypeWithBundle:(NSString *)boundle;
@end
