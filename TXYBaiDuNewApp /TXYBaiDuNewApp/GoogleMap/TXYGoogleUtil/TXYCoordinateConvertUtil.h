//
//  TXYCoordinateConvertUtil.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface TXYCoordinateConvertUtil : NSObject

+ (CLLocationCoordinate2D)getFireCoordinateFromGpsCoordinate:(CLLocationCoordinate2D)gpsCoor;

+ (CLLocationCoordinate2D)getGpsCoordinateFromFireCoordinate:(CLLocationCoordinate2D)fireCoor;

@end
