//
//  QRoute.h
//  SOSOMap
//
//  Created by Alonzo on 13-9-17.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

/**    @file QRoute.h     */

#import <Foundation/Foundation.h>

/**
 *  @brief 单条路径的信息类
 */
@interface QRoute : NSObject

/*!
 *  @brief  当前道路名称
 */
@property(nonatomic, retain) NSString *currentRoadName;

/*!
 *  @brief 下一个道路的名称
 */
@property(nonatomic, retain) NSString *nextRoadName;

/*!
 *  @brief 到下一个转向的距离
 */
@property(nonatomic, retain) NSString *distance;

/*!
 *  @brief 总的剩余距离
 */
@property(nonatomic, retain) NSString *totalDistanceLeft;

/*!
 *  @brief 总的剩余时间
 */
@property(nonatomic, retain) NSString *timeLeft;

/*!
 *  @brief 路口信息
 */
@property(nonatomic, retain) NSString* intersectionImageName;

@end
