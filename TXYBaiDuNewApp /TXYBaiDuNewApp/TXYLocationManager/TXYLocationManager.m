//
//  TXYLocationManager.m
//  TXYBaiDuNewApp
//
//  Created by aa on 16/8/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TXYConfig.h"
#import "TXYTools.h"

@interface TXYLocationManager()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager      *locationManager;

@end

@implementation TXYLocationManager

+ (instancetype)sharedManager
{
    static TXYLocationManager   *__sharedManager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager__ = [[TXYLocationManager alloc] init];
    });
    return __sharedManager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if (iOS8) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
    }
    return self;
}

- (void)startSearchRealLocation
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *curLocation = [locations lastObject];
    [[TXYConfig sharedConfig] setRealGPS:curLocation.coordinate];
    //判断是否在国外 是否需要上传信息
    [[TXYTools sharedTools] setOldCoordinate:curLocation.coordinate];
    [manager stopUpdatingLocation];
}

@end
