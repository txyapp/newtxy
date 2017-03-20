//
//  GoogleMapTileImageOperation.h
//  TXYGoogleTest
//
//  Created by aa on 16/7/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapTileImageOperation : NSObject

+ (void)MapTileImageDownloadInit;

+ (void)loadMapTileImages:(NSArray *)googleMapTileImageViews;

+ (void)loadMapTileImagesCancel;

+ (void)clearMapTileMemoryCache;

+ (void)clearMapTileDiskCache;

+ (NSString *)getMapTileCacheSize;

@end
