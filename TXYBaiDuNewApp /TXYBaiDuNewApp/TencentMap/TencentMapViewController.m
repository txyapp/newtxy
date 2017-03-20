//
//  TencentMapViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TencentMapViewController.h"
//#import <QMapKit/QMapKit.h>
#import "TXYConfig.h"
#import "TXYTools.h"
#import "FireToGps.h"
#import "PopoverView.h"
#import "WebViewController.h"
#import "QMapKit.h"
#import <QMapSearchKit/QMapSearchKit.h>

#import "UMSocial.h"
#import "TCSearchViewController.h"
#import "AppDelegate.h"
#import "TCZhoubianViewController.h"
#import <QPanoramaKit/QPanoramaKit.h>
#import "KGStatusBar.h"
#import "ZCNoneiFLYTEK.h"
#import "WGS84TOGCJ02.h"

typedef enum {
    GPSCoordinates = 0,   ///< GPS坐标
    MarsCoordinates,    ///< 火星坐标
    BaiduCoordinates,   ///< 百度坐标
} CoordinateType;
//腾讯地图
QMapView *_qMapView;
QMSSearcher *_qSearcher;
QPointAnnotation* _qAnnotation;
//地理反编码
QMSReverseGeoCodeSearchOption *_qGeocode;
CLLocationCoordinate2D  qConCoord;
@interface TencentMapViewController ()<QMapViewDelegate,QMSSearchDelegate,UIGestureRecognizerDelegate,QPanoramaViewDelegate,UIAlertViewDelegate>{

    QPanoramaView *_panoramaView;
    UITapGestureRecognizer *mTap;
    ZCNoneiFLYTEK* manager;
    //用于记录定位方法执行次数
    int num;
    int isFirst;
    
}
@property (nonatomic)CLLocationDistance dis;
@property (nonatomic)NSNumber* longitude;
@property (nonatomic)NSNumber* latitude;
@property (nonatomic)UIButton* functionBtn;
@end

@implementation TencentMapViewController

