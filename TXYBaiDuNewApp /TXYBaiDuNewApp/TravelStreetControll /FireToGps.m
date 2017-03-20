//
//  FireToGps.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "FireToGps.h"
#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293
#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0
#define jzA 6378245.0
#define jzEE 0.00669342162296594323
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
static FireToGps *gpsFire=nil;
@implementation FireToGps
+ (instancetype)sharedIntances{
    @synchronized (self){
        if (gpsFire==nil) {
            gpsFire=[[FireToGps alloc]init];
        }
    }
    return gpsFire;
}

- (instancetype)init{
    self=[super init];
    if (self) {
    }
    return self;
}
//火星转gps
- (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}
//gps转火星
- (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
- (double)transformLat:(double)x bdLon:(double)y
{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}

- (double)transformLon:(double)x bdLon:(double)y
{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}
- (BOOL)outOfChina:(double)lat bdLon:(double)lon
{
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}
//百度坐标转换为火星坐标
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps
{
    CLLocationCoordinate2D googleGps;
    //0.065
    long double bd_x=baiduGps.longitude - 0.0065;
    long double bd_y=baiduGps.latitude - 0.006;
    long double z =(long double)sqrt(bd_x * bd_x + bd_y * bd_y) -(long double)0.00002 * sin(bd_y * x_pi);
    long double theta = (long double)atan2(bd_y, bd_x) - (long double)0.000003 * cos(bd_x * x_pi);
    googleGps.longitude = (long double)z * cos(theta);
    googleGps.latitude = (long double)z * sin(theta);
    return googleGps;
}
//火星转换为百度坐标
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps
{
    CLLocationCoordinate2D bdGps;
    long double huo_x=fireGps.longitude;
    long double huo_y=fireGps.latitude;
    long double z = (long double)sqrt(huo_x * huo_x + huo_y * huo_y) +(long double) 0.00002 * sin(huo_y * x_pi);
    long double theta =(long double) atan2(huo_y, huo_x) +(long double) 0.000003 * cos(huo_x * x_pi);
    bdGps.longitude = z * cos(theta) + 0.0065;
    bdGps.latitude = z * sin(theta) + 0.006;
    return bdGps;
}
@end
