//
//  GoogleMapScrollView.m
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import "GoogleMapScrollView.h"
#import "GoogleMapViewUtil.h"
#import "TXYGoogleService.h"
#import "GoogleMapTileUtil.h"


@implementation GoogleMapScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initalScrollConfig];
        
    }
    return self;
}


- (void)initalScrollConfig
{
    self.minimumZoomScale = 0.25;
    self.maximumZoomScale = 6;
    self.bouncesZoom = NO;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.mapScrollViewDelegate = [[GoogleMapScrollViewDelegate alloc] initWithScrollView:self];
    self.delegate = self.mapScrollViewDelegate;
    
    self.mapConfig = [TXYGoogleService mapConfig];
    
    self.annotationArray = [[NSMutableArray alloc] init];
    self.travelAnnotations = [[NSMutableArray alloc] init];
    self.oldBaseMapViewArray = [[NSMutableArray alloc] init];
    self.oldMapLineViewArray = [[NSMutableArray alloc] init];
    self.isShowMapLine = NO;
    int curZoomLevel = self.mapConfig.currentZoomLevel;
    CGSize baseViewSize = [GoogleMapViewUtil getGoogleMapScrollBaseViewSizeWithZoomLevel:curZoomLevel];
    [self resetBaseMapViewWithFrame:CGRectMake(0, 0, baseViewSize.width, baseViewSize.height)];
    self.contentSize = CGSizeMake(baseViewSize.width, baseViewSize.height);
}



- (void)resetBaseMapViewWithFrame:(CGRect)baseViewFrame
{
    if (self.oldBaseMapViewArray.count == 2) {
        UIView *removeView = [self.oldBaseMapViewArray objectAtIndex:0];
        [self.oldBaseMapViewArray removeObjectAtIndex:0];
        [removeView removeFromSuperview];
        UIView *bgView = [self.oldBaseMapViewArray lastObject];
        bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    }
    
    
    if (self.mapLineView) {
        [self.mapLineView removeFromSuperview];
    }
    
    
    self.baseMapView = [[UIView alloc] initWithFrame:baseViewFrame];
    //    self.mapLineView = [[GoogleMapLineView alloc] initWithFrame:baseViewFrame];
    [self.oldBaseMapViewArray addObject:self.baseMapView];
    [self addSubview:self.baseMapView];
    
    if (self.mapShowType == MapTileShowTypeZoom) {
        if (self.isShowMapLine) {
            [self showMapLineWithModel:self.mapLineModel];
        }
    }else{
        if (self.isShowMapLine) {
            [self addSubview:self.mapLineView];
        }
    }
    
    
}

- (void)resetMapScrollViewMinScale:(float)min andMaxScale:(float)max
{
    self.minimumZoomScale = min;
    self.maximumZoomScale = max;
}

- (void)addMapTileImageView:(GoogleMapTileImageView *)mapTileImageView
{
    mapTileImageView.mapTapDelegate = self;
    [self.baseMapView addSubview:mapTileImageView];
}

- (void)loadVisiableRectMap
{
    CGRect visiableRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    [self resetBaseMapViewWithFrame:self.baseMapView.frame];
    
    [[TXYGoogleService mapManager] loadMapTilesImageInRect:visiableRect atZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel];
    [self reloadAnnotations];
    
}

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    self.mapShowType = MapTileShowTypeScroll;
    CGPoint centerPoint = [GoogleMapTileUtil getMapViewPointWithCoordinate:coordinate andZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel withMapTileSize:[[TXYGoogleService mapConfig] getScaledMapTileSize]];
    CGRect visibleRect = CGRectMake(centerPoint.x - self.frame.size.width/2, centerPoint.y - self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
//    [self scrollRectToVisible:visibleRect animated:NO];
    [self setContentOffset:visibleRect.origin animated:animated];
    if (animated == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadVisiableRectMap];
        });
    }else{
        [self loadVisiableRectMap];
    }
}

- (void)removeMapAnnotation:(GoogleAnnotation *)annotation
{
    [annotation.annotationView removeFromSuperview];
//    [self removeMapAnnotationView:annotation];
//    [self.annotationArray removeObject:annotation];
}

