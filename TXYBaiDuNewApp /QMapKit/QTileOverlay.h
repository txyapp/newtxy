//
//  QTileOverlay.h
//  QMapKit
//
//  Created by tabsong on 15/8/10.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

/**    @file QTileOverlay.h     */

#import <Foundation/Foundation.h>
#import "QGeometry.h"

/**
 * @brief 代表单个瓦片的索引
 */
typedef struct {
    NSInteger x;    ///< 瓦片的x下标
    NSInteger y;    ///< 瓦片的y下标
    NSInteger z;    ///< 瓦片所在缩放级别
} QTileOverlayPath;

/**
 * @brief 用于自定义瓦片内容的类
 */
@interface QTileOverlay : NSObject

/*!
 *  @brief  最小zoom级别.
 */
@property (nonatomic, assign) NSInteger minimumZ;

/*!
 *  @brief  最大zoom级别.
 */
@property (nonatomic, assign) NSInteger maximumZ;

/*!
 *  @brief  水平范围.
 */
@property (nonatomic, assign) QMapRect boundingMapRect;

/*!
 *  @brief  tile当前是否过期. 
 *
 *  @param path     tile 的索引
 *  @return 是否过期
 *
 *  重载 @code - (void)loadTileAtPath:(QTileOverlayPath)path result:(void (^)(UIImage *tileImage, NSError *error))result @endcode 时,
 *  异步加载数据前调用该API, 若返回NO, 则无需加载数据.
 */
- (BOOL)tileAtPathIsExpired:(QTileOverlayPath)path;

@end

/**
 * @brief QTileOverlay的扩展类，用于提供数据加载方法
 */
@interface QTileOverlay (CustomLoading)

/*!
 *  @brief  加载tile数据
 *
 *  @param path     tile 的索引
 *  @param result   数据准备好后, 调用该block
 */
- (void)loadTileAtPath:(QTileOverlayPath)path result:(void (^)(UIImage *tileImage, NSError *error))result;

@end
