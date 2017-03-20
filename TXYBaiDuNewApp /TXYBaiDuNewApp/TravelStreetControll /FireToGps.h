//
//  FireToGps.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FireToGps : NSObject
+ (instancetype)sharedIntances;
- (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon;
- (BOOL)outOfChina:(double)lat bdLon:(double)lon;
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps;
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps;
- (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon;
@end
