//
//  DataBaseManager.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/10.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "DataBaseManager.h"
@interface DataBaseManager ()
{
    NSString *path;
}
@end
@implementation DataBaseManager
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
    path = [NSString stringWithFormat:@"%@/Library/Caches/5.db", NSHomeDirectory()];
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
    /*
     latitude 维度
     longtitude 精度
     indexInStep  在step中的位置
     whichbundle 应用名称
     whichstep 哪一个step
     thestepTotleNum 本step的点数的数量
     totleStep 总共有几个step
     isWaitPoint 是否是拐点(红绿灯的地方)
     whiceAddIndex  那一次添加的
     */@try{
         [_database open];
         BOOL res;
//         NSString *sqlCreateTable =  @"create table if not exists applist(isCycle,whichType,whichbundle,att0 BLOB,potines BLOB,att1 BLOB,att2 BLOB,att3 BLOB,att4 BLOB,att5 BLOB,att6 BLOB,att7 BLOB,att8 BLOB,att9 BLOB)";
         NSString *sqlCreateTable =  @"create table if not exists applist(isCycle,whichType,whichbundle,att0 BLOB,potines BLOB)";
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
    FMResultSet *rs = [_database executeQuery:@"select tbl_name from sqlite_master where type ='table' and name ='applist'"];
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
//存储线路
-(BOOL)saveFileRecordWithBoundle:(NSString *)boundle withNsarry :(NSMutableArray *)lines withType:(NSString *)type withIsCycle:(NSString *)isCycle withPotions:(NSMutableArray *)potions
{
    
    @try{
        [_database open];
        int i ;
        BOOL  res;
        res = [_database executeUpdate:@"insert into applist values (?,?,?,?,?)",isCycle,type,boundle,[NSKeyedArchiver archivedDataWithRootObject:lines],[NSKeyedArchiver archivedDataWithRootObject:potions]];
        if (res==1) {
            i ++;
        }
        NSLog(@"%d",i);
        [_database close];
        return res;
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
//得到某个应用的路线
-(NSMutableArray *)getLinesFrom:(NSString *)boundle
{
    [_database open];
    NSMutableArray *arr = nil;
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select att0 from applist where whichbundle='%@'",boundle]];
    while ([set next]) {
       // NSLog(@"%@",[set dataForColumn:@"att"]);
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"att0"]];
        //NSLog(@"%lu",(unsigned long)arr.count);
        return arr;
    }
    [_database close];
    return nil;
}
//得到某个应用点的点
-(NSMutableArray *)getPotionsFrom:(NSString *)boundle
{
    [_database open];
    NSMutableArray *arr = nil;
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select potines from applist where whichbundle='%@'",boundle]];
    while ([set next]) {
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"potines"]];
        return arr;
    }
    [_database close];
    return nil;
}
//判断某个app是否存在表中
-(BOOL)isExistRecordWithID:(NSString *)boundle
{
    [_database open];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select whichbundle from applist"]];
    while ([set next]) {
        NSString *appName = [set stringForColumn:@"whichbundle"];
        if ([appName isEqualToString:boundle]) {
            return YES;
        }
    }
    [_database close];
    return NO;
}
//判断是哪种出行方式
-(NSString *)chargeWhichType:(NSString *)boundle
{
    [_database open];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select whichType from applist where whichbundle='%@'",boundle]];
    while ([set next]) {
        //返回出行方式对应的字段
        return [set stringForColumn:@"whichType"];
    }
    [_database close];
    return nil;
}
//判断是否循环
-(NSString *)chargeIsCycle:(NSString *)boundle
{
    [_database open];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select isCycle from applist where whichbundle='%@'",boundle]];
    while ([set next]) {
        //返回出行方式对应的字段
        return [set stringForColumn:@"isCycle"];
    }
    [_database close];
    return nil;
}
//求表中app的数量
-(NSMutableArray *)getAppsFromDB
{
    [_database open];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *set = [_database executeQuery:[NSString stringWithFormat:@"select whichbundle from applist"]];
    while ([set next]) {
        NSString *appName = [set stringForColumn:@"whichbundle"];
        NSLog(@"%@",appName);
        if (appName) {
            [arr addObject:appName];
        }
    }
    NSLog(@"%@",arr);
    [_database close];
    return arr;
}
//删除路线
-(BOOL)deleteCurrentLines:(NSString *)boundle
{
    @try{
        [_database open];
        int i ;
        BOOL  res ;
        res = [_database executeUpdate:[NSString stringWithFormat:@"delete from applist where whichbundle='%@'",boundle]];
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
@end
