//
//  GoogleMapManager.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapManager.h"
#import "TXYGoogleService.h"
#import "GoogleMapViewUtil.h"
#import "GoogleMapTileImageOperation.h"

@implementation GoogleMapManager

- (instancetype)init
{
    if (self = [super init]) {
        [self initalScrollView];
        self.mapTilesArray = [[NSMutableArray alloc] init];
        self.oldMapTilesArray = [[NSMutableArray alloc] init];
        self.mapLineModel = [[GoogleMapLineModel alloc] init];
        [GoogleMapTileImageOperation MapTileImageDownloadInit];
    }
    return self;
}

- (void)initalScrollView
{
    CGRect scrollFrame = [TXYGoogleService mapConfig].scrollMapViewFrame;
    self.mapScrollView = [[GoogleMapScrollView alloc] initWithFrame:scrollFrame];
}

- (GoogleMapScrollView *)getMapScrollView
{
    return self.mapScrollView;
}

- (void)addMapTileImageView:(GoogleMapTileImageView *)mapTile
{
    [self.mapScrollView addMapTileImageView:mapTile];
}

- (void)addMapTiles:(NSArray *)mapTileImageArray
{
    for (GoogleMapTileImageView *view in mapTileImageArray) {
        [GoogleMapViewUtil resetMapTilesSizeInArray:mapTileImageArray];
        [self addMapTileImageView:view];
    }
}
- (void)removeMapTileImageViews:(NSArray *)mapTileImageView
{
    for (GoogleMapTileImageView *view in mapTileImageView) {
        [view removeFromSuperview];
    }
}

- (void)loadMapTilesImage:(NSArray *)mapTileImageView
{
    [GoogleMapTileImageOperation loadMapTileImages:mapTileImageView];
}

- (void)loadMapTilesImageInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel
{
    [GoogleMapTileImageOperation loadMapTileImagesCancel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.oldMapTilesArray.count == 2) {
        if (self.oldMapTilesArray.count > 3) {
            NSArray *removeMapTiles = [self.oldMapTilesArray objectAtIndex:0];
            [self.oldMapTilesArray removeObjectAtIndex:0];
            [self removeMapTileImageViews:removeMapTiles];
            [GoogleMapTileImageOperation clearMapTileMemoryCache];
        }
        
//        }
    });
    
    self.mapTilesArray = [GoogleMapViewUtil getGoogleMapTileImageViewsAtRect:displayRect atZoomLevel:zoomLevel withMapTileSize:[[TXYGoogleService mapConfig] getScaledMapTileSize]];
    [self.oldMapTilesArray addObject:self.mapTilesArray];
    [self addMapTiles:self.mapTilesArray];
    [self loadMapTilesImage:self.mapTilesArray];
}

- (void)refreshAnnotations
{
    [self.mapScrollView reloadAnnotations];
}

- (void)addCurrentLocationAnnotationAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapScrollView addCurrentAnnotationAtCoordinate:coordinate];
}

- (void)setGoogleMapCenterAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapScrollView setMapCenter:coordinate animated:YES];
}

- (void)addMapLineCoordinateValue:(NSValue *)value
{
    [self.mapLineModel addMapLinePointValue:value];
}

- (void)removeMapLineInfos
{
    [self.mapLineModel removeAllMapLinePoints];
}

- (void)showMapLine
{
    [[self getMapScrollView] showMapLineWithModel:self.mapLineModel];
}

- (void)dismissLine
{
    [[self getMapScrollView] dismissMapLine];
}

@end
