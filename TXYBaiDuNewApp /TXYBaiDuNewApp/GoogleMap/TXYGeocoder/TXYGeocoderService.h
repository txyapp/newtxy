//
//  TXYGeocoderManager.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXYGeocoderProtocol.h"
#import <CoreLocation/CLLocation.h>

@interface TXYGeocoderService : NSObject

@property (nonatomic,weak)  id<TXYReverseGeocoderProtocol>   reverseGeocoderDelegate;
@property (nonatomic,weak)  id<TXYGeocoderProtocol>          geocoderSearchDelegate;

@property (nonatomic,strong) id<TXYGeocoderServiceInterface> TXYGeocoder;

+ (instancetype)defaultService;

- (void)reverseGeoCoderWithCoordinate:(CLLocationCoordinate2D)coordinate andHandlerObject:(id<TXYReverseGeocoderProtocol>)handlerObject;
- (void)geoCoderSearchText:(NSString *)searchText andHandlerObject:(id<TXYGeocoderProtocol>)handlerObject;

@end
