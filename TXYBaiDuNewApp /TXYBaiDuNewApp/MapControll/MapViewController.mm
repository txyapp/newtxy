//
//  MapViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/8.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "MapViewController.h"
#import "PanoViewController.h"
#import "TXYConfig.h"
#import "PoiViewController.h"
#import "MyAlert.h"
#import "ZhoubianViewController.h"
#import "TXYTools.h"
#import "ZCNoneiFLYTEK.h"
#import "FireToGps.h"
#import "SearchResultViewController.h"
#import "AppDelegate.h"
#import "UserAuth.h"
#import "MBProgressHUD.h"
#import "JKAlertDialog.h"
#import "WebViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "WGS84TOGCJ02.h"

static int single;
const double ee = 0.00005;
const double pi = 3.14159265358979324;
CLLocationCoordinate2D  conCoord;
//百度地图
BMKMapView *_mapView;
BMKPointAnnotation* _annotation;
//地理反编码
BMKGeoCodeSearch *_search;
@interface MapViewController ()<BMKPoiSearchDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    UIView *_downPushView;
    ZCNoneiFLYTEK*manager;
    int num;
    int _i;
    //弹出菜单计时器
    NSTimer *timer;
    UIButton *down;
    NSString* singleStr;
    int tappress;
}
@property (nonatomic,strong)UILabel* tishi;
@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* time;
@property (nonatomic)NSNumber* longitude;
@property (nonatomic)NSNumber* latitude;

@property (nonatomic)CLLocationDistance dis;

@end

@implementation MapViewController

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
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
//    CGPoint dar = [_mapView convertCoordinate:baiduZuo toPointToView:_mapView];
//    CGPoint dararar;
    NSLog(@"移动时 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,conCoord.latitude,conCoord.longitude);
    // 东半球，北半球
    if (conCoord.latitude >=0 && conCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =-LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =-LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =-LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =-LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //东半球 南半球
    if (conCoord.latitude <0 && conCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //西半球 南半球
    if (conCoord.latitude <0 && conCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //西半球 北半球
    if (conCoord.latitude >0 && conCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =-LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =-LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =-LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =-LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*200+conCoord.longitude;
        }
    }
    NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,conCoord.latitude,conCoord.longitude);
//    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]gcj02Encrypt:conCoord.latitude bdLon:conCoord.longitude];
//    //将火星转为百度
    CLLocationCoordinate2D baiduZuo111 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing111];
    [[TXYConfig sharedConfig]setFakeGPS:conCoord];
    [_mapView setCenterCoordinate:baiduZuo111];
    [_mapView removeAnnotation:_annotation];
    _annotation.coordinate = baiduZuo111;
    _annotation.title = @"解析中";
    [_mapView addAnnotation:_annotation];
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
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
    NSLog(@"移动停止 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,conCoord.latitude,conCoord.longitude);
    
    // 东半球，北半球
    if (conCoord.latitude >=0 && conCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =-LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =-LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =-LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =-LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //东半球 南半球
    if (conCoord.latitude <0 && conCoord.longitude >= 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //西半球 南半球
    if (conCoord.latitude <0 && conCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*200+conCoord.longitude;
        }
    }
    //西半球 北半球
    if (conCoord.latitude >0 && conCoord.longitude < 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            conCoord.latitude =-LA*dir.y/50/5+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50/5+conCoord.longitude;
        }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
            conCoord.latitude =-LA*dir.y/50+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"20m"]) {
            conCoord.latitude =-LA*dir.y/50*4+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*4+conCoord.longitude;
        }
        if ([jingdu isEqualToString:@"1000m"]) {
            conCoord.latitude =-LA*dir.y/50*200+conCoord.latitude;
            conCoord.longitude = -LO*dir.x/50*200+conCoord.longitude;
        }
    }
    NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,conCoord.latitude,conCoord.longitude);
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]gcj02Encrypt:conCoord.latitude bdLon:conCoord.longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo111 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing111];
    [[TXYConfig sharedConfig]setFakeGPS:conCoord];
    [_mapView setCenterCoordinate:baiduZuo111];
    [_mapView removeAnnotation:_annotation];
    _annotation.coordinate = baiduZuo111;
    _annotation.title = @"解析中";
    [_mapView addAnnotation:_annotation];
    BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
    pt1.reverseGeoPoint = baiduZuo111;
    [_search reverseGeoCode:pt1];

}


- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refush) name:@"result" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(alertShow:) name:@"mainUpdata" object:nil];

  //  self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
    NSLog(@"setdict = %@",setDict);
    if (![[TXYTools sharedTools]isCanOpen]||![[TXYConfig sharedConfig]getToggle]) {
        _switchView.on = NO;
        [[TXYConfig sharedConfig]setToggleWithBool:NO];
    }
    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NewUserStatus"];
//    NSString *str = LoginPlist;
//    NSMutableDictionary *plistDict;
//    if (str) {
//        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:LoginPlist];
//        if (plistDict==nil) {
//            plistDict=[NSMutableDictionary dictionary];
//        }
//    }else{
//        plistDict=[NSMutableDictionary dictionary];
//    }
//    [plistDict removeAllObjects];
//    BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
//    if (result) {
//        NSLog(@"存入成功");
//    }else{
//        NSLog(@"存入失败");
//    }
    
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
    
    //设置显示比例尺
    _mapView.showMapScaleBar = YES;
   
    //设定比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
    
 
    _mapView.delegate = self;
    _locService.delegate = self;
    
    //如果模拟位置为空，定位
    if ((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0&&(int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0){
        [self knowWhereRU:1];
    }
 
    //如果开关没打开
    if (![[TXYConfig sharedConfig]getToggle]) {
        if (_isSou) {
            
        }else{
            if (self.isAPP&&!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
                NSLog(@"coord.la = %lf,coord.lo = %lf",coord.latitude,coord.longitude);
                //将工具类中的gps坐标转为火星坐标
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
                //将火星转为百度
                CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];

                [_mapView setCenterCoordinate:baiduZuo] ;
                BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                pt1.reverseGeoPoint = baiduZuo;
                [_search reverseGeoCode:pt1];
            }else{
            if (_isSou) {
                
            }else{
                
                if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude) == 0 &&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                  //  NSLog(@"la = %f  lo = %f",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
                    [_mapView removeAnnotations:_mapView.annotations];
                    
                    //将工具类中的gps坐标转为火星坐标
                    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
                    //将火星转为百度
                    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
    
                    [_mapView setCenterCoordinate:baiduZuo] ;
                    BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                    pt1.reverseGeoPoint = baiduZuo;
                    [_search reverseGeoCode:pt1];
                }else{
                    
                    [self knowWhereRU:1];
                }
            }

            }
        }
    }else{
        //如果地图选点定过位置，直接显示某个应用程序的选点位置,如果没有显示系统模拟位置
        if (self.isAPP&&!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            NSLog(@"coord.la = %lf,coord.lo = %lf",coord.latitude,coord.longitude);
            
            //将工具类中的gps坐标转为火星坐标
            CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue] bdLon:[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] doubleValue] ];
            //将火星转为百度
            CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
            [_mapView removeAnnotation:_annotation];
            _annotation.coordinate = baiduZuo;
            if (!_annotation.title) {
                _annotation.title = @"解析中";
            }
            [_mapView addAnnotation:_annotation];
            [_mapView selectAnnotation:_annotation animated:YES];
            [_mapView setCenterCoordinate:baiduZuo] ;
            BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
            pt1.reverseGeoPoint = baiduZuo;
            [_search reverseGeoCode:pt1];
            
        }else{
            if (_isSou) {
                
            }else{
            
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude) == 0 &&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                NSLog(@"DOuble = %lf",[[TXYConfig sharedConfig]getFakeGPS].latitude);
                [_mapView removeAnnotations:_mapView.annotations];
                
                //将工具类中的gps坐标转为火星坐标
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
                //将火星转为百度
                CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
                [_mapView removeAnnotation:_annotation];
                _annotation.coordinate = baiduZuo;
                if (!_annotation.title) {
                    _annotation.title = @"解析中";
                }
                [_mapView addAnnotation:_annotation];
                [_mapView selectAnnotation:_annotation animated:YES];
                [_mapView setCenterCoordinate:baiduZuo] ;
                BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                pt1.reverseGeoPoint = baiduZuo;
                [_search reverseGeoCode:pt1];
                
            }else{
                
                [self knowWhereRU:1];
            }
            }
        }

    }
}

