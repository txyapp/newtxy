//
//  GoogleMapTileInfoModel.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapTileInfoModel.h"
#import "TXYMapTileConvert.h"

#define MapTileUrl(x,y,z) [NSString stringWithFormat:@"http://mt2.google.cn/vt/lyrs=m&hl=zh-CN&gl=cn&scale=2&x=%d&y=%d&z=%d",x,y,z]

@implementation GoogleMapTileInfoModel

- (void)resetMapTileImageURLString
{
    self.mapTileURLString = MapTileUrl(self.xIndex, self.yIndex, self.zoomLevel);
}

- (void)resetMapTileCoordinate
{
    self.startCoordinate = CLLocationCoordinate2DMake([TXYMapTileConvert tiley2lat:self.yIndex andZoomLevel:self.zoomLevel], [TXYMapTileConvert tilex2long:self.xIndex andZoomLevel:self.zoomLevel]);
    self.endCoordinate = CLLocationCoordinate2DMake([TXYMapTileConvert tiley2lat:self.yIndex+1 andZoomLevel:self.zoomLevel], [TXYMapTileConvert tilex2long:self.xIndex+1 andZoomLevel:self.zoomLevel]);
}

- (void)resetMapImageIdentity
{
    self.imageIdentity = [NSString stringWithFormat:@"%d-%d-%d",self.xIndex,self.yIndex,self.zoomLevel];
}

@end
