//
//  SaojieMapViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/24.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import "BaseViewController.h"

@interface SaojieMapViewController :UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>

//地图
@property BMKMapView* mapView;

@property(nonatomic,strong)id<PassDelegate>delegate;

@property (nonatomic)NSInteger index;
//已经选定的点
@property(nonatomic,copy)NSMutableArray *currentPoints;
- (void)addClick:(UIButton*) button;
@end
