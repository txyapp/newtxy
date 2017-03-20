//
//  QRoutePassbySegment.h
//  QMapKit
//
//  Created by cleverzhang on 15/1/19.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//
/**     @file QRoutePassbySegment.h **/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QTypes.h"
#import "QRouteSearch.h"
/*
 * @enum QRoutePassbySegmentLineType
 * 途经点路线一段路线的样式
 */
typedef enum  {
    QRoutePassbySegmentLineType_Normal       = 0,   ///< 实线
    QRoutePassbySegmentLineType_Dash    	= 1,    ///< 虚线
} QRoutePassbySegmentLineType;

/**
 * @brief 途经点路线一段的路线
 */
@interface QRoutePassbySegment : NSObject

/*!
 *  @brief 此分段起点
 */
@property(nonatomic, retain) QPlaceInfo* startPoint;

/*!
 *  @brief 此分段终点
 */
@property(nonatomic, retain) QPlaceInfo* endPoint;

/*!
 *  @brief 此分段样式(实线/虚线)
 */
@property(nonatomic, assign) QRoutePassbySegmentLineType lineType;

/*!
 *  @brief 此分段颜色
 */
@property(nonatomic, assign) QMRouteColor lineColor;

/*!
 *  @brief 此分段线宽 (预留接口暂时不起作用)
 */
@property(nonatomic, assign) CGFloat lineWith;

/*!
 *  @brief 导航过程中获取是否已经经过途径点. YES: 已经经过
 */
@property(nonatomic, assign) BOOL bPass;

@end
