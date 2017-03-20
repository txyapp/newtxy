//
//  SaojieLuxianViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/8.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "SaojieLuxianViewController.h"

@implementation SaojieLuxianViewController



- (void)viewDidLoad{
    
}



- (void)makeView{
    
    //实例化地图
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    //根据出行方式展示地图缩放比
    if (_index == 0) {
        
    }
    if (_index == 1) {
        
    }
    if (_index == 2) {
        
    }
    
    //定位按钮
    UIButton* dingweiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dingweiBtn setTitle:@"定位" forState:UIControlStateNormal];
    [dingweiBtn addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    
}

//定位按钮
- (void)dingwei{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
