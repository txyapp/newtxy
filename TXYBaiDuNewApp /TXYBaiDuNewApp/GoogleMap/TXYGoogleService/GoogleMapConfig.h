//
//  GoogleMapConfigs.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

@interface GoogleMapConfig : NSObject

@property (nonatomic,assign) int             minZoomLevel;
@property (nonatomic,assign) int             maxZoomLevel;
@property (nonatomic,assign) int             currentZoomLevel;

@property (nonatomic,assign) CGSize          mapTileDefaultSize;
@property (nonatomic,assign) float           mapTileScale;

@property (nonatomic,assign) CGRect          scrollMapViewFrame;

- (void)initDefaultConfig;
- (CGSize)getScaledMapTileSize;

@end
