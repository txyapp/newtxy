//
//  ZhoubianJilu.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhoubianJilu : NSObject


@property (nonatomic)int radius;
@property (nonatomic)int paixu;
@property (nonatomic)int tcpaixu;



//获取一个记录类的单例
+ (instancetype)shared;

@end
