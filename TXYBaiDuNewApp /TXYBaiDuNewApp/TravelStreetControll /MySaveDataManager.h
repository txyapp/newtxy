//
//  MySaveDataManager.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/26.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "XuandianModel.h"
@interface MySaveDataManager : NSObject
{
    FMDatabase *_database;
}
+(id)shareInatance;
-(BOOL)creatTabel;
-(BOOL)chargeListInDB;
-(void)saveFileRecordwithPotions:(NSMutableArray *)potions withDate:(NSString *)saveDate;
//得到所有的时间点
-(NSMutableArray *)getPotionsDate;
//通过时间点 得到所有的点
-(NSMutableArray *)getPotionsWith:(NSString *)date;
//删除收藏的路线
-(BOOL)deleteCollectionLines:(NSString *)date;
//改变线路的时间(也就是线路的名字)
-(BOOL)changeCollectionLinesName:(NSString *)oldDate withNewDate:(NSString *)newDate;
@end
