//
//  GoogleMapViewUtil.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapViewUtil.h"
#import "TXYGoogleService.h"
#import "GoogleMapTileUtil.h"

@implementation GoogleMapViewUtil

+ (BOOL)isOutOfZoomRangeWithMapSize:(CGSize)mapSize
{
    CGSize mapDefaultSize = [TXYGoogleService mapConfig].mapTileDefaultSize;
    int minMapTileCount = [GoogleMapTileUtil getXMaxIndexAtZoomLevel:[TXYGoogleService mapConfig].minZoomLevel];
    int maxMapTileCount = [GoogleMapTileUtil getXMaxIndexAtZoomLevel:[TXYGoogleService mapConfig].maxZoomLevel];
    if (mapSize.width < minMapTileCount*mapDefaultSize.width || mapDefaultSize.width > maxMapTileCount*mapDefaultSize.width) {
        return YES;
    }else{
        return NO;
    }
}

+ (float)getMapScaledWithMapSize:(CGSize)mapSize atZoomLevel:(int)zoomLevel
{
    CGSize mapDefaultSize = [TXYGoogleService mapConfig].mapTileDefaultSize;
    int mapTileCount = [GoogleMapTileUtil getXMaxIndexAtZoomLevel:zoomLevel];
    return mapSize.width/(mapDefaultSize.width*mapTileCount);
}

+ (int)getZoomLevelWithSize:(CGSize)mapSize
{
    int count = (int)mapSize.width/[TXYGoogleService mapConfig].mapTileDefaultSize.width;
    double zoom = log2((double)count);
    return (int)zoom;
}

+ (CGSize)getGoogleMapScrollBaseViewSizeWithZoomLevel:(int)zoomLevel
{
    CGSize mapTileSize = [[TXYGoogleService mapConfig] getScaledMapTileSize];
    int xMaxIndex = [GoogleMapTileUtil getXMaxIndexAtZoomLevel:zoomLevel];
    int yMaxIndex = [GoogleMapTileUtil getYMaxIndexAtZoomLevel:zoomLevel];
    return CGSizeMake(mapTileSize.width*xMaxIndex, mapTileSize.height*yMaxIndex);
}

+ (NSMutableArray *)getGoogleMapTileImageViewsAtRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize
{
    NSArray *mapTileInfos = [GoogleMapTileUtil getLoadMapTilesInfoInRect:displayRect atZoomLevel:zoomLevel withMapTileSize:mapTileSize];
    NSMutableArray *mapTileImageViewsArray = [[NSMutableArray alloc] initWithCapacity:mapTileInfos.count];
    for (GoogleMapTileInfoModel *model in mapTileInfos) {
        GoogleMapTileImageView *imageView = [[GoogleMapTileImageView alloc] initWithInfoModel:model];
        [mapTileImageViewsArray addObject:imageView];
    }
    return mapTileImageViewsArray;
}

+ (CGPoint)getMapPointAtCurrentZoomLevelWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [GoogleMapTileUtil getMapViewPointWithCoordinate:coordinate andZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel withMapTileSize:[[TXYGoogleService mapConfig] getScaledMapTileSize]];
}

+ (void)resetMapTilesSizeInArray:(NSArray *)mapTilesArray
{
    for (GoogleMapTileImageView *mapTileImageView in mapTilesArray) {
        CGSize fixedSize = [self getMapTileImageViewSize:mapTileImageView atMapTiles:mapTilesArray];
        mapTileImageView.frame = CGRectMake(mapTileImageView.frame.origin.x, mapTileImageView.frame.origin.y, fixedSize.width, fixedSize.height);
    }
}

+ (CGSize)getMapTileImageViewSize:(GoogleMapTileImageView *)mapTile atMapTiles:(NSArray *)mapTilesArray
{
//    int xIndex = mapTile.mapTileInfo.xIndex;
//    int yIndex = mapTile.mapTileInfo.yIndex;
    float nextX = [self getNextMapTileImageViewOrignalXAtXIndex:mapTile.mapTileInfo.xIndex atMapTiles:mapTilesArray];
    float nextY = [self getNextMapTileImageViewOrignalYAtYIndex:mapTile.mapTileInfo.yIndex atMapTiles:mapTilesArray];
    
    float width,height;
    if (nextX == 0) {
        width = mapTile.frame.size.width;
    }else{
        width = nextX - mapTile.frame.origin.x;
    }
    if (nextY == 0) {
        height = mapTile.frame.size.height;
    }else{
        height = nextY - mapTile.frame.origin.y;
    }
    
    return CGSizeMake(width, height);
    
}

+ (float)getNextMapTileImageViewOrignalXAtXIndex:(int)xIndex atMapTiles:(NSArray *)mapTilesArray
{
    for (GoogleMapTileImageView *mapTileView in mapTilesArray) {
        if (mapTileView.mapTileInfo.xIndex == xIndex+1) {
            return mapTileView.frame.origin.x;
        }
    }
    return 0;
}

+ (float)getNextMapTileImageViewOrignalYAtYIndex:(int)yIndex atMapTiles:(NSArray *)mapTilesArray
{
    for (GoogleMapTileImageView *mapTileView in mapTilesArray) {
        if (mapTileView.mapTileInfo.yIndex == yIndex+1) {
            return mapTileView.frame.origin.y;
        }
    }
    return 0;
}

+ (float)getMapMinZoomScaleWithMapSize:(CGSize)mapSize
{
    CGSize minSize = [self getGoogleMapScrollBaseViewSizeWithZoomLevel:[TXYGoogleService mapConfig].minZoomLevel];
    return minSize.width/mapSize.width;
}

+ (float)getMapMaxZoomScaleWithMapSize:(CGSize)mapSize
{
    CGSize maxSize = [self getGoogleMapScrollBaseViewSizeWithZoomLevel:[TXYGoogleService mapConfig].maxZoomLevel];
    return maxSize.width/mapSize.width;
}


@end
