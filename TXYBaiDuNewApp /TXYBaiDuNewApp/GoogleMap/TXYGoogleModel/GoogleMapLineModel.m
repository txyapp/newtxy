//
//  GoogleMapLineModel.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapLineModel.h"

@implementation GoogleMapLineModel

- (instancetype)init
{
    if (self = [super init]) {
        self.mapLinePointCoordinateInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addMapLinePointValue:(NSValue *)pointValue
{
    [self.mapLinePointCoordinateInfoArray addObject:pointValue];
}

- (void)removeAllMapLinePoints
{
    [self.mapLinePointCoordinateInfoArray removeAllObjects];
}

@end
