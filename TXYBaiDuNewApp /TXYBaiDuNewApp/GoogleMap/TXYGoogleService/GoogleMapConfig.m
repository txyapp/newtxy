//
//  GoogleMapConfigs.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapConfig.h"

static float         kMapTileWidth = 160.0; //128
static float         kMapTileHeight = 160.0;

static int           kMapDefaultZoomLevel = 15;

static int           kMapMaxZoomLevel = 18;
static int           kMapMinZoomLevel = 3;

@implementation GoogleMapConfig

- (instancetype)init
{
    if (self = [super init]) {
        [self initDefaultConfig];
    }
    return self;
}

- (void)initDefaultConfig
{
    self.minZoomLevel = kMapMinZoomLevel;
    self.maxZoomLevel = kMapMaxZoomLevel;
    self.mapTileDefaultSize = CGSizeMake(kMapTileWidth, kMapTileHeight);
    
    self.mapTileScale = 1.0;
    self.currentZoomLevel = kMapDefaultZoomLevel;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.scrollMapViewFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

- (CGSize)getScaledMapTileSize
{
    return CGSizeMake(kMapTileWidth*self.mapTileScale, kMapTileHeight*self.mapTileScale);
}

@end