-(void)alertShow:(NSNotification *)notification
{
    //提示需要注册
    //判断是否是会员未注册
    NSString *code = (NSString *)notification.object;
    NSString* newuserstatus =  [[NSUserDefaults standardUserDefaults] objectForKey:@"NewUserStatus"];
    NSLog(@"new = %@",newuserstatus);
    ;
    if ([newuserstatus isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"尊敬的会员您好" message:[NSString stringWithFormat:@"您的机器码为:%@ 已检测您为VIP用户,由于天下游登陆系统升级,您需要注册账号进行登录,账号密码登陆系统可用于换机.\n给您带来的不便,敬请谅解.",code] delegate:nil cancelButtonTitle:@"暂不注册" otherButtonTitles:@"前去注册", nil];
        alert.delegate = self;
        alert.tag = 101;
        [alert show];
    }
    _switchView.on = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tappress = 0;
    conCoord = [[TXYConfig sharedConfig]getFakeGPS];
    conCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
    conCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    _mapView.zoomLevel = 3;
    num = M_PI*60/180;
     _i = 0;
    single = 0;
    singleStr = [NSString stringWithFormat:@"%d",single];
    [singleStr addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    //实例化地图
    [self creatBMap];
    //如果没有模拟位置

    //判断是否是第一次进入app
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    
    NSString* first = [userPoint objectForKey:@"First"];
    if (!first) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"用户协议" message:@"1. 天下游服务条款的接受\n  天下游为北京天下在线科技有限公司（以下简称“天下在线公司”）所独立拥有，并按本协议及天下在线公司不时发布的规则提供基于互联网的相关服务（以下称“网络服务”）。为获得网络服务，服务使用人（以下称“用户”） 应仔细阅读本协议条款，用户同意本协议的全部条款并按照页面上的提示完成全部的注册程序。用户在进行注册程序过程中点击同意按钮即表示用户完全接受本协议项下的全部条款，如发生纠纷，用户不得以未仔细阅读为由进行任何实体和程序抗辩。\n  用户注册成功后，天下游将给予每个用户一个用户帐号及相应的密码，该用户帐号和密码由用户负责保管；对于天下游分配给用户的用户帐号，用户在对登陆后所持帐号产生的行为依法享有权利和承担义务。用户应当对以其用户帐号进行的所有活动和事件承担相应法律责任.\n2. 服务内容\n2.1　天下游提供的网络服务具体内容由天下在线公司根据实际情况提供，例如天下游主软件下载，游戏工具下载，官方活动发布，官方论坛(BBS)等。\n2.2 天下游中提供用户使用的功能仅供用户个人学习和研究使用。 用户使用时还应遵守相关软件及资料的使用协议、用户规则等规定，如有违反的后果由用户自行承担，如造成本公司损失的，本公司有权追偿。\n3. 服务变更、中断或终止\n3.1　 鉴于网络服务的特殊性，用户同意天下游有权随时变更、中断或终止部分或全部的网络服务。 如变更、中断或终止的网络服务时，无需对任何用户或任何第三方承担任何责任，但天下游将尽可能事先进行通告。\n3.2 　用户理解，天下游需要定期或不定期地对提供网络服务的平台或相关的设备进行检修或者维护，如因此类情况而造成网络服务（包括收费网络服务）在合理时间内的中断，天下游无需为此承担任何责任，但天下游应尽可能事先进行通告。\n3.3 　用户有下列行为之一的，天下游将暂停分配给用户帐号的登录和使用。若天下游认为用户行为严重程度较低的，天下游可能在采取暂停措施之前通知用户限期改正。若天下游通知客户改正的，用户应在所通知的期限内改正。用户未在天下游的通知期限内改正的，天下游有权随时中断或终止向用户提供本协议项下的网络服务而无需对用户或任何第三方承担任何责任：用户就天下游通知中所述的行为已经改正并经天下游确认的，天下游将恢复该帐号的登录和使用：\n3.3.1 　用户严重违反本协议的行为；\n3.3.2 　用户提供虚假注册身份信息的；\n3.3.3 　用户违反本协议中规定的使用规则；\n3.3.4 　通过不正当手段使用天下游的产品和服务的；\n3.3.5 　违反中华人民共和国的法律禁止性规定的；\n3.3.6 　违背社会公德的行为。\n3.4 　天下游适用3.3款项之规定暂停用户帐号等单方中止或终止合同履行的，若需要天下游举证，则天下游仅在天下游的现有技术限度内就用户违反法律禁止性规定和严重违反合同约定的事实承担举证责任。\n3.5 　如用户注册的网络服务的帐号在任何连续180日内未实际使用，或者用户订购收费网络服务后连续180日内未实际使用，则天下游有权删除该帐号并停止为该用户提供相关的网络服务。\n4. 使用规则\n4.1 　用户同意以其真实身份注册成为天下游的用户，并保证所提供的个人身份资料信息真实、完整，依据法律规定和本协议约定对所提供的不实信息承担相应的法律责任和不利的法律后果。用户不应将其帐号、密码转让或出借予他人使用。如用户发现其帐号遭他人非法使用，应立即通知天下游。因黑客行为或用户的保管疏忽导致帐号、密码遭他人非法使用，天下游不承担任何责任。\n4.2 　用户注册成为天下游的用户后，需要修改、变更所提供的个人身份资料信息的应当根据天下游公布的方式通知天下游并提供相关证明。天下游收到通知并审核相关证明(未免疑问，天下游仅对相关文件承担形式审查责任，不对相关证明的审核承担实质性审查疑问)后，天下游将在合理的时间内为用户提供修改、变更服务。\n4.3 　天下游有权审查用户注册所提供的身份信息是否真实，并采取必要的技术与管理等措施保障用户帐号的安全、有效。\n4.4 　用户有义务妥善保管该用户帐号及密码，严格按照本协议的约定正确、安全地使用用户帐号及密码。用户因为自身原因造成密码遗失、帐号被盗而给自身和他人民事权利造成损害的，天下游不承担法律责任，用户自行承担相应责任，但法律另有规定和本协议另有约定的除外。\n4.5　用户发现所分配的帐号或密码被他人非法使用或有使用异常的情况的，应及时根据天下游公布的方式通知天下游，并有权要求天下游采取措施暂停该帐号的登录和使用。\n4.6　天下游用户申请采取措施暂停用户帐号的登录和使用的，用户应当向天下游提供有效的个人身份证件，并对用户提供的个人身份证件与其注册身份信息的一致性进行形式审查：\n4.6.1 　天下游核实要求采取措施暂停该帐号的登录和使用的用户所提供的个人有效身份证件与所注册的身份信息相一致的，将暂停该用户帐号的登录和使用，并通知用户。\n4.6.2　 若因可归责于天下游原因，导致天下游未及时采取措施暂停用户帐号的登录和使用，而造成用户与此相关的直接损失的，天下游仅对未及时采取措施所导致的扩大的直接损失承担责任。\n4.6.3 　用户未提供其个人有效身份证件或者用户提供的个人有效身份证件与所注册的身份信息不一致的，天下游将拒绝用户暂停该用户帐号的登录和使用的请求。\n4.7 　用户为了维护其合法权益，向天下游提供与所注册的身份信息相一致的个人有效身份证件时，天下游将为用户提供必要的协助和支持，并根据需要向有关行政机关和司法机关提供相关证据信息资料。\n4.8 　用户同意接受天下游通过电子邮件或其他方式向用户发送商品促销或其他相关商业信息。\n4.9 　用户对于其创作并通过天下游网络服务（包括但不限于论坛）上传到天下游上的内容依法享有版权及其他相关合法权利。对于用户通过天下游网络服务上传到天下游网站上可公开获取区域的任何内容，用户同意天下游在全世界范围内具有免费的、永久性的、不可撤销的权利和许可，以使用、复制、修改、翻译、据以创作衍生作品、传播、表演和展示此等内容。\n4.10 　用户在使用天下游网络服务过程中，必须遵循以下原则：\n4.10.1 　遵守中国有关的法律和法规；\n4.10.2 　遵守天下游的所有网络协议、规定和程序；\n4.10.3 　不得为任何非法目的而使用网络服务系统；\n4.10.4 　不得利用天下游网络服务系统进行任何可能对互联网或天下游正常运转造成不利影响的行为；\n4.10.5 　不得利用天下游提供的网络服务上传、展示或传播任何虚假的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、庸俗淫秽的或其他任何非法的信息资料；\n4.10.6 　不得侵犯其他任何第三方的专利权、著作权、商标权、名誉权或其他任何合法权益；\n4.10.7 　如发现任何非法使用用户帐号或帐号出现安全漏洞的情况，应立即通告天下游。\n4.11 　如用户在使用网络服务时违反任何上述规定，天下游或其授权的人有权要求用户改正或直接采取一切必要的措施（包括但不限于更改或删除用户张贴的内容等、暂停或终止用户使用网络服务的权利）以减轻用户不当行为造成的影响。天下游适用本款之规定暂停用户帐号等单方中止或终止合同履行的，若需要天下游举证，则天下游仅在天下游的现有技术限度内就用户违反法律禁止性规定和严重违反合同约定的事实承担举证责任。\n4.12 　用户利用注册的天下游账号接受天下游提供的软件，工具，邮箱等相关服务时，应视为用户已同意相关软件、工具、邮箱等服务所特有（专用）的服务协议及相关规则并承诺予以遵守。上文所称的特有（专用）的服务协议及相关规则，用户应主动在相关服务的首页（官网）上查阅，如用户对该服务协议及相关规则有异议的，应主动终止相关的服务。\n4.13 　天下游针对某些特定的天下游网络服务的使用通过各种方式（包括但不限于网页公告、电子邮件、短信提醒等）作出的任何声明、通知、警示等内容视为本协议的一部分，用户如使用该等天下游网络服务，视为用户同意该等声明、通知、警示的内容。如用户对该声明、通知、警示有异议的，应主动终止相关的服务。\n5. 知识产权\n5.1 　天下游提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护，未经相关权利人同意，上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行，或者被用于其他任何商业目的。所有这些资料或资料的任何部分仅可作为私人和非商业用途而保存在某台计算机内。天下游不就由上述资料产生或在传送或递交全部或部分上述资料过程中产生的延误、不准确、错误和遗漏或从中产生或由此产生的任何损害赔偿，以任何形式，向用户或任何第三方负责。\n5.2 　天下游为提供网络服务而使用的任何软件（包括但不限于软件中所含的任何图像、照片、动画、录像、录音、音乐、文字和附加程序、随附的帮助材料）的一切权利均属于该软件的著作权人，未经该软件的著作权人许可，用户不得对该软件进行反向工程（reverse engineer）、反向编译（decompile）或反汇编（disassemble）。\n6. 用户信息保护\n6.1 　用户提供与其个人身份有关的信息资料给天下游时，应当已了解并接受天下游的隐私权保护政策和个人信息利用政策。天下游将采取措施保护用户的个人信息资料的安全。\n6.2 　未经用户许可，天下游不会向任何第三方公开或共享用户注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：\n6.2.1 　用户或用户监护人授权天下游披露的；\n6.2.2 　有关法律要求天下游披露的；\n6.2.3 　司法机关或行政机关基于法定程序要求天下游提供的；\n6.2.4 　应用户监护人的合法要求而提供用户个人身份信息时；\n6.2.5 　天下游为维护自己的合法权益向用户提起诉讼或者仲裁时；\n6.2.6 　其它需要提供用户个人身份信息的情况。\n6.3 　天下游可能会与第三方合作向用户提供相关的网络服务，在此情况下，如该第三方同意承担与天下游同等的保护用户隐私的责任，则天下游有权将用户的注册资料等提供给该第三方。\n6.4 　在不透露单个用户隐私资料的前提下，天下游有权对整个用户数据库进行分析并对用户数据库进行商业上的利用。\n7. 免责声明\n7.1 　天下游不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该等外部链接指向的不由天下游实际控制的任何网页上的内容，天下游不承担任何责任。\n7.2 　天下游有权但无义务，改善或更正本服务任何部分之任何疏漏、错误。\n7.3 　天下游不保证（包括但不限于）：\n7.3.1 　网络服务适合用户的使用要求；\n7.3.2 　网络服务不受干扰，及时、安全、可靠或不出现错误，包括黑客入侵，网络中断，电信问题及其他不可抗力等；\n7.3.3 　用户经由网络服务取得的任何产品、服务或其他材料符合用户的期望；\n7.3.4 　对于因不可抗力或天下游不能控制的原因造成的网络服务中断或其它缺陷，天下游不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。\n7.4 　用户同意，对于天下游向用户提供的服务的质量缺陷本身及其引发的任何损失，天下游无需承担任何责任。\n7.5 　由于用户经由天下游张贴或传送内容、违反本服务条款或侵害其他人的任何权利导致任何第三人提出权利主张，用户同意赔偿天下游及其分公司、关联公司、代理人或其他合作伙伴及员工，并使其免受损害。\n8. 协议修改\n8.1 　天下游有权随时修改本协议的任何条款，一旦本协议的内容发生变动，天下游将会通过网页公告等方式向用户提示修改内容。\n8.2 　如果不同意天下游对本协议相关条款所做的修改，用户有权停止使用网络服务。如果用户继续使用网络服务，则视为用户接受天下游对本协议相关条款所做的修改。\n9. 通知送达\n9.1 　本协议项下天下游对于用户所有的通知均可通过网页公告、电子邮件等方式进行；该等通知于发送之日视为已送达收件人。\n9.2 　用户对于天下游的通知应当通过天下游对外正式公布的通信地址、传真号码等联系信息进行送达。\n10. 青少年用户特别提示\n青少年用户必须遵守全国青少年网络文明公约：\n要善于网上学习，不浏览不良信息；要诚实友好交流，不侮辱欺诈他人；要增强自护意识，不随意约会网友；要维护网络安全，不破坏网络秩序；要有益身心健康，不沉溺虚拟时空。\n11. 法律管辖\n11.1 　本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律并受中国法院管辖。\n11.2 　如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向天下在线公司注册地的人民法院提起诉讼。\n12. 其他规定\n12.1 　本协议构成双方对本协议之约定事项及其他有关事宜的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\n12.2 　如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n12.3 　本协议中的标题仅为方便而设，在解释本协议时应被忽略。\n                    北京天下在线科技有限公司                                                                                                                                            .                  " delegate:nil cancelButtonTitle:@"不同意" otherButtonTitles:@"我同意", nil];
            alert.delegate = self;
            alert.tag = 100;
            [alert show];
    }
    
    //修改ui
    [self creatUI];
    // Do any additional setup after loading the view.
    
    //悬浮框的通知
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver: self
//                           selector: @selector (onStickChanged:)
//                               name: @"StickChanged"
//                             object: nil];
//    [notificationCenter addObserver: self
//                           selector: @selector (GPSMoveTo:)
//                               name: @"GPSMoveTo"
//                             object: nil];
//    NSString* getChanggeStr = @"com.txy.getchange";
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


