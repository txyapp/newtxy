/*
 ============================================================================
 Name           : QOverlay.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QOverlay declaration
 ============================================================================
 */

/**    @file QOverlay.h     */

#ifndef SOSOMapAPI_QOverlay_h
#define SOSOMapAPI_QOverlay_h
#import "QAnnotation.h"
#import "QGeometry.h"

/*!
 *  @brief  该类为地图覆盖物的protocol，提供了覆盖物的基本信息函数
 */
@protocol QOverlay <QAnnotation>
@required

/*!
 *  @brief  经纬坐标点
 */
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @brief  区域外接矩形.  单位: mercator
 */
@property(nonatomic, readonly) QMapRect boundingMapRect;

@end

#endif
