//
//  BaiduPanoUtils.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/28.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef struct MecatorPoint
{
    double x;
    double y;
    MecatorPoint():x(0.0), y(0.0) {}
    MecatorPoint(double dx, double dy):x(dx), y(dy) {}
}MECATORPOINT, *BPMECATORPOINT;

typedef enum : NSUInteger {
    COOR_TYPE_BDLL = 1,//百度坐标
    COOR_TYPE_BDMC = 2,//百度墨卡托坐标
    COOR_TYPE_GPS     = 3,//GPS原始坐标
    COOR_TYPE_COMMON  = 4,//其他坐标，腾讯，高德，google等
} COOR_TYPE;

@interface BaiduPanoUtils : NSObject

/**
 * @abstract 百度地理坐标转化为百度墨卡托坐标
 * @param    lon：经度     lat：纬度
 */
+ (MECATORPOINT)getMcWithLon:(double)lon lat:(double)lat;

/**
 * @abstract 坐标转化工具，将其他坐标系的坐标转为百度坐标
 * @param    lon：经度     lat：纬度      type：其他坐标系类型
 */
+ (CLLocationCoordinate2D)baiduCoorEncryptLon:(double)lon lat:(double)lat coorType:(COOR_TYPE)type;

@end
