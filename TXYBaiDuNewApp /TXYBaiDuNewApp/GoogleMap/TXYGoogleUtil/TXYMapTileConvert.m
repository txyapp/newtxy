//
//  TXYMapTileConvert.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/11.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYMapTileConvert.h"
#include <math.h>

@implementation TXYMapTileConvert

+ (int)long2tilex:(double)lon andZoomLevel:(int)z
{
    return (int)(floor((lon + 180.0) / 360.0 * pow(2.0, z)));
}

+ (int)lat2tiley:(double)lat andZoomLevel:(int)z
{
    return (int)(floor((1.0 - log( tan(lat * M_PI/180.0) + 1.0 / cos(lat * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, z)));
}

+ (double)tilex2long:(int)x andZoomLevel:(int)z
{
    return x / pow(2.0, z) * 360.0 - 180;
}

+ (double)tiley2lat:(int)y andZoomLevel:(int)z
{
    double n = M_PI - 2.0 * M_PI * y / pow(2.0, z);
    return 180.0 / M_PI * atan(0.5 * (exp(n) - exp(-n)));
}

@end
