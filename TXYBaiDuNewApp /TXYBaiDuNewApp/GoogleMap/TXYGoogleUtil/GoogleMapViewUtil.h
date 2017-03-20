//
//  GoogleMapViewUtil.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreLocation/CLLocation.h>
#import "GoogleMapTileImageView.h"

@interface GoogleMapViewUtil : NSObject

+ (BOOL)isOutOfZoomRangeWithMapSize:(CGSize)mapSize;

+ (int)getZoomLevelWithSize:(CGSize)mapSize;

+ (float)getMapScaledWithMapSize:(CGSize)mapSize atZoomLevel:(int)zoomLevel;

+ (CGSize)getGoogleMapScrollBaseViewSizeWithZoomLevel:(int)zoomLevel;

+ (NSMutableArray *)getGoogleMapTileImageViewsAtRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize;

+ (CGPoint)getMapPointAtCurrentZoomLevelWithCoordinate:(CLLocationCoordinate2D)coordinate;

+ (void)resetMapTilesSizeInArray:(NSArray *)mapTilesArray;
+ (CGSize)getMapTileImageViewSize:(GoogleMapTileImageView *)mapTile atMapTiles:(NSArray *)mapTilesArray;
+ (float)getNextMapTileImageViewOrignalXAtXIndex:(int)xIndex atMapTiles:(NSArray *)mapTilesArray;
+ (float)getNextMapTileImageViewOrignalYAtYIndex:(int)yIndex atMapTiles:(NSArray *)mapTilesArray;

+ (float)getMapMinZoomScaleWithMapSize:(CGSize)mapSize;
+ (float)getMapMaxZoomScaleWithMapSize:(CGSize)mapSize;


@end
