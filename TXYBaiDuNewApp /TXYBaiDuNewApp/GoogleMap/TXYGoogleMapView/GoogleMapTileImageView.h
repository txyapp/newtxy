//
//  GoogleMapTileImageView.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <UIKit/UIKit.h>
#import "GoogleMapTileInfoModel.h"

@protocol GoogleMapTileTapDelegate <NSObject>

- (void)didMapTileImageViewTapLocationCoordinate:(CLLocationCoordinate2D)tapCoordinate;

@end

@interface GoogleMapTileImageView : UIImageView

@property (nonatomic,weak) id<GoogleMapTileTapDelegate>          mapTapDelegate;
@property (nonatomic,strong) GoogleMapTileInfoModel             *mapTileInfo;

- (instancetype)initWithInfoModel:(GoogleMapTileInfoModel *)infoModel;

@end
