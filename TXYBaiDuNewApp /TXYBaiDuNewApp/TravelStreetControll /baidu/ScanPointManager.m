//
//  ScanPointManager.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "ScanPointManager.h"

@implementation ScanPointManager
static ScanPointManager *defaultManager = nil;
+(ScanPointManager*)defaultManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(defaultManager == nil)
        {
            defaultManager = [[self alloc] init];
        }
        });
    return defaultManager;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(defaultManager == nil)
        {
            defaultManager = [super allocWithZone:zone];
        }
    });
    return defaultManager;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        return self;
        self.dic = [[NSMutableDictionary alloc]init];
    }
    return nil;
}
@end
