//
//  NSString+object.m
//  TXYBaiDuNewApp
//
//  Created by fad on 15/12/13.
//  Copyright © 2015年 yunlian. All rights reserved.
//

#import "NSString+object.h"

@implementation NSString(obj)

-(NSString *)objectForKey:(NSString *)key{
    NSLog(@"error !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"key=%@",key);
    return key;
}

@end
