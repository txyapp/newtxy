//
//  QPanoAnnotation.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/24.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*!
 *  @brief  街景标注协议
 */
@protocol QPanoAnnotation <NSObject>

/*!
 *  @brief  经纬度
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @brief  高度
 */
@property (nonatomic, readonly) CGFloat height;

@optional

/*!
 *  @brief  获取annotation标题
 *
 *  @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 *  @brief  获取annotation副标题
 *
 *  @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end
