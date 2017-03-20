//
//  HuiFuModel.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "HuiFuModel.h"

@implementation HuiFuModel
@synthesize isOpen = _isOpen;

- (id)init {
    self = [super init];
    if (self) {
        _isOpen = NO;
    }
    
    return self;
}
@end
