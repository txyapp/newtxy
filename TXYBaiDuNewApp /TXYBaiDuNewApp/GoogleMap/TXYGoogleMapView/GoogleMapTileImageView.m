//
//  GoogleMapTileImageView.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapTileImageView.h"
#import "GoogleMapTileUtil.h"

@implementation GoogleMapTileImageView

- (instancetype)initWithInfoModel:(GoogleMapTileInfoModel *)infoModel
{
    if (self = [super init]) {
        self.mapTileInfo = infoModel;
        self.frame = CGRectMake(infoModel.mapTileOrigin.x, infoModel.mapTileOrigin.y
                                , infoModel.mapTileSize.width, infoModel.mapTileSize.height);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    CGPoint tapPoint = [ges locationInView:self];
    float xPer = tapPoint.x / self.frame.size.width;
    float yPer = tapPoint.y /self.frame.size.height;
    CLLocationCoordinate2D tapCoordinate = [GoogleMapTileUtil getLocationCoordinateWithMapTileInfo:self.mapTileInfo andTapXPer:xPer andTapYPer:yPer];
    [self.mapTapDelegate didMapTileImageViewTapLocationCoordinate:tapCoordinate];
}

@end
