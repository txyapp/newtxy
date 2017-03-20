//
//  SearchResultViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PassDelegate.h"

@interface SearchResultViewController : UIViewController<PassDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate>{
    BMKPoiSearch *_poiSearch;    //poi搜索
}

@property (nonatomic)BOOL isAPP;

@property (nonatomic,copy)NSString* bundleID;

//是否为周边搜索
@property (nonatomic)BOOL isZhou;

//记录收藏的点
@property (nonatomic)CLLocationCoordinate2D coord;

//列表
@property (nonatomic,strong)UITableView* tableView;

//多少个结果lab
@property (nonatomic,strong)UILabel* jieguoLab;

//数据源
@property (nonatomic,strong)NSMutableArray* dataArray;

//模型
@property (nonatomic,strong)BMKPoiResult* poiResult;

//当前城市是否有结果
@property (nonatomic)BOOL isYes;
// 检索城市名
@property (nonatomic,copy)NSString* cityName;
// 检索关键字
@property (nonatomic,copy)NSString* keyWord;
//  当前页
@property (nonatomic)int currentPage;

//搜索半径
@property (nonatomic)int radius;

//排序方式
@property (nonatomic)int fangshi;

//搜索半径button
@property (nonatomic,strong)UIButton* zhouBtn;

//上一页
@property (nonatomic,strong)UIButton* upBtn;

//下一页
@property (nonatomic,strong)UIButton* downBtn;

//页数
@property (nonatomic,strong)UILabel* yeLab;

//页数的母视图
@property (nonatomic,strong)UIView* bview;

//排序button
@property(nonatomic,strong)UIButton* paiBtn;

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

//map界面的代理
@property (nonatomic,strong)id<PassDelegate>delegate;

//当前是第几页
@property (nonatomic)int yeshu;

//zhoubian界面的代理
@property(nonatomic,strong)id<PassDelegate>dele;

//是否是扫街切进来
@property (nonatomic,copy)NSString* isSaojie;

//扫街第几个传过来的
@property (nonatomic)int index;

//是否语音播放
@property (nonatomic)BOOL isYuyin;
@end
