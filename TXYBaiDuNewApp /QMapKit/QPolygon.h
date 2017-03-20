/*
 ============================================================================
 Name           : QPolygon.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QPolygon declaration
 ============================================================================
 */

/**    @file QPolygon.h     */

#import "QMultiPoint.h"
#import "QOverlay.h"

/*!
 *  @brief  此类用于定义一个由多个点组成的闭合多边形, 点与点之间按顺序尾部相连, 第一个点与最后一个点相连
 */
@interface QPolygon : QMultiPoint <QOverlay> {
    @package
    CLLocationCoordinate2D _centroid;
    NSArray *_interiorPolygons;
    BOOL _isDefinitelyConvex;
}

/*!
 *  @brief  根据mapPoint数据生成多边形
 *
 *  @param points mapPoint数据,points对应的内存会拷贝,调用者负责该内存的释放
 *  @param count  点的个数
 *
 *  @return 新生成的多边形
 */
+ (QPolygon *)polygonWithPoints:(QMapPoint *)points count:(NSUInteger)count;

/*!
 *  @brief  根据经纬度坐标数据生成闭合多边形
 *
 *  @param coords 经纬度坐标点数据, coords对应的内存会拷贝, 调用者负责该内存的释放
 *  @param count  经纬度坐标点数组个数
 *
 *  @return 新生成的多边形
 */
+ (QPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end
