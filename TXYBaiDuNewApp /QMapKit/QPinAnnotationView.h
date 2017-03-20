//
//  QPinAnnotationView.h
//  TMSTest
//
//  Created by tabsong on 14/12/15.
//  Copyright (c) 2014年 tabsong. All rights reserved.
//
/**     @file QPinAnnotationView.h  **/

#import "QAnnotationView.h"

/*!
 * @enum QPinAnnotationColor
 *  QPinAnnotationView的颜色值
 */
typedef enum {
    QPinAnnotationColorRed = 0, ///<大头针红色
    QPinAnnotationColorGreen,   ///<大头针绿色
    QPinAnnotationColorPurple   ///<大头针紫色
} QPinAnnotationColor;

/*!
 *  @brief  提供类似大头针效果的annotationView
 */
@interface QPinAnnotationView : QAnnotationView

/*!
 *  @brief  大头针的颜色
 */
@property (nonatomic) QPinAnnotationColor pinColor;

/*!
 *  @brief  动画效果
 */
@property (nonatomic) BOOL animatesDrop;

@end