//记得释放百度SDK的代理
-(void)viewWillDisappear:(BOOL)animated
{
    tappress = 0;
    _isDing = NO;
    _isSou = NO;
    [_mapView viewWillDisappear];
    self.tabBarController.tabBar.hidden = NO;
    //右上角按钮
    bem.hidden = YES;
    _stateView.hidden = YES;
    _switchView.hidden = YES;
    _isShou = YES;
    _isGang = YES;
    _yuyinJieGuoLab.text = @"";
    _mapView.delegate = nil; // 不用时，置nil
    //[_locService stopUserLocationService];
    _locService.delegate = nil;
   // _locService = nil;
    _yuyinBack.hidden = YES;
    _isTan = NO;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
    _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
    [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
    [UIView commitAnimations];
    //比例尺位置和当前按钮随之变化
    //写到动画结束回调里面
    self.tabBarController.tabBar.hidden = NO;
}

//实例化百度地图
-(void)creatBMap
{
    _mapView  = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview: _mapView];
    _annotation = [[BMKPointAnnotation alloc]init];
    _search = [[BMKGeoCodeSearch alloc]init];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //指定最小距离更新(米)
    _locService.distanceFilter = kCLLocationAccuracyThreeKilometers;
    //设置显示比例尺
    _mapView.showMapScaleBar = YES;
    
    //设定比例尺的位置
   // _mapView.mapScaleBarPosition = CGPointMake(10, Height - 80);
    
    _search.delegate = self;
    //为地图添加手势
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
    [_mapView addGestureRecognizer:mTap];
}
//实例化googleMap
-(void)creatGoogle
{
    //在这里实现googleSdk的实例化
}

