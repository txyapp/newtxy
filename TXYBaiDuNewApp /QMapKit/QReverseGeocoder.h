/*
 ============================================================================
 Name           : QReverseGeocoder.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QReverseGeocoder declaration
 ============================================================================
 */
/**    @file QReverseGeocoder.h     */

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "QTypes.h"

/**前向声明**/
@class QPlaceMark;
@class QReverseGeocoderInternal;
@protocol QReverseGeocoderDelegate;

/**
 *  @brief QReverseGeocoder:地址反编码
 *
 *  目前用于地图、街景的所有的反查，区别是是否指定radius属性，如果未指定radius或指定radius为0，
 *  则进行正常地址反查，如果指定radius则只进行街景反查。
 **/
@interface QReverseGeocoder : NSObject
{
    QReverseGeocoderInternal *_internal;
}

/**
 *  @brief 根据地理坐标生成QReverseGeocoder对象
 * @param coordinate   地理坐标
 * @return 新生成QReverseGeocoder对象
 */
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

/**  @brief 指定街景的搜索半径（单位:m）,如果不指定，会使用默认值，仅发起搜索前设置有效**/
@property(nonatomic, assign) NSUInteger radius;

/**  @brief 开始查询**/
- (BOOL)start;

/**  @brief 撤销查询**/
- (void)cancel;

/**  @brief delegate**/
@property(nonatomic, assign) id<QReverseGeocoderDelegate> delegate;

/**  @brief 查询的地理坐标**/
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

/**  @brief 查询的结果**/
@property(nonatomic, readonly) QPlaceMark *placeMark;

/**  @brief 查询的标识**/
@property(nonatomic, readonly, getter=isQuerying) BOOL querying;

@end


/**
 *  @brief QReverseGeocoderDelegate:地址反编码代理
 **/
@protocol QReverseGeocoderDelegate <NSObject>
@required

/**  @brief 成功时的通知
 * @param geocoder       QReverseGeocoder
 * @param placeMark      查询的结果
 */
- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFindPlacemark:(QPlaceMark *)placeMark;

/**  @brief 失败时的通知
 * @param geocoder    QReverseGeocoder
 * @param error       错误码. @see QErrorCode
 */
- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFailWithError:(QErrorCode)error;


@end
