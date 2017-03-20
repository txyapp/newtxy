//
//  TXYConfig.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "TXYConfig.h"
#include <notify.h>

static TXYConfig *txyCfg=nil;
@implementation TXYConfig

#pragma obfuscate on
+ (instancetype)sharedConfig{
    @synchronized (self){
        if (txyCfg==nil) {
            txyCfg=[[TXYConfig alloc]init];
        }
    }
    return txyCfg;
}


-(void)setToggleWithBool:(BOOL)b{
    NSMutableDictionary *dict=[self loadSetDict];
    [dict setObject:[NSNumber numberWithBool:b] forKey:@"Toggle"];
    [self writeSetConfigWithDict:dict];
}


-(BOOL)getToggle{
    NSMutableDictionary *dict=[self loadSetDict];
    return [[dict objectForKey:@"Toggle"] boolValue];
}


- (void)setFakeGPS:(CLLocationCoordinate2D)fakeGPS{
    NSMutableDictionary *dict=[self loadSetDict];
    NSDictionary *fakeGPSDic = @{@"FakeLatitude":@(fakeGPS.latitude),@"FakeLongitude":@(fakeGPS.longitude)};
    [dict setObject:fakeGPSDic forKey:@"FakeLocation"];
    [self writeSetConfigWithDict:dict];
}


- (CLLocationCoordinate2D)getFakeGPS{
    NSMutableDictionary *dict=[self loadSetDict];
    NSDictionary *fakeGPSDic=[dict objectForKey:@"FakeLocation"];
    return CLLocationCoordinate2DMake([[fakeGPSDic objectForKey:@"FakeLatitude"] doubleValue], [[fakeGPSDic objectForKey:@"FakeLongitude"] doubleValue]);
}


- (void)setRealGPS:(CLLocationCoordinate2D)realGPS{
    NSMutableDictionary *dict=[self loadSetDict];
    NSDictionary *realGPSDic = @{@"RealLatitude":@(realGPS.latitude),@"RealLongitude":@(realGPS.longitude)};
    [dict setObject:realGPSDic forKey:@"RealLocation"];
    [self writeSetConfigWithDict:dict];
}


- (CLLocationCoordinate2D)getRealGPS{
    NSMutableDictionary *dict=[self loadSetDict];
    NSDictionary *realGPSDic=[dict objectForKey:@"RealLocation"];
    return CLLocationCoordinate2DMake([[realGPSDic objectForKey:@"RealLatitude"] doubleValue], [[realGPSDic objectForKey:@"RealLongitude"] doubleValue]);
}

-(void)setLocationWithBundleId:(NSString *)bundleId andType:(FakeType)type andGPS:(CLLocationCoordinate2D)gps{
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *appDict=[dict objectForKey:@"AppLocation"];
    if (appDict==nil) {
        appDict=[NSMutableDictionary dictionary];
    }
    NSMutableDictionary *GPSDict = [@{@"Latitude":@(gps.latitude),@"Longitude":@(gps.longitude)} mutableCopy];
    [GPSDict setObject:@(type) forKey:@"FakeType"];
    [appDict setObject:GPSDict forKey:bundleId];
    [dict setObject:@(YES) forKey:@"Toggle"];
    [dict setObject:appDict forKey:@"AppLocation"];
    [self writeSetConfigWithDict:dict];
}

-(NSDictionary *)getLocationWithBundleId:(NSString *)bundleId{
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *appDict=[dict objectForKey:@"AppLocation"];
    if (appDict==nil) {
        appDict=[NSMutableDictionary dictionary];
    }
    NSDictionary *GPSDict=[appDict objectForKey:bundleId];
    return GPSDict;
}

-(NSArray *)getAllBundleIdForLoca{
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *appDict=[dict objectForKey:@"AppLocation"];
    if (appDict==nil) {
        appDict=[NSMutableDictionary dictionary];
    }
    return [appDict allKeys];
}


-(void)deleteLocationWithBundleId:(NSString *)bundleId{
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *appDict=[dict objectForKey:@"AppLocation"];
    if (appDict==nil) {
        appDict=[NSMutableDictionary dictionary];
    }
    [appDict removeObjectForKey:bundleId];
    [dict setObject:appDict forKey:@"AppLocation"];
    [self writeSetConfigWithDict:dict];
}


