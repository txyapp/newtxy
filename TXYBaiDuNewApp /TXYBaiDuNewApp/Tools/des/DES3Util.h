//
//  DES3Util.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/12/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

+ (NSString*) AES128Encrypt:(NSString *)plainText;

+ (NSString*) AES128Decrypt:(NSString *)encryptText;

@end
