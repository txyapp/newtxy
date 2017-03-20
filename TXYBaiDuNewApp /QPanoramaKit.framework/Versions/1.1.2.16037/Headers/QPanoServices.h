//
//  QPanoServices.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/5/25.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  区别于QPanoramaService, 该类用于提供SDK版本信息和权限鉴定功能
 */
@interface QPanoServices : NSObject


+ (QPanoServices *)sharedServices;

/*!
 *  @brief  在创建QMapView之前需要先绑定key
 */
@property (nonatomic, copy) NSString *apiKey;

/*!
 *  @brief  SDK 版本号
 */
@property (nonatomic, readonly) NSString *SDKVersion;



@end
