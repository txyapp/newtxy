//
//  MapTypeDataManager.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "MapTypeDataManager.h"
@interface MapTypeDataManager ()
{
    NSString *path;
}
@end
@implementation MapTypeDataManager
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
    path = [NSString stringWithFormat:@"%@/Library/Caches/8.db", NSHomeDirectory()];
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
        NSString *sqlCreateTable =  @"create table if not exists mapType(whichApp,whichMap)";
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
    FMResultSet *rs = [_database executeQuery:@"select * from sqlite_master where type ='table' and name ='mapType'"];
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
-(void)saveFileRecordwithWhichApp:(NSString *)appBundle withWhichMap:(NSString *)whichMap
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:@"insert into mapType values (?,?)",appBundle,whichMap];
        NSLog(@"%d",res);
        if (res==1) {
            //[ProgressHUD showSuccess:@"收藏成功"];
            [KGStatusBar showWithStatus:@"存储成功"];
            i ++;
        }
        else
        {
            //[ProgressHUD showError:@"收藏失败"];
            [KGStatusBar showWithStatus:@"存储失败"];
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
-(NSString *)getWhichMapWith:(NSString *)boundle{
    [_database open];
    NSLog(@"%@",boundle);
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select whichMap from mapType where whichApp='%@'",boundle]];
    while ([set next]) {
        //返回出行方式对应的字段
        return [set stringForColumn:@"whichMap"];
    }
    [_database close];
    return nil;
}
-(BOOL)isExistRecordWithBundle:(NSString *)boundle
{
    [_database open];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select whichApp from mapType"]];
    while ([set next]) {
        NSString *appName = [set stringForColumn:@"whichApp"];
        if ([appName isEqualToString:boundle]) {
            return YES;
        }
    }
    [_database close];
    return NO;
}
-(BOOL)deleteMapTypeWithBundle:(NSString *)boundle
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:[NSString stringWithFormat:@"delete from mapType where whichApp='%@'",boundle]];
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
@end
