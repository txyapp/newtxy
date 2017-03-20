//
//  QPanorama.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/2/28.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/*!
 *  @brief  该类封装了街景场景相关属性
 */
@interface QPanorama : NSObject

/*!
 *  @brief  经纬度
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @brief  街景id
 */
@property (nonatomic, copy, readonly) NSString *panoramaID;

/*!
 *  @brief  相关的街景
 */
@property (nonatomic, copy, readonly) NSArray *links;


- (instancetype)initWithPanoramaID:(NSString *)panoramaID coordinate:(CLLocationCoordinate2D)coordinate links:(NSArray *)links;

@end
