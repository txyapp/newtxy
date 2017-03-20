/*
 ============================================================================
 Name           : QPolygonView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QPolygonView declaration
 ============================================================================
 */

/**    @file QPolygonView.h     */

#import "QOverlayPathView.h"
#import "Qpolygon.h"

/*!
 *  @brief  此类是QPolygon的显示多边形View,可以通过QOverlayPathView修改其fill和stroke属性来配置样式
 */
@interface QPolygonView : QOverlayPathView

/*!
 *  @brief  根据指定的多边形生成一个多边形view
 *
 *  @param polygon 指定的多边形数据对象
 *
 *  @return 新生成的多边形view
 */
- (id)initWithPolygon:(QPolygon *)polygon;

/*!
 *  @brief  关联的QPolygon对象
 */
@property(nonatomic, readonly) QPolygon *polygon;

@end
