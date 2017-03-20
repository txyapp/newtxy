/*
 ============================================================================
 Name           : QPolylineView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QPolylineView declaration
 ============================================================================
 */

/**    @file QPolylineView.h     */

#import "QOverlayPathView.h"
#import "QPolyLine.h"

/*!
 *  @brief   此类是QPolyline用于显示多段线的view,可以通过QOverlayPathView修改其fill和stroke属性来配置样式
 */
@interface QPolylineView : QOverlayPathView

/*!
 *  @brief  根据指定的QPolyline生成一个多段线view
 *
 *  @param polyline 指定的QPolyline
 *
 *  @return 新生成的折线段view
 */
- (id)initWithPolyline:(QPolyline *)polyline;

/*!
 *  @brief  关联的QPolyline对象
 */
@property (nonatomic, readonly) QPolyline *polyline;


@end
