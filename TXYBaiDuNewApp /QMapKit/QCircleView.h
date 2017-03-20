/*
 ============================================================================
 Name           : QCircleView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QCircleView declaration
 ============================================================================
 */

/**    @file QCircleView.h     */

#import "QOverlayPathView.h"
#import "QCircle.h"

/**
 *  @brief QCircleView:定义圆对应的View
 **/
@interface QCircleView : QOverlayPathView

/*!
 *  @brief  根据指定圆生成对应的view
 *
 *  @param circle 指定的QCircle对象
 *
 *  @return 生成的view
 */
- (id)initWithCircle:(QCircle *)circle;

/*!
 *  @brief  关联的QCirlce对象
 */
@property(nonatomic, readonly) QCircle *circle;

@end
