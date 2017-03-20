//
//  TXYCoordinateConvertUtil.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYCoordinateConvertUtil.h"
#import "FireToGps.h"

@implementation TXYCoordinateConvertUtil

+ (CLLocationCoordinate2D)getFireCoordinateFromGpsCoordinate:(CLLocationCoordinate2D)gpsCoor
{
    CLLocationCoordinate2D fireCoor = [[FireToGps sharedIntances] gcj02Encrypt:gpsCoor.latitude bdLon:gpsCoor.longitude];
    return fireCoor;
}

+ (CLLocationCoordinate2D)getGpsCoordinateFromFireCoordinate:(CLLocationCoordinate2D)fireCoor
{
    CLLocationCoordinate2D gpsCoor = [[FireToGps sharedIntances] gcj02Decrypt:fireCoor.latitude gjLon:fireCoor.longitude];
    return gpsCoor;
}

@end
