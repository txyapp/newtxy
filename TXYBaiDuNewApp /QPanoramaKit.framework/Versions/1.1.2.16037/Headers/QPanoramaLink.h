//
//  QPanoramaLink.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/9.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  QPanorama的周边点
 */
@interface QPanoramaLink : NSObject

/*!
 *  @brief  初始化偏航角
 */
@property (nonatomic, assign) CGFloat heading;

/*!
 *  @brief  街景id
 */
@property (nonatomic, copy) NSString *panoramaID;

@end
