/*
 ============================================================================
 Name           : QTypes.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QTypes declaration
 ============================================================================
 */
/**    @file QTypes.h      */

#ifndef SOSOMapAPI_QTypes_h
#define SOSOMapAPI_QTypes_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  @enum QMapType
 *  地图类型
 **/
typedef enum {
    QMapTypeStandard = 0,   ///< 标准地图
    QMapTypeSatellite,      ///< 卫星地图
} QMapType;

/**
 * @enum QMUserTrackingMode
 * 用户的定位模式
 */
typedef enum {
	QMUserTrackingModeNone = 0,             ///< the user's location is not followed
	QMUserTrackingModeFollow,               ///< the map follows the user's location
	QMUserTrackingModeFollowWithHeading,    ///< the map follows the user's location and heading
} QMUserTrackingMode;

/**
 * @enum QMRouteDrawType
 * 路线样式类型
 */
typedef enum {
    QMRouteDrawMultiColorLine = 0,  ///< 线
    QMRouteDrawImaginaryLine,       ///< 虚线
    QMRouteDrawDottedLine           ///< 点
} QMRouteDrawType;


/**
 *  @enum QErrorCode
 *  错误码
 *
 *  errorCode>=0的类型表示正常的类型，其它类型为表示已知的错误类型
 **/
typedef enum {
    QAppKeyCheckFail = -100,        /** 应用程序验证码验证失败**/
	QDataError = -5,                /** 网络接收的数据错误**/
    QParamError = -4,               /** 网络请求的参数错误**/
    QNetError = -3,                 /** 网络连接错误**/
    QServiceNotSupport = -2,        /** 服务暂不支持**/
    QNotFound= -1,                  /** 没有找到**/
    
	QErrorNone = 0,                 /** 正确，无错误**/
    QSmartTripsList,                /** 搜索建议，智能提示**/
    QPoiSearchResultPoiList,        /** POI搜索类型:城市内搜索POI列表**/
    QPoiSearchResultRoundPoi,       /** POI搜索类型:城市内搜索周边POI**/
    QPoiSearchResultCity,           /** POI搜索类型:城市**/
    QPoiSearchResultCrossCityList,  /** POI搜索类型:城市列表**/
    QRouteSearchResultBusList,      /** 路线搜索类型:公交路线搜索返回的起点或终点的选择列表**/
    QRouteSearchResultBusResult,    /** 路线搜索类型:公交路线搜索返回的结果**/
    QRouteSearchResultDriveList,    /** 路线搜索类型:驾车路线搜索返回的起点或终点的选择列表**/
    QRouteSearchResultDriveResult,  /** 路线搜索类型:驾车路线搜索返回的结果**/
    QBusLineSearchResultBusInfo,     /** 公交线搜索类型:公交线搜索返回的结果**/
    QNetWorkUnavailable,        /**网络不可用**/
    QNetWorkSignalWeak         /**网络信号弱**/
    
} QErrorCode;

/// @def 错误域名称
#define QErrorDomain @"QErrorDomain"

/**
 * @enum QMRouteColor
 * 导航线路图的颜色
 *
 *  可用于标识类似路况等效果
 */
typedef enum {
    RC_TRAFFIC= -1,     ///< 根据路况来画导航图的颜色，只有设置RC_TRAFFIC才会动态更新路况
    RC_GREEN = 0,       ///< 绿色
    RC_YELLOW = 1,      ///< 黄色
    RC_RED = 2,         ///< 红色
    RC_LIGHT_BLUE = 4,  ///< 浅蓝色
    RC_DARK_BLUE = 5,   ///< 深蓝色
    
 } QMRouteColor;

typedef enum : NSUInteger {
    MAP_AUTONAV = 1,  //高德
    MAP_NAVINFO = 2,  //四维
} QMapDataType;


/**
 *  @brief 点击地图标注返回数据结构
 */
@interface QMapPoi : NSObject
/// 点标注的名称
@property (nonatomic,copy,readonly) NSString* text;
/// 点标注的经纬度坐标
@property (nonatomic,assign,readonly) CLLocationCoordinate2D coordinate;

@end

#endif
