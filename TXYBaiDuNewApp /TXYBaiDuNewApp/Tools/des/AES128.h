//
//  AES128.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/12/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128 : NSObject
+(NSString *)AES128Encrypt:(NSString *)plainText withKey:(NSString *)key;
+(NSString *)AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key;
@end
