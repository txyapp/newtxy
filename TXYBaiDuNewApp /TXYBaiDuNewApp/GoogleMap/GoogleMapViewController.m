//
//  ViewController.m
//  TXYGoogleTest
//
//  Created by aa on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapViewController.h"
#import "TXYGoogleService.h"
#import "GoogleAnnotationView.h"
#import "GoogleAnnotation.h"
#import "TXYGeocoderService.h"
#import "GoogleMapViewUtil.h"
#import "FireToGps.h"
#import "TXYConfig.h"
#import "TXYTools.h"
#import "PopoverView.h"
#import "WebViewController.h"
#import "ZCNoneiFLYTEK.h"
#import "GoogleSearchViewController.h"
#import <mach-o/dyld.h>
#import "TXYTools.h"
#import "UMSocial.h"

#define WXIdentifier 0xbcc
static unsigned char str2[] = {(WXIdentifier ^ '/'),(WXIdentifier ^ 'L'),(WXIdentifier ^ 'i'),(WXIdentifier ^ 'b'),(WXIdentifier ^ 'r'),(WXIdentifier ^ 'a'),(WXIdentifier ^ 'r'),(WXIdentifier ^ 'y'),(WXIdentifier ^ '/'),(WXIdentifier ^ 'M'),(WXIdentifier ^ 'o'),(WXIdentifier ^ 'b'),(WXIdentifier ^ 'i'),(WXIdentifier ^ 'l'),(WXIdentifier ^ 'e'),(WXIdentifier ^ 'S'),(WXIdentifier ^ 'u'),(WXIdentifier ^ 'b'),(WXIdentifier ^ 's'),(WXIdentifier ^ 't'),(WXIdentifier ^ 'r'),(WXIdentifier ^ 'a'),(WXIdentifier ^ 't'),(WXIdentifier ^ 'e'),(WXIdentifier ^ '/'),(WXIdentifier ^ 'D'),(WXIdentifier ^ 'y'),(WXIdentifier ^ 'n'),(WXIdentifier ^ 'a'),(WXIdentifier ^ 'm'),(WXIdentifier ^ 'i'),(WXIdentifier ^ 'c'),(WXIdentifier ^ 'L'),(WXIdentifier ^ 'i'),(WXIdentifier ^ 'b'),(WXIdentifier ^ 'r'),(WXIdentifier ^ 'a'),(WXIdentifier ^ 'r'),(WXIdentifier ^ 'i'),(WXIdentifier ^ 'e'),(WXIdentifier ^ 's'),(WXIdentifier ^ '/'),(WXIdentifier ^ '\0')};
GoogleMapScrollView *_gMapView;
GoogleAnnotation *_gAnnotation;
CLLocationCoordinate2D gConCoord;
@interface GoogleMapViewController ()<GoogleMapViewDelegate,TXYReverseGeocoderProtocol,TXYGoogleCurrentLocationProtocol,TXYGeocoderProtocol,UIAlertViewDelegate,PassDelegate>{

    ZCNoneiFLYTEK* manager;
    UIButton* shoucangBtn;
    int num;
}
@property (nonatomic,assign) CLLocationCoordinate2D  currentCoordinate;
@property (nonatomic)CLLocationDistance dis;
@property (nonatomic,strong) NSMutableArray         *m_array;

@end

@implementation GoogleMapViewController

