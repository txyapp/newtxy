/*
 ============================================================================
 Name           : QGeocoder.h
 Author         : 腾讯SOSO地图API
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QAddressInfo,QGeocoder declaration
 ============================================================================
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "QTypes.h"


/**
 *  @brief QAddressInfo:地址信息
 **/
@interface QAddressInfo : NSObject

/** @brief 所在的省份或直辖市**/
@property(nonatomic, copy) NSString* province;
/** @brief 所在的城市**/
@property(nonatomic, copy) NSString* city;
/** @brief 所在的地区**/
@property(nonatomic, copy) NSString* district;
/** @brief 地理坐标**/
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

/**前向声明**/
@class QGeocoderInternal;
@protocol QGeocoderDelegate;

/**
 *  @brief QGeocoder:地址编码
 **/
@interface QGeocoder : NSObject
{
    QGeocoderInternal *_internal;
}

/**
 * @brief 根据地点生成QGeocoder对象
 * @param address    地点
 * @return 新生成QGeocoder对象
 */
- (id)initWithAddress:(NSString*)address;

/** @brief 开始查询**/
- (void)start;

/** @brief 撤销查询**/
- (void)cancel;

/** @brief delegate**/
@property(nonatomic, assign) id<QGeocoderDelegate> delegate;

/** @brief 地点**/
@property(nonatomic, readonly) NSString* address;

/** @brief 查询的结果**/
@property(nonatomic, readonly) QAddressInfo* addressInfo;

/** @brief 查询的标识**/
@property(nonatomic, readonly, getter=isQuerying) BOOL querying;

@end

/**
 * @brief 协议类。用于通知查询的回调
 */
@protocol QGeocoderDelegate <NSObject>
@required

/** @brief 成功时的通知
 * @param geocoder       QGeocoder
 * @param placeMarkList  查询的结果
 */
- (void)geocoder:(QGeocoder *)geocoder didFindAddressInfo:(QAddressInfo*) addressInfo;

/** @brief 失败时的通知
 *  @param geocoder    QGeocoder
 *  @param error       错误码 @see QErrorCode
 */
- (void)geocoder:(QGeocoder *)geocoder didFailWithError:(QErrorCode)error;

@end