//修改UI
-(void)creatUI
{
    //弹出时间设置
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* Tanchu = [userPoint objectForKey:@"Time"];
    
//    UITextField* textf = [[UITextField alloc]init];
//    textf.frame = CGRectMake(50, 100, 300, 100);
//    textf.placeholder = @"qingshuru ";
//    [self.view addSubview:textf];
    
    //是否弹出
    _isTan = NO;
    //是否添加收藏
    _isCollect = NO;
  //  self.title = @"天下游";
    self.navigationController.navigationBar.translucent = YES;
    //bar颜色
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
    //字体颜色
  //  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
   // self.navigationController.navigationBar.barTintColor = [UIColor redColor];
 
    
    //实例化tarview
    _tarView = [[UIView alloc]init];
    _tarView.backgroundColor = [UIColor grayColor];
    _tarView.frame = CGRectMake(0, 0, Width, 49);
    _tarView.hidden = YES;
    [self.tabBarController.tabBar addSubview:_tarView];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
 
    _nowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nowBtn setBackgroundImage:[UIImage imageNamed:@"map_icon_location@3x.png"] forState:UIControlStateNormal];
    [_nowBtn addTarget:self action:@selector(dangqian) forControlEvents:UIControlEventTouchUpInside];
    _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
    [self.view addSubview:_nowBtn];
    
    //switch
    _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(5, 4, 79, 36)];
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
    
    //➕按钮
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiahao.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
//    self.navigationItem.rightBarButtonItem = btn;
    
    bem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bem.frame = CGRectMake(Width - 38, 4, 34, 32);
    [bem setBackgroundImage:[UIImage imageNamed:@"poi_picker_drag_img@2x.png"] forState:UIControlStateNormal];
    [bem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:bem];
    
    //判断系统版本是否高于6  然后规划stateBar高度
    
    _stateView = [[UIView alloc]initWithFrame:CGRectMake(57, 4, Width-97, 32)];

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
    [_btn1 addTarget:self action:@selector(quanjing:) forControlEvents:UIControlEventTouchUpInside];
    //[_btn1 setAlpha:0.5];
   // [_btn1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_btn1];
    //图形
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 8001;
    btn2.frame = CGRectMake(Width - 50, _btn1.frame.origin.y+ 5+50, 50, 50);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tuceng2.png"] forState:UIControlStateNormal];
   // [btn2 setAlpha:0.5];
    [btn2 addTarget:self action:@selector(quanjing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    //热力
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.tag = 8002;
    _btn3.frame = CGRectMake(Width - 50, btn2.frame.origin.y+ 5+ 50, 50, 50);
    [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli1.png"] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(quanjing:) forControlEvents:UIControlEventTouchUpInside];
   // [_btn3 setAlpha:0.5];
  //  [_btn3 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_btn3];
    
    //搜周边
    _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[_button1 setTitle:@"搜周边" forState:UIControlStateNormal];
    _button1.tag = 7000;
    [_button1 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];

    _button1.frame = CGRectMake(0, adress.frame.origin.y+ 30, Width / 4 , 50);
    UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhoubian1.png"]];
    imageView1.frame = CGRectMake(10, 10, 30, 30);
  
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/4 - 40, 30)];
  
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
    _button2.frame = CGRectMake(Width/4, adress.frame.origin.y+ 30, Width / 4, 50);
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang1.png"]];
    imageView2.frame = CGRectMake(10, 10, 30, 30);
  
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/4 - 40, 30)];
 
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
    _button3.frame = CGRectMake(Width/4*3, adress.frame.origin.y+ 30, Width / 4, 50);
  

    UIImageView* imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanjing.png"]];
    imageView3.frame = CGRectMake(10,10, 30, 30);
   
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/4 - 40, 30)];
  
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"全景";
    //label2.userInteractionEnabled = YES;
    [_button3 addSubview:label3];
    [_button3 addSubview:imageView3];
    
    //分享
    _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button4.tag = 7003;
    [_button4 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button4.frame = CGRectMake(Width/4*2, adress.frame.origin.y+ 30, Width / 4, 50);
  
    
    UIImageView* imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxiang2.png"]];
    imageView4.frame = CGRectMake(10,10, 30, 30);
   
    UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, Width/4 - 40, 30)];
   
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"分享";
    //label2.userInteractionEnabled = YES;
    [_button4 addSubview:label4];
    [_button4 addSubview:imageView4];
    
    [view addSubview:_button1];
    [view addSubview:_button2];
    [view addSubview:_button3];
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

    
    
  }