//按移动距离计算
void notificationCallback (CFNotificationCenterRef center,
                           void * observer,
                           CFStringRef name,
                           const void * object,
                           CFDictionaryRef userInfo) {
    
    
    NSString *str = XuanFuGPSPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuGPSPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSDictionary* xuanfuDic = [plistDict objectForKey:@"xuanfugps"];
    NSMutableDictionary* xuanfuMdic = nil;
    if (xuanfuDic == nil){
        xuanfuMdic = [NSMutableDictionary dictionary];
    }else{
        xuanfuMdic = [NSMutableDictionary dictionaryWithDictionary:xuanfuDic];
    }
    NSNumber *vx = [xuanfuDic objectForKey:@"dirx"];
    NSNumber *vy = [xuanfuDic objectForKey:@"diry"];
    CGPoint dir;
    double z1 = 0.0;
    double dx = 0.0;
    double dy = 0.0;
    if (vx && vy) {
        dx = [vx doubleValue];
        dy = [vy doubleValue];
        dir = CGPointMake(dx, dy);
        z1 = sqrt(dx*dx + dy*dy);
    }
    double pi = z1 / 50;
    double x1;//1单位比值的x
    double y1;//1单位比值的y
    //如果pi>1，证明划出这个圆
    x1 = 50*dx/z1;
    y1 = 50*dy/z1;
    if (pi  > 1) {
        pi = (int)pi;
    }else{
        pi = 1;
    }
    
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
    CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
    // 东半球，北半球
    if (qConCoord.latitude >=0 && qConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =-LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =-LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =-LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =-LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //东半球 南半球
    if (qConCoord.latitude <0 && qConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //西半球 南半球
    if (qConCoord.latitude <0 && qConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //西半球 北半球
    if (qConCoord.latitude >0 && qConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =-LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =-LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =-LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =-LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    [[TXYConfig sharedConfig]setFakeGPS:qConCoord];
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:qConCoord.latitude bdLon:qConCoord.longitude];
    [_qAnnotation setCoordinate:huoxing];
    [_qMapView setCenterCoordinate:huoxing];

}
//滑动停止时的反应
void notificationCallbackEnd (CFNotificationCenterRef center,
                              void * observer,
                              CFStringRef name,
                              const void * object,
                              CFDictionaryRef userInfo) {
    NSString *str = XuanFuEndGPSPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuEndGPSPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSDictionary* xuanfuDic = [plistDict objectForKey:@"xuanfugps"];
    NSMutableDictionary* xuanfuMdic = nil;
    if (xuanfuDic == nil){
        xuanfuMdic = [NSMutableDictionary dictionary];
    }else{
        xuanfuMdic = [NSMutableDictionary dictionaryWithDictionary:xuanfuDic];
    }
    NSNumber *vx = [xuanfuDic objectForKey:@"dirx"];
    NSNumber *vy = [xuanfuDic objectForKey:@"diry"];
    CGPoint dir;
    if (vx && vy) {
        double dx = [vx doubleValue];
        double dy = [vy doubleValue];
        dir = CGPointMake(dx, dy);
    }
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
    CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);


    NSLog(@"移动停止 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,qConCoord.latitude,qConCoord.longitude);
    
    // 东半球，北半球
    if (qConCoord.latitude >=0 && qConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =-LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =-LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =-LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =-LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //东半球 南半球
    if (qConCoord.latitude <0 && qConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //西半球 南半球
    if (qConCoord.latitude <0 && qConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*200+qConCoord.longitude;
        }
    }
    //西半球 北半球
    if (qConCoord.latitude >0 && qConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            qConCoord.latitude =-LA*dir.y/50/5+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50/5+qConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            qConCoord.latitude =-LA*dir.y/50+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            qConCoord.latitude =-LA*dir.y/50*4+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*4+qConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            qConCoord.latitude =-LA*dir.y/50*200+qConCoord.latitude;
            qConCoord.longitude = -LO*dir.x/50*200+qConCoord.longitude;
        }
    }
     [[TXYConfig sharedConfig]setFakeGPS:qConCoord];
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:qConCoord.latitude bdLon:qConCoord.longitude];
    [_qAnnotation setCoordinate:huoxing];
    [_qMapView setCenterCoordinate:huoxing];
    //地址解析
    [_qGeocode setLocationWithCenterCoordinate:huoxing];
    [_qSearcher searchWithReverseGeoCodeSearchOption:_qGeocode];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    qConCoord = [[TXYConfig sharedConfig]getFakeGPS];
    qConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
    qConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    //判断是否是会员未注册
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(alertShow) name:@"mainUpdata" object:nil];
    [self createMap];
    
    [self makeView];
    isFirst =1;
    
    //底层滑动通知
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    notificationCallback,
                                    (CFStringRef)@"com.txy.getchange",
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    //底层停止滑动时通知
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    notificationCallbackEnd,
                                    (CFStringRef)@"com.txy.getchangeEnd",
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
}
-(void)alertShow
{
    //提示需要注册
    //判断是否是会员未注册
    NSString* newuserstatus =  [[NSUserDefaults standardUserDefaults] objectForKey:@"NewUserStatus"];
    NSLog(@"new = %@",newuserstatus);
    if ([newuserstatus isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"尊敬的会员您好" message:@"天下游现在将采用更安全的账号密码方式登录,请您注册登录体验更多功能，未注册使用将受到影响。\n天下游将给您带来更好更完美的服务" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 101;
        [alert show];
    }
    _switchView.on = NO;
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refush
{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    _isDing = NO;
    _switchView.hidden = YES;
    _stateView.hidden = YES;
    bem.hidden = YES;
    _yuyinJieGuoLab.text = @"";
    _yuyinBack.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [_qMapView viewDidDisappear];
    
}
//-(void)viewDidAppear:(BOOL)animated
- (void)viewWillAppear:(BOOL)animated{
   // [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refush) name:@"result" object:nil];
    //  self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    _isGang = YES;
    if (![[TXYTools sharedTools]isCanOpen]) {
        _switchView.on = NO;
        [[TXYConfig sharedConfig]setToggleWithBool:NO];
    }
    num = 0;
    //计时器
    //弹出时间设置
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* Tanchu = [userPoint objectForKey:@"Time"];
    if ([Tanchu isEqualToString:@"no"]) {
        [down setTitle:@"" forState:UIControlStateNormal];
        [down setBackgroundImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
    }
    if ([Tanchu isEqualToString:@"5s"]||!Tanchu) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"6" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"10s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"11" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"20s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"21" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    //右上角按钮
    bem.hidden = NO;
    _isGang = YES;
//    [_qMapView viewWillAppear];
    _qMapView.delegate = self;
    _qSearcher.delegate = self;
    if (_isTan){
        self.tabBarController.tabBar.hidden = YES;
    }
    
    if (self.isAPP) {
        UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
        self.navigationItem.leftBarButtonItem = items;
        _switchView.hidden = YES;
        _stateView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }else{
        _switchView.hidden = NO;
        _stateView.hidden = NO;
    }
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
    NSLog(@"la = %f, lo = %f",coord.latitude,coord.longitude);
    //如果开关没打开
    if (![[TXYConfig sharedConfig]getToggle]) {
        if (self.isAPP&&!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
            [_qAnnotation setCoordinate:huoxing];
            [_qMapView setCenterCoordinate:huoxing animated:NO];
//            [_qAnnotation setTitle:@"解析中"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_qMapView selectAnnotation:_qAnnotation animated:YES];
//            });
            [self locationAndGeo:coord CoordinateType:MarsCoordinates];
        }else{
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                [_qAnnotation setCoordinate:huoxing];
                [_qMapView setCenterCoordinate:huoxing animated:NO];
//                [_qAnnotation setTitle:@"解析中"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_qMapView selectAnnotation:_qAnnotation animated:YES];
//                });
                [self locationAndGeo:coord CoordinateType:MarsCoordinates];
            }else{
                [self knowWhereRU:1];
            }
        }
    }else{
        //如果地图选点定过位置，直接显示某个应用程序的选点位置,如果没有显示系统模拟位置
        if (self.isAPP&&!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
            NSLog(@"la = %f, lo = %f",coord.latitude,coord.longitude);
            [_qAnnotation setCoordinate:huoxing];
            [_qMapView setCenterCoordinate:huoxing animated:NO];
//            [_qAnnotation setTitle:@"解析中"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_qMapView selectAnnotation:_qAnnotation animated:YES];
//            });
            [self locationAndGeo:coord CoordinateType:MarsCoordinates];
        }else{
                if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude) == 0 &&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                    NSLog(@"gps.la = %lf,gps.lo = %lf",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                    NSLog(@"huoxing.la = %lf,huoxing.lo = %lf",huoxing.latitude,huoxing.longitude);
                    [_qMapView setCenterCoordinate:huoxing animated:NO];
                    [_qAnnotation setCoordinate:huoxing];
//                    [_qAnnotation setTitle:@"解析中"];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [_qMapView selectAnnotation:_qAnnotation animated:YES];
//                    });
                    [_qAnnotation setCoordinate:huoxing];
//                    [_qAnnotation setTitle:@"解析中"];
                    [self locationAndGeo:coord CoordinateType:MarsCoordinates];
//                    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                }else{
                    
                    [self knowWhereRU:1];
                }
        }
    }
}
-(void)delayMethod
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    [_qAnnotation setCoordinate:huoxing];
    [_qAnnotation setTitle:@"解析中"];
    [self locationAndGeo:coord CoordinateType:MarsCoordinates];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//生成地图
- (void)createMap{
    _qMapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    [_qMapView setZoomLevel:10];
    //为地图添加手势
    mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
    mTap.delegate = self;
    [_qMapView addGestureRecognizer:mTap];
    _qMapView.delegate = self;
    _qSearcher = [[QMSSearcher alloc] init];
    [_qSearcher setDelegate:self];
    _qGeocode = [[QMSReverseGeoCodeSearchOption alloc] init];
    [self.view addSubview:_qMapView];
    _qAnnotation = [[QPointAnnotation alloc] init];
    [_qMapView addAnnotation:_qAnnotation];
 
   // [_qMapView selectAnnotation:_qAnnotation animated:YES];

}
- (void)makeView{

    //定位按钮
    _nowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nowBtn setBackgroundImage:[UIImage imageNamed:@"map_icon_location@3x.png"] forState:UIControlStateNormal];
    [_nowBtn addTarget:self action:@selector(dangqian) forControlEvents:UIControlEventTouchUpInside];
    _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
    [self.view addSubview:_nowBtn];
    //弹出时间设置
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* Tanchu = [userPoint objectForKey:@"Time"];
    //是否弹出
    _isTan = NO;
    //是否添加收藏
    _isCollect = NO;
    self.navigationController.navigationBar.translucent = YES;
    //实例化tarview
    _tarView = [[UIView alloc]init];
    _tarView.backgroundColor = [UIColor grayColor];
    _tarView.frame = CGRectMake(0, 0, Width, 49);
    _tarView.hidden = YES;
    [self.tabBarController.tabBar addSubview:_tarView];

    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    
    //switch
    if (iOS7) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(5, 4, 79, 36)];
    }else{
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(5, 8, 79, 36)];
    }
    _switchView.onTintColor = IWColor(60, 170, 249);
    _switchView.tintColor = [UIColor whiteColor];
    //  _switchView.thumbTintColor = [UIColor redColor];
    
    [_switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    if ([[TXYTools sharedTools] isCanOpen]) {
        if ([[TXYConfig sharedConfig]getToggle]) {
            _switchView.on = YES;
        }else{
            _switchView.on = NO;
        }
        
    }else{
        _switchView.on = NO;
    }
    
    [self.navigationController.navigationBar addSubview:_switchView];
    //功能按钮
    bem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (iOS7) {
        bem.frame = CGRectMake(Width - 38, 4, 34, 32);
    }else{
        bem.frame = CGRectMake(Width - 38, 4, 34, 32);
    }
    [bem setBackgroundImage:[UIImage imageNamed:@"poi_picker_drag_img@2x.png"] forState:UIControlStateNormal];
    [bem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:bem];
    
    //判断系统版本是否高于6  然后规划stateBar高度
    if (iOS7) {
        _stateView = [[UIView alloc]initWithFrame:CGRectMake(57, 4, Width-97, 32)];
    }else{
        _stateView = [[UIView alloc]initWithFrame:CGRectMake(79, 4, Width-120, 32)];
    }
    //_stateView.image = [UIImage imageNamed:@"se.png"];
    _stateView.backgroundColor = [UIColor whiteColor];
    _stateView.layer.cornerRadius = 15;
    _stateView.layer.masksToBounds = YES;
    //  _stateView.layer.borderWidth = 1;
    //  _stateView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 17, 16)];
    searchIcon.image = [UIImage imageNamed:@"icon_search@2x.png"];
    [_stateView  addSubview:searchIcon];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(45, 7, 100, 18)];
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = @"搜地点";
    [_stateView addSubview:lab];
    UIView* xianview = [[UIView alloc]initWithFrame:CGRectMake(_stateView.frame.size.width - 40, 4, 2, 30)];
    xianview.backgroundColor = [UIColor grayColor];
    // [_stateView addSubview:xianview];
    UIButton* yuyinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuyinBtn.frame = CGRectMake(_stateView.frame.size.width - 37, 0, 30, 30);
    [yuyinBtn addTarget:self action:@selector(yuyin) forControlEvents:UIControlEventTouchUpInside];
    [yuyinBtn setBackgroundImage:[UIImage imageNamed:@"icon_poi_voice2.png"] forState:UIControlStateNormal];
    [_stateView addSubview:yuyinBtn];
    // [self.view addSubview:_stateView];
    
    [self.navigationController.navigationBar addSubview:_stateView];
    
    UITapGestureRecognizer* tapS = [[UITapGestureRecognizer alloc]init];
    [tapS addTarget:self action:@selector(searchTap)];
    [_stateView addGestureRecognizer:tapS];
    
    //  [_stateView addSubview:search];
    
    //点击地图 大头针出现后 从下面弹出来的view
    _downPushView = [[UIView alloc]initWithFrame:CGRectMake(0, Height + 130, Width, 130)];
    _downPushView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, Width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [_downPushView addSubview:view];
    down = [UIButton buttonWithType:UIButtonTypeCustom];
    [down addTarget:self action:@selector(xiaoshi) forControlEvents:UIControlEventTouchUpInside];
    // [down setTitle:@"点击消失" forState:UIControlStateNormal];
    down.titleLabel.font = [UIFont systemFontOfSize:12];
    // down.backgroundColor = [UIColor blueColor];
    //根据不同的弹出时间设置不同类型
    if ([Tanchu isEqualToString:@"no"]) {
        down.titleLabel.text = @"";
        [down setTitle:@"" forState:UIControlStateNormal];
        [down setBackgroundImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
    }
    if ([Tanchu isEqualToString:@"5s"]||!Tanchu) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"6" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"10s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"11" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"20s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"21" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    down.frame = CGRectMake(Width - 60, -10, 50, 50);
    down.layer.masksToBounds = YES;
    down.layer.cornerRadius = 25;
    [_downPushView addSubview:down];
    adress = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, Width-160 , 30)];
    adress.font = [UIFont systemFontOfSize:12];
    adress.numberOfLines = 0;
    adress.lineBreakMode = NSLineBreakByCharWrapping;
    
    juliLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - 150, 5, 145, 30)];
    juliLab.font = [UIFont systemFontOfSize:12];
    juliLab.textAlignment = NSTextAlignmentRight;
    
    [view addSubview:juliLab];
    [view addSubview:adress];
    //右边栏按钮
    //实时路况
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn1.tag = 8000;
    _btn1.frame = CGRectMake(Width - 50,   _stateView.frame.size.height+_stateView.frame.origin.y + 30, 50, 50);
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"lukuang1.png"] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(gongneng:) forControlEvents:UIControlEventTouchUpInside];
    //[_btn1 setAlpha:0.5];
    // [_btn1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_btn1];
    //图形
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 8001;
    btn2.frame = CGRectMake(Width - 50, _btn1.frame.origin.y+ 5+50, 50, 50);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tuceng2.png"] forState:UIControlStateNormal];
    // [btn2 setAlpha:0.5];
    [btn2 addTarget:self action:@selector(gongneng:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    //热力
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.tag = 8002;
    _btn3.frame = CGRectMake(Width - 50, btn2.frame.origin.y+ 5+ 50, 50, 50);
    [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli1.png"] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(gongneng:) forControlEvents:UIControlEventTouchUpInside];
    // [_btn3 setAlpha:0.5];
    //  [_btn3 setBackgroundColor:[UIColor grayColor]];
   // [self.view addSubview:_btn3];

    //搜周边
    _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[_button1 setTitle:@"搜周边" forState:UIControlStateNormal];
    _button1.tag = 7000;
    [_button1 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    if (!iOS7) {
        _button1.frame = CGRectMake(0, adress.frame.origin.y+30, Width/3, 30);
    }
    _button1.frame = CGRectMake(0, adress.frame.origin.y+ 30, Width / 3 , 50);
    UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhoubian1.png"]];
    imageView1.frame = CGRectMake(10, 10, 30, 30);
 
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
   
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"周边";
    //label2.userInteractionEnabled = YES;
    [_button1 addSubview:label1];
    
    [_button1 addSubview:imageView1];
    
    //添加收藏
    _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // [_button2 setTitle:@"添加收藏" forState:UIControlStateNormal];
    _button2.tag = 7001;
    [_button2 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button2.frame = CGRectMake(Width/3, adress.frame.origin.y+ 30, Width / 3, 50);
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang1.png"]];
    imageView2.frame = CGRectMake(10, 10, 30, 30);

    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];

    label2.font = [UIFont systemFontOfSize:14];
    //label2.textColor = [UIColor blueColor];
    label2.text = @"收藏";
    //label2.userInteractionEnabled = YES;
    [_button2 setShowsTouchWhenHighlighted:NO];
    [_button2 addSubview:label2];
    [_button2 addSubview:imageView2];
    
    //全景图
    _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //  [_button3 setTitle:@"全景图" forState:UIControlStateNormal];
    _button3.tag = 7002;
    [_button3 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button3.frame = CGRectMake(Width/3*2, adress.frame.origin.y+ 30, Width / 3, 50);
 
    UIImageView* imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanjing.png"]];
    imageView3.frame = CGRectMake(10,10, 30, 30);
   
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
   
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"全景";
    //label2.userInteractionEnabled = YES;
    [_button3 addSubview:label3];
    [_button3 addSubview:imageView3];
    
    //分享
    _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button4.tag = 7003;
    [_button4 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button4.frame = CGRectMake(Width/3*2, adress.frame.origin.y+ 30, Width / 3, 50);
  
    
    UIImageView* imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxiang2.png"]];
    imageView4.frame = CGRectMake(10,10, 30, 30);
  
    UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"分享";
    //label2.userInteractionEnabled = YES;
    [_button4 addSubview:label4];
    [_button4 addSubview:imageView4];
    
    [view addSubview:_button1];
    [view addSubview:_button2];
  //  [view addSubview:_button3];
    [view addSubview:_button4];
    
    [self.view addSubview:_downPushView];
    
    //语音搜索ui
    _yuyinBack = [[UIView alloc]init];
    _yuyinBack.frame = CGRectMake(0, 0, Width, Height);
    _yuyinBack.hidden = YES;
    _yuyinBack.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yuyinBackTap)];
    [_yuyinBack addGestureRecognizer:backTap];
    
    UIView* beijingView = [[UIView alloc]init];
    beijingView.frame = self.view.frame;
    beijingView.backgroundColor = [UIColor whiteColor];
    [_yuyinBack addSubview:beijingView];
    
    UILabel* shuohuaLab = [[UILabel alloc]init];
    shuohuaLab.text = @"请说话...";
    
    shuohuaLab.frame = CGRectMake(0, 30, Width, 30);
    _yuyinJieGuoLab.font = [UIFont systemFontOfSize:23];
    shuohuaLab.textAlignment = NSTextAlignmentCenter;
    [beijingView addSubview:shuohuaLab];
    
    
    _yuyinJieGuoLab = [[UILabel alloc]init];
    _yuyinJieGuoLab.frame = CGRectMake(0, 80, Width, 30);
    _yuyinJieGuoLab.textAlignment = NSTextAlignmentCenter;
    _yuyinJieGuoLab.font = [UIFont systemFontOfSize:20];
    [beijingView addSubview:_yuyinJieGuoLab];
    
    _bofangView = [[UIImageView alloc]init];
    _bofangView.frame = CGRectMake(50, 150, Width - 100, 100);
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Voice_Pop up_icon_speak_enter2@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter3@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter4@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter5@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter6@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter7@2x.png"],
                         [UIImage imageNamed:@"Voice_Pop up_icon_speak_enter8@2x.png"],
                         nil];
    _bofangView.animationImages = gifArray; //动画图片数组
    _bofangView.animationDuration = 3; //执行一次完整动画所需的时长
    _bofangView.animationRepeatCount = 5;  //动画重复次数
    
    [beijingView addSubview:_bofangView];
    
    _bofangView1 = [[UIImageView alloc]init];
    _bofangView1.frame = CGRectMake(20, Height - 50, Width - 40, 30);
    NSArray *gifArray1 = [NSArray arrayWithObjects:[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern9@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern1@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern2@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern3@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern4@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern5@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern6@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern7@2x"],[UIImage imageNamed:@"Voice_Pop up_icon_speak_discern8@2x"], nil];
    _bofangView1.animationImages = gifArray1; //动画图片数组
    _bofangView1.animationDuration = 3; //执行一次完整动画所需的时长
    _bofangView1.animationRepeatCount = 5;  //动画重复次数
    [beijingView addSubview:_bofangView1];
    
    _bofangView3 = [[UIImageView alloc]init];
    _bofangView3.frame = CGRectMake((Width - 104)/2, Height - 176, 104, 104);
    _bofangView3.image = [UIImage imageNamed:@"xuanzhuan.png"];
    // [beijingView addSubview:_bofangView3];
    
    _bofangView2 = [[UIImageView alloc]init];
    _bofangView2.frame = CGRectMake((Width - 100)/2, Height - 180, 100, 100);
    _bofangView2.image = [UIImage imageNamed:@"voicemap_sound_recording"];
    [beijingView addSubview:_bofangView2];
    
    
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_yuyinBack];
    
    //实例化背景view
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    _backView.frame = self.view.frame;
    _backView.hidden = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_backView addGestureRecognizer:tap];
    [self.view addSubview:_backView];
    //tanView
    _tanView = [[UIView alloc]init];
    _tanView.frame = CGRectMake(5, btn2.frame.origin.y + 50, Width - 5, (Height/3)/2);
    _tanView.backgroundColor = [UIColor whiteColor];
    [_backView  addSubview:_tanView];
    //弹出view内容
    weixingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [weixingBtn setBackgroundImage:[UIImage imageNamed:@"weixing.jpg"] forState:UIControlStateNormal];
    weixingBtn.frame = CGRectMake(10, 5, (Width - 20)/4, (Height /3)/2 - 40);
    [weixingBtn addTarget:self action:@selector(tuxing:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* weixingLab = [[UILabel alloc]init];
    weixingBtn.tag = 9000;
    weixingLab.text = @"卫星图";
    weixingLab.font = [UIFont systemFontOfSize:14];
    weixingLab.textAlignment = NSTextAlignmentCenter;
    weixingLab.frame = CGRectMake(10, (Height /3)/2 - 25, (Width - 20)/4, 17);
    
    weixingBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [weixingBtn1 setBackgroundImage:[UIImage imageNamed:@"2d.png"] forState:UIControlStateNormal];
    weixingBtn1.frame = CGRectMake(10+(Width - 20)/4+(Width -20)/8, 5, (Width - 20)/4, (Height /3)/2 - 40);
    [weixingBtn1 addTarget:self action:@selector(tuxing:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* weixingLab1 = [[UILabel alloc]init];
    weixingBtn1.tag = 9001;
    weixingLab1.text = @"2D平面图";
    weixingLab1.font = [UIFont systemFontOfSize:14];
    weixingLab1.textAlignment = NSTextAlignmentCenter;
    weixingLab1.frame = CGRectMake(10+(Width - 20)/4+(Width -20)/8, (Height /3)/2 - 25, (Width - 20)/4, 17);
    
    weixingBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [weixingBtn2 setBackgroundImage:[UIImage imageNamed:@"3d.png"] forState:UIControlStateNormal];
    weixingBtn2.frame = CGRectMake(10+(Width - 20)/4*2+(Width-20) /4, 5, (Width - 20)/4, (Height /3)/2 - 40);
    [weixingBtn2 addTarget:self action:@selector(tuxing:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* weixingLab2 = [[UILabel alloc]init];
    weixingBtn2.tag = 9002;
    weixingLab2.text = @"3D俯视图";
    weixingLab2.font = [UIFont systemFontOfSize:14];
    weixingLab2.textAlignment = NSTextAlignmentCenter;
    weixingLab2.frame = CGRectMake(10+(Width - 20)/4*2+(Width-20) /4, (Height /3)/2 - 25, (Width - 20)/4, 17);
    
    UIView* view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor grayColor];
    view1.frame = CGRectMake(10, weixingLab.frame.origin.y + 17, Width-20, 1);
    UIView* view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor grayColor];
    view2.frame = CGRectMake(10, _tanView.frame.size.height/4*3, Width - 20, 1);
    
    
    // [_tanView addSubview:view2];
    // [_tanView addSubview:view1];
    [_tanView addSubview:weixingLab];
    [_tanView addSubview:weixingBtn];
    [_tanView addSubview:weixingBtn1];
    [_tanView addSubview:weixingLab1];
    [_tanView addSubview:weixingBtn2];
    [_tanView addSubview:weixingLab2];
    
    // self.navigationController.navigationBarHidden =  YES;
    
    //地图功能button
    _functionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_functionBtn setBackgroundImage:[UIImage imageNamed:@"tuceng2.png"] forState:UIControlStateNormal];
    _functionBtn.frame = CGRectMake( 50, _stateView.frame.size.height+_stateView.frame.origin.y + 30, 50, 50);
    
}

#pragma mark - 图形按钮
//图形控制按钮
- (void)tuxing:(UIButton*)button{
    //卫星图
    if (button.tag == 9000) {
        [_qMapView setMapType:QMapTypeSatellite];
        _qMapView.show3D = NO;
        weixingBtn.layer.borderWidth = 2;
        weixingBtn.layer.borderColor = [UIColor blueColor].CGColor;
        weixingBtn1.layer.borderWidth = 0;
        weixingBtn2.layer.borderWidth = 0;
    }
    //2D平面图
    if (button.tag == 9001) {
        [_qMapView setMapType:QMapTypeStandard];
        _qMapView.show3D = NO;
        weixingBtn.layer.borderWidth = 0;
        weixingBtn1.layer.borderWidth = 2;
        weixingBtn1.layer.borderColor = [UIColor blueColor].CGColor;
        weixingBtn2.layer.borderWidth = 0;
    }
    //3D俯视图
    if (button.tag == 9002) {
        [_qMapView setMapType:QMapTypeStandard];
        _qMapView.show3D = YES;
        weixingBtn.layer.borderWidth = 0;
        weixingBtn1.layer.borderWidth = 0;
        weixingBtn2.layer.borderWidth = 2;
        weixingBtn2.layer.borderColor = [UIColor blueColor].CGColor;
    }
}
//让背景消失
- (void)tap{
    [self.view bringSubviewToFront:_backView];
    _backView.hidden = YES;
    _tarView.hidden = YES;
    if (!_isTan) {
        self.tabBarController.tabBar.hidden = NO;
    }
    mTap.delegate = self;
}
//全景按钮点击事件
- (void)gongneng:(UIButton *)button{
    //打开路况
    if (button.tag == 8000) {
        _qMapView.showTraffic = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"lukuang2.png"] forState:UIControlStateNormal];
        NSLog(@"打开路况");
        [button setAlpha:1.0];
        _btn1.tag = 8005;
        return;
    }
    //图形
    if (button.tag == 8001) {
        [self.view bringSubviewToFront:_backView];
        mTap.delegate = nil;
        [button setAlpha:1.0];
        _tarView.hidden = NO;
        _backView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        return;
    }
    //打开热力
    if (button.tag == 8002) {
       
        _btn3.tag = 8006;
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli2.png"] forState:UIControlStateNormal];
        NSLog(@"打开热力");
        return;
    }
    //关闭路况
    if (button.tag == 8005) {
        _qMapView.showTraffic = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"lukuang1.png"] forState:UIControlStateNormal];
        _btn1.tag = 8000;
        //   [button setAlpha:0.5];
        NSLog(@"关闭路况");
        return;
    }
    //关闭热力
    if (button.tag == 8006) {
        
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli1.png"] forState:UIControlStateNormal];
        _btn3.tag = 8002;
        [button setBackgroundColor:[UIColor clearColor]];
        NSLog(@"关闭热力");
        return;
    }
}

#pragma mark - 功能按钮
//➕点击事件
-(void)btnClick:(UIButton *)sender
{
    
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2 , _stateView.frame.origin.y + _stateView.frame.size.height + 10);
    NSArray *titles = @[@"天下论坛",@"联系客服",@"手动输入"];
    PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        if (index == 0) {
            NSLog(@"我是菜单一");
            WebViewController* wvc = [[WebViewController alloc]init];
            [self.navigationController pushViewController:wvc animated:YES];
        }
        if (index == 1) {
            NSLog(@"我是菜单二");
            
            NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=800061106&version=1&src_type=web"];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        if (index == 2) {
            NSLog(@"我是菜单三");
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"手动输入" message:@"请输入经度和纬度" delegate:self
                                      cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 200;
            alertView.delegate = self;
            //设置AlertView的样式
            [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            //   tf.keyboardType = UIKeyboardTypeNumberPad;
            // 设置textfield 的键盘类型。
            tf.placeholder = @"经度";
            UITextField *tf1 = [alertView textFieldAtIndex:1];
            tf1.secureTextEntry = NO;
            tf1.placeholder = @"纬度";
            // tf1.keyboardType = UIKeyboardTypeNumberPad;
            [alertView show];
        }
    };
    [pop show];
}

