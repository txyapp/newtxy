//
//  QPointAnnotation.h
//  TMSTest
//
//  Created by tabsong on 14/12/15.
//  Copyright (c) 2014年 tabsong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAnnotation.h"

/*!
 *  @brief  点类覆盖物
 */
@interface QPointAnnotation : NSObject <QAnnotation>

/*!
 *  @brief  标题
 */
@property (copy) NSString *title;

/*!
 *  @brief  副标题
 */
@property (copy) NSString *subtitle;

/*!
 *  @brief  经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
