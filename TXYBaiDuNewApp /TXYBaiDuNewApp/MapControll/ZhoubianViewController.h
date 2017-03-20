//
//  ZhoubianViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"

@interface ZhoubianViewController : UIViewController<BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,PassDelegate>{
    BMKPoiSearch *_poiSearch;    //poi搜索
    //状态栏
    UIView *_stateView;
}

@property (nonatomic)BOOL isAPP;

@property (nonatomic,copy)NSString* bundleID;

//记录传过来的点
@property (nonatomic)CLLocationCoordinate2D coord;

//tableview
@property(nonatomic,strong)UITableView* tableView;

//数据源
@property (nonatomic,strong)NSMutableArray* dataArray;

//搜索按钮
@property (nonatomic,strong)UIButton* searchBtn;

//searchBar
@property (nonatomic,strong)UISearchBar* searchBar;

//附近云检索
@property (nonatomic,strong) BMKNearbySearchOption *nearBySearchOption;

//云检索基类
@property (nonatomic,strong)BMKBasePoiSearchOption *baseSearchOption;

//搜索信息类
@property (nonatomic,strong) BMKSuggestionSearchOption* option;

//搜索服务类
@property (nonatomic,strong)BMKSuggestionSearch* suggest;

//城市搜索类
@property (nonatomic,strong)BMKCitySearchOption* citySearch;

//扩展view
@property (nonatomic,strong)UIView* kuoView;

//scrollerview
@property (nonatomic,strong)UIScrollView* scView;

@end
