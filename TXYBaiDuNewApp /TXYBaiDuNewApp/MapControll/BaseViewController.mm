//
//  BaseViewController.m
//  TXYBaiDuNewApp
//
//  Created by yl on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBMKMapView];
    
    [self creatBMKPoiSearch];
    
   
    
    
    _mapView.showMapScaleBar=YES;
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake([UIScreen mainScreen].bounds.size.width/5 , [UIScreen mainScreen].bounds.size.height/1.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BMKMapView *)creatBMKMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;//显示定位图层
    
    return _mapView ;
}
- (BMKPoiSearch *)creatBMKPoiSearch
{
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    //return annotation;
    _search =[[BMKPoiSearch alloc]init];
    _search.delegate = self;
    
    return _search ;
    
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        // 设置可拖拽
        newAnnotationView.draggable = YES;
        // 设置位置
        newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
        newAnnotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        newAnnotationView.canShowCallout = YES;
        return newAnnotationView;
    }
    return nil;
}
#pragma mark --BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    for (BMKPoiInfo *info in poiResult.poiInfoList) {
        NSLog(@"%@ %@",info.name,info.address);
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        
        annotation.coordinate = info.pt;
        annotation.title = info.name;
        
        [_mapView addAnnotation:annotation];
        
    }
    
}
#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    //点击大头针的输出
    NSLog(@"%s",__FUNCTION__);
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"%s",__FUNCTION__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
