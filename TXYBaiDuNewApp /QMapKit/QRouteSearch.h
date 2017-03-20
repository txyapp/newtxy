/*
 ============================================================================
 Name           : QRouteSearch.h
 Author         : 腾讯SOSO地图API
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QRouteNode,QPlaceInfo,QTaxiInfo,QRouteSegmentForBus,QRouteInfoForBus..... declaration
 ============================================================================
 */
/**    @file QRouteSearch.h     */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QTypes.h"

/**
 * @brief QPlaceInfo:地点信息
 **/
@interface QPlaceInfo : NSObject

/** @brief 地点的名称**/
@property(nonatomic, retain) NSString* name;
/** @brief 地点的详细地址信息**/
@property(nonatomic, retain) NSString* address;
/** @brief 地点的坐标**/
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

/** @brief 标示该地点是不是一个城市**/
@property(nonatomic, assign) BOOL isCity;

/** @brief 标示该地点所在的城市**/
@property(nonatomic, retain)NSString* city;
/**  @brief 标识id    */
@property(nonatomic,retain)NSString* uid;

@end


/**
 * @brief QTaxiInfo:出租车信息
 **/
@interface QTaxiInfo : NSObject

/**  @brief 打车距离(单位:m)**/
@property(nonatomic, assign) NSInteger distance;
/** @brief 打车时间(单位:minute)**/
@property(nonatomic, assign) NSInteger time;

/** @brief 白天打车总的费用(单位:元)**/
@property(nonatomic, assign) NSInteger dayTotalFee;
/** @brief 白天打车起步价**/
@property(nonatomic, assign) NSInteger dayStartFee;
/** @brief 白天打车每公里多少元**/
@property(nonatomic, assign) NSInteger dayFeePerKM;
/** @brief 白天出租运营的时间段**/
@property(nonatomic, retain) NSString* dayTime;

/** @brief 夜晚打车总的费用**/
@property(nonatomic, assign) NSInteger nightTotalFee;
/** @brief 夜晚打车起步价**/
@property(nonatomic ,assign) NSInteger nightStartFee;
/** @brief 夜晚打车每公里多少元**/
@property(nonatomic, assign) NSInteger nightFeePerKM;
/** @brief 夜晚出租运营的时间段**/
@property(nonatomic, retain) NSString* nightTime;

@end


/**
 * @brief QRouteBusSegmentType:公交路段的类型
 **/
typedef enum  {
    QRouteSegmentTypeWalk = 0,  /**公交路段的类型:步行**/
    QRouteSegmentTypeBus,       /**公交路段的类型:公交**/
    QRouteSegmentTypeSubway,    /**公交路段的类型:地铁**/
    QRouteSegmentTypeFinish,    /**公交路段的类型:终点**/
} QRouteBusSegmentType;

/**
 * @brief QWalkDirectionType:行走方向的类型
 **/
typedef enum {
    QWalkDirectionEast = 0,     /**行走方向的类型:东**/
    QWalkDirectionNorthEast,    /**行走方向的类型:东北**/
    QWalkDirectionNorth,        /**行走方向的类型:北**/
    QWalkDirectionNorthWest,    /**行走方向的类型:西北**/
    QWalkDirectionWest,         /**行走方向的类型:西**/
    QWalkDirectionSouthWest,    /**行走方向的类型:西南**/
    QWalkDirectionSouth,        /**行走方向的类型:南**/
    QWalkDirectionSouthEast,    /**行走方向的类型:东南**/
    
}QWalkDirectionType;

/**
 * @brief QRouteSegmentForBus:公交的路段信息
 **/
@interface QRouteSegmentForBus : NSObject

/** @brief 公交路段距离(单位:m)**/
@property(nonatomic, assign) NSUInteger distance;
/** @brief 公交路段名称**/
@property(nonatomic, retain) NSString* name;
/** @brief 公交路段总站数**/
@property(nonatomic, assign) NSUInteger stationNum;
/** @brief 公交路段运行时间(单位:minute)**/
@property(nonatomic, assign) NSUInteger time;
/** @brief 公交路段类型**/
@property(nonatomic, assign) QRouteBusSegmentType type;
/** @brief 该公交路段在哪上车**/
@property(nonatomic, retain) NSString* whereGetOn;
/** @brief 该公交路段在哪下车**/
@property(nonatomic, retain) NSString* whereGetOff;
/** @brief QWalkDirectionType**/
@property(nonatomic, assign) QWalkDirectionType walkDirection;
/** @brief  该公交路段起点在路线节点中的索引**/
@property(nonatomic, assign) NSInteger startIndex;
/** @brief  该公交路段终点在路线节点中的索引**/
@property(nonatomic, assign) NSInteger endIndex;

@end

/**
 * @brief QRouteInfoForBus:公交的路线信息
 **/
@interface QRouteInfoForBus : NSObject