//搜索事件
- (void)searchTap{
    
    TCSearchViewController* tcSearch = [[TCSearchViewController alloc]init];
    NSLog(@"_chengshi = %@",_chengshi);
    tcSearch.chengshi = _chengshi;
    NSLog(@"_chengshi = %@",_chengshi);
    tcSearch.delegate = self;
    tcSearch.isAPP = self.isAPP;
    tcSearch.bundleID = self.bundleID;
    //如果有城市，城市内搜索，如果没有，周边
    if (_chengshi) {
        tcSearch.isZhou = NO;
    }else{
        tcSearch.isZhou = YES;
        if ((((int)[[TXYConfig sharedConfig]getRealGPS].latitude) == 0 &&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
            tcSearch.isZhou = NO;
            _chengshi = @"北京";
        }
    }
    [self.navigationController pushViewController:tcSearch animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tcSearch];
//    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 语音按钮
- (void)yuyin{
    [[[UIApplication sharedApplication] keyWindow] addSubview:_yuyinBack];
    _isYuyin = YES;
    _yuyinBack.hidden = NO;
    [_bofangView2 setImage:[UIImage imageNamed:@"voicemap_sound_recording"]];
    [_bofangView startAnimating];
    [_bofangView1 startAnimating];
    //  _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(xuanzhuan) userInfo:nil repeats:YES];
    manager=[ZCNoneiFLYTEK shareManager];
    [manager discernBlock:^(NSString *str) {
        NSLog(@"~~~~%@",str);
        _yuyinJieGuoLab.text = str;
        [manager cancle];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:nil];
            [_bofangView stopAnimating];
            [_bofangView1 stopAnimating];
            //    [_timer invalidate];
            [_bofangView2  setImage:[UIImage imageNamed:@"yuyintupian.png"]];
            if (_isYuyin) {
                TCSearchViewController* tcSearch = [[TCSearchViewController alloc]init];
                NSLog(@"_chengshi = %@",_chengshi);
                tcSearch.chengshi = _chengshi;
                NSLog(@"_chengshi = %@",_chengshi);
                tcSearch.delegate = self;
                tcSearch.isAPP = self.isAPP;
                tcSearch.bundleID = self.bundleID;
                tcSearch.keyWord1 = _yuyinJieGuoLab.text;
                tcSearch.isYuYin = YES;
                tcSearch.isHis = NO;
                //如果有城市，城市内搜索，如果没有，周边
                if (_chengshi) {
                    tcSearch.isZhou = NO;
                }else{
                    tcSearch.isZhou = YES;
                }
                [self.navigationController pushViewController:tcSearch animated:YES];
                [self yuyinBackTap];
            }
            
        });
        
        
        NSLog(@"text = %@",_yuyinJieGuoLab.text);
        //    //取消识别
    }];
}


