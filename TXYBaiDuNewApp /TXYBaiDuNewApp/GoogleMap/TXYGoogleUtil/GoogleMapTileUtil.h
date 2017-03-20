//
//  GoogleMapTileUtil.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreLocation/CLLocation.h>
#import "GoogleMapTileInfoModel.h"

@interface GoogleMapTileUtil : NSObject

+ (int)getXMaxIndexAtZoomLevel:(int)zoomLevel;
+ (int)getYMaxIndexAtZoomLevel:(int)zoomLevel;

+ (NSArray *)getXIndexesInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize;
+ (NSArray *)getYIndexesInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize;

+ (NSArray *)getLoadMapTilesInfoInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize;
+ (CGPoint)getMapTileOriginAtXIndex:(int)xIndex andYIndex:(int)yIndex withMapTileSize:(CGSize)mapTileSize;

+ (CLLocationCoordinate2D)getLocationCoordinateWithMapTileInfo:(GoogleMapTileInfoModel *)infoModel andTapXPer:(float)xPer andTapYPer:(float)yPer;

+ (CGPoint)getMapViewPointWithCoordinate:(CLLocationCoordinate2D)coordinate andZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize;

@end
