//
//  TXYConfig.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface TXYConfig : NSObject

/**
 *  获取一个配置类的单例
 *
 *  @return TXYConfig的实例
 */
+ (instancetype)sharedConfig;

/**
 *  设置总开关状态
 *
 *  @param b 开关的值
 */
-(void)setToggleWithBool:(BOOL)b;

/**
 *  获取当前开关状态
 *
 *  @return 返回开关布尔值
 */
-(BOOL)getToggle;

/**
 *  设置全局虚假坐标
 *
 *  @param fakeGPS GPS坐标
 */
- (void)setFakeGPS:(CLLocationCoordinate2D)fakeGPS;

/**
 *  获取全局虚假坐标
 *
 *  @return 虚假坐标
 */
- (CLLocationCoordinate2D)getFakeGPS;

/**
 *  设置用户当前真实位置的坐标
 *
 *  @param realGPS 真实的GPS
 */
- (void)setRealGPS:(CLLocationCoordinate2D)realGPS;

/**
 *  获取保存的用户当前真实坐标
 *
 *  @return 真实GPS坐标
 */
- (CLLocationCoordinate2D)getRealGPS;

/**
 *  针对某个App单独定位
 *
 *  @param bundleId App的BundleId
 *  @param gps      GPS坐标
 */
-(void)setLocationWithBundleId:(NSString *)bundleId andType:(FakeType)type andGPS:(CLLocationCoordinate2D)gps;

/**
 *  获取一个app单独定位信息
 *
 *  @return 定位坐标
 */
-(NSDictionary *)getLocationWithBundleId:(NSString *)bundleId;

/**
 *  获取所有单独定位过的app BundleId
 *
 *  @return 所有app数组
 */
-(NSArray *)getAllBundleIdForLoca;

/**
 *  删除针对某个app定位
 *
 */
-(void)deleteLocationWithBundleId:(NSString *)bundleId;


/**
 *  对App进行扫街，并且进入扫街状态,扫街完毕会停留在最后的位置
 *
 *  @param bundleDict 扫街配置
 */
-(void)scanStreetWithBundleDict:(NSDictionary *)bundleDict;


//扫街示例代码
/*
 dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
 dispatch_async(concurrentQueue, ^(){
 for(int i=0;i<100;i++){
 NSLog(@"%d",i);
 
 NSMutableDictionary *scanDict=[NSMutableDictionary dictionary];
 //CBD
 NSDictionary *GPSdict1=@{@"Latitude":@(34.7737624103709+(i*0.001)),
 @"Longitude":@(113.72338702091+(i*0.001))};
 
 //高新区
 NSDictionary *GPSdict2=@{@"Latitude":@(34.8292607738366+(i*0.001)),
 @"Longitude":@(113.540843203972+(i*0.001))};
 
 [scanDict setObject:GPSdict1 forKey:@"com.ubercab.UberClient"];
 [scanDict setObject:GPSdict2 forKey:@"com.apple.Maps"];
 
 NSLog(@"Uber客户端%@",GPSdict1);
 NSLog(@"系统地图%@",GPSdict2);
 
 [[TXYConfig sharedConfig] scanStreetWithBundleDict:scanDict];
 [NSThread sleepForTimeInterval:0.5];
 
 }
 });*/


/**
 *  取消App扫街状态，可以解除扫街后的停留
 *
 *  @param bundleId App的bundleId
 */
-(void)stopScanStreetWithBundleId:(NSString *)bundleId;

/**
 *  获得一个App的定位状态
 *
 *  @param bundleId App的BundleID
 *
 *  @return 扫街:ScanLoca、单独定位:AloneLoca、全局定位:GlobalLoca、真实位置:RealLoca、错误:Error.
 */
- (NSString *)getAppStatus:(NSString *)bundleId;

/**
 *  设置app语言
 *
 *  @param languageStr 语言字符串 中文:CN 英文:EN
 */
- (void)setLanguage:(NSString *)languageStr;

/**
 *  获取当前app设置的语言
 *
 *  @return 语言字符串 中文:CN 英文:EN
 */
- (NSString *)getLanguage;

/**
 *  设置到期时间
 *
 */
- (void)setDaoQiTime:(NSString *)Str;

/**
 *  获取到期时间
 *
 */
- (NSString *)getDaoQiTime;

/**
 *  设置是否是国外用户需要上传数据
 */
- (void)setIsVip:(BOOL)isVip;
- (BOOL)getIsVip;

@end
