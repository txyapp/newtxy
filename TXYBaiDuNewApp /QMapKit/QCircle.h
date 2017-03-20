/*
 ============================================================================
 Name           : QCircle.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QCircle declaration
 ============================================================================
 */

/**    @file QCircle.h     */

#import "QShape.h"
#import "QOverlay.h"

/*!
 * @brief 圆形覆盖物
 */
@interface QCircle : QShape <QOverlay>{

@package
    CLLocationCoordinate2D _coordinate;
    double _radius;
    QMapRect _boundingMapRect;
}

/*!
 *  @brief  根据中心点, 半径构建circle
 *
 *  @param coor 中心点
 *  @param radius 半径
 *
 *  @return circle
 */
+ (QCircle *)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord radius:(double)radius;

/*!
 *  @brief  根据指定的直角坐标矩形生成circle
 *
 *  @param mapRect 指定的直角坐标矩形
 *
 *  @return circle
 */
+ (QCircle *)circleWithMapRect:(QMapRect)mapRect;

/*!
 *  @brief  中心点坐标
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @brief  半径, 单位米
 */
@property (nonatomic, readonly) double radius;

/*!
 *  @brief  该圆的外接矩形
 */
@property (nonatomic, readonly) QMapRect boundingMapRect; 

@end
