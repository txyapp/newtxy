//
//  GoogleMapLocationManager.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TXYGoogleLocationManagerDelegate.h"
#import "TXYGoogleLocationProtocol.h"

@interface GoogleMapLocationManager : NSObject

@property (nonatomic,strong) CLLocationManager                      *locationManager;
@property (nonatomic,strong) TXYGoogleLocationManagerDelegate       *locationManagerDelegate;


@property (nonatomic,weak) id<TXYGoogleCurrentLocationProtocol>      currentLocationDelegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)startReceiveCurrentLocationWithHandler:(id<TXYGoogleCurrentLocationProtocol>)handlerObj;

@end
