//
//  Prefix.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//
#ifdef __OBJC__
#ifndef TXYBaiDuNewApp_Prefix_h
#define TXYBaiDuNewApp_Prefix_h
#import "AFNetworking.h"
#import "DeviceAbout.h"
#import "KGStatusBar.h"
#include <DES/DES.h>
#import "NSString+object.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MyAlert.h"
#endif
#define GaijiPlist @"/var/mobile/Library/Preferences/gaiji.plist"
//56303f39e0f55a4b9800150d  测试
//53ad71d756240b79860546bc  上线
#define UmengKeyT @"53ad71d756240b79860546bc"  //上线
#define BaiduKey @"Wg2u42yshcGXUEvp0q01Q6mb"
#define AESKey @"Hz2Ywe8UBe@YfZ0*"
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define kSetPlist @"/var/mobile/Library/Preferences/com.txy.BaiduNew.plist"
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
//#define line [UIColor colorWithRed:226/255.0f green:226/255.0f blue:229/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//腾讯地图搜索历史记录
#define TencentPlist @"/var/mobile/Library/Preferences/com.txy.TencentSearchHistory.plist"
//腾讯地图搜索历史记录
#define XuanFuDian @"/var/mobile/Library/Preferences/com.txy.XuanFuDian.plist"
//谷歌地图搜索历史
#define GooglePlist @"/var/mobile/Library/Preferences/com.txy.GoogleSearchHistory.plist"
//地图类型
#define WhichMap @"/var/mobile/Library/Preferences/com.txy.WhichMap.plist"
//健康数据
#define HeaithKit @"/var/mobile/Library/Preferences/com.txy.HeaithKit.plist"
//注册登录信息
#define LoginPlist @"/var/mobile/Library/Preferences/com.txy.Login.plist"
//悬浮点坐标
#define XuanFuGPSPlist @"/var/mobile/Library/Preferences/com.txy.xuanfudian.plist"
//停止移动悬浮点坐标
#define XuanFuEndGPSPlist @"/var/mobile/Library/Preferences/com.txy.xuanfudianend.plist"
//悬浮开关
#define XuanFuSWPlist @"/var/mobile/Library/Preferences/com.txy.xuanfuSwitch.plist"
//上传过后查询是否上传状态值
#define UpdataFinshPlist @"/var/mobile/Library/Preferences/com.txy.UpdataFinish.plist"
#define LA  (0.00000899322/5)//0.0000092593
#define LO  (0.00001169/5)   //0.0000117702
#endif

#define AppLanguage @"appLanguage"
#define CustomLocalizedString(key, comment) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
typedef enum channelType {
    PaypalBtnAlipay,
    PaypalBtnWx,
    PaypalBtnUp,
} channelType;
typedef enum{
    FakeGPSTypeReal,        // 真实经纬度
    FakeGPSTypeSystem,      // 系统模拟经纬度
    FakeGPSTypeFav,         // 收藏夹
    FakeGPSTypeMap,         // 地图选点
}FakeType;
typedef struct {
    double x;
    double y;
    const  char *str;
    //扫街频率
    double ScanRate;
    //红绿灯选择的时间
    int redWaitSeconds;
    //维度
    double latitude;
    //经度
    double longtitude;
    //该app扫街是否循环
    int isCycle;
    //是否是拐点(红绿灯的地方)
    int isWaitPoint;
    //
    char* weizhi;
    //此点的等待时间 seconds
    int  waiteSeconds;
    //
    const  char *whichbundle;
    //距离
    double juli;
    //时间
    const  char *time;
    //改点是否提醒
    int  alert;
    int isState;
    
    //用户设置参数得到切线的基础长度
    float len;
    //这里设置一个是否是手动暂停的点 并非是拐点
    int waitePoint;
} DBResultModel;


//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0)
//请求接口


/*
 uuid		# 原机器码			(string)
 uptime 		# 上报时间			(timestamp)
 vercode	   	# 天下游版本号			(string)
 sysapi 		# 系统版本 eg.8.1.2		(string)
 model		# 手机型号 eg.iphone4 iphone5s	(string)
 systype		# 手机类型 ios			(string)
 */
//测试 120.27.151.113   正式121.43.32.123
//#define MainApi @"http://120.27.151.113:7658/api/entrance"
//发布
#define MainApi @"http://ipay.txyapp.com:7658/api/entrance/"
//http://ipay.txyapp.com:7658/api/entrance/
//### 用户注册 (110)
#define RegisterApi @"/110"
// ### 用户登录 (111)
#define LoginApi @"/111"
// ### 忘记密码 (112)
#define ForgetApi @"/112"
// ### 获取短信或邮箱验证码 (114)
#define EmailOrPhoneNum @"/114"
//### 修改密码 (115)
#define ChangePassWord @"/115"
//### 用户退出 (116)
#define LoginOut @"/116"
//获取用户信息(117)
#define GetUserInfo @"/117"
//### 验证用户登录状态并返回数据 (119)
#define TestUserIsLogin @"/119"
//### 修改手机号或邮箱 (121)
#define ChangePhoneOrEmail @"/121"
//### 生成支付宝订单 (301)
#define buildAliPayOrder @"/301"
//### 生成微信订单 (302)
#define buildWXOrder @"/302"
//### 微信订单查询 (303)
#define getWXOrder @"/303"
//### ios查看机器码是否是会员 (124)
#define checkIsVIP @"/124"
//充值卡
#define chongzhika @"http://ipay.txyapp.com:8181/appsrv/mobi/charge"
#define neiwang @"http://192.168.100.250:8181/appsrv/mobi/charge"
//判断是否是国外用户
#define checkIsOutMainLand @"/304"
//上传用户点
#define updataPoints @"/"
//机器码
#define both_pub_key @"qRH=59m>3R,f"
#define DeviceNum [[DeviceAbout sharedDevice]deviceNum]
//上报时间 int型
#define uptime  (long long int)[[NSDate date] timeIntervalSince1970]
//天下游版本号 vercode
#define vercode  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//sysapi  系统版本号
#define sysapi  [[DeviceAbout sharedDevice]getDeviceIOS]
//手机型号
#define PhoneModel [[DeviceAbout sharedDevice]deviceModel]
//systype 手机类型
#define systype @"IOS"
//获取公共参数字典
#define getPhonePublicInfo [[DeviceAbout sharedDevice]getPublicPhone]