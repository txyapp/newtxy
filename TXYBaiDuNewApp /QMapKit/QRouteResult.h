//
//  QRouteResult.h
//  QQMap
//
//  Created by Nopwang on 5/6/11.
//  Copyright 2011 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGeometry.h"

@class QPlaceInfo;

/** 
 *  @brief 路线上的路径点
 */
typedef struct
{
    int x;  ///<    x坐标值
    int y;  ///<    y坐标值
} QGuidanceMapPoint;

/**
 *  @brief 路线搜索的结果类.
 * 本类为搜索结果，内部使用
 */
@interface QRouteResult : NSObject {

    NSArray *routes_;
    
    NSArray *taxiFees_;
    NSString *taxiFeeString_;
    
    NSInteger selectedRouteIndex_;
    BOOL isFromAndToIdentical_;
}
/// 未使用
@property (nonatomic) int forkIndex;
/// 未使用
@property (nonatomic) double forkX;
/// 未使用
@property (nonatomic) double forkY;
/// 未使用
@property (nonatomic) int saveTime;
/// 未使用
@property (nonatomic, retain) NSString *dynReason;

/// 所有路线
@property (nonatomic, retain) NSArray *routes;
/// 出租车费用
@property (nonatomic, retain) NSArray *taxiFees;
/// 出租车费用
@property (nonatomic, retain) NSString *taxiFeeString;
/// 当前选中路线
@property (nonatomic) NSInteger selectedRouteIndex;
/// 是否唯一起终点
@property (nonatomic) BOOL isFromAndToIdentical;
/// 是否为local结果
@property (nonatomic) BOOL isLocalResult;
/// 保存在线路线请求返回的url
@property (nonatomic, retain) NSString *reqRouteUrl;
/// 是否为区域结果
@property (nonatomic, assign) BOOL isBoundsResult;
/// 地理围栏坐标点
@property (nonatomic, assign) QGuidanceMapPoint *fencePoints;
/// 实际坐标点
@property (nonatomic, assign) QGuidanceMapPoint *mapPoints;
/// 地理围栏坐标点个数
@property (nonatomic, assign) int fencePointsCount;

/// 内部使用
@property(nonatomic, retain) id context;

/**  @brief 是否显示导航路线的终点图标**/
@property(nonatomic,assign)BOOL bHidePoints;
/**  @brief 是否显示导航路线的起点图标**/
@property(nonatomic,assign)BOOL bHideArrow;

/// 解析坐标点。内部使用
- (void)parseCoorPoints:(NSString *)coors;
/// 解析坐标点。内部使用
- (void)parseCarCoorPoints:(NSString *)coors;

/// 是否公交
- (BOOL)isTypeBusByRow:(int)row;
/// 是否自驾
- (BOOL)isTypeCarByRow:(int)row;
/// 是否步行
- (BOOL)isTypeWalkByRow:(int)row;
/// 是否公交
- (BOOL)isTypeBus;
/// 是否自驾
- (BOOL)isTypeCar;
/// 是否步行
- (BOOL)isTypeWalk;
/// 是否包含地铁
- (BOOL)isHassub;
/// 是否有路线
- (BOOL)hasRoutes;
/// 返回被选中的路线
- (id)selectedRoute;
/// type路线
- (id)typeRoute;
/**  @brief 返回路线的起始点信息，只包括经纬度信息，name和address字段暂时为空**/
- (QPlaceInfo*)startPlaceInfo;
/**  @brief 返回路线的结束点信息，只包括经纬度信息，name和address字段暂时为空**/
- (QPlaceInfo*)endPlaceInfo;
/**  @brief 返回路线的途经点信息，只包括经纬度，name信息，address字段暂时为空**/
- (NSArray*)passesPlaceInfo;
/**  @brief 返回被选择的Route的外接Rect,默认selectedRouteIndex==0**/
-(QMapRect)rectForSelectedRoute;
@end