- (void)xuanzhuan{
    
    _bofangView3.transform = CGAffineTransformMakeRotation(num);
//    int number = 0;
//    number = number+50.0;
//    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation(number / 180.0 * M_PI );
//    
//    [_bofangView3 setTransform:rotate];
    num=+ M_PI*60/180;
}


- (void)yuyinBackTap{
    _yuyinBack.hidden = YES;
    [manager cancle];
    [_bofangView stopAnimating];
    [_bofangView1 stopAnimating];
  //  [_timer invalidate];
    _isYuyin = NO;
}

//上传用户位置信息
- (void)addUserLocation:(CLLocationCoordinate2D)coo andAdress:(NSString *)adress1
{
    //上传国外用户坐标
    if (![WGS84TOGCJ02 isLocationOutOfChina:coo]) {
        [[TXYTools sharedTools] getOldInfoWithCoor:coo andAdress:adress1];
    }else{
        //先把百度坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances] hhTrans_GCGPS:coo];
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances] gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
        [[TXYTools sharedTools] getOldInfoWithCoor:gpsZuo andAdress:adress1];
    }
}

#pragma mark - 语音搜索
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
                _citySearch = [[BMKCitySearchOption alloc]init];
                _citySearch.keyword = _yuyinJieGuoLab.text;
                _citySearch.city = _chengshi;
                
                BMKPoiSearch *_poiSearch = [[BMKPoiSearch alloc]init];
                _poiSearch.delegate = self;
                
                NSLog(@"城市= %@",_chengshi);
                NSLog(@"关键字= %@",_citySearch.keyword);
                
                BOOL flag = [_poiSearch poiSearchInCity:_citySearch];
                
                if(flag)
                {
                    NSLog(@"城市内检索发送成功");
                }
                else
                {
                    NSLog(@"城市内检索发送失败");
                }
            }

        });
        
        
        NSLog(@"text = %@",_yuyinJieGuoLab.text);
        //    //取消识别
    }];
}
-(void)refush
{
    
}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    SearchResultViewController* srvc = [[SearchResultViewController alloc]init];
    srvc.keyWord = _yuyinJieGuoLab.text;
    NSLog(@"srvc.keyword = %@",srvc.keyWord);
    srvc.cityName = _chengshi;
    srvc.isAPP = self.isAPP;
    srvc.bundleID = self.bundleID;
    NSLog(@"poiResult.totalPoiNum = %d",poiResult.totalPoiNum);
    NSLog(@"poiResult.currPoiNum = %d",poiResult.currPoiNum);
    NSLog(@"poiResult.pageNum = %d",poiResult.pageNum);
    NSLog(@"poiResult.pageIndex = %d",poiResult.pageIndex);
    NSLog(@"poiResult.poiInfoList = %@",poiResult.poiInfoList);
    NSLog(@"poiResult.cityList = %@",poiResult.cityList);

    
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[MapViewController class]]) {
            MapViewController* choose = (MapViewController*)vc;
            srvc.delegate = choose;
        }
               
    }
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        srvc.poiResult = poiResult;
        srvc.citySearch = _citySearch;
        srvc.isZhou = NO;
       
        //是否有内容
        if (poiResult.totalPoiNum == 0) {
            srvc.isYes = NO;
        }else{
            srvc.isYes = YES;
        }
        if (srvc.isYes) {
            NSLog(@"isYes");
        }
         [self.navigationController pushViewController:srvc animated:YES];
    }
    if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        [MyAlert ShowAlertMessage:@"检索词有歧义" title:@"检索失败"];
    }
    if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        [MyAlert ShowAlertMessage:@"检索地址有岐义" title:@"检索失败"];
    }
    if (errorCode ==  BMK_SEARCH_RESULT_NOT_FOUND){
        [MyAlert ShowAlertMessage:@"没有找到检索结果" title:@"检索失败"];
    }
    if (errorCode == BMK_SEARCH_NETWOKR_ERROR||errorCode == BMK_SEARCH_NETWOKR_TIMEOUT){
        [MyAlert ShowAlertMessage:@"网络连接错误,请检查网络" title:@"检索失败"];
    }
    

}

