//
//  QPanoramaService.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/11.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class QPanorama;

typedef void (^QPanoramaCallback)(QPanorama *panorama, NSError *error);


/*!
 * @brief  区别于 QPanoServices 用于提供街景数据接口
 */


@interface QPanoramaService : NSObject

/*!
 *  @brief  通过经纬度请求街景数据
 *
 *  @param coordinate 经纬度
 *  @param callback   结果回调
 */
- (void)requestPanoramaNearCoordinate:(CLLocationCoordinate2D)coordinate
                             callback:(QPanoramaCallback)callback;

/*!
 *  @brief  通过经纬度和半径请求数据
 *
 *  @param coordinate 经纬度
 *  @param radius     半径
 *  @param callback   结果回调
 */
- (void)requestPanoramaNearCoordinate:(CLLocationCoordinate2D)coordinate
                               radius:(NSUInteger)radius
                             callback:(QPanoramaCallback)callback;

/*!
 *  @brief  通过街景ID获取数据(QPanorama中包含links)
 *
 *  @param panoramaID 街景ID
 *  @param callback   结果回调
 */
- (void)requestPanoramaWithID:(NSString *)panoramaID
                     callback:(QPanoramaCallback)callback;

@end

