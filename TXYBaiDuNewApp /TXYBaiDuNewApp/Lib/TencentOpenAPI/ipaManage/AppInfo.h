//
//  AppInfo.h
//  FakePhoneApp
//
//  Created by root1 on 15/9/10.
//  Copyright (c) 2015年 root1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface AppInfo : NSObject

- (NSArray *)allAppBundleId;

- (NSString *)appNameForBundelId:(NSString *)bundleId;

- (NSString *)appDataPathForBundleId:(NSString *)bundleId;

- (UIImage *)appIconForBundleId:(NSString *)bundleId;

@end