//搜索事件
- (void)searchTap{
   
     PoiViewController* povc = [[PoiViewController alloc]init];
  
    if ([[TXYConfig sharedConfig]getFakeGPS].longitude) {
     
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
        //将火星转为百度
        CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
 
        povc.coord = baiduZuo;

    }else{
        povc.coord = _nowCoord;
    }
    NSLog(@"chengshi = %@",_chengshi);
    povc.chengshi = _chengshi;
    povc.delegate = self;
    povc.isAPP = self.isAPP;
    povc.bundleID = self.bundleID;
    //不是周边搜索
    povc.isZhou = NO;
    [self.navigationController pushViewController:povc animated:YES];
}
/*
level 11  5km
level 12  2km
level 13  1km
level 14  1km .
level 15  5km
level 16  5km
level 17  5km
level 18  5km
level 19  5km
level 20  10m 20
level 21  5m 20
*/
//定位到当前位置
- (void)dangqian{
   // [_mapView zoomOut];
    NSLog(@"_maView.zoonlevel = %f",_mapView.zoomLevel);
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [MyAlert ShowAlertMessage:@"定位服务未开启，请进入系统【设置】->【隐私】->【定位服务】中打开开关，并允许天下游使用定位服务" title:@"打开定位开关"];
    } else{
     //   NSLog(@"定位服务打开");
    }

    //如果开关打开
    if ([[TXYConfig sharedConfig]getToggle]) {
        NSLog(@"你好");
        //如果是选取应用程序状态
        if (self.isAPP) {
            //如果该应用程序有模拟位置
            if (!([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]intValue] == 0 &&[[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] intValue]==0)) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"] doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"] doubleValue]);
                NSLog(@"coord = %f  %f",coord.latitude,coord.longitude);
                //将工具类中的gps坐标转为火星坐标
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                //将火星转为百度
                CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
                [_mapView setCenterCoordinate:baiduZuo animated:YES];
                BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                pt1.reverseGeoPoint = baiduZuo;
                [_search reverseGeoCode:pt1];
            }else{
                if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                     CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
                    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                    //将火星转为百度
                    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
                    [_mapView setCenterCoordinate:baiduZuo animated:YES];
                    BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                    pt1.reverseGeoPoint = baiduZuo;
                    [_search reverseGeoCode:pt1];
                }else{
                    [self knowWhereRU:1];
                }
                [KGStatusBar showWithStatus:@"当前还没有选取模拟位置"];

            }
            
        }else{
            NSLog(@"txy = %f  %f",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
            if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
                 NSLog(@"la1 = %f  lo1 = %f",coord.latitude,coord.longitude);
                 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
                 //将火星转为百度
                 CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
            //      NSLog(@"la = %f  lo = %f",baiduZuo.latitude,baiduZuo.longitude);
                 [_mapView setCenterCoordinate:baiduZuo animated:YES];
                BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                pt1.reverseGeoPoint = baiduZuo;
                [_search reverseGeoCode:pt1];
            }else{
                   [self knowWhereRU:1];
                [KGStatusBar showWithStatus:@"当前还没有选取模拟位置"];
            }
        
        }
    }else{
        [self knowWhereRU:1];
    }
}


//图形控制按钮
- (void)tuxing:(UIButton*)button{
    //卫星图
    if (button.tag == 9000) {
        [_mapView setMapType:BMKMapTypeSatellite];
        [_mapView setBuildingsEnabled:NO];
        weixingBtn.layer.borderWidth = 2;
        weixingBtn.layer.borderColor = [UIColor blueColor].CGColor;
        weixingBtn1.layer.borderWidth = 0;
        weixingBtn2.layer.borderWidth = 0;
        _mapView.overlooking = 0;
    }
    //2D平面图
    if (button.tag == 9001) {
        [_mapView setMapType:BMKMapTypeStandard];
        [_mapView setBuildingsEnabled:NO];
        weixingBtn.layer.borderWidth = 0;
        weixingBtn1.layer.borderWidth = 2;
        weixingBtn1.layer.borderColor = [UIColor blueColor].CGColor;
        weixingBtn2.layer.borderWidth = 0;
        _mapView.overlooking = 0;
    }
    //3D俯视图
    if (button.tag == 9002) {
      
        [_mapView setBuildingsEnabled:YES];
        weixingBtn.layer.borderWidth = 0;
        weixingBtn1.layer.borderWidth = 0;
        weixingBtn2.layer.borderWidth = 2;
        weixingBtn2.layer.borderColor = [UIColor blueColor].CGColor;
        _mapView.overlooking = -45;
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
        _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
        _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
        [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
      
        [UIView commitAnimations];
        //比例尺位置和当前按钮随之变化
   
    }else{
        _isTan = NO;
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
        _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
        [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
     
        [UIView commitAnimations];
        //比例尺位置和当前按钮随之变化
        //写到动画结束回调里面
        self.tabBarController.tabBar.hidden = NO;
    }
}

//全景按钮点击事件
- (void)quanjing:(UIButton *)button{
    //打开路况
    if (button.tag == 8000) {
        [_mapView setTrafficEnabled:YES];
        [button setBackgroundImage:[UIImage imageNamed:@"lukuang2.png"] forState:UIControlStateNormal];
        NSLog(@"打开路况");
        [button setAlpha:1.0];
        _btn1.tag = 8005;
        return;
    }
    //图形
    if (button.tag == 8001) {
        [self.view bringSubviewToFront:_backView];
        [button setAlpha:1.0];
        _tarView.hidden = NO;
        _backView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        return;
    }
    //打开热力
    if (button.tag == 8002) {
        [_mapView setBaiduHeatMapEnabled:YES];
        _btn3.tag = 8006;
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli2.png"] forState:UIControlStateNormal];
    //    [button setAlpha:1.0];
    //    [button setBackgroundColor:[UIColor whiteColor]];
        NSLog(@"打开热力");
        return;
    }
    //关闭路况
    if (button.tag == 8005) {
        [_mapView setTrafficEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"lukuang1.png"] forState:UIControlStateNormal];
        _btn1.tag = 8000;
     //   [button setAlpha:0.5];
        NSLog(@"关闭路况");
        return;
    }
    //关闭热力
    if (button.tag == 8006) {
        [_mapView setBaiduHeatMapEnabled:NO];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"reli1.png"] forState:UIControlStateNormal];
        _btn3.tag = 8002;
   //     [button setAlpha:0.5];
        [button setBackgroundColor:[UIColor clearColor]];
        NSLog(@"关闭热力");
        return;
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
    
}

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
//            JKAlertDialog  *alert = [[JKAlertDialog alloc]initWithTitle:CustomLocalizedString(@"手动输入", nil) message:nil];
//            UIView* _bView = [[UIView alloc]init];
////            UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
////            button.frame = CGRectMake(20, 30, 200, 30);
////            [button setTitle:@"你好" forState:UIControlStateNormal];
////            [button addTarget:self action:@selector(nihao) forControlEvents:UIControlEventTouchUpInside];
//            
//            _bView.frame = CGRectMake(0, 0, 260, Height /2 + 100);
//            
//            UITextField* textField1 = [[UITextField alloc]init];
//            textField1.frame = CGRectMake(20, 30, 200, 30);
//            textField1.placeholder = @"请输入经度";
            
//            //边框
//            textField1.borderStyle = UITextBorderStyleRoundedRect;
//            //内容对齐方式
//            textField1.textAlignment = NSTextAlignmentLeft;
//            //设置键盘的样式
//            textField1.keyboardType = UIKeyboardTypeNumberPad;
//            
//            UITextField* textField2 = [[UITextField alloc]init];
//            textField2.frame = CGRectMake(20, 70, 200, 30);
//            textField2.placeholder = @"请输入纬度";
//            //边框
//            textField2.borderStyle = UITextBorderStyleRoundedRect;
//            //内容对齐方式
//            textField2.textAlignment = NSTextAlignmentLeft;
//            //设置键盘的样式
//            textField2.keyboardType = UIKeyboardTypeNumberPad;
//            
//            textField1.delegate = self;
//            textField2.delegate = self;
//            [_bView addSubview:textField1];
//            [_bView addSubview:textField2];
//           
//            alert.contentView =  textField1;
//            [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
//                exit(0);
//            }];
//            [alert addButton:Button_CANCEL withTitle:@"确定" handler:^(JKAlertDialogItem *item) {
//                
// 
//            }];
//            
//            [alert show2];
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