/** @brief 路线花费时间(单位:minute)**/
@property(nonatomic, assign) NSInteger time;
/** @brief 路线路程(单位:m)**/
@property(nonatomic, assign) NSInteger distance;
/** @brief 路线类型**/
@property(nonatomic, assign) NSInteger type;
/** @brief 路线的路段信息，存放的是QRouteSegmentForBus**/
@property(nonatomic, retain) NSArray* routeSegmentList;
/** @brief 线路各个地理坐标点数组**/
@property(nonatomic, readonly) CLLocationCoordinate2D* routeNodeList;
/** @brief 线路各个地理坐标点个数**/
@property(nonatomic, readonly) NSUInteger routeNodeCount;

/**
 * @brief 根据指定坐标点生成一段路线
 * @param routeNodeList 指定的地理坐标点数组
 * @param routeNodeCount 坐标点的个数
 */
- (void)setRouteNodeList:(CLLocationCoordinate2D *)routeNodeList withRouteNodeCount:(NSUInteger)routeNodeCount;

@end


/**
 * @brief QBusSearchType:公交搜索的类型
 **/
typedef enum  {
    QBusSearchShortCut  = 0,    /**公交搜索的类型:快捷**/
    QBusSearchLessTransfer,     /**公交搜索的类型:少换乘**/
    QBusSearchLessWalk,         /**公交搜索的类型:少步行**/
    QBusSearchNoSubway          /**公交搜索的类型:不走高速**/
}QBusSearchType;

/**
 * @brief QRoutePlan:路线方案
 **/
@interface QRoutePlan : NSObject

/** @brief 公交搜索的类型，调用者调用busSearch:start:end:withBusSearchType:时传入的**/
@property(nonatomic, assign) QBusSearchType busSearchType;
/** @brief 公交搜索的起点信息**/
@property(nonatomic, retain) QPlaceInfo* start;
/** @brief 公交搜索的终点信息**/
@property(nonatomic, retain) QPlaceInfo* end;
/** @brief 公交搜索的路线列表，存放的是QRouteInfoForBus**/
@property(nonatomic, retain) NSMutableArray* routeInfoList;
/** @brief 公交时间(单位:minute)**/
@property(nonatomic, assign) NSInteger time;

@end

/**
 * @brief QDriveSearchType:驾车搜索的类型
 **/
typedef enum  {
    QDriveSearchShortTime  = 0,  /**驾车搜索的类型:时间段**/
    QDriveSearchShortDistance = 2, /**驾车搜索的类型:距离短**/
} QDriveSearchType;


/**
 * @brief QDriveSegmentFeeType:驾车的路段的收费类型
 **/
typedef enum  {
     QDriveSegmentFeeFree  = 0, /** 驾车时路段的收费类型:全路段免费**/
     QDriveSegmentFeeAll,       /** 驾车时路段的收费类型:全路段收费**/
     QDriveSegmentFeePartial    /** 驾车时路段的收费类型:部分路段收费**/
} QDriveSegmentFeeType;


/**
 * @brief QRouteSegmentForDrive:驾车的路段信息
 **/
@interface QRouteSegmentForDrive : NSObject

/** @brief  驾车路段的动作**/
@property(nonatomic, retain) NSString* action;
/** @brief 驾车路段的描述**/
@property(nonatomic, retain) NSString* textInfo;
/** @brief  该驾车路段起点在路线节点中的索引**/
@property(nonatomic, assign) NSInteger startIndex;
/** @brief  该驾车路段终点在路线节点中的索引**/
@property(nonatomic, assign) NSInteger endIndex;
/** @brief  驾车路段的收费类型**/
@property(nonatomic, assign) QDriveSegmentFeeType feeType;
/** @brief  驾车路段的路程(单位:m)**/
@property(nonatomic, assign) NSInteger roadLength;
/** @brief  驾车路段的主要地点列表,存放的是QPlaceInfo对象**/
@property(nonatomic, retain) NSArray* keyPlaceList;
/** @brief  驾车路段的停车场列表,存放的是QPlaceInfo对象**/
@property(nonatomic, retain) NSArray* parkingList;

@end


/**前向声明**/
@class QPlaceInfo;

/**
 * @brief QRouteInfoForDrive:驾车的路线信息
 **/
@interface QRouteInfoForDrive : NSObject

/** @brief 驾车搜索的起点信息**/
@property(nonatomic, retain) QPlaceInfo* start;
/** @brief 驾车搜索的终点点信息**/
@property(nonatomic, retain) QPlaceInfo* end;
/** @brief 驾车路线所用时间**/
@property(nonatomic, assign) NSInteger time;
/** @brief 驾车路线的路程(单位:m)**/
@property(nonatomic, assign) NSInteger distance;
/** @brief 驾车路线的路经的主要地点数目**/
@property(nonatomic, assign) NSInteger keyPlaceNum;
/** @brief 驾车路线的路经的停车场数目**/
@property(nonatomic, assign) NSInteger parkingNum;
/** @brief 驾车路线的地理坐标点数组**/
@property(nonatomic, readonly) CLLocationCoordinate2D* routeNodeList;
/** @brief 驾车路线的地理坐标点个数**/
@property(nonatomic, readonly) NSUInteger routeNodeCount;
/**驾车路线的路段信息，存放的是QRouteSegmentForDrive对象**/
@property(nonatomic, retain) NSArray* routeSegmentList;

