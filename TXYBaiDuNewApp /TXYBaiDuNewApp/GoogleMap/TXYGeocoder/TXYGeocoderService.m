//
//  TXYGeocoderManager.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYGeocoderService.h"
#import <CoreLocation/CoreLocation.h>
#import "CLGeocoderManager.h"


@interface TXYGeocoderService ()

@property (nonatomic,strong) CLGeocoder         *geocoder;

@end

@implementation TXYGeocoderService

+ (instancetype)defaultService
{
    static TXYGeocoderService       *__defaultService__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultService__ = [[TXYGeocoderService alloc] init];
    });
    return __defaultService__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.TXYGeocoder = [CLGeocoderManager sharedManager];
    }
    return self;
}

- (void)reverseGeoCoderWithCoordinate:(CLLocationCoordinate2D)coordinate andHandlerObject:(id<TXYReverseGeocoderProtocol>)handlerObject
{
    self.TXYGeocoder.reverseGeocoderDelegate = handlerObject;
    [self.TXYGeocoder startReverseGeocoderWithCoordinate:coordinate];
    
}

- (void)geoCoderSearchText:(NSString *)searchText andHandlerObject:(id<TXYGeocoderProtocol>)handlerObject
{
    self.TXYGeocoder.geocoderSearchDelegate = handlerObject;
    [self.TXYGeocoder startGeocoderSearchText:searchText];
}

@end
