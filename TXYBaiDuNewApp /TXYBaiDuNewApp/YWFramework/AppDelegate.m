//
//  AppDelegate.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "SetViewController.h"
#import "TravelStreetViewController.h"
#import "FavoriteViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "SearchViewController.h"
#import "UserAuth.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "Pingpp.h"
#import "PayPalMobile.h"
#import "UMessage.h"
#import "TXYTools.h"
#import "CollectViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MBProgressHUD.h"
#import "TXYConfig.h"
#import "AFHTTPRequestOperation.h"
#include <notify.h>
#import "FakePhoneViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UMOnlineConfig.h"
#import "BackgroundTask.h"
#import <Bugly/CrashReporter.h>
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import "CaptainHook.h"
#import <BmobSDK/Bmob.h>
#import "Tools.h"
#include <dlfcn.h>
#import <sys/sysctl.h>
#include <mach-o/dyld.h>
#import "AdvancedViewController.h"
//#import <QMapKit/QMapKit.h>
#import "TencentMapViewController.h"
#import "QMapKit.h"
#import <QMapSearchKit/QMapSearchKit.h>
#import <QPanoramaKit/QPanoramaKit.h>
#import "GoogleMapViewController.h"
#import "TXYLocationManager.h"
#import "UpdateService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MBProgressHUD.h"
#import "GeTuiSdk.h"
#import "MyAlert.h"
#import "JoyStickView.h"
#import "AES128.h"
#import "MySaveDataManager.h"
//#import "WXApi.h"
#define kGtAppId           @"JkCQTyZrzF7K5RLUQjd8N4"
#define kGtAppKey          @"CozUIufNfd96W5zxkLnwJ4"
#define kGtAppSecret       @"7ZqJ9cRt518aen42siMJi"
//#define kGtAppId           @"4ORYA0rGGPAjN81lcbYdP3"
//#define kGtAppKey          @"pWaNuhWrpk9fccqLU4qtjA"
//#define kGtAppSecret       @"szT1Zxb3uT9sBuZCiSbef8"
#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
@interface AppDelegate ()<QAppKeyCheckDelegate,BMKGeneralDelegate,WXApiDelegate,UIApplicationDelegate, GeTuiSdkDelegate>
{
    MBProgressHUD *HUD;
    JoyStickView* _joyView;
    CGPoint playerOrigin;
}
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)BackgroundTask *bgTask;

@end

@implementation AppDelegate

/*CHDeclareClass(UIAlertController);
CHMethod(0, id, UIAlertController, popoverPresentationController){
    
    NSLog(@"111111111111111111111111111111111111");
    NSLog(@"self  %@",self);
    //NSLog(@"1111111");
    //CHSuper(5, UIActionSheet, initWithTitle, @"111", delegate, d, cancelButtonTitle, @"222", destructiveButtonTitle, @"333", otherButtonTitles, @"444");
    
    return self;
}*/



