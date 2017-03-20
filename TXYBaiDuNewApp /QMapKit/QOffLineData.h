//
//  QOfflinData.h
//  SOSOMap_DiDi
//
//  Created by Alonzo on 14-3-6.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//
/**    @file QOffLineData.h     */

#import <Foundation/Foundation.h>
#import "QCityData.h"

@protocol IDataReceiveNotification;
@protocol IViewNotification;

/**
 * @enum QCityDataUpdateResult
 * @brief 离线包检查更新的结果
 */
typedef enum {
    QCHECK_CITYDATA_AND_UPDATED=0,              ///< 检查并更新了城市配置文件
    QCHECK_CITYDATA_WITHOUT_UPDATE,             ///< 检查但是不需要更新
    QCHECK_CITYDATA_WITH_NET_ERROR              ///< 网络错误
} QCityDataUpdateResult;

/**
 * @brief 协议类。用于离线包下载和更新的回调
 */
@protocol QOffLineCityDelegate <NSObject>

/**
 * @brief 离线包下载进度回调
 *
 * @param city 当前离线包
 * @param currentLength 当前已下载大小
 * @param length 总大小
 */
- (void)onReceiveCity:(QCityData*)city Size:(int)currentLength totalLength:(int)length;
/**
 * @brief 离线包下载完成回调
 *
 * @param city 当前离线包
 */
- (void)cityDataIsReadyForUse:(QCityData*)city;
/**
 * @brief 检查离线包更新回调
 *
 * @param result 检查结果有无可用更新
 * @see QCityDataUpdateResult
 */
- (void)notifyCheckCityDataUpdateResult:(QCityDataUpdateResult)result;
/**
 * @brief 下载离线包失败回调
 *
 * @param city 当前离线包
 * @param error 原因
 */

- (void)onReceiveCity:(QCityData*)city Error:(NSError*)error;
@end

/**
 * @brief 用于离线包的下载
 */
@interface QOffLineData : NSObject

@property (atomic, assign) id<QOffLineCityDelegate> delegate;

+ (QOffLineData *)defaultManager ;
/**
 *  @brief 开始下载
 *
 * @param city 当前离线包
 */
- (void)startTask:(QCityData *)city;
/**
 *  @brief 暂停下载
 *
 * @param city 当前离线包
 */
- (void)pauseTask:(QCityData *)city;
/**
 *  @brief 取消下载
 */
- (void)cancelTask:(QCityData *)city;
/**
 *  @brief 删除下载
 *
 * @param city 当前离线包
 */
- (BOOL)deleteCityData:(QCityData *)city;

/**
 *  @brief 根据区号返回CityData
 *
 * @param areaID 当前离线包的行政区号
 */
- (QCityData *) findCityByareaID:(NSString *)areaID;


/**
 *  @brief 检查是否有新的离线数据
 *
 */
-(void)checkCityDataUpdate;

@end
