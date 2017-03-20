//
//  TXYGoogleLocationManagerDelegate.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYGoogleLocationManagerDelegate.h"
#import "GoogleMapLocationManager.h"

@implementation TXYGoogleLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    if (self.locationManager.currentLocationDelegate) {
        [self.locationManager.currentLocationDelegate didReceiveCurrentLocation:lastLocation];
    }
}

@end
