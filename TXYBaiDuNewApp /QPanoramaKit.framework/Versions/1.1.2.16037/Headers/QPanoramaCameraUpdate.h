//
//  QPanoramaCameraUpdate.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/3.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief   用于场景视角更新
 */
@interface QPanoramaCameraUpdate : NSObject

/*!
 *  @brief  创建偏航角(原始heading角度+deltaHeading)
 *
 *  @param deltaHeading 偏航角差值
 *
 *  @return QPanoramaCameraUpdate
 */
+ (QPanoramaCameraUpdate *)rotateBy:(CGFloat)deltaHeading;

/*!
 *  @brief  创建偏航角
 *
 *  @param heading 偏航角
 *
 *  @return QPanoramaCameraUpdate
 */
+ (QPanoramaCameraUpdate *)setHeading:(CGFloat)heading;

/*!
 *  @brief  创建俯仰角
 *
 *  @param pitch 俯仰角
 *
 *  @return QPanoramaCameraUpdate
 */
+ (QPanoramaCameraUpdate *)setPitch:(CGFloat)pitch;

/*!
 *  @brief  创建缩放级别
 *
 *  @param zoom 缩放级别
 *
 *  @return QPanoramaCameraUpdate
 */
+ (QPanoramaCameraUpdate *)setZoom:(CGFloat)zoom;

@end