/**
 *  @brief 根据指定坐标点生成一段路线
 * @param routeNodeList 指定的地理坐标点数组
 * @param routeNodeCount 坐标点的个数
 */
- (void)setRouteNodeList:(CLLocationCoordinate2D *)routeNodeList withRouteNodeCount:(NSUInteger)routeNodeCount;

@end


/**
 * @brief QRouteQueryResultChoice:路线查询结果的选择，一般是起点或终点需要重新选择时返回的起点或终点的列表
 **/
@interface QRouteQueryResultChoice : NSObject
/** @brief 起点的列表，如果为列表中只有一个时，这项不用选择了，存放的是QPlaceInfo对象**/
@property(nonatomic, retain) NSArray* startList;
/** @brief 终点的列表，如果为列表中只有一个时，这项不用选择了，存放的是QPlaceInfo对象**/
@property(nonatomic, retain) NSArray* endList;

@end


/**
 * @brief QRouteSearchResult:路线搜索的结果
 **/
@interface QRouteSearchResult : NSObject

/** @brief 错误码，见QErrorCode,
 *  - 当errorCode为QRouteSearchResultBusList或QRouteSearchResultDriveList时,data为QRouteQueryResultChoice，
 *  - 当errorCode为QRouteSearchResultBusResult时,data为QRoutePlan，
 *  - 当errorCode为QRouteSearchResultDriveResult时,data为QRouteInfoForDrive，
 *  - 其他为非正常状态
 **/
@property(nonatomic, assign) QErrorCode errorCode;
/** @brief 结果检索。不同检索会存储不同类型**/
@property(nonatomic, retain) id data;
/** @brief 打车信息，当QRouteSearchResultBusList或QRouteSearchResultDriveList打车费用为空**/
@property(nonatomic, retain) QTaxiInfo* taxiInfo;
/** @brief 对调用者可以直接忽略**/
@property(nonatomic, retain) id context;

@end


/**
 * @brief QBusStationInfo:公交线站点信息
 **/
@interface QBusStationInfo : NSObject

/** @brief 公交站点名称**/
@property(nonatomic, retain) NSString* name;
/** @brief 公交站点UID**/
@property(nonatomic, retain) NSString* uid;
/** @brief 公交站点地理坐标**/
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

/**
 * @brief QBusLineInfo:公交线信息
 **/
@interface QBusLineInfo : NSObject

/** @brief 公交线UID    **/
@property(nonatomic, retain) NSString* uid;
/** @brief 公交线返程UID**/
@property(nonatomic, retain) NSString* reverseUid;
/** @brief 公交线公告**/
@property(nonatomic, retain) NSString* announcement;
/** @brief 公交线名称**/
@property(nonatomic, retain) NSString* name;
/** @brief 公交线始发站**/
@property(nonatomic, retain) NSString* startStation;
/** @brief 公交线终点站**/
@property(nonatomic, retain) NSString* endStation;
/** @brief 公交线首班车时间**/
@property(nonatomic, retain) NSString* startTime;
/** @brief 公交线末班车时间**/
@property(nonatomic, retain) NSString* endTime;
/** @brief 公交线路程(单位:km)**/
@property(nonatomic, assign) NSInteger distance;
/** @brief 公交线全程价格(单位:元)**/
@property(nonatomic, assign) NSInteger price;
/** @brief 公交线节点－显示公交线使用**/
@property(nonatomic, readonly) CLLocationCoordinate2D* busNodeList;
/** @brief 公交线节点数目－显示公交线使用**/
@property(nonatomic, readonly) NSUInteger busNodeCount;
/** @brief 公交线全部站点,存放的是QBusStationInfo对象**/
@property(nonatomic, retain) NSArray* stationList;

/**
 *指定坐标点生成一段折线
 *@param busNodeList    公交线节点数组
 *@param busNodeCount   公交线节点数目
 *@return 
 */
- (void)setBusNodeList:(CLLocationCoordinate2D*)busNodeList widthBusNodeCount:(NSUInteger)busNodeCount;

@end


/**
 * @brief QBusLineSearchResult:公交线搜索结果
 **/
@interface QBusLineSearchResult : NSObject

/** @brief 错误码，见QErrorCode,
 * 对busLineSearchResult中的errorCode而言.当errorCode为QBusLineSearchResultBusInfo时,data为QBusInfo,
 * 其他为非正常状态
 * @see QErrorCode
 **/
@property(nonatomic, assign) QErrorCode errorCode;
/** @brief 结果. 类型为 QBusLineInfo  **/
@property(nonatomic, retain) id data;

@end
