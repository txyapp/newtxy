//
//  MySaveDataManager.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/26.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "MySaveDataManager.h"
#import "ProgressHUD.h"
@interface MySaveDataManager ()
{
    NSString *path;
}
@end
@implementation MySaveDataManager
+(id)shareInatance
{
    static id dataBase = nil;
    if(dataBase == nil)
    {
        dataBase = [[[self class] alloc] init];
    }
    return dataBase;
}
-(id)init
{
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}
-(void)initDatabase
{
    // 创建一个数据库对象
    path = [NSString stringWithFormat:@"%@/Library/Caches/6.db", NSHomeDirectory()];
    NSLog(@"%@",path);
    _database = [[FMDatabase alloc] initWithPath:path];
    // 打开数据库
    [_database open];
}
#pragma mark -save
//存储数据
-(BOOL)creatTabel
{
    //表格的数据结构
@try{
         [_database open];
         BOOL res;
         NSString *sqlCreateTable =  @"create table if not exists appCollection(dateForSelf,potines BLOB)";
         res = [_database executeUpdate:sqlCreateTable];
         if (res == NO) {
             NSLog(@"创建表失败");
         }
         [_database close];
         return res;
     }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
//判断数据库中是否存在表
-(BOOL)chargeListInDB
{
    [_database open];
    FMResultSet *rs = [_database executeQuery:@"select * from sqlite_master where type ='table' and name ='appCollection'"];
    while ([rs next]) {
        NSString *count = [rs stringForColumn:@"tbl_name"];
        if (count)
            
        {
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    [_database close];
    return NO;
}
-(void)saveFileRecordwithPotions:(NSMutableArray *)potions withDate:(NSString *)saveDate
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:@"insert into appCollection values (?,?)",saveDate,[NSKeyedArchiver archivedDataWithRootObject:potions]];
        NSLog(@"%d",res);
        if (res==1) {
            //[ProgressHUD showSuccess:@"收藏成功"];
            [KGStatusBar showWithStatus:@"收藏成功"];
            i ++;
        }
        else
        {
            //[ProgressHUD showError:@"收藏失败"];
            [KGStatusBar showWithStatus:@"收藏失败"];
        }
        NSLog(@"%d",i);
        [_database close];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }

}
-(NSMutableArray *)getPotionsDate
{
    [_database open];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select * from appCollection"]];
    while ([set next]) {
        NSString *appName = [set stringForColumn:@"dateForSelf"];
        NSLog(@"%@",appName);
        if (appName) {
            [arr addObject:appName];
        }
    }
    NSLog(@"%@",arr);
    [_database close];
    return arr;
}
-(NSMutableArray *)getPotionsWith:(NSString *)date
{
    [_database open];
    NSMutableArray *arr = nil;
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select * from appCollection where dateForSelf='%@'",date]];
    while ([set next]) {
        // NSLog(@"%@",[set dataForColumn:@"att"]);
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"potines"]];
        //NSLog(@"%lu",(unsigned long)arr.count);
        return arr;
    }
    [_database close];
    return nil;
}
//删除路线
-(BOOL)deleteCollectionLines:(NSString *)date
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:[NSString stringWithFormat:@"delete from appCollection where dateForSelf='%@'",date]];
        //[NSJSONSerialization dataWithJSONObject:_linesData options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%d",res);
        if (res==1) {
            i ++;
            return YES;
        }
        NSLog(@"%d",i);
        return NO;
        [_database close];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
//修改路线时间(也就是名字)
-(BOOL)changeCollectionLinesName:(NSString *)oldDate withNewDate:(NSString *)newDate
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:[NSString stringWithFormat:@"update appCollection set  dateForSelf ='%@' where dateForSelf='%@'",newDate,oldDate]];
        //[NSJSONSerialization dataWithJSONObject:_linesData options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%d",res);
        if (res==1) {
            i ++;
            return YES;
        }
        NSLog(@"%d",i);
        return NO;
        [_database close];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
// NSString *updateTable=@"update zhaochao set username=? where username=?";
//NSArray  *updateParams=@[@"admin",@"zhaochao"];
@end
