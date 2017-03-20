/*
 ============================================================================
 Name           : QUserLocation.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QUserLocation declaration
 ============================================================================
 */

/**    @file QUserLocation.h     */

#import <Foundation/Foundation.h>
#import "QAnnotation.h"

/*!
 *  @brief 定位信息类
 */
@interface QUserLocation : NSObject <QAnnotation>

/*!
 *  @brief  位置更新状态，如果正在更新位置信息，则该值为YES
 */
@property(readonly, nonatomic, getter=isUpdating) BOOL updating;

/*!
 *  @brief  位置信息, 如果QMapView的showsUserLocation为NO, 或者尚未定位成功, 则该值为nil
 */
@property( nonatomic, readonly) CLLocationCoordinate2D location;

/*!
 *  @brief  定位标注点要显示的标题信息
 */
@property(nonatomic, readonly) NSString *title;

/*!
 *  @brief  定位标注点要显示的副标题信息
 */
@property(nonatomic, readonly) NSString *subtitle;

@end
