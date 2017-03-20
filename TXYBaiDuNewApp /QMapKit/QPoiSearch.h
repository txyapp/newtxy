/*
 ============================================================================
 Name           : QPoiSearch.h
 Author         : 腾讯SOSO地图API
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QPoiInfo,QPoiData,QCityInfoForPoi,QPoiResult declaration
 ============================================================================
 */

/**    @file QPoiSearch.h     */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QTypes.h"

/**
 *  @brief QPoiType:POI类型
 **/
typedef enum
{
    QPoiTypeCommon  = 0,    /**POI类型:无特殊类型标记人普通POI**/
    QPoiTypeBusStation,     /**POI类型:公交站**/
    QPoiTypeSubwayStation,  /**POI类型:地铁站**/
    QPoiTypeBusLine,        /**POI类型:公交线**/
    QPoiTypeAear,           /**POI类型:行政区划**/
    
}QPoiType;

/**
 *  @brief QPoiInfo:POI数据信息
 **/
@interface QPoiInfo : NSObject

/** @brief POI的类型**/
@property(nonatomic, assign) QPoiType  type;
/** @brief POI的UID**/
@property(nonatomic, retain) NSString* uid;
/** @brief POI的名称**/
@property(nonatomic, retain) NSString* name;
/** @brief POI的详细地址**/
@property(nonatomic, retain) NSString* address;
/** @brief POI的电话**/
@property(nonatomic, retain) NSString* phone;
/** @brief POI的分类**/
@property(nonatomic, retain) NSString* classes;
/** @brief POI的详细描述**/
@property(nonatomic, retain) NSString* poiInfo;
/** @brief POI的地理坐标**/
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

/**
 *  @brief QPoiData:POI数据
 **/
@interface QPoiData : NSObject

/** @brief 本次POI搜索的总结果数**/
@property(nonatomic, assign) NSInteger totalPoiNum;
/** @brief 当前页的POI结果数**/
@property(nonatomic, assign) NSInteger curPoiNum;
/** @brief 本次POI搜索的总页数**/
@property(nonatomic, assign) NSInteger pageNum;
/** @brief 当前页的索引**/
@property(nonatomic, assign) NSInteger pageIndex;
/** @brief POI列表，成员是QPoiInfo**/
@property(nonatomic, retain) NSArray* poiInfoList;

@end


/**
 *  @brief QCityInfoForPoi:POI搜索下的城市信息
 **/
@interface QCityInfoForPoi : NSObject

/** @brief 所在的省，如果为直辖市，则为直辖市名称**/
@property(nonatomic, retain) NSString* provinceName;
/** @brief 城市名，如果为直辖市，则为直辖市名称**/
@property(nonatomic, retain) NSString* name;
/** @brief 该城市POI的数目**/
@property(nonatomic, assign) NSInteger poiNum;

@end

/**
 * @brief QPoiResult:POI搜索结果
 **/
@interface QPoiSearchResult : NSObject
/**
 * @brief 错误码
 * - 当errorCode为QPoiSearchPoiData时, data是QPoiData
 * - 当errorCode为QPoiSearchCityData时, data是QPoiInfo
 * - 当errorCode为QPoiSearchCrossCityData时, data是NSArray存放的是QCityInfoForPoi
 * - 其他为非正常状态,可以参见QErrorCode
 **/
@property(nonatomic, assign) QErrorCode errorCode;
/** @brief 搜索结果，和errorCode有一一对应关系**/
@property(nonatomic, retain) id data;	
/** @brief 搜索的POI所在的城市**/
@property(nonatomic, retain) NSString* cityName;
/** @brief 搜索的POI的关键字**/
@property(nonatomic, retain) NSString* keyWord;

@end


/**
 * @brief QSmartTripsResult:智能提示的结果
 **/
@interface QSmartTripsResult : NSObject
/** 
 *  @brief  错误友
 *  当errorCode为QSmartTripsList时, data是NSArray,存放的是NSString
 *  其他为非正常状态,可以参见QErrorCode
 **/
@property(nonatomic, assign) QErrorCode errorCode;
/** @brief 搜索结果，和errorCode有一一对应关系**/
@property(nonatomic, retain) id data;

@end

