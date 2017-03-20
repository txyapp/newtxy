//
//  TXYGoogleService.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "TXYGoogleService.h"

@implementation TXYGoogleService

+ (instancetype)defaultService
{
    static TXYGoogleService *__defaultService__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultService__ = [[TXYGoogleService alloc] init];
    });
    return __defaultService__;
}

+ (GoogleMapManager *)mapManager
{
    static GoogleMapManager *__defaultManager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultManager__ = [[GoogleMapManager alloc] init];
    });
    return __defaultManager__;
}

+ (GoogleMapConfig *)mapConfig
{
    static GoogleMapConfig *__googleConfig__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __googleConfig__ = [[GoogleMapConfig alloc] init];
    });
    return __googleConfig__;
}

+ (GoogleMapLocationManager *)locationManager
{
    static GoogleMapLocationManager *__googleLocationManager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __googleLocationManager__ = [[GoogleMapLocationManager alloc] init];
    });
    return __googleLocationManager__;
}


@end
