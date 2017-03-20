//
//  TCSearchResultViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import <QMapSearchKit/QMapSearchKit.h>

@interface TCSearchResultViewController : UIViewController

@property (nonatomic)BOOL isAPP;

@property (nonatomic,copy)NSString* bundleID;

//是否为周边搜索
@property (nonatomic)BOOL isZhou;
//两点距离
@property (nonatomic)CLLocationDistance dis;
//搜索结果
@property (nonatomic)QMSPoiSearchResult* poiSearchResult;
//搜索基类
@property (nonatomic,strong)QMSSearcher *searcher;
//搜索类
@property (nonatomic,strong)QMSPoiSearchOption *poiSearchOption;
//列表
@property (nonatomic,strong)UITableView* tableView;

//多少个结果lab
@property (nonatomic,strong)UILabel* jieguoLab;

//数据源
@property (nonatomic,strong)NSMutableArray* dataArray;

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