- (void)yuyinBackTap{
    _yuyinBack.hidden = YES;
    [manager cancle];
    [_bofangView stopAnimating];
    [_bofangView1 stopAnimating];
    //  [_timer invalidate];
    _isYuyin = NO;
}

#pragma mark - 开关按钮
//开关按钮的点击事件
-(void)switchClick:(UISwitch *)sender
{
    //如果已经购买
    if ([[TXYTools sharedTools] isCanOpen]) {
        
        NSLog(@"sender.on = %d",sender.on);
        //sender.on=!sender.on;
        if (sender.on) {
            [[TXYConfig sharedConfig] setToggleWithBool:YES];
            NSLog(@"yes");
        }else{
            [[TXYConfig sharedConfig] setToggleWithBool:NO];
            NSLog(@"no");
        }
        
    }
    else
    {
        [[TXYConfig sharedConfig] setToggleWithBool:NO];
        [KGStatusBar showWithStatus:@"你还没有权限，购买登陆后才能享用天下游的服务"];
        if (sender.on == YES) {
            sender.on = NO;
        }else{
            sender.on = NO;
        }
        
    }
}
#pragma mark - 虚拟定位加解析
- (void)locationAndGeo:(CLLocationCoordinate2D)coord CoordinateType:(CoordinateType)type{
    CLLocationCoordinate2D nowCoord;
    if (type == 0) {
        nowCoord = coord;
    }
    if (type == 1) {
        //将工具类中的gps坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
        nowCoord = huoxing;
    }
    if (type == 2) {
        //将工具类中的gps坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
        //将火星转为百度
        CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
        nowCoord = baiduZuo;
    }
  //  [_qMapView setZoomLevel:10];
    [_qAnnotation setCoordinate:nowCoord];
    [_qMapView setCenterCoordinate:nowCoord];
    NSLog(@"nowcoord.la = %lf,nowcoord,lo = %lf",nowCoord.latitude,nowCoord.longitude);
    //地址解析
    [_qGeocode setLocationWithCenterCoordinate:nowCoord];
    [_qSearcher searchWithReverseGeoCodeSearchOption:_qGeocode];
}
//Geo逆地址解析
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult{
    //因为返回的是字符串，分割后取出经纬度
    NSLog(@"reverseGeoCodeSearchOption.location = %@",reverseGeoCodeSearchOption.location);
    NSArray *strarray = [reverseGeoCodeSearchOption.location componentsSeparatedByString:@","];
    NSString* la;
    NSString* lo;
    CLLocationCoordinate2D coord;
    if (strarray.count == 2) {
         la = strarray[0];
         lo = strarray[1];
    }
    NSLog(@"字符串:la = %@,lo = %@",la,lo);
    coord = CLLocationCoordinate2DMake([la floatValue], [lo floatValue]);
    NSLog(@"转换为经纬度:coord.la = %f  coord.lo = %f",coord.latitude,coord.longitude);
    NSLog(@"address = %@ location = %@",reverseGeoCodeSearchResult.address,reverseGeoCodeSearchOption.location);
    
    //不是点击地图或者搜索进来的，不弹出
    if (_isGang) {
        
    }else{
        [self addClick];
        _isGang = NO;
    }
    //存入plist
    AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _appDelegate.city = reverseGeoCodeSearchResult.address_component.city;
    //如果是定位状态，只获取当前所在的城市，不做大头针操作
    if (_isDing) {
        _chengshi = reverseGeoCodeSearchResult.address_component.city;
        NSLog(@"_chengshi = %@ , %@",_chengshi,reverseGeoCodeSearchResult.address_component.city);
        _isDing = NO;
    }

    if (self.isAPP) {
        if (!(((int)coord.latitude == 0)&&((int)coord.longitude == 0))) {
            //把点击的模拟位置转化为gps坐标存入plist
            _nowCoord = coord;
            //把火星坐标转为gps坐标
            CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
            NSLog(@"gpsZuo.la = %lf,gpsZuo.lo = %lf",gpsZuo.latitude,gpsZuo.longitude);
            [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
        }
            
        }else{
            if (!(((int)coord.latitude == 0)&&((int)coord.longitude == 0))) {
                //把点击的模拟位置转化为gps坐标存入plist
                _nowCoord = coord;
                //把火星坐标转为gps坐标
                CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
                [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
                qConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
                qConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
            }
        }
    
    //计算模拟点和真实点距离
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing1 = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getRealGPS].latitude bdLon:[[TXYConfig sharedConfig]getRealGPS].longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo1 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing1];
    CLLocationCoordinate2D huoxing2 = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo2 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing2];
    BMKMapPoint po1 = BMKMapPointForCoordinate(baiduZuo1);
    BMKMapPoint po2 = BMKMapPointForCoordinate(baiduZuo2);
    _dis = BMKMetersBetweenMapPoints(po1,po2);
    if (_dis > 1000) {
        _juli = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
    }else{
        _juli = [NSString stringWithFormat:@"%.f米",_dis];
    }
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    _time = locationString;
    _name = reverseGeoCodeSearchResult.address;
    adress.text = [NSString stringWithFormat:@"%@",reverseGeoCodeSearchResult.address];
    juliLab.text = [NSString stringWithFormat:@"距真实位置:%@",_juli];
    //将城市存起来，以免下次直接进入搜索没有城市
    _chengshi = reverseGeoCodeSearchResult.ad_info.city;
    NSLog(@"这个_chengshi = %@",_chengshi);
    NSLog(@"执行了3此");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_qAnnotation.title isEqualToString:reverseGeoCodeSearchResult.address]) {
            NSLog(@"你好啊");
        }else{
            //大头针添加信息
            if (![reverseGeoCodeSearchResult.address isEqualToString:@" "]) {
                [_qAnnotation setTitle:reverseGeoCodeSearchResult.address];
            }else{
                [_qAnnotation setTitle:@"国外"];
            }
        }
        NSLog(@"执行了一次");
        [_qMapView selectAnnotation:_qAnnotation animated:NO];
    });
    //上传用户信息
    [self addUserLocation:coord andAdress:reverseGeoCodeSearchResult.address];
    NSLog(@"执行了2次");
}
#pragma mark - 大头针回调
- (QAnnotationView *)mapView:(QMapView *)mapView
           viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        //设置复用标识
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        QAnnotationView *annotationView = [_qMapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[QPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];;
            //显示气泡
            annotationView.canShowCallout = YES;
        }
        //设置图标
      //  [annotationView setImage:[UIImage imageNamed:@"pin_red@2x"]];
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button1 addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 9000;
        annotationView.rightCalloutAccessoryView = button1;
        return annotationView;
    }
    return nil;
}

