//
//  GoogleMapTileUtil.m
//  Pods
//
//  Created by aa on 16/7/27.
//220.167
//82,568,112  82,568,336


#import "GoogleMapTileUtil.h"
#import "GoogleMapTileInfoModel.h"
#import "TXYMapTileConvert.h"
#include <math.h>

@implementation GoogleMapTileUtil

+ (int)getXMaxIndexAtZoomLevel:(int)zoomLevel
{
    return pow(2, zoomLevel);
}

+ (int)getYMaxIndexAtZoomLevel:(int)zoomLevel
{
    return pow(2, zoomLevel);
}

+ (NSArray *)getXIndexesInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize
{
    CGFloat mapTileWidth = mapTileSize.width;
    NSMutableArray *xIndexes = [[NSMutableArray alloc] init];
    int startXIndex = displayRect.origin.x/mapTileWidth - 1;
    int endXIndex = (displayRect.origin.x+displayRect.size.width)/mapTileWidth + 2;
    for (int i = startXIndex; i < endXIndex; i++) {
        if (i < 0 || i >= [self getXMaxIndexAtZoomLevel:zoomLevel]) {
            continue;
        }
        NSNumber *xIndexNumber = [NSNumber numberWithInt:i];
        [xIndexes addObject:xIndexNumber];
    }
    return xIndexes;
}
+ (NSArray *)getYIndexesInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize
{
    CGFloat mapTileHeight = mapTileSize.height;
    NSMutableArray *yIndexes = [[NSMutableArray alloc] init];
    int startYIndex = displayRect.origin.y/mapTileHeight - 1;
    int endYIndex = (displayRect.origin.y+displayRect.size.height)/mapTileHeight + 2;
    for (int i = startYIndex; i < endYIndex; i++) {
        if (i < 0 || i >= [self getYMaxIndexAtZoomLevel:zoomLevel]) {
            continue;
        }
        NSNumber *yIndexNumber = [NSNumber numberWithInt:i];
        [yIndexes addObject:yIndexNumber];
    }
    return yIndexes;
}

+ (NSArray *)getLoadMapTilesInfoInRect:(CGRect)displayRect atZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize
{
    NSArray *xIndexes = [self getXIndexesInRect:displayRect atZoomLevel:zoomLevel withMapTileSize:mapTileSize];
    NSArray *yIndexes = [self getYIndexesInRect:displayRect atZoomLevel:zoomLevel withMapTileSize:mapTileSize];
    NSUInteger loadMapTileTotalCount = xIndexes.count*yIndexes.count;
    NSMutableArray *loadMapTilesInfos = [[NSMutableArray alloc] initWithCapacity:loadMapTileTotalCount];
    
    
/*    CGPoint first1Origin = [self getMapTileOriginAtXIndex:[xIndexes[0] intValue] andYIndex:[yIndexes[0] intValue] withMapTileSize:mapTileSize];
    CGPoint nextOrigin = [self getMapTileOriginAtXIndex:[xIndexes[0] intValue]+1 andYIndex:[yIndexes[0] intValue]+1 withMapTileSize:mapTileSize];
    CGSize fixedMapTileSize = CGSizeMake(nextOrigin.x - first1Origin.x, nextOrigin.x - first1Origin.x);
    NSLog(@"width %f",fixedMapTileSize.width);*/
    CGPoint firstOrigin;
    int firstXIndex = 0,firstYIndex = 0;
    for (int i = 0; i < yIndexes.count; i++) {
        for (int j = 0; j < xIndexes.count; j++) {
            GoogleMapTileInfoModel *model = [[GoogleMapTileInfoModel alloc] init];
            model.xIndex = [[xIndexes objectAtIndex:j] intValue];
            model.yIndex = [[yIndexes objectAtIndex:i] intValue];
            model.zoomLevel = zoomLevel;
            model.mapTileOrigin = [self getMapTileOriginAtXIndex:model.xIndex andYIndex:model.yIndex withMapTileSize:mapTileSize];
            if (i == 0 && j ==0) {
                firstOrigin = model.mapTileOrigin;
                firstXIndex = model.xIndex;
                firstYIndex = model.yIndex;
            }else{
                float delX = mapTileSize.width * (float)(model.xIndex - firstXIndex);
                float delY = mapTileSize.height * (float)(model.yIndex - firstYIndex);
                model.mapTileOrigin = CGPointMake(firstOrigin.x + delX, firstOrigin.y + delY);
            }
            float nextDelX = mapTileSize.width * (float)(model.xIndex+1 - firstXIndex);
            float nextDelY = mapTileSize.height * (float)(model.yIndex+1 - firstYIndex);
            CGPoint nextTileOrigin = CGPointMake(firstOrigin.x + nextDelX, firstOrigin.y + nextDelY);
            model.mapTileSize = CGSizeMake(nextTileOrigin.x - model.mapTileOrigin.x, nextTileOrigin.y - model.mapTileOrigin.y);
            [model resetMapTileImageURLString];
            [model resetMapTileCoordinate];
            [model resetMapImageIdentity];
            [loadMapTilesInfos addObject:model];
        }
    }
    return loadMapTilesInfos;
}

+ (CGPoint)getMapTileOriginAtXIndex:(int)xIndex andYIndex:(int)yIndex withMapTileSize:(CGSize)mapTileSize
{
    CGPoint origin = CGPointMake(((double)xIndex*mapTileSize.width), ((double)yIndex)*mapTileSize.height);
    return origin;
}

+ (CLLocationCoordinate2D)getLocationCoordinateWithMapTileInfo:(GoogleMapTileInfoModel *)infoModel andTapXPer:(float)xPer andTapYPer:(float)yPer
{
    double delLon = infoModel.endCoordinate.longitude - infoModel.startCoordinate.longitude;
    double delLat = infoModel.endCoordinate.latitude - infoModel.startCoordinate.latitude;
    double lon = infoModel.startCoordinate.longitude + delLon*xPer;
    double lat = infoModel.startCoordinate.latitude + delLat*yPer;
    CLLocationCoordinate2D tapCoor = CLLocationCoordinate2DMake(lat, lon);
    return tapCoor;
}

+ (CGPoint)getMapViewPointWithCoordinate:(CLLocationCoordinate2D)coordinate andZoomLevel:(int)zoomLevel withMapTileSize:(CGSize)mapTileSize
{
    int xIndex = [TXYMapTileConvert long2tilex:coordinate.longitude andZoomLevel:zoomLevel];
    int yIndex = [TXYMapTileConvert lat2tiley:coordinate.latitude andZoomLevel:zoomLevel];
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([TXYMapTileConvert tiley2lat:yIndex andZoomLevel:zoomLevel], [TXYMapTileConvert tilex2long:xIndex andZoomLevel:zoomLevel]);
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([TXYMapTileConvert tiley2lat:yIndex+1 andZoomLevel:zoomLevel], [TXYMapTileConvert tilex2long:xIndex+1 andZoomLevel:zoomLevel]);
    double delLon = endCoordinate.longitude - startCoordinate.longitude;
    double delLat = endCoordinate.latitude - startCoordinate.latitude;
    double offsetLon = coordinate.longitude - startCoordinate.longitude;
    double offsetLat = coordinate.latitude - startCoordinate.latitude;
    float xPer = offsetLon/delLon;
    float yPer = offsetLat/delLat;
    float delx = mapTileSize.width * xPer;
    float dely = mapTileSize.height * yPer;
    return CGPointMake(xIndex*mapTileSize.width + delx, yIndex*mapTileSize.height + dely);
}


@end
