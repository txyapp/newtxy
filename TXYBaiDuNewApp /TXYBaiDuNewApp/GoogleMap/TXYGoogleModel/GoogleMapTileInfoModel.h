//
//  GoogleMapTileInfoModel.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreLocation/CLLocation.h>

@interface GoogleMapTileInfoModel : NSObject

@property (nonatomic,assign) int                         xIndex;
@property (nonatomic,assign) int                         yIndex;
@property (nonatomic,assign) int                         zoomLevel;
@property (nonatomic,assign) CGPoint                     mapTileOrigin;
@property (nonatomic,assign) CGSize                      mapTileSize;

@property (nonatomic,strong) NSString                   *mapTileURLString;

@property (nonatomic,assign) CLLocationCoordinate2D      startCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D      endCoordinate;

@property (nonatomic,strong) NSString                   *imageIdentity;

- (void)resetMapTileImageURLString;
- (void)resetMapTileCoordinate;
- (void)resetMapImageIdentity;

@end
