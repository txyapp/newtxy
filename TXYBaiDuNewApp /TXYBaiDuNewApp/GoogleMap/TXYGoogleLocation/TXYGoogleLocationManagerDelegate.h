//
//  TXYGoogleLocationManagerDelegate.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GoogleMapLocationManager;
@interface TXYGoogleLocationManagerDelegate : NSObject<CLLocationManagerDelegate>

@property (nonatomic,weak) GoogleMapLocationManager *locationManager;

@end