-(void)scanStreetWithBundleDict:(NSDictionary *)bundleDict{    
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *scanDict=[[dict objectForKey:@"AppScan"] mutableCopy];
    if(scanDict==nil){
        scanDict=[NSMutableDictionary dictionary];
    }
    [scanDict setValuesForKeysWithDictionary:bundleDict];
    [dict setObject:scanDict forKey:@"AppScan"];
    [self writeSetConfigWithDict:dict];
    notify_post("com.yunlian.AppScan");
}

  
-(void)stopScanStreetWithBundleId:(NSString *)bundleId{
    NSMutableDictionary *dict=[self loadSetDict];
    NSMutableDictionary *scanDict=[[dict objectForKey:@"AppScan"] mutableCopy];
    if(scanDict==nil){
        scanDict=[NSMutableDictionary dictionary];
    }
    [scanDict removeObjectForKey:bundleId];
    [dict setObject:scanDict forKey:@"AppScan"];
    [self writeSetConfigWithDict:dict];
}


- (NSString *)getAppStatus:(NSString *)bundleId{
    NSDictionary *dict=[self loadSetDict];
    BOOL Toggle=[[dict objectForKey:@"Toggle"] boolValue];
    NSDictionary *scanDict=[dict objectForKey:@"AppScan"];
    if ([[scanDict allKeys]containsObject:bundleId]&&Toggle) {
        return @"ScanLoca";
    }
    NSDictionary *locaDict=[dict objectForKey:@"AppLocation"];
    if ([[locaDict allKeys] containsObject:bundleId]&&Toggle) {
        return @"AloneLoca";
    }
    NSDictionary *fakeLoca=[dict objectForKey:@"FakeLocation"];
    if (fakeLoca&&Toggle) {
        return @"GlobalLoca";
    }
    if (!Toggle) {
        return @"RealLoca";
    }
    return @"ERROR";
}

- (NSMutableDictionary *)loadSetDict{
    NSString *str = [NSString stringWithContentsOfFile:kSetPlist encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        NSString *desStr = [DES decryptString:str];
        NSData *jsonData = [desStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] mutableCopy];
        if (dict==nil) {
            dict=[NSMutableDictionary dictionary];
        }
        return dict;
    }else{
        return [NSMutableDictionary dictionary];
    }
}

- (BOOL)writeSetConfigWithDict:(NSMutableDictionary *)dict{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *desStr = [DES encryptString:str];
    NSError *error;
    BOOL result=[desStr writeToFile:kSetPlist atomically:NO encoding:NSUTF8StringEncoding error:&error];
    return result;
}

- (void)setLanguage:(NSString *)languageStr{
    NSMutableDictionary *dict=[self loadSetDict];
    [dict setValue:languageStr forKey:@"Language"];
    [self writeSetConfigWithDict:dict];
}

- (NSString *)getLanguage{
    NSMutableDictionary *dict=[self loadSetDict];
    NSString *languageStr=[dict objectForKey:@"Language"];
    return languageStr;
}


- (void)setDaoQiTime:(NSString *)Str{
    NSMutableDictionary *dict=[self loadSetDict];
    [dict setValue:Str forKey:@"DaoQi"];
    [self writeSetConfigWithDict:dict];
}

- (NSString *)getDaoQiTime{
    NSMutableDictionary *dict=[self loadSetDict];
    NSString *languageStr=[dict objectForKey:@"DaoQi"];
    return languageStr;
}

- (void)setIsVip:(BOOL)isVip
{
    NSMutableDictionary *dict=[self loadSetDict];
    [dict setValue:[NSNumber numberWithBool:isVip] forKey:@"isVip"];
    [self writeSetConfigWithDict:dict];
}

- (BOOL)getIsVip
{
    NSMutableDictionary *dict=[self loadSetDict];
    NSNumber *isVip = [dict objectForKey:@"isVip"];
    return [isVip boolValue];
}

@end