//按移动距离计算
void notificationCallback1 (CFNotificationCenterRef center,
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
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
    //    CGPoint dar = [_mapView convertCoordinate:baiduZuo toPointToView:_mapView];
    //    CGPoint dararar;
    NSLog(@"移动时 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,gConCoord.latitude,gConCoord.longitude);
    // 东半球，北半球
    if (gConCoord.latitude >=0 && gConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =-LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =-LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =-LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =-LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //东半球 南半球
    if (gConCoord.latitude <0 && gConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //西半球 南半球
    if (gConCoord.latitude <0 && gConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =LA*5*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = -LO*5*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //西半球 北半球
    if (gConCoord.latitude >0 && gConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =-LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =-LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =-LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =-LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,gConCoord.latitude,gConCoord.longitude);
    [_gMapView setMapCenter:gConCoord animated:YES];
    [_gMapView removeMapAnnotation:_gAnnotation];
    _gAnnotation.annotationTitle = @"解析中...";
    _gAnnotation.coordinate = gConCoord;
    [_gMapView addMapAnnotation:_gAnnotation];
    [[TXYConfig sharedConfig]setFakeGPS:gConCoord];

}
//滑动停止时的反应
void notificationCallbackEnd1 (CFNotificationCenterRef center,
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
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
    NSLog(@"移动停止 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,gConCoord.latitude,gConCoord.longitude);
    
    // 东半球，北半球
    if (gConCoord.latitude >=0 && gConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =-LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =-LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =-LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =-LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //东半球 南半球
    if (gConCoord.latitude <0 && gConCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //西半球 南半球
    if (gConCoord.latitude <0 && gConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    //西半球 北半球
    if (gConCoord.latitude >0 && gConCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            gConCoord.latitude =-LA*dir.y/50/5+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50/5+gConCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            gConCoord.latitude =-LA*dir.y/50+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            gConCoord.latitude =-LA*dir.y/50*4+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*4+gConCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            gConCoord.latitude =-LA*dir.y/50*200+gConCoord.latitude;
            gConCoord.longitude = -LO*dir.x/50*200+gConCoord.longitude;
        }
    }
    NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,gConCoord.latitude,gConCoord.longitude);
    [_gMapView setMapCenter:gConCoord animated:YES];
    [_gMapView removeMapAnnotation:_gAnnotation];
    _gAnnotation.annotationTitle = @"解析中...";
    _gAnnotation.coordinate = gConCoord;
    [_gMapView addMapAnnotation:_gAnnotation];
    [[TXYConfig sharedConfig]setFakeGPS:gConCoord];
  //  [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:tapCoordinate andHandlerObject:self];
}


- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    _isGang = YES;
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
    _gMapView = [[TXYGoogleService mapManager] getMapScrollView];
    _gMapView.mapViewDelegate = self;
    [self.view addSubview:_gMapView];
   // [self.view addSubview:shoucangBtn];
    [self.view addSubview:_nowBtn];
    [_gMapView removeMapAnnotation:_gAnnotation];
    if (self.isAPP) {
        UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
        self.navigationItem.leftBarButtonItem = items;
        _switchView.hidden = YES;
        _stateView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }else{
        _switchView.hidden = NO;
        _stateView.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }
    bem.hidden = NO;
    if (![[TXYTools sharedTools]isCanOpen]) {
        _switchView.on = NO;
        [[TXYConfig sharedConfig]setToggleWithBool:NO];
    }
    if (![[TXYConfig sharedConfig]getToggle]) {
        if (self.isAPP&&!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
                 CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            [_gMapView removeMapAnnotation:_gAnnotation];
            _gAnnotation.annotationTitle = @"解析中...";
            _gAnnotation.coordinate = coord;
            [_gMapView addMapAnnotation:_gAnnotation];
            [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
            [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];

        }else{
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                [_gMapView removeMapAnnotation:_gAnnotation];
               _gAnnotation.annotationTitle = @"解析中...";
                _gAnnotation.coordinate = coord;
                [_gMapView addMapAnnotation:_gAnnotation];
                [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];

            }else{
                [self knowWhereRU:1];
            }
        }
    }else{
        //如果地图选点定过位置，直接显示某个应用程序的选点位置,如果没有显示系统模拟位置
        if (self.isAPP&&!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            [_gMapView removeMapAnnotation:_gAnnotation];
            _gAnnotation.annotationTitle = @"解析中...";
            _gAnnotation.coordinate = coord;
            [_gMapView addMapAnnotation:_gAnnotation];
            [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
            [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];

        }else{
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude) == 0 &&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                NSLog(@"DOuble = %lf",[[TXYConfig sharedConfig]getFakeGPS].latitude);
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                [_gMapView removeMapAnnotation:_gAnnotation];
                _gAnnotation.annotationTitle = @"解析中...";
                _gAnnotation.coordinate = coord;
                [_gMapView addMapAnnotation:_gAnnotation];
                [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];

            }else{
                
                [self knowWhereRU:1];
            }
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    _gMapView.mapViewDelegate = nil;
    _switchView.hidden = YES;
    _stateView.hidden = YES;
    bem.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gConCoord = [[TXYConfig sharedConfig]getFakeGPS];
    gConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
    gConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    // Do any additional setup after loading the view, typically from a nib.
    //判断是否是会员未注册
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(alertShow) name:@"mainUpdata" object:nil];
    //开始时调用以下方法
    [TXYGoogleService defaultService];
    [TXYGoogleService mapConfig];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [TXYGoogleService mapConfig].scrollMapViewFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    [TXYGoogleService mapManager];
    [TXYGoogleService locationManager];
    
    
//    [[TXYGoogleService mapManager] setMapScrollViewFrame:CGRectMake(0, 0, mapSize.width, mapSize.height)];

    unsigned char *p = str2;
    while( ((*p) ^=  WXIdentifier) != '\0')  p++;
    self.m_array = [[NSMutableArray alloc] init];
    for (uint32_t i = 0; i < _dyld_image_count(); i++){
        if (!strncmp(_dyld_get_image_name(i), str2, 42)){
            NSString *str = [self.m_array objectAtIndex:2];
            NSLog(@"%@",str);
        }
    }
    
    
    _gMapView = [[TXYGoogleService mapManager] getMapScrollView];
    _gMapView.mapViewDelegate = self;
    [self.view addSubview:_gMapView];
    
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    [[TXYGoogleService mapManager] loadMapTilesImageInRect:screenFrame atZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    _gAnnotation = [[GoogleAnnotation alloc] initWithAddButton:btn];
    
    //添加大头针,如果有模拟位置定位到模拟位置，如果没有开启定位
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {

    }else{
        [[TXYGoogleService locationManager] startUpdatingLocation];
        [[TXYGoogleService locationManager] startReceiveCurrentLocationWithHandler:self];
    }
    
    [self makeView];
    //底层滑动通知
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    notificationCallback1,
                                    (CFStringRef)@"com.txy.getchange",
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    //底层停止滑动时通知
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    notificationCallbackEnd1,
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
- (void)makeView{
    //定位按钮
    _nowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nowBtn setBackgroundImage:[UIImage imageNamed:@"map_icon_location@3x.png"] forState:UIControlStateNormal];
    [_nowBtn addTarget:self action:@selector(dangqian) forControlEvents:UIControlEventTouchUpInside];
    _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
    [self.view addSubview:_nowBtn];
    
    //开关
    _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(5, 8, 79, 36)];
    _switchView.onTintColor = IWColor(60, 170, 249);
    _switchView.tintColor = [UIColor whiteColor];
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
    bem.frame = CGRectMake(Width - 38, 4, 34, 32);
    [bem setBackgroundImage:[UIImage imageNamed:@"poi_picker_drag_img@2x.png"] forState:UIControlStateNormal];
    [bem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:bem];
    
    //搜索栏
    _stateView = [[UIView alloc]initWithFrame:CGRectMake(79, 4, Width-120, 32)];
    _stateView.backgroundColor = [UIColor whiteColor];
    _stateView.layer.cornerRadius = 15;
    _stateView.layer.masksToBounds = YES;
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
    [self.navigationController.navigationBar addSubview:_stateView];
    UITapGestureRecognizer* tapS = [[UITapGestureRecognizer alloc]init];
    [tapS addTarget:self action:@selector(searchTap)];
    [_stateView addGestureRecognizer:tapS];
    
    //收藏按钮
    //实时路况
    shoucangBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shoucangBtn.frame = CGRectMake(Width - 50,   _stateView.frame.size.height+_stateView.frame.origin.y + 40, 40, 40);
    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [shoucangBtn addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:shoucangBtn];
    
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
    
    //弹出时间设置
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* Tanchu = [userPoint objectForKey:@"Time"];
    //是否弹出
    _isTan = NO;
    //点击地图 大头针出现后 从下面弹出来的view
    _downPushView = [[UIView alloc]initWithFrame:CGRectMake(0, Height + 130, Width, 130)];
    _downPushView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, Width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [_downPushView addSubview:view];
    down = [UIButton buttonWithType:UIButtonTypeCustom];
    [down addTarget:self action:@selector(xiaoshi) forControlEvents:UIControlEventTouchUpInside];
    down.titleLabel.font = [UIFont systemFontOfSize:12];
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
    //搜周边
    _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    [_button1 addSubview:label1];
    
    [_button1 addSubview:imageView1];
    
    //添加收藏
    _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button2.tag = 7001;
    [_button2 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button2.frame = CGRectMake(Width/3/2, adress.frame.origin.y+ 30, Width / 3, 50);
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang1.png"]];
    imageView2.frame = CGRectMake(10, 10, 30, 30);
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
    
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"收藏";
    [_button2 setShowsTouchWhenHighlighted:NO];
    [_button2 addSubview:label2];
    [_button2 addSubview:imageView2];
    
    //全景图
    _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button3.tag = 7002;
    [_button3 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button3.frame = CGRectMake(Width/3*2-Width/12, adress.frame.origin.y+ 30, Width / 3, 50);
    
    UIImageView* imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanjing.png"]];
    imageView3.frame = CGRectMake(10,10, 30, 30);
    
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
    
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"全景";
    [_button3 addSubview:label3];
    [_button3 addSubview:imageView3];
    
    //分享
    _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button4.tag = 7003;
    [_button4 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button4.frame = CGRectMake(Width/3*2-Width/12, adress.frame.origin.y+ 30, Width / 3, 50);
    
    
    UIImageView* imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxiang2.png"]];
    imageView4.frame = CGRectMake(10,10, 30, 30);
    
    UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/3 - 40, 30)];
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"分享";
    [_button4 addSubview:label4];
    [_button4 addSubview:imageView4];
    
    //[view addSubview:_button1];
    [view addSubview:_button2];
    [view addSubview:_button4];

    [self.view addSubview:_downPushView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_yuyinBack];
}

#pragma mark - 弹出框
-(void)addClick
{
    [self.view bringSubviewToFront:_downPushView];
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
    self.tabBarController.tabBar.hidden = YES;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    if (self.isAPP) {
        [_downPushView setFrame:CGRectMake(0, Height - 180, Width, 130)];
        _nowBtn.frame = CGRectMake(5, Height - 225, 50, 50);
    }else{
        [_downPushView setFrame:CGRectMake(0, Height - 130, Width, 130)];
        _nowBtn.frame = CGRectMake(5, Height - 175, 50, 50);
    }
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

    }
    
    //添加收藏
    if (button.tag == 7001) {
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
            NSString* whichMap2 = doct[@"whichMap"];
            int longi2 = [doct[@"longitudeNum"] doubleValue] * 1000;
            int latitude2 = [doct[@"latitudeNum"] doubleValue] * 1000;
            NSLog(@"doct1 = %lf, doct2 = %lf",[doct[@"longitudeNum"] doubleValue],[doct[@"latitudeNum"] doubleValue]);
            NSLog(@"longi2 = %d,latitude2 = %d",longi2,latitude2);
            if (self.isAPP) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
                int longi = coord.longitude * 1000;
                int latidu = coord.latitude * 1000;
                if ((longi2 == longi)&&(latitude2 == latidu)&&[whichMap1 isEqualToString:whichMap2]) {
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
                if ((longi2 == longi)&&(latitude2 == latidu)&&[whichMap1 isEqualToString:whichMap2]) {
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
            [dict setValue:_latitude forKey:@"latitude"];
            [dict setValue:@"google" forKey:@"whichMap"];
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
            
            [dict setValue:str forKey:@"juli"];
            NSLog(@"collect = %@",dict);
            
            
            [userArray insertObject:dict atIndex:0];
            [userPoint setObject:userArray forKey:@"collect"];
            //同步操作
            [userPoint synchronize];
            //  [MyAlert ShowAlertMessage:@"成功存入收藏夹" title:@"添加成功"];
            [KGStatusBar showWithStatus:@"添加收藏成功"];
        }

    }
    //全景图

    
    //分享
    if (button.tag == 7003) {
        double j= [[TXYConfig sharedConfig]getFakeGPS].longitude;
        double w = [[TXYConfig sharedConfig]getFakeGPS].latitude;
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

#pragma mark - 定位按钮

//开始定位
-(void)knowWhereRU:(int)whichSdk
{
    [[TXYGoogleService locationManager] startUpdatingLocation];
    [[TXYGoogleService locationManager] startReceiveCurrentLocationWithHandler:self];

}
//定位按钮点击方法
- (void)dangqian{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [MyAlert ShowAlertMessage:@"定位服务未开启，请进入系统【设置】->【隐私】->【定位服务】中打开开关，并允许天下游使用定位服务" title:@"打开定位开关"];
    } else{
        NSLog(@"定位服务打开");
    }
    //如果开关打开
    if ([[TXYConfig sharedConfig]getToggle]) {
        NSLog(@"你好");
        //如果是选取应用程序状态
        if (self.isAPP) {
            //如果该应用程序有模拟位置
            if (!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"] doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] doubleValue]);
                [_gMapView removeMapAnnotation:_gAnnotation];
                _gAnnotation.annotationTitle = @"解析中...";
                _gAnnotation.coordinate = coord;
                [_gMapView addMapAnnotation:_gAnnotation];
                [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
            }else{
                if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
                    [_gMapView removeMapAnnotation:_gAnnotation];
                    _gAnnotation.annotationTitle = @"解析中...";
                    _gAnnotation.coordinate = coord;
                    [_gMapView addMapAnnotation:_gAnnotation];
                    [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                    [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
                }else{
                    [self knowWhereRU:1];
                }
                [KGStatusBar showWithStatus:@"当前还没有选取模拟位置"];
                
            }
            
        }else{
            NSLog(@"txy = %f  %f",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                [_gMapView removeMapAnnotation:_gAnnotation];
                _gAnnotation.annotationTitle = @"解析中...";
                _gAnnotation.coordinate = coord;
                [_gMapView addMapAnnotation:_gAnnotation];
                [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
                
            }else{
                if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
                    [_gMapView removeMapAnnotation:_gAnnotation];
                    _gAnnotation.annotationTitle = @"解析中...";
                    _gAnnotation.coordinate = coord;
                    [_gMapView addMapAnnotation:_gAnnotation];
                    [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
                    [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
                    
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
#pragma mark - 功能按钮
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
                GoogleSearchViewController* ggsv = [[GoogleSearchViewController alloc]init];
                ggsv.delegate = self;
                ggsv.isAPP = self.isAPP;
                ggsv.bundleID = self.bundleID;
                ggsv.keyWord1 = str;
                ggsv.isYuYin = YES;
                ggsv.isHis = NO;
                [self.navigationController pushViewController:ggsv animated:YES];
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

#pragma mark - 搜索按钮
- (void)searchTap{
    GoogleSearchViewController* ggsv = [[GoogleSearchViewController alloc]init];
    ggsv.delegate = self;
    ggsv.isAPP = self.isAPP;
    ggsv.bundleID = self.bundleID;
    [self.navigationController pushViewController:ggsv animated:YES];
}

#pragma mark - 搜索回调
//实现代理方法
-(void)chuanzhi:(XuandianModel *)model
{
    _isGang = NO;
    NSLog(@"实现代理方法");
    NSLog(@"la = %f",[model.latitudeNum doubleValue]);
    NSLog(@"lo = %f",[model.longitudeNum doubleValue]);
    if (!self.isAPP) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
        [[TXYConfig sharedConfig]setFakeGPS:coord];
        gConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        gConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
        [_gMapView removeMapAnnotation:_gAnnotation];
        _gAnnotation.annotationTitle = @"解析中...";
        _gAnnotation.coordinate = coord;
        [_gMapView addMapAnnotation:_gAnnotation];
        [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
        [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];

    }else{
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
        [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:coord];
        [_gMapView removeMapAnnotation:_gAnnotation];
        _gAnnotation.annotationTitle = @"解析中...";
        _gAnnotation.coordinate = coord;
        [_gMapView addMapAnnotation:_gAnnotation];
        [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
        [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
    }
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - 收藏按钮
- (void)shoucang{
    
  
}

- (void)googleMapScrollView:(GoogleMapScrollView *)mapScrollView didTapLocationCoordinate:(CLLocationCoordinate2D)tapCoordinate
{
     _isGang = NO;
    [mapScrollView setMapCenter:tapCoordinate animated:YES];
    [mapScrollView removeMapAnnotation:_gAnnotation];
    _gAnnotation.annotationTitle = @"解析中...";
    _gAnnotation.coordinate = tapCoordinate;
    [mapScrollView addMapAnnotation:_gAnnotation];
    [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:tapCoordinate andHandlerObject:self];
    //存入plist
    if (self.isAPP) {
        [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:tapCoordinate];
    }else{
    [[TXYConfig sharedConfig]setFakeGPS:tapCoordinate];
        gConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        gConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    }
}

- (void)didReverseGeocodeSuccessWithStreetInfo:(NSString *)info andCoordinate:(CLLocationCoordinate2D)coordinate
{
    _gAnnotation.annotationTitle = info;
    
    
    //不是点击地图或者搜索进来的，不弹出
    if (_isGang) {
        
    }else{
        [self addClick];
        _isGang = NO;
    }
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    _time = locationString;
    _name = info;
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
    adress.text = [NSString stringWithFormat:@"%@",info];
    juliLab.text = [NSString stringWithFormat:@"距真实位置:%@",_juli];
    
    [[TXYTools sharedTools] getOldInfoWithCoor:coordinate andAdress:info];
}

- (void)didReverseGeocodeFailedWithInfo:(NSString *)info
{
    _gAnnotation.annotationTitle = info;
}

- (void)didReceiveCurrentLocation:(CLLocation *)currentLocation
{
    self.currentCoordinate = currentLocation.coordinate;
    [[TXYTools sharedTools] setOldCoordinate:currentLocation.coordinate];
    [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:self.currentCoordinate];
    [[TXYGoogleService mapManager] addCurrentLocationAnnotationAtCoordinate:currentLocation.coordinate];
    [[TXYGoogleService mapManager] refreshAnnotations];
    [[TXYGoogleService locationManager] stopUpdatingLocation];
}

- (void)didGeocoderSuccessWithResults:(NSArray *)results
{
    
}

- (void)didGeocoderFailedWithInfo:(NSString *)failedInfo
{
    NSLog(@"search failed : %@",failedInfo);
}

- (IBAction)click:(id)sender
{
    [[TXYGoogleService locationManager] startUpdatingLocation];
    [[TXYGoogleService locationManager] startReceiveCurrentLocationWithHandler:self];
    NSLog(@"click");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            self.tabBarController.selectedIndex = 4;
        }
        if (buttonIndex == 0) {
            
        }
    }else{

    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        _isGang = NO;
        // 拿到UITextField
        UITextField *tf = [alertView textFieldAtIndex:0];
        UITextField *tf1 = [alertView textFieldAtIndex:1];
        
        if ([self isPureFloat:tf.text] && [self isPureFloat:tf1.text] ) {
            long double la = [tf.text doubleValue];
            long double lo = [tf1.text doubleValue];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lo, la);
            [_gMapView removeMapAnnotation:_gAnnotation];
            _gAnnotation.annotationTitle = @"解析中...";
            _gAnnotation.coordinate = coord;
            [_gMapView addMapAnnotation:_gAnnotation];
            [[TXYGoogleService mapManager] setGoogleMapCenterAtCoordinate:coord];
            [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:coord andHandlerObject:self];
            if (!self.isAPP) {
                [[TXYConfig sharedConfig]setFakeGPS:coord];
                gConCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
                gConCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
            }else{
                [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:coord];
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
