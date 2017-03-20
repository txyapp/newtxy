//
//  AppManage.h
//  AppManage
//
//  Created by root1 on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+noNIL.h"

@interface AppManage : NSObject

/**
 *  获取一个app管理类
 *
 *  @return 管理类
 */
+ (instancetype)sharedAppManage;

/**
 *  获取全部App
 *
 *  @return app的BundleId数组
 */
-(NSArray *)getAllAppArray;

/**
 *  通过BundleId获取应用图标
 *
 *  @param bundleId App BundleId
 *
 *  @return App的图片
 */
-(UIImage *)getIconForBundleId:(NSString *)bundleId;

/**
 *  通过AppBundleId获取app名字
 *
 *  @param bundleId App BundleId
 *
 *  @return App的名字
 */
-(NSString *)getAppNameForBundleId:(NSString *)bundleId;

@end