//开始定位
-(void)knowWhereRU:(int)whichSdk
{
    if (whichSdk ==1) {

        //那么我们使用百度定位
        //设置定位精确度，默认：kCLLocationAccuracyBest

        //启动LocationService
        [_locService startUserLocationService];
        //定位成功后需要显示到地图上
    }
    else
    {
        //我们使用google定位
    }
}
//手势点击方法的处理
-(void)tapPress:(UIGestureRecognizer *)tap
{
    tappress = 1;
         _isGang = NO;
         _isShou = NO;
         _isDing = NO;
         CGPoint point = [tap locationInView:self.view];
         CLLocationCoordinate2D coo = [_mapView convertPoint:point toCoordinateFromView:_mapView];
         NSLog(@"经纬度:%lf, %lf", coo.longitude,  coo.latitude);
         NSLog(@"调用一次");
        [_mapView removeAnnotation:_annotation];
        _annotation.coordinate = coo;
        _annotation.title = @"解析中";
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
        [_mapView setCenterCoordinate:coo] ;
    //先把百度坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coo];
    //再把火星坐标转为gps坐标
    CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
    if (_isAPP) {
        [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
    }else{
        
        [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
        conCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        conCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    }
         BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
         pt1.reverseGeoPoint = coo;
         [_search reverseGeoCode:pt1];
    }
//地理编码   地址编译后添加大头针
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error != 0 ) {
        [_annotation setTitle:@"解析失败,请检查网络设置"];
        [KGStatusBar showWithStatus:@"网络连接超时，请打开网络"];
    }
    
    if (![[TXYConfig sharedConfig]getToggle]) {
        _switchView.on = NO;
        [KGStatusBar showWithStatus:@"开关未打开，请打开开关"];
    };
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

 //   NSLog(@"la = %f",result.location.latitude);
 //   NSLog(@"lo = %f",result.location.longitude);
   //  NSLog(@"街道号%@ 街道名%@ district%@ 城市%@ 省份%@",result.addressDetail.streetNumber,result.addressDetail.streetName,result.addressDetail.district    ,result.addressDetail.city,result.addressDetail.province);
    if (result.address.length == 0) {
        [KGStatusBar showWithStatus:@"位置已更改"];
        result.address = @"国外";
    }
    _weizhi = result.address;
    //如果是定位状态，只获取当前所在的城市，不做大头针操作
    if (_isDing) {
        _chengshi = result.addressDetail.city;
        _isDing = NO;
    }else{
        // 添加一个PointAnnotation
        if (self.isAPP) {
            if (!(((int)result.location.latitude == 0)&&((int)result.location.longitude == 0))) {
                //把点击的模拟位置转化为gps坐标存入plist
                _nowCoord = result.location;
                //先把百度坐标转为火星坐标
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:result.location];
                //再把火星坐标转为gps坐标
                CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
                NSLog(@"gpsZuo.la = %lf,gpsZuo.lo = %lf",gpsZuo.latitude,gpsZuo.longitude);
                
                [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
            }
            
        }else{
            if (!(((int)result.location.latitude == 0)&&((int)result.location.longitude == 0))) {
                //把点击的模拟位置转化为gps坐标存入plist
                _nowCoord = result.location;
                //先把百度坐标转为火星坐标
                CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:result.location];
                //再把火星坐标转为gps坐标
                CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
                [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
                conCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
                conCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
            }
        }
        CLLocationCoordinate2D huoxing2;
        CLLocationCoordinate2D baiduZuo2;
        if (_isAPP) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Latitude"]doubleValue], [[[TXYConfig sharedConfig]getLocationWithBundleId:self.bundleID][@"Longitude"]doubleValue]);
            //将工具类中的gps坐标转为火星坐标
            huoxing2 = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
            //将火星转为百度
            baiduZuo2 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing2];
        }else{
            //将工具类中的gps坐标转为火星坐标
           huoxing2 = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
            //将火星转为百度
           baiduZuo2 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing2];

        }
        
        //将工具类中的gps坐标转为火星坐标
        CLLocationCoordinate2D huoxing1 = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getRealGPS].latitude bdLon:[[TXYConfig sharedConfig]getRealGPS].longitude];
        //将火星转为百度
        CLLocationCoordinate2D baiduZuo1 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing1];
        NSLog(@"%lf",baiduZuo1.latitude);
        NSLog(@"%lf",baiduZuo1.longitude);

        _nowCoord =baiduZuo2;
        [_mapView removeAnnotation:_annotation];
        _annotation.coordinate = baiduZuo2;
        _annotation.title = result.address;
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
        
        NSLog(@" 1 = %lf",[[TXYConfig sharedConfig]getRealGPS].latitude);
        NSLog(@" 2 = %lf",[[TXYConfig sharedConfig]getRealGPS].longitude);
        
        
        BMKMapPoint po1 = BMKMapPointForCoordinate(baiduZuo1);
        BMKMapPoint po2 = BMKMapPointForCoordinate(baiduZuo2);
        
        
        
        _dis = BMKMetersBetweenMapPoints(po1,po2);
        if (_dis > 1000) {
            _juli = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
        }else{
            _juli = [NSString stringWithFormat:@"%.f米",_dis];
        }
        AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        _appDelegate.city = result.addressDetail.city;
        _chengshi = result.addressDetail.city;
        
        _name = result.address;
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        _time = locationString;
        _longitude = [NSNumber numberWithDouble:_annotation.coordinate.longitude];
        _latitude = [NSNumber numberWithDouble:_annotation.coordinate.latitude];
    
        //  adress.font = [UIFont systemFontOfSize:15];
        adress.text = [NSString stringWithFormat:@"%@",_weizhi];
        juliLab.text = [NSString stringWithFormat:@"距真实位置:%@",_juli];
        [_mapView setCenterCoordinate:baiduZuo2 animated:YES];
        NSLog(@"address = %d juli = %@",_weizhi.length,_juli);
        
        
        
        //判断是否已经添加收藏夹
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
        NSArray* array = [userPoint objectForKey:@"collect"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        _isCollect = NO;
        for(int i = 0;i < userArray.count;i++){
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:userArray[i]];
            
            double longitude = [dict[@"longitudeNum"] doubleValue];
            double latitude = [dict[@"latitudeNum"] doubleValue];
            if (baiduZuo2.longitude == longitude&&baiduZuo2.latitude == latitude) {
                _isCollect = YES;
                break;
            }
        }
        //在这里推出此annotation的更多选项view；
        if (_isShou) {
            NSLog(@"shou");
        }
        if (_isGang) {
            NSLog(@"gang");
        }
        if (!_isShou && !_isGang) {
            self.tabBarController.tabBar.hidden = YES;
            [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationDelegate:self];
            [_downPushView setFrame:CGRectMake(0, Height - 130, Width, 130)];
            //比例尺位置和当前按钮随之变化
            _mapView.mapScaleBarPosition = CGPointMake(60, Height - 150);
            _nowBtn.frame = CGRectMake(5, Height - 175, 50, 50);
            [UIView commitAnimations];
            if ([Tanchu isEqualToString:@"no"]) {
                
            }else{
            [timer invalidate];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            [timer fire];
            }
            _isTan = YES;
        }

    }
    if (tappress == 1) {
        [self addUserLocation:result.location andAdress:result.address];
    }
}
#define MarkDTZ AnnitationDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.canShowCallout=YES;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button1 addTarget:self action:@selector(addClick:annoview:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 9000;
        newAnnotationView.rightCalloutAccessoryView = button1;

        return newAnnotationView;
    }
    return nil;
}
//点击大头针方法
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    NSLog(@"点击了一下");
}

