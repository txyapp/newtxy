/*
 ============================================================================
 Name           : QSearch.h
 Author         : 腾讯SOSO地图API
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QSearch declaration
 ============================================================================
 */

/**    @file QSearch.h     */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QRouteSearch.h"
#import "QPoiSearch.h"
#import "QRouteResult.h"

/**前向声明**/
@protocol QSearchDelegate;
@class QSearchInternal;


/**
 * @brief QSearch:POI，周边，路线，公交，驾车等搜索服务
  **/
@interface QSearch : NSObject
{
    QSearchInternal* _internal;
}

/**  @brief Search Delegate**/
@property(nonatomic, assign) id<QSearchDelegate> delegate;

/**
 *  @brief 设置每页容量
 * 支持1-50.默认为10,对下一次检索有效,如果在pageCapacity小于1或大于50时,则会设置为默认值10
 * @param capacity 指定的每页POI最大数目
 * @return 返回每页容量(1-50之间)
 */
@property(nonatomic, assign) NSInteger pageCapacity;

/**
 *  @brief 根据地理坐标获取城市名
 * @param locationCoordinate2D 地理坐标
 * @return 成功返回城市名，否则返回nil
 */
- (NSString*)getCityNameFromPos:(CLLocationCoordinate2D)locationCoordinate2D;

/*!
 *  @brief  起始点 导航路线搜索
 *
 *  @param start  起点
 *  @param end   终点
 *  @param driveSearchType 搜索选项
 *  @param bNoHighway 是否走高速. YES: 不走高速. NO: 走高速
 *  @return 是否成功
 */
- (BOOL)navRouteSearchWithLocation:(QPlaceInfo*)start
                               end:(QPlaceInfo*)end
              withDriveSearchType:(QDriveSearchType)driveSearchType
                         noHighway:(BOOL)bNoHighway;

/*!
 *  @brief  途径点 导航路线搜索
 *
 *  @param lineArray  包含起点，终点，途经点的数组. 元素为QRoutePassbySegment
 *  @param driveSearchType 搜索选项
 *  @param bNoHighway 是否走高速. YES: 不走高速. NO: 走高速
 *  @return 是否成功
 */
- (BOOL)navRouteSearchWithLocationArray:(NSArray*)lineArray
                    withDriveSearchType:(QDriveSearchType)driveSearchType
                              noHighway:(BOOL)bNoHighway;

@end


/**
 * @brief QSearchDelegate:POI，周边，路线，公交，驾车等搜索结果的通知
 **/
@protocol QSearchDelegate<NSObject>

@optional

/*!
 *  @brief  导航路线搜索 (包含途经点)
 *
 *  @param routeSearchResult  搜索路径结果
 */
- (void)notifyNavRouteSearchResult:(QRouteResult*)routeSearchResult;

/*!
 * @brief 返回导航搜索错误结果
 * @param error 错误类型
 *       Error domain: QErrorDomain
 *       Error code: -1 QNotFound 无数据
 *                   -1 QNetError 网络连接错误
 */
- (void)notifyNavRouteSearchDidFailWithError:(NSError *)error;

@end