//
//  GoogleMapScrollView.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <UIKit/UIKit.h>
#import "GoogleMapTileImageView.h"
#import "GoogleMapConfig.h"
#import "GoogleMapScrollViewDelegate.h"
#import "GoogleAnnotation.h"
#import "GoogleCurrentLocationAnnotationView.h"
#import "GoogleMapLineView.h"
#import "GoogleTravelAnnotation.h"

@class GoogleMapScrollView;
@protocol GoogleMapViewDelegate <NSObject>

- (void)googleMapScrollView:(GoogleMapScrollView *)mapScrollView didTapLocationCoordinate:(CLLocationCoordinate2D)tapCoordinate;

@end

@interface GoogleMapScrollView : UIScrollView<GoogleMapTileTapDelegate>

//注意不用时设为nil
@property (nonatomic,weak)  id<GoogleMapViewDelegate>                mapViewDelegate;


@property (nonatomic,strong) GoogleMapScrollViewDelegate            *mapScrollViewDelegate;
@property (nonatomic,strong) UIView                                 *baseMapView;


//用于储存展示过的baseview，缓存用
@property (nonatomic,strong) NSMutableArray                         *oldBaseMapViewArray;
@property (nonatomic,weak) GoogleMapConfig                          *mapConfig;


@property (nonatomic,weak) GoogleAnnotation                         *annotation;
@property (nonatomic,strong) NSMutableArray                         *annotationArray;
@property (nonatomic,strong) GoogleCurrentLocationAnnotationView    *currentAnnotationView;

@property (nonatomic,strong) GoogleMapLineView                      *mapLineView;
@property (nonatomic,weak) GoogleMapLineModel                       *mapLineModel;
@property (nonatomic,strong) NSMutableArray                         *oldMapLineViewArray;   //为了让画的线安全移除掉

@property (nonatomic,assign) BOOL                                    isShowMapLine;

@property (nonatomic,strong) NSMutableArray                         *travelAnnotations;
@property (nonatomic,assign) MapTileShowType                         mapShowType;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)initalScrollConfig;
- (void)resetBaseMapViewWithFrame:(CGRect)baseViewFrame;
- (void)resetMapScrollViewMinScale:(float)min andMaxScale:(float)max;

- (void)addMapTileImageView:(GoogleMapTileImageView *)mapTileImageView;

- (void)loadVisiableRectMap;

- (void)showMapLineWithModel:(GoogleMapLineModel *)model;
- (void)dismissMapLine;

- (void)reloadAnnotations;

//用户可以调用
- (void)setMapCenter:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;
- (void)removeMapAnnotation:(GoogleAnnotation *)annotation;
- (void)addMapAnnotation:(GoogleAnnotation *)annotation;

- (void)addMapTravelAnnotation:(GoogleTravelAnnotation *)annotation;

- (void)removeCurrentAnnotationView;
- (void)addCurrentAnnotationAtCoordinate:(CLLocationCoordinate2D)curCoordinate;

- (void)removeAllAnnotations;
- (void)removeAllTravelAnnotations;


@end
