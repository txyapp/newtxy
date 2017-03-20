//
//  GoogleMapScrollViewDelegate.m
//  TXYGoogleTest
//
//  Created by aa on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapScrollViewDelegate.h"
#import "GoogleMapScrollView.h"
#import "GoogleMapViewUtil.h"
#import "TXYGoogleService.h"



@interface GoogleMapScrollViewDelegate ()

@property (nonatomic,weak) GoogleMapScrollView      *mapScrollView;

@property (nonatomic,assign) MapTileShowType         mapTileShowType;

@end

@implementation GoogleMapScrollViewDelegate

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.mapScrollView = (GoogleMapScrollView *)scrollView;
    }
    return self;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    scrollView.scrollEnabled = NO;
    self.mapTileShowType = MapTileShowTypeZoom;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    scrollView.scrollEnabled = YES;
    int zoomLevel = [GoogleMapViewUtil getZoomLevelWithSize:view.frame.size];
    [TXYGoogleService mapConfig].currentZoomLevel = zoomLevel;
    float mapScaled = [GoogleMapViewUtil getMapScaledWithMapSize:view.frame.size atZoomLevel:zoomLevel];
    [TXYGoogleService mapConfig].mapTileScale = mapScaled;
    self.mapScrollView.minimumZoomScale = [GoogleMapViewUtil getMapMinZoomScaleWithMapSize:view.frame.size];
    self.mapScrollView.maximumZoomScale = [GoogleMapViewUtil getMapMaxZoomScaleWithMapSize:view.frame.size];
    if (self.mapTileShowType == MapTileShowTypeZoom) {
        [self loadVisiableRectMap];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    GoogleMapScrollView *mapScrollView = (GoogleMapScrollView *)scrollView;
    return mapScrollView.baseMapView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.mapTileShowType = MapTileShowTypeScroll;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        //交给滑动停止后的函数处理
        self.mapTileShowType = MapTileShowTypeDecelerate;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.mapTileShowType == MapTileShowTypeScroll) {
                [self loadVisiableRectMap];
            }
        });
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.mapTileShowType == MapTileShowTypeDecelerate) {
        [self loadVisiableRectMap];
    }
}

- (void)loadVisiableRectMap
{
    self.mapScrollView.mapShowType = self.mapTileShowType;
    [self.mapScrollView loadVisiableRectMap];
}

- (BOOL)isNeedZoom:(int)zoomLevel
{
    if ([TXYGoogleService mapConfig].currentZoomLevel == zoomLevel) {
        return NO;
    }else{
        return YES;
    }
}

@end
