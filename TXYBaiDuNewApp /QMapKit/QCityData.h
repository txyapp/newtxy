//
//  QCityData.h
//  QQMap
//
//  Created by Jasonzhang on 6/29/11.
//  Copyright 2011 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  离线包下载的当前状态
 */
typedef enum QCityDataState_ {
    QCityData_None,                      // No city data
    QCityData_Available,                 // No city data in local, while available on server
    QCityData_Downloading,               // Downloading city data from server
    QCityData_Pause,                     // Pause downloading
    QCityData_OK                         // Data is ready for using
} QCityDataState;

/**
 *  @brief 单个城市的离线包
 */
@interface QCityData : NSObject <NSCoding> {
    
}

/// @brief id
@property (nonatomic)   int ID;
/// @brief 版本号
@property (nonatomic)   int version;
/// @brief 城市名
@property (nonatomic, copy) NSString*   name;
/// @brief 城市拼音
@property (nonatomic, copy) NSString*   spelling;
/// @brief 城市拼音缩写
@property (nonatomic, copy) NSString*   spellingForShort;
/// @brief 区号
@property (nonatomic, copy) NSString*   areaID;
/// @brief 省区号
@property (nonatomic)   int provinceID;
/** @brief 状态
 * @see QCityDataState
 */
@property (nonatomic)   QCityDataState   curState;
/** @brief 总大小
 * @note totalSize 可能会重置为0，需要显示数据包大小，请使用displaySzie
 */
@property (nonatomic)   int totalSize;
/// @brief 总大小
@property (nonatomic)   int displaySize;
/// @brief 已下载大小
@property (nonatomic)   int downloadedSize;
/// @brief 是否下载完成
@property (nonatomic)   BOOL isDataReadyForUse;
/// @brief 更新日期
@property (nonatomic, copy) NSString* updateDate;
/// @brief 检验码
@property (nonatomic, copy) NSString* MD5;
/// @brief 是否有更新日期
@property(nonatomic, assign)BOOL isHasUpdateData;
/// @brief 是否有离线包数据
@property(nonatomic,assign)BOOL isHasOfflineData;
@end