- (void)removeMapAnnotationView:(GoogleAnnotation *)annotation
{
    [annotation.annotationView removeFromSuperview];
}

- (void)addMapAnnotation:(GoogleAnnotation *)annotation
{
/*    if (![self.annotationArray containsObject:annotation]) {
        [self.annotationArray addObject:annotation];
    }*/
    self.annotation = annotation;
    [self.baseMapView addSubview:annotation.annotationView];
//    [self addMapAnnotationView:annotation];
}

- (void)addMapTravelAnnotation:(GoogleTravelAnnotation *)annotation
{
    [self.travelAnnotations addObject:annotation];
    [self.baseMapView addSubview:annotation.annotationView];
}

- (void)addMapAnnotationView:(GoogleAnnotation *)annotation
{
    [self.baseMapView addSubview:annotation.annotationView];
}

- (void)removeCurrentAnnotationView
{
    [self.currentAnnotationView removeFromSuperview];
}

- (void)addCurrentAnnotationAtCoordinate:(CLLocationCoordinate2D)curCoordinate
{
    if (self.currentAnnotationView == nil) {
        self.currentAnnotationView = [[GoogleCurrentLocationAnnotationView alloc] init];
    }
    self.currentAnnotationView.coordinate = curCoordinate;
    [self.baseMapView addSubview:self.currentAnnotationView];
}

- (void)removeAllAnnotations
{
    if (self.annotation) {
        [self removeMapAnnotation:self.annotation];
        self.annotation = nil;
    }
    if (self.currentAnnotationView) {
        [self removeCurrentAnnotationView];
        self.currentAnnotationView = nil;
    }
    for (GoogleAnnotation *annotation in self.annotationArray) {
        [self removeMapAnnotationView:annotation];
    }
    [self.annotationArray removeAllObjects];
}

- (void)removeAllTravelAnnotations
{
    for (GoogleTravelAnnotation *annotation in self.travelAnnotations) {
        [self removeMapAnnotationView:annotation];
    }
    [self.travelAnnotations removeAllObjects];
}

- (void)reloadAnnotations
{
    if (self.currentAnnotationView) {
        [self removeCurrentAnnotationView];
        [self addCurrentAnnotationAtCoordinate:self.currentAnnotationView.coordinate];
    }
    if (self.annotation) {
        [self removeMapAnnotation:self.annotation];
        self.annotation.coordinate = self.annotation.coordinate;
        [self addMapAnnotation:self.annotation];
    }
    
    if (self.travelAnnotations) {
        for (GoogleTravelAnnotation *annotation in self.travelAnnotations) {
            [self removeMapAnnotationView:annotation];
            annotation.coordinate = annotation.coordinate;
            [self addMapAnnotationView:annotation];
        }
    }
}

- (void)showMapLineWithModel:(GoogleMapLineModel *)model
{
    if (self.mapLineView) {
        [self.mapLineView stopDraw];
        [self.oldMapLineViewArray addObject:self.mapLineView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @try {
                if ([self.oldMapLineViewArray objectAtIndex:0]) {
                    [self.oldMapLineViewArray removeObjectAtIndex:0];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception : %@",exception);
            }
            @finally {
            }
            
        });
    }
    self.mapLineView = [[GoogleMapLineView alloc] initWithFrame:self.baseMapView.frame];
    self.isShowMapLine = YES;
    self.mapLineModel = model;
    [self.mapLineView addMapLine:model];
    [self addSubview:self.mapLineView];
    

    
    
}

- (void)dismissMapLine
{
    self.isShowMapLine = NO;
    [self.mapLineView removeFromSuperview];
    self.mapLineView = nil;
}



#pragma mark - delegate
- (void)didMapTileImageViewTapLocationCoordinate:(CLLocationCoordinate2D)tapCoordinate
{
    if (self.mapViewDelegate != nil) {
        if ([self.mapViewDelegate respondsToSelector:@selector(googleMapScrollView:didTapLocationCoordinate:)]) {
            [self.mapViewDelegate googleMapScrollView:self didTapLocationCoordinate:tapCoordinate];
        }
    }
}


@end
