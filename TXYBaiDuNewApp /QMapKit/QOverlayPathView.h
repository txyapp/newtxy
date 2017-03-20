/*
 ============================================================================
 Name           : QOverlayPathView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QOverlayPathView declaration
 ============================================================================
 */

/**    @file QOverlayPathView.h     */

#import "QOverlayView.h"

/**
 *  @brief 路径类图形覆盖物的基类
 */
@interface QOverlayPathView : QOverlayView{

}

/*!
 *  @brief  填充颜色
 */
@property(nonatomic, retain) UIColor *fillColor;

/*!
 *  @brief  笔触颜色
 */
@property(nonatomic, retain) UIColor *strokeColor;

/*!
 *  @brief  笔触宽度,默认是0
 */
@property(nonatomic, assign) CGFloat lineWidth; 


@end
