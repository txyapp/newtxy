//
//  UserAuth.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAuth : NSObject

/**
 *  获取一个用户认证类的单例
 *
 *  @return UserAuth的实例
 */
+ (instancetype)sharedUserAuth;

/**
 *  当前用户的权限值
 *
 *  @return 权限数值
 */
- (NSInteger)authValueForFile;

-(void)authValueFormWeb;
-(void)newAuthValueFormWeb;
@end