-(void)addClick
{
    //计时器
    //弹出时间设置
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* Tanchu = [userPoint objectForKey:@"Time"];
    if ([Tanchu isEqualToString:@"no"]) {
        down.titleLabel.text = @"";
        [down setBackgroundImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
    }
    if ([Tanchu isEqualToString:@"5s"]||!Tanchu) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"6" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"10s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"11" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    if ([Tanchu isEqualToString:@"20s"]) {
        [down setBackgroundImage:nil forState:UIControlStateNormal];
        [down setTitle:@"21" forState:UIControlStateNormal];
        down.titleLabel.font = [UIFont systemFontOfSize:20];
        [down setBackgroundColor:IWColor(60, 170, 249)];
    }
    
    NSLog(@"点击了一下");
    //在这里推出此annotation的更多选项view；
    if (!iOS7) {
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
        self.tabBarController.tabBar.hidden=YES;
        
        UIView *contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame=CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height+tabBar.bounds.size.height);
        
    }
    self.tabBarController.tabBar.hidden = YES;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_downPushView setFrame:CGRectMake(0, Height - 130, Width, 130)];
    _nowBtn.frame = CGRectMake(5, Height - 175, 50, 50);
    [UIView commitAnimations];
    _isTan = YES;
    if ([Tanchu isEqualToString:@"no"]) {
        
    }else{
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [timer fire];
    }
    //比例尺位置和当前按钮随之变化
    
}
//计时器方法
- (void)timerFired{
    int tim = [down.titleLabel.text intValue];
    //    NSLog(@"tim1 = %d",tim);
    if (tim <=0) {
        [timer invalidate];
        if (self.isAPP) {
            _isTan = NO;
            [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationDelegate:self];
            _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
            [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
            if (!iOS7) {
                [_downPushView setFrame:CGRectMake(0, Height + 200, Width, 170)];
            }
            [UIView commitAnimations];
            //比例尺位置和当前按钮随之变化
            
        }else{
            _isTan = NO;
            [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationDelegate:self];
            _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
            [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
            if (!iOS7) {
                [_downPushView setFrame:CGRectMake(0, Height + 200, Width, 170)];
            }
            [UIView commitAnimations];
            
            //比例尺位置和当前按钮随之变化
            
            //写到动画结束回调里面
            self.tabBarController.tabBar.hidden = NO;
        }
        
    }else
    {
        tim = tim - 1;
        [down setTitle:[NSString stringWithFormat:@"%d",tim] forState:UIControlStateNormal] ;
    }
}
//最下面弹出view中seg的点击事件
-(void)segClick:(UIButton *)button
{
    //搜周边
    if (button.tag == 7000 ) {
        TCZhoubianViewController* zhoubian = [[TCZhoubianViewController alloc]init];
        zhoubian.isZhou = YES;
        //self.hidesBottomBarWhenPushed=YES;
        //zhoubian.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zhoubian animated:YES];
        self.tabBarController.tabBar.hidden = YES;
    }
    
    //添加收藏
    if (button.tag == 7001) {
        //存储到本地收藏夹
        //如果已经添加到收藏夹
        
        NSLog(@"添加至收藏夹");
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
        NSString* whichMap1 = [plistDict objectForKey:@"WhichMap"];
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
        NSArray* array = [userPoint objectForKey:@"collect"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* doct = [[NSMutableDictionary alloc]init];
        BOOL isCun = NO;
        //判断收藏夹里面是否已经存有
        for (int i = 0; i<userArray.count; i++) {
            doct = [NSMutableDictionary dictionaryWithDictionary:userArray[i]];
            NSLog(@"doct = %@",doct);
            int longi2 = [doct[@"longitudeNum"] doubleValue] * 1000;
            int latitude2 = [doct[@"latitudeNum"] doubleValue] * 1000;
            NSString* whichMap2 = doct[@"whichMap"];
            NSLog(@"doct1 = %lf, doct2 = %lf",[doct[@"longitudeNum"] doubleValue],[doct[@"latitudeNum"] doubleValue]);
            NSLog(@"longi2 = %d,latitude2 = %d",longi2,latitude2);
            if (self.isAPP) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
                int longi = coord.longitude * 1000;
                int latidu = coord.latitude * 1000;
                if ((longi2 == longi)&&(latitude2 == latidu)&&([whichMap2 isEqualToString:@"baidu"]||[whichMap2 isEqualToString:@"tencent"]||!whichMap2)) {
                    isCun = YES;
                    //  [MyAlert ShowAlertMessage:@"收藏夹已经添加" title:@"温馨提示"];
                    [KGStatusBar showWithStatus:@"已存在，不能重复收藏"];
                    break;
                }
                
            }else{
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
                int longi = coord.longitude * 1000;
                int latidu = coord.latitude * 1000;
                NSLog(@"txy1 = %lf, txy2 = %lf",coord.longitude,coord.latitude);
                NSLog(@"longi = %d,latitude = %d",longi,latidu);
                if ((longi2 == longi)&&(latitude2 == latidu)&&([whichMap2 isEqualToString:@"baidu"]||[whichMap2 isEqualToString:@"tencent"]||!whichMap2)) {
                    NSLog(@"%d",longi);
                    isCun = YES;
                    //  [MyAlert ShowAlertMessage:@"收藏夹已经添加" title:@"温馨提示"];
                    [KGStatusBar showWithStatus:@"已存在，不能重复收藏"];
                    break;
                }
            }
        }
        //如果收藏夹中没有，存入收藏夹
        if (!isCun) {
            [dict setValue:_name forKey:@"name"];
            [dict setValue:_time forKey:@"time"];
            [dict setValue:@"tencent" forKey:@"whichMap"];
            [dict setValue:_latitude forKey:@"latitude"];
            [dict setValue:_longitude forKey:@"longitude"];
            if (_isAPP) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
                [dict setValue:[NSNumber numberWithDouble:coord.latitude] forKey:@"latitudeNum"];
                [dict setValue:[NSNumber numberWithDouble:coord.longitude] forKey:@"longitudeNum"];
            }else{
                [dict setValue:[NSNumber numberWithDouble:[[TXYConfig sharedConfig] getFakeGPS].latitude] forKey:@"latitudeNum"];
                [dict setValue:[NSNumber numberWithDouble:[[TXYConfig sharedConfig] getFakeGPS].longitude] forKey:@"longitudeNum"];
            }
            NSString* str;
            if (_dis > 1000) {
                str = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
            }else{
                str = [NSString stringWithFormat:@"%.f米",_dis];
            }
            [dict setValue:str forKey:@"juli"];
            NSLog(@"collect = %@",dict);
            
            
            [userArray insertObject:dict atIndex:0];
            [userPoint setObject:userArray forKey:@"collect"];
            _isCollect = YES;
            //同步操作
            [userPoint synchronize];
            //  [MyAlert ShowAlertMessage:@"成功存入收藏夹" title:@"添加成功"];
            [KGStatusBar showWithStatus:@"添加成功"];
        }
    }
    //全景图
    if (button.tag == 7002 ) {
        CLLocationCoordinate2D coord;
        if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
            coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
        }else{
            coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
        }
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
        _panoramaView = [QPanoramaView panoramaViewWithFrame:CGRectMake(
                                                                            0, 0, self.view.frame.size.width,
                                                                            self.view.frame.size.height )
                                                  nearCoordinate:huoxing radius:100];
      //  [_panoramaView setAllGesturesEnabled:YES];
       // _panoramaView.orientationEnabled = YES;
        [_panoramaView setParkViewHidden:YES];
        [_panoramaView setDelegate:self];
        [self.view addSubview:_panoramaView];
    }
    
    //分享
    if (button.tag == 7003) {
        double j= _nowCoord.longitude;
        double w = _nowCoord.latitude;
        NSDecimalNumber *number = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:j];
        NSDecimalNumber * number1 = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:w];
        NSString* str = [NSString stringWithFormat:@"经度:\n%@\n纬度:\n%@",number,number1];
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56025001e0f55a1ec4000e6a"
                                          shareText:str
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms, nil]
                                           delegate:nil];
    }
}
- (void)panoramaView:(QPanoramaView *)view
               error:(NSError *)error
onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate{
    NSLog(@"出错了");
   [KGStatusBar showWithStatus:@"当前选点没有全景图"];
    [_panoramaView removeFromSuperview];
}

- (void)panoramaView:(QPanoramaView *)panoramaView didTap:(CGPoint)point{
    NSLog(@"nihao ");
    [_panoramaView removeFromSuperview];
}

//上传用户位置信息
- (void)addUserLocation:(CLLocationCoordinate2D)coo andAdress:(NSString *)adress1
{
    //上传国外用户坐标
    //把火星坐标转为gps坐标
    if ([WGS84TOGCJ02 isLocationOutOfChina:coo]) {
        [[TXYTools sharedTools] getOldInfoWithCoor:coo andAdress:adress1];
    }else{
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coo.latitude gjLon:coo.longitude];
        [[TXYTools sharedTools] getOldInfoWithCoor:gpsZuo andAdress:adress1];
    }
}
//地图点击手势
//手势点击方法的处理
-(void)tapPress:(UIGestureRecognizer *)tap
{
  //  [_qMapView setShowsUserLocation:NO];
    _isGang = NO;
    _isShou = NO;
    _isDing = NO;
    CGPoint point = [tap locationInView:_qMapView];
    CLLocationCoordinate2D coord = [_qMapView convertPoint:point toCoordinateFromView:_qMapView];
    [_qAnnotation setCoordinate:coord];
    [_qAnnotation setTitle:@"解析中"];
    //解析坐标
    [self locationAndGeo:coord CoordinateType:0];
    //把火星坐标转为gps坐标
    CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
    //传入plist
    if (_isAPP) {
        [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
    }else{
        [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
        qConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        qConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    }
    
}
//点击消失事件
- (void)xiaoshi{
    [timer invalidate];
    if (self.isAPP) {
        _isTan = NO;
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
        [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
        if (!iOS7) {
            [_downPushView setFrame:CGRectMake(0, Height + 200, Width, 170)];
        }
        [UIView commitAnimations];
        //比例尺位置和当前按钮随之变化
        
    }else{
        _isTan = NO;
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
        [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
        if (!iOS7) {
            [_downPushView setFrame:CGRectMake(0, Height + 200, Width, 170)];
        }
        [UIView commitAnimations];
        //比例尺位置和当前按钮随之变化
        //写到动画结束回调里面
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            [userPoint setObject:@"first" forKey:@"First"];
            [userPoint synchronize];
        }
        if (buttonIndex == 0) {
            exit(0);
        }
        
    }
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            self.tabBarController.selectedIndex = 4;
        }
        if (buttonIndex == 0) {
            
        }
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            UITextField *tf1 = [alertView textFieldAtIndex:1];
            
            if ([self isPureFloat:tf.text] && [self isPureFloat:tf1.text] ) {
                long double la = [tf.text doubleValue];
                long double lo = [tf1.text doubleValue];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lo, la);
                _isGang = NO;
                _isShou = NO;
                [[TXYConfig sharedConfig]setFakeGPS:coord];
                qConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
                qConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                [_qAnnotation setCoordinate:huoxing];
                [_qMapView setCenterCoordinate:huoxing animated:NO];
                [_qAnnotation setTitle:@"解析中"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_qMapView selectAnnotation:_qAnnotation animated:YES];
//                });
                [self locationAndGeo:huoxing CoordinateType:0];
            }else{
                [KGStatusBar showWithStatus:@"格式不对，请重新输入"];
            }
            
        }
    }
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 搜索回调
//实现代理方法
-(void)chuanzhi:(XuandianModel *)model
{
    _isGang = NO;
    _isShou = NO;
    _isSou = YES;
    self.mingzi = model.weizhi;
    NSLog(@"实现代理方法");
    NSLog(@"%@",self.mingzi);
    NSLog(@"la = %f",[model.latitudeNum doubleValue]);
    NSLog(@"lo = %f",[model.longitudeNum doubleValue]);
    if (!self.isAPP) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
        //把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
        _nowCoord = coord;
        [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
        qConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        qConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
        [_qAnnotation setCoordinate:coord];
        [_qMapView setCenterCoordinate:coord animated:NO];
        [_qAnnotation setTitle:@"解析中"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_qMapView selectAnnotation:_qAnnotation animated:YES];
//        });
        //反编译
        [self locationAndGeo:coord CoordinateType:0];
    }else{
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
        _nowCoord = coord;
        [_qAnnotation setCoordinate:coord];
        [_qMapView setCenterCoordinate:coord animated:NO];
        [_qAnnotation setTitle:@"解析中"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_qMapView selectAnnotation:_qAnnotation animated:YES];
//        });
       [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
        [self locationAndGeo:coord CoordinateType:0];
    }
}



#pragma mark - 系统定位
//在地图view将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView{
    NSLog(@"开始定位");
}
//在地图view定位停止后，会调用此函数
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView{
    NSLog(@"停止定位");
}

