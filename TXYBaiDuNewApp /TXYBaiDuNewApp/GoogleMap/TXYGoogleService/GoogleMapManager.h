//
//  GoogleMapManager.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import "GoogleMapScrollView.h"
#import <CoreLocation/CLLocation.h>
#import "GoogleMapLineModel.h"

@interface GoogleMapManager : NSObject

@property (nonatomic,strong) GoogleMapScrollView        *mapScrollView;
@property (nonatomic,strong) NSMutableArray             *mapTilesArray;

@property (nonatomic,strong) GoogleMapLineModel         *mapLineModel;
//纪录下3次请求到的地图数据
@property (nonatomic,strong) NSMutableArray             *oldMapTilesArray;

- (GoogleMapScrollView *)getMapScrollView;


- (void)addMapTileImageView:(GoogleMapTileImageView *)mapTile;
- (void)addMapTiles:(NSArray *)mapTileImageArray;
- (void)removeMapTileImageViews:(NSArray *)mapTileImageView;
- (void)loadMapTilesImage:(NSArray *)mapTileImageView;

- (void)loadMapTilesImageInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel;

- (void)addCurrentLocationAnnotationAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)setGoogleMapCenterAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)refreshAnnotations;

- (void)addMapLineCoordinateValue:(NSValue *)value;
- (void)showMapLine;
- (void)dismissLine;
- (void)removeMapLineInfos;
@end
