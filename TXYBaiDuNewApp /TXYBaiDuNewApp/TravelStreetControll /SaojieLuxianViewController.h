//
//  SaojieLuxianViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/8.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XuandianModel.h"

@interface SaojieLuxianViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

//地图
@property BMKMapView* mapView;
//定位服务
@property (nonatomic,strong) BMKLocationService* bsc;
//出行方式
@property(nonatomic)NSInteger index;

//经纬度
@property(nonatomic,copy)XuandianModel *xuandian;


//点的数组
@property(nonatomic,copy)NSMutableArray *arr;
@end
