//
//  TXYGeocoderProtocol.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@protocol TXYGeocoderProtocol <NSObject>

- (void)didGeocoderSuccessWithResults:(NSArray *)results;
- (void)didGeocoderFailedWithInfo:(NSString *)failedInfo;

@end

@protocol TXYReverseGeocoderProtocol <NSObject>

- (void)didReverseGeocodeSuccessWithStreetInfo:(NSString *)info andCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)didReverseGeocodeFailedWithInfo:(NSString *)info;

@end

@protocol TXYGeocoderServiceInterface <NSObject>

@property (nonatomic,weak) id<TXYReverseGeocoderProtocol>    reverseGeocoderDelegate;
@property (nonatomic,weak) id<TXYGeocoderProtocol>           geocoderSearchDelegate;

- (void)startReverseGeocoderWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)startGeocoderSearchText:(NSString *)searchText;

@end
