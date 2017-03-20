//
//  GoogleMapLocationManager.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapLocationManager.h"
#import <UIKit/UIDevice.h>

@implementation GoogleMapLocationManager

- (instancetype)init
{
    if (self = [super init]) {
        [self locationManagerInit];
    }
    return self;
}

- (void)locationManagerInit
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManagerDelegate = [[TXYGoogleLocationManagerDelegate alloc] init];
    self.locationManager.delegate = self.locationManagerDelegate;
    self.locationManagerDelegate.locationManager = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (void)startReceiveCurrentLocationWithHandler:(id<TXYGoogleCurrentLocationProtocol>)handlerObj
{
    self.currentLocationDelegate = handlerObj;
}

@end
