//
//  TXYMapTileConvert.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/11.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXYMapTileConvert : NSObject

+ (int)long2tilex:(double)lon andZoomLevel:(int)z;

+ (int)lat2tiley:(double)lat andZoomLevel:(int)z;

+ (double)tilex2long:(int)x andZoomLevel:(int)z;

+ (double)tiley2lat:(int)y andZoomLevel:(int)z;
@end
