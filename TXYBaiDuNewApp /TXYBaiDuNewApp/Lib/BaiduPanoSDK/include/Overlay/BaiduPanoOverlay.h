//
//  BaiduPanoOverlay.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum : NSUInteger {
    BaiduPanoOverlayTypeLabel,
    BaiduPanoOverlayTypeImage,
    BaiduPanoOverlayTypeUnknown,
} BaiduPanoOverlayType;
@interface BaiduPanoOverlay : NSObject
@property(strong, nonatomic) NSString *overlayKey;   //覆盖物唯一表示
@property(assign, nonatomic) BaiduPanoOverlayType type; // 覆盖物类型
@property(assign, nonatomic) CLLocationCoordinate2D coordinate; // 覆盖物所在坐标点（百度坐标）
@property(assign, nonatomic) double    height;// 覆盖物高度
@end