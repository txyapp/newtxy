//
//  ZhoubianJilu.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ZhoubianJilu.h"
static ZhoubianJilu *zb=nil;
@implementation ZhoubianJilu

+ (instancetype)shared{
    @synchronized (self){
        if (zb==nil) {
            zb=[[ZhoubianJilu alloc]init];
        }
    }
    return zb;
}


@end
