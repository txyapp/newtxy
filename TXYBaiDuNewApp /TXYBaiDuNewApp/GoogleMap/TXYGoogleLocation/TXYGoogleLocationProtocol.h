//
//  TXYGoogleLocationProtocol.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@protocol TXYGoogleLocationProtocol <NSObject>

@end

@protocol TXYGoogleCurrentLocationProtocol <NSObject>

- (void)didReceiveCurrentLocation:(CLLocation *)currentLocation;

@end;
