//
//  QPanoPointAnnotation.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/24.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPanoAnnotation.h"

/*!
 *  @brief  定义了一种符合QAnnotation协议的类
 */
@interface QPanoPointAnnotation : NSObject  <QPanoAnnotation>

/*!
 *  @brief  经纬度
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/*!
 *  @brief  高度
 */
@property (nonatomic) CGFloat height;

/*!
 *  @brief  标题
 */
@property (nonatomic, copy) NSString *title;

/*!
 *  @brief  副标题
 */
@property (nonatomic, copy) NSString *subtitle;

@end