-(void)addClick:(UIButton *)sender annoview:(BMKAnnotationView *)annoview
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
    self.tabBarController.tabBar.hidden = YES;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_downPushView setFrame:CGRectMake(0, Height - 130, Width, 130)];
    _mapView.mapScaleBarPosition = CGPointMake(60, Height - 150);
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
#define Mark BMapLocationDelegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    _coord = userLocation.location.coordinate;
    _nowCoord = userLocation.location.coordinate;
    
    //先把百度坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:_coord];
    //再把火星坐标转为gps坐标
    CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
    //如果模拟位置为空，把真实位置设成模拟位置
    if ((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0&&(int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0){
        [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
        conCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        conCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
    }
    
    if ([WGS84TOGCJ02 isLocationOutOfChina:userLocation.location.coordinate]) {
        [[TXYConfig sharedConfig] setRealGPS:userLocation.location.coordinate];
    }else{
        [[TXYConfig sharedConfig] setRealGPS:gpsZuo];
    }
    
    //判断是否在国外 是否需要上传信息
   // [[TXYTools sharedTools] setOldCoordinate:gpsZuo];
    //以下_mapView为BMKMapView对象
    if (![[TXYConfig sharedConfig]getToggle]) {
        if (userLocation) {
            _mapView.showsUserLocation = YES;//显示定位图层
            [_mapView updateLocationData:userLocation];
            [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            _isDing = YES;
        }
        else
        {
            [MyAlert ShowAlertMessage:@"定位失败" title:@"请设置允许定位权限"];
        }
    }else{
        if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
            _mapView.showsUserLocation = YES;//显示定位图层
            //将工具类中的gps坐标转为火星坐标
            CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
            //将火星转为百度
            CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
            [_mapView setCenterCoordinate:baiduZuo] ;
            
        }
    }
    [_locService stopUserLocationService];
    }
//最下面弹出view中seg的点击事件
-(void)segClick:(UIButton *)button
{
    //搜周边
    if (button.tag == 7000 ) {
        
        ZhoubianViewController* zhvc = [[ZhoubianViewController alloc]init];
        zhvc.nearBySearchOption = [[BMKNearbySearchOption alloc]init];
        zhvc.coord = _nowCoord;
        zhvc.isAPP = self.isAPP;
        zhvc.bundleID = self.bundleID;
        [self.navigationController pushViewController:zhvc animated:YES];
    }
 
    //添加收藏
    if (button.tag == 7001) {
        //存储到本地收藏夹
        //如果已经添加到收藏夹
  
        NSLog(@"添加至收藏夹");
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
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
            [dict setValue:@"baidu" forKey:@"whichMap"];
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
        PanoViewController* pavc = [[PanoViewController alloc]init];
        pavc.coord = _nowCoord;
        [self.navigationController pushViewController:pavc animated:YES];
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

#pragma mark - 实现代理方法
//实现代理方法
-(void)chuanzhi:(XuandianModel *)model
{
    tappress = 1;
    _isGang = NO;
    _isShou = NO;
    _isSou = YES;
    self.mingzi = model.weizhi;
    
    BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
    NSLog(@"实现代理方法");
    NSLog(@"%@",self.mingzi);
    NSLog(@"la = %f",[model.latitudeNum doubleValue]);
    NSLog(@"lo = %f",[model.longitudeNum doubleValue]);
    if (!self.isAPP) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
        //先把百度坐标转为火星坐标
//        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coord];
//        //火星转百度
//     //   CLLocationCoordinate2D baidu = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
        //再把火星坐标转为gps坐标
//        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
//
//        //把gps转为火星
//        CLLocationCoordinate2D huoxing2 = [[FireToGps sharedIntances]gcj02Encrypt:gpsZuo.latitude bdLon:gpsZuo.longitude];
        //把火星转为百度
     //   CLLocationCoordinate2D baidu2 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing2];
        _nowCoord = coord;
//        [[TXYConfig sharedConfig]setFakeGPS:gpsZuo];
        conCoord.longitude = [[TXYConfig sharedConfig]getFakeGPS].longitude;
        conCoord.latitude = [[TXYConfig sharedConfig]getFakeGPS].latitude;
        [_mapView removeAnnotation:_annotation];
        _annotation.coordinate = coord;
        _annotation.title = @"解析中";
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
        [_mapView setCenterCoordinate:coord] ;
        pt1.reverseGeoPoint = coord;
        [_search reverseGeoCode:pt1];

    }else{
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
//        //先把百度坐标转为火星坐u
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coord];
//        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
        _nowCoord = coord;
        [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeMap andGPS:gpsZuo];
        [_mapView removeAnnotation:_annotation];
        _annotation.coordinate = coord;
        _annotation.title = @"解析中";
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
        [_mapView setCenterCoordinate:coord] ;
        pt1.reverseGeoPoint = coord;
        [_search reverseGeoCode:pt1];
        [_mapView selectAnnotation:_annotation animated:YES];
        [_mapView setCenterCoordinate:coord] ;
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
            tappress = 1;
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            UITextField *tf1 = [alertView textFieldAtIndex:1];
            
            if ([self isPureFloat:tf.text] && [self isPureFloat:tf1.text] ) {
                long double la = [tf.text doubleValue];
                long double lo = [tf1.text doubleValue];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lo, la);
                _isGang = NO;
                _isShou = NO;
                [_mapView removeAnnotations:_mapView.annotations];
                BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
                pt1.reverseGeoPoint = coord;
                [_search reverseGeoCode:pt1];
            }else{
                [KGStatusBar showWithStatus:@"格式不对，请重新输入"];
            }
    
        }
    }
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
            _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
            _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
            [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
            [UIView commitAnimations];
            //比例尺位置和当前按钮随之变化
            
        }else{
            _isTan = NO;
            [UIView beginAnimations:@"animation" context:(__bridge void *)(_downPushView)];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationDelegate:self];
            _mapView.mapScaleBarPosition = CGPointMake(60, Height - 100);
            _nowBtn.frame = CGRectMake(5, Height - 125, 50, 50);
            [_downPushView setFrame:CGRectMake(0, Height + 150, Width, 150)];
            [UIView commitAnimations];
            
            //比例尺位置和当前按钮随之变化
            
            //写到动画结束回调里面
            self.tabBarController.tabBar.hidden = NO;
        }
        
    }else
    {
//        NSLog(@"tim3 = %d",tim);
        tim = tim - 1;
//        NSLog(@"tim4 = %d",tim);
        [down setTitle:[NSString stringWithFormat:@"%d",tim] forState:UIControlStateNormal] ;
//        NSLog(@"tim5 = %d",tim);
//        NSLog(@"tim2 = %@",down.titleLabel.text);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