#pragma obfuscate on
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(	NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    //NSString *str= [NSString stringWithFormat:@"cydia://url/%@/cydia.html", docDir];
    
    //悬浮控制
//    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
//    NSString* xuanfu = [userPoint objectForKey:@"isXuanfu"];
//    if ([xuanfu isEqualToString:@"yes"]) {
//        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(),
//                                                        (CFStringRef)@"com.chinapyg.fakecarrier-change",
//                                                        NULL,
//                                                        nil,
//                                                        kCFNotificationDeliverImmediately|kCFNotificationPostToAllSessions);
//
//    }else{
//        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(),
//                                                        (CFStringRef)@"com.chinapyg.fakecarrier-change",
//                                                        NULL,
//                                                        nil,
//                                                        kCFNotificationDeliverImmediately|kCFNotificationPostToAllSessions);
//    }

    //检测是否是国外用户 根据ip来判断
    [self isOutMainLand];
    
    /**
     *  腾讯地图key设置
     */
    QAppKeyCheck* keyCheck = [[QAppKeyCheck alloc] init];
    [keyCheck start:@"4EHBZ-SHORU-FO4V4-42XX2-ICWFK-PLB7C" withDelegate:self];
    [[QMSSearchServices sharedServices] setApiKey:@"4EHBZ-SHORU-FO4V4-42XX2-ICWFK-PLB7C"];
    [[QPanoServices sharedServices] setApiKey:@"4EHBZ-SHORU-FO4V4-42XX2-ICWFK-PLB7C"];
    //[[Tools sharedTools] deleteForBackUpWithBundleId:@"www.akkun.com.YWFeedbackDemo" Key:@"2016-04-28-17:24:18"];
    
    [Bmob registerWithAppKey:@"9620d23633eb8aa2d2234539e08ddec2"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UserAuth sharedUserAuth]newAuthValueFormWeb];
    });
    

    [MobClick setCrashReportEnabled:NO];
    
    [[CrashReporter sharedInstance] enableLog:YES];
    [[CrashReporter sharedInstance] installWithAppId:@"900015156"];
    
    //[self performSelector:@selector(crash) withObject:nil afterDelay:3.0];
    [self creatBMKMapManager];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([[[TXYConfig sharedConfig]getLanguage]isEqualToString:@"CN"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
    }
    else if ([[[TXYConfig sharedConfig]getLanguage]isEqualToString:@"EN"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
    }
    else if([[[TXYConfig sharedConfig]getLanguage]isEqualToString:@"System"]||![[TXYConfig sharedConfig]getLanguage])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSLocale preferredLanguages]objectAtIndex:0] forKey:AppLanguage];
    }
    self.window.rootViewController=[self getTabBar];
    /**
     *  阿里云川用户反馈
     */
    
    /*
     *  获取真实位置
     */
    [[TXYLocationManager sharedManager] startSearchRealLocation];
    
    /**
     *  反动态调试检测
     */

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            sleep(10);
//            size_t size = sizeof(struct kinfo_proc);
//            struct kinfo_proc info;
//            int ret, name[4];
//            memset(&info, 0, sizeof(struct kinfo_proc));
//            name[0]= CTL_KERN;
//            name[1] = KERN_PROC;
//            name[2] = KERN_PROC_PID;
//            name[3] = getpid();
//            if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) {
//                continue;
//            }
//            int flag = (info.kp_proc.p_flag & P_TRACED) ? 1 : 0;
//            
//            if (flag == 1) {
////                //[[TXYConfigController sharedInstance] setLongandLat:@"1411sadNTirue8342JKLSwqnwyerojzxQQQ"];
//                exit(-1);
//                
//            }
//        }
//    });

    //[[QMapServices sharedServices] setApiKey:@"4EHBZ-SHORU-FO4V4-42XX2-ICWFK-PLB7C"];
    /**
     *  高德地图搜索配置
     */
    //[AMapSearchServices sharedServices].apiKey = @"b23d0637eb41abc6db707b76fbf51ecd";
    /**
     *  Tools相关
     */
    int uid=geteuid();
    NSLog(@"****************uid:%d",uid);
    [UMSocialData setAppKey:UmengKeyT];
    
    /**
     *  Map相关
     */
    
    
    /**
     *  TravelStreet相关
     */
    
    
    /**
     *  Set相关
     */
    
    
    // 打开本地通知
    if (iOS8) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
    else
    {
        //        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    //更新
    [[UpdateService defaultService] checkUpdateRelease];
    
    //分享
    [MobClick startWithAppkey:UmengKeyT reportPolicy:REALTIME channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
//    [MobClick checkUpdateWithDelegate:self selector:@selector(updata:)];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    
    //微信分享
    [UMSocialWechatHandler setWXAppId:@"wx1091af87d954d92d" appSecret:@"27d60cf961975ddefd2b2cc3d7ac7cbd" url:@"http://www.txyapp.com"];
    //微信支付
    //[WXApi registerApp:@"wx1091af87d954d92d"];
    [WXApi registerApp:@"wx1091af87d954d92d" withDescription:@"demo 2.0"];
    
    [UMOnlineConfig updateOnlineConfigWithAppkey:UmengKeyT];
    
    //QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1105008508" appKey:@"tnl9SXtrOT7C81M" url:@"http://www.txyapp.com"];
    
    [MobClick setLogEnabled:YES];// 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    // reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:UmengKeyT reportPolicy:(ReportPolicy)REALTIME channelId:nil];
    [MobClick updateOnlineConfig];//在线配置参数
    
    //问题反馈
    [UMOpus setAudioEnable:YES];
    [UMFeedback setLogEnabled:NO];
    [UMFeedback setAppkey:UmengKeyT];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
    
    //paypal 支付
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",PayPalEnvironmentSandbox : @"Abt6-BA1dwQHnYYPudmaR2RzSlRVohOBNuCcikwTMJP3ye0YzwQSxMd7FQRm"}];
    
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    
    [self checkDylibExist];
    
    //悬浮框

//    _joyView = [[JoyStickView  alloc]init];
//    _joyView.backgroundColor = [UIColor clearColor];
//    
//    self.window.windowLevel = UIWindowLevelAlert;
//    _joyView.frame = CGRectMake(100,Height/4*3, 100, 100);
//    [self.window addSubview:_joyView];
    return YES;
}

//按移动距离计算
- (void)onStickChanged:(id)notification
{
    //取出手指移动距离的x y
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];
    NSLog(@"dir.x = %f,dir.y = %f",dir.x,dir.y);
    NSLog(@"dir.x = %f  dir.y = %f",dir.x,dir.y);
    
    
}
//判断是否是国外用户
-(void)isOutMainLand
{
    NSDictionary *requestDic = @{@"header":getPhonePublicInfo};
    NSString *stringR = [self convertToJSONData:requestDic];
    NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"304",@"flag":@"4"};
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://118.178.230.72:7658/api/entrance",checkIsOutMainLand];
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict=responseObject;
        NSLog(@"responseDict = %@     %@",responseDict,responseDict[@"info"]);
        if (responseDict) {
            int state = [responseDict[@"status"] integerValue];
            if (state == 0) {
                NSString *data = responseDict[@"data"];
                if(!data) return ;
                NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic status = %d",[dic[@"status"] integerValue]);
                NSLog(@"data  = %@",dic[@"msg"]);
                if (dic[@"msg"][@"outOfMainland"]) {
                    if ([dic[@"msg"][@"outOfMainland"] intValue]==0) {
                        //国内
                        [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:@"outOfMainland"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        //[self updataPointAndLines];
                    }
                    else
                    {
                        //国外
                        [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:@"outOfMainland"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        //根据国内外用户上传收藏路线与选点
                        [self updataPointAndLines];
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/**
 *  返回一个tabBar
 *
 *  @return tabBar
 */
-(UITabBarController *)getTabBar{
    //如果没有设置语言版本，或者设为跟随系统
    UINavigationController *mapNaviCtrl;

    MapViewController *mapCtrl=[[MapViewController alloc]init];
    mapNaviCtrl=[[UINavigationController alloc]initWithRootViewController:mapCtrl];
    mapNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_map"];
    mapNaviCtrl.title=@"百度*地图";
    
    TencentMapViewController* tcmp = [[TencentMapViewController alloc]init];
    UINavigationController *tcNaviCtrl = [[UINavigationController alloc]initWithRootViewController:tcmp];
    tcNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_map"];
    tcNaviCtrl.title=@"腾讯*地图";
    
    GoogleMapViewController* ggmp = [[GoogleMapViewController alloc]init];
    UINavigationController *ggNaviCtrl = [[UINavigationController alloc]initWithRootViewController:ggmp];
    ggNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_map"];
    ggNaviCtrl.title=@"谷歌*地图";
  
    SetViewController *setCtrl=[[SetViewController alloc]init];
    UINavigationController *setNaviCtrl=[[UINavigationController alloc]initWithRootViewController:setCtrl];
    setNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_settings"];
    setNaviCtrl.title=@"设置";
    
    CollectViewController *favoriteCtrl=[[CollectViewController alloc]init];
    UINavigationController *favoriteNaviCtrl=[[UINavigationController alloc]initWithRootViewController:favoriteCtrl];
    favoriteNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_outline_star"];
    favoriteNaviCtrl.title=@"收藏";
    
    AdvancedViewController *fpCtrl=[[AdvancedViewController alloc]init];
    UINavigationController *fpNaviCtrl=[[UINavigationController alloc]initWithRootViewController:fpCtrl];
    fpNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"fp"];
    fpNaviCtrl.title=@"高级";
    
    TravelStreetViewController *travelStreetCtrl=[[TravelStreetViewController alloc]init];
    UINavigationController *travelStreetNaviCtrl=[[UINavigationController alloc]initWithRootViewController:travelStreetCtrl];
    travelStreetNaviCtrl.title=@"扫街";
    travelStreetNaviCtrl.tabBarItem.image = [UIImage imageNamed:@"menu_polyline"];
    UITabBarController *tabBarCtrl=[[UITabBarController alloc]init];
    NSString *str = WhichMap;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:WhichMap];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
   NSString* whichMap = [plistDict objectForKey:@"WhichMap"];
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [tabBarCtrl setViewControllers:@[mapNaviCtrl,favoriteNaviCtrl,travelStreetNaviCtrl,fpNaviCtrl,setNaviCtrl]];
    }
    if ([whichMap isEqualToString:@"tencent"]) {
        //此时界面应该是跳转腾讯的
        [tabBarCtrl setViewControllers:@[tcNaviCtrl,favoriteNaviCtrl,travelStreetNaviCtrl,fpNaviCtrl,setNaviCtrl]];
    }
    if ([whichMap isEqualToString:@"google"]) {
        //此时界面应该是跳转谷歌的
        [tabBarCtrl setViewControllers:@[ggNaviCtrl,favoriteNaviCtrl,travelStreetNaviCtrl,fpNaviCtrl,setNaviCtrl]];
    }
    return tabBarCtrl;
}


/*
- (void)updata:(NSDictionary *)appInfo{
    NSString *update_log=[appInfo objectForKey:@"update_log"];
    NSString *newVersion=[appInfo objectForKey:@"version"];
    BOOL isupdata=[[appInfo objectForKey:@"update"] boolValue];
    if (isupdata) {
        NSString *title=[NSString stringWithFormat:@"发现新版本 v%@",newVersion];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:update_log delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"方式一：cydia更新",@"方式二：下载更新", nil];
        alert.tag=4;
        [alert show];
    }
}

- (void)rewriteAppCydiaHtml
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cydia" ofType:@"html"];
    NSString *CydiaLogo = [[NSBundle mainBundle] pathForResource:@"Cydia_logo" ofType:@"png"];
    NSString *CydiaBtn = [[NSBundle mainBundle] pathForResource:@"Cydia_btn" ofType:@"png"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSString *log_text = [[NSString alloc] initWithData:
                          [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########LOGO" withString:CydiaLogo];
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########BTN" withString:CydiaBtn];
    [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //BOOL bRet = [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //    NSLog(@"write result %d", bRet);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self rewriteAppCydiaHtml];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"cydia://url/%@/cydia.html", docDir]]];
        exit(0);

 
    }else if(buttonIndex==2){
         MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.window.rootViewController.view];
         [self.window.rootViewController.view addSubview:hud];
         hud.mode=MBProgressHUDModeIndeterminate;
         [hud show:YES];
         
         NSString *url=[UMOnlineConfig getConfigParams:@"url"];
        
         //下载准备
         NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
         AFHTTPRequestOperation *requestOper=[[AFHTTPRequestOperation alloc]initWithRequest:request];
         // 下载
         // 指定文件保存路径，将文件保存在沙盒中
         NSString *cachePath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];;
         NSString *filePath=[cachePath stringByAppendingPathComponent:@"txy.deb"];
         filePath=@"/var/mobile/Library/Preferences/txy.deb";
         requestOper.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
         //监听下载进度
         [requestOper setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
             CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
             hud.progress=precent;
             hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(precent*100)];
         }];
         //下载结果
         [requestOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"下载成功");
             hud.labelText = @"正在安装";
             system("killall -9 Cydia");
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 notify_post("com.txyupdata.start");
             });
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"下载失败");
             [hud removeFromSuperview];
         if (error) {
             NSLog(@"%@",error);
         }
         }];
         
         [requestOper start];
    }else{
        NSLog(@"取消");
        
    }
}
*/


/**
 *  返回一个_mapManager
 *  AK  M1G9VgySxZ2FXLsOitELtlKy
 *  @return _mapManager
 */
- (BMKMapManager *)creatBMKMapManager
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduKey generalDelegate:self];
    if (ret) {
        NSLog(@"启动成功");
    }else{
        NSLog(@"启动失败");
    }
    return _mapManager;
}
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    if (clientId) {
        [[NSUserDefaults standardUserDefaults]setObject:clientId forKey:@"clientId"];
    }
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    //891007665
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    if([payloadMsg isEqualToString: @"offline"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
        NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
        [setDict setObject:@(0) forKey:@"authValue"];
        [[TXYConfig sharedConfig] setToggleWithBool:NO];
        [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
        NSLog(@"%@",[self.window.rootViewController class]) ;
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            NSLog(@"%@",((UITabBarController *)self.window.rootViewController).selectedViewController);
            if ([((UITabBarController *)self.window.rootViewController).selectedViewController isKindOfClass:[UINavigationController class]]) {
                //判断是否在各大界面
                UINavigationController *nav =((UINavigationController *)((UITabBarController *)self.window.rootViewController).selectedViewController);
                NSLog(@"%@",nav.viewControllers);
                int exist = 0;
                for (UIViewController *vis  in  nav.viewControllers) {
                    if ([vis isKindOfClass:[SetViewController class]]) {
                        exist = 1;
                    }
                    else
                    {
                        [nav popToRootViewControllerAnimated:YES];
                    }
                }
                if (exist == 1) {
                    //如果在设置界面 则跳转主界面
                    ((UITabBarController *)self.window.rootViewController).selectedIndex = 0;
                }
                else
                {
                    ((UITabBarController *)self.window.rootViewController).selectedIndex = 4;
                }
            }
            
        }
        [MyAlert ShowAlertMessage:@"您的账号在另一台设备登陆,请重新登陆" title:@"温馨提示"];
    }
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

- (void)onGetNetworkState:(int)iError
{
    NSLog(@"baidu map network state: %d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"baidu map Permission state: %d",iError);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([[UIDevice currentDevice].systemVersion doubleValue]<8.0) {
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.pausesLocationUpdatesAutomatically = NO;//否则只能运行10分钟
        [self.locationManager startUpdatingLocation];
    }
    if ([[UIDevice currentDevice].systemVersion doubleValue]>8.0) {
        if ([CLLocationManager locationServicesEnabled]) {
            
            [self.locationManager startUpdatingLocation];
        }
    }
    self.bgTask = [[BackgroundTask alloc] init];
    [self.bgTask startBackgroundTasks:2 target:self selector:@selector(backgroundHandler)];
}

- (void)checkDylibExist
{
    NSString *path = @"/Library/MobileSubstrate/DynamicLibraries/txytweak.dylib";
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"软件不完整" message:@"缺少核心文件 请重新安装" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)openLocalNotification
{
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (iOS8) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Remote Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
//    [application registerUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    application.applicationIconBadgeNumber = 0;
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [self.locationManager stopUpdatingLocation];
    [self.bgTask stopBackgroundTask];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService applicationDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

-(void)backgroundHandler{
    NSLog(@"bg Runing");
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"%@",url.host);
    NSString *urlStr=[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *wxORwb = [urlStr substringToIndex:2];
      NSLog(@"%@",wxORwb);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                if ([resultDic[@"resultStatus"] integerValue]==9000) {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付成功";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
//                    PersonInfoViewController *person =  [[PersonInfoViewController alloc]init];
//                    [person loadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==8000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"正在处理中";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==4000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"订单支付失败";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==5000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"重复请求";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6001)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"用户中途取消";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6002)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"网络连接出错";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6004)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付结果未知";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付错误";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
            }
        }];
    }
    else if ([wxORwb isEqualToString:@"wx"])
    {
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
        return  isSuc;
    }
    return YES;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"%@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                if ([resultDic[@"resultStatus"] integerValue]==9000) {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付成功";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    //                    PersonInfoViewController *person =  [[PersonInfoViewController alloc]init];
                    //                    [person loadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==8000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"正在处理中";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==4000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"订单支付失败";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==5000)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"重复请求";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6001)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"用户中途取消";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6002)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"网络连接出错";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else if ([resultDic[@"resultStatus"] integerValue]==6004)
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付结果未知";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
                else
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"支付错误";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
                    return ;
                }
            }
        }];
    }
    else if ([url.host isEqualToString:@"pay"])
    {
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
        return  isSuc;
    }
    return YES;
}
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        if (response.errCode == WXSuccess) {
            HUD = [[MBProgressHUD alloc] initWithView:self.window];
            [self.window addSubview:HUD];
            HUD.labelText = @"支付成功";
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:0.7];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
            return ;
        }
        else{
            HUD = [[MBProgressHUD alloc] initWithView:self.window];
            [self.window addSubview:HUD];
            HUD.labelText = @"支付失败";
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:0.7];
            return ;
        }
    }
    NSLog(@"%@",[resp class]);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == WXSuccess) {
            HUD = [[MBProgressHUD alloc] initWithView:self.window];
            [self.window addSubview:HUD];
            HUD.labelText = @"分享成功";
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:0.7];
            return ;
        }
        else{
            NSLog(@"分享失败");
        }
    }
}
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//}