//位置或者设备方向更新后，会调用此函数
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation{
    num++;
    NSLog(@"方向更新");
    NSLog(@"la = %f, lo = %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //将当前位置的火星坐标转为gps存起来
   
    CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:userLocation.coordinate.latitude gjLon:userLocation.coordinate.longitude];
    
    if ([WGS84TOGCJ02 isLocationOutOfChina:userLocation.coordinate]) {
        [[TXYConfig sharedConfig] setRealGPS:userLocation.coordinate];
    }else{
        [[TXYConfig sharedConfig]setRealGPS:gpsZuo];
    }
    [[TXYTools sharedTools] setOldCoordinate:gpsZuo];
    _isDing = NO;
}

// 定位失败后，会调用此函数
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
}

//开始定位
-(void)knowWhereRU:(int)whichSdk
{
    _isDing = YES;
    //开启定位功能
    [_qMapView setUserTrackingMode:0];
    [_qMapView setShowsUserLocation:YES];
}



//定位按钮点击方法
- (void)dangqian{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [MyAlert ShowAlertMessage:@"定位服务未开启，请进入系统【设置】->【隐私】->【定位服务】中打开开关，并允许天下游使用定位服务" title:@"打开定位开关"];
    } else{
        NSLog(@"定位服务打开");
    }
    _isOutChina = NO;
    //如果开关打开
    if ([[TXYConfig sharedConfig]getToggle]) {
        NSLog(@"你好");
        //如果是选取应用程序状态
        if (self.isAPP) {
            //如果该应用程序有模拟位置
            if (!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"] doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] doubleValue]);
                 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                [_qMapView setCenterCoordinate:huoxing];
                [self locationAndGeo:coord CoordinateType:MarsCoordinates];
            }else{
                if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
                    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                    [_qMapView setCenterCoordinate:huoxing];
                    _qMapView.stayCenteredDuringZoom = YES;
                    [self locationAndGeo:coord CoordinateType:MarsCoordinates];
                }else{
                    [self knowWhereRU:1];
                }
                [KGStatusBar showWithStatus:@"当前还没有选取模拟位置"];
                
            }
            
        }else{
            NSLog(@"txy = %f  %f",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                [_qMapView setCenterCoordinate:huoxing];
                [self locationAndGeo:coord CoordinateType:MarsCoordinates];
                
            }else{
                if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
                    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                    [_qMapView setCenterCoordinate:huoxing];
                    [self locationAndGeo:coord CoordinateType:MarsCoordinates];
                    
                }else{
                    [self knowWhereRU:1];
                }
                [KGStatusBar showWithStatus:@"当前还没有选取模拟位置"];
            }
            
        }
    }else{
        [self knowWhereRU:1];
//        if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
//            
//            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
//            [self locationAndGeo:coord CoordinateType:MarsCoordinates];
//            
//        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
