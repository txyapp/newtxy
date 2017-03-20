//
//  QPanoramaCamera.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/3.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QOrientation.h"

/*!
 * @brief  该类用于控制QPanoramaView的视角,和具体的街景场景点无关
 */
@interface QPanoramaCamera : NSObject

//初始化方法
- (instancetype)initWithOrientation:(QOrientation)orientation zoom:(float)zoom;

/*!
 *  @brief  视场
 */
@property (nonatomic, assign, readonly) double FOV;

/*!
 *  @brief  缩放级别
 */
@property (nonatomic, assign, readonly) float zoom;

/*!
 *  @brief  俯仰角和方位角
 */
@property (nonatomic, assign, readonly) QOrientation orientation;
@end
