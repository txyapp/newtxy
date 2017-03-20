//
//  WGS84TOGCJ02.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/18.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface WGS84TOGCJ02 : NSObject

//判断是否已经超出中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

//转GCJ-02
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;


@end