//查询后台微信支付是否成功
-(void)checkWXPayIsSuccess:(NSString *)payNumber
{
    
}
//上传收藏的点的信息 还有路线的信息
-(void)updataPointAndLines
{
   // [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:@"outOfMainland"];
   int isOut =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"outOfMainland"] intValue];
    if (isOut == 1) {
        NSString *str = UpdataFinshPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:UpdataFinshPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSString* isFinish = [plistDict objectForKey:@"updataFinish"];
        //国外
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]&&![isFinish isEqualToString:@"yes"]) {
            //已经登录的状态  从本地收藏夹中提取数据
            NSMutableArray *updataPointsArr = [NSMutableArray arrayWithCapacity:0];
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            NSArray* array = [userPoint objectForKey:@"collect"];
            NSMutableArray* userArray = nil;
            if (array == nil){
                userArray = [NSMutableArray array];
            }else{
                userArray = [NSMutableArray arrayWithArray:array];
            }
            for (int i = 0; i<userArray.count; i++) {
                NSMutableDictionary* dict = userArray[i];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSLog(@"%@",dict[@"name"]);
                [dic setValue:dict[@"name"] forKey:@"address"];
                [dic setValue:dict[@"latitude"] forKey:@"lat"];
                [dic setValue:dict[@"longitude"] forKey:@"lng"];
                [updataPointsArr addObject:dic];
            }
            
            NSLog(@"需要上传的收藏点的个数:%d",updataPointsArr.count);
            NSDictionary *userDic = nil;
            if (updataPointsArr.count >0) {
                userDic = @{@"username":[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"],@"real lat":@([[TXYConfig sharedConfig]getRealGPS].latitude),@"real lng":@([[TXYConfig sharedConfig]getRealGPS].longitude),@"collection position":@[updataPointsArr],@"uuid":[[DeviceAbout sharedDevice] deviceNum]};
                NSString *userString =[self convertToJSONData:userDic];
                NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                NSString *stringR = [self convertToJSONData:requestDic];
                NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
                NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"1009",@"flag":@"4"};
                AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
                //http://ipay.txyapp.com:7658/api/entrance/
                NSString *url = @"http://ipay.txyapp.com:7658/api/entrance/";
                [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //上传成功后 需要本地做一个标示  来表明收藏夹已经上传了  不需要再次上传
                    [plistDict setObject:@"yes" forKey:@"updataFinish"];
                    [plistDict writeToFile:UpdataFinshPlist atomically:YES];
                    NSLog(@"shangcangjia shangchuan");
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }
    }
}
- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted  error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}
-(NSString*)encodeString:(NSString*)unencodedString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)unencodedString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    
    return encodedString;
}
@end
