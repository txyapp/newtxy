//
//  DeviceAbout.h
//  1111111
//
//  Created by yunlian on 16/3/23.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
#import "Tools.h"
extern NSString *const Device_Simulator;
extern NSString *const Device_iPod1;
extern NSString *const Device_iPod2;
extern NSString *const Device_iPod3;
extern NSString *const Device_iPod4;
extern NSString *const Device_iPod5;
extern NSString *const Device_iPad2;
extern NSString *const Device_iPad3;
extern NSString *const Device_iPad4;
extern NSString *const Device_iPhone4;
extern NSString *const Device_iPhone4S;
extern NSString *const Device_iPhone5;
extern NSString *const Device_iPhone5S;
extern NSString *const Device_iPhone5C;
extern NSString *const Device_iPadMini1;
extern NSString *const Device_iPadMini2;
extern NSString *const Device_iPadMini3;
extern NSString *const Device_iPadAir1;
extern NSString *const Device_iPadAir2;
extern NSString *const Device_iPhone6;
extern NSString *const Device_iPhone6plus;
extern NSString *const Device_iPhone6S;
extern NSString *const Device_iPhone6Splus;
extern NSString *const Device_Unrecognized;
@interface DeviceAbout : NSObject
/**
 *  获取一个配置类的单例
 *
 *  @return DeviceAbout的实例
 */
+ (instancetype)sharedDevice;
/**
 *  获取wifi相关信息
 *
 *  @return wifi的相关信息
 */
- (id)fetchSSIDInfo;
/**
 *  获取ADUUID
 *
 *  @return ADUUID字符串
 */
- (NSString *)getADUUID;
/**
 *  获取UUID
 *
 *  @return UUID字符串
 */
- (NSString *)getUUID;
/**
 *  获取设备名称 eg. "imac"的iphone
 *
 *  @return 设备名称字符串
 */
- (NSString *)getDeviceName;
/**
 *  获取系统版本 eg.iOS7
 *
 *  @return 系统版本
 *  当返回值为 -1 时  说明系统版本不在 DevVersion 内
 */
- (NSString*)getDeviceIOS;
/**
 *  获取设备类型 eg.iphone
 *
 *  @return 设备类型
 *  当返回值为 -1 时  说明系统版本不在 DevTpye 内
 */
- (DevTpye)getDeviceType;
/**
 *  获取手机网络
 *
 *  @return 手机网络
 *  
 */
-(NSString *)getNetWorkStates;

//获取序列号
-(NSString *)getImei;

//获取设备具体型号
-(NSString *) deviceModel;
//获取机器码
-(NSString *)deviceNum;


//设置一下公共参数
-(NSDictionary *)getPublicPhone;
@end
