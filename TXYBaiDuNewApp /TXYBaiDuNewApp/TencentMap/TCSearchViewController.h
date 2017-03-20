//
//  TCSearchViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "PassDelegate.h"
@interface TCSearchViewController : UIViewController{
    
}
//搜索基类
@property (nonatomic,strong)QMSSearcher *searcher;
//搜索类
@property (nonatomic,strong)QMSPoiSearchOption *poiSearchOption;
//衍生词
@property (nonatomic,strong)QMSSuggestionSearchOption* suggestionSearchOption;
//是否某个应用程序
@property (nonatomic)BOOL isAPP;
//应用程序bundleID
@property (nonatomic,copy)NSString* bundleID;

//是否是历史记录
@property (nonatomic)BOOL isHis;

//是否是衍生词
@property (nonatomic)BOOL isYan;
//记录搜索半径
@property(nonatomic)int radius;
//是否为周边搜索
@property(nonatomic)BOOL isZhou;

//记录传过来的关键字
@property (nonatomic,copy)NSString* keyWord1;

//记录传过来的城市
@property (nonatomic)NSString* chengshi;

//tableview
@property(nonatomic,strong)UITableView* tableView;

//数据源
@property (nonatomic,strong)NSMutableArray* dataArray;

//搜索按钮
@property (nonatomic,strong)UIButton* searchBtn;

//searchBar
@property (nonatomic,strong)UISearchBar* searchBar;

//是否是扫街切进来
@property (nonatomic,copy)NSString* isSaojie;

//是否语音搜索
@property (nonatomic)BOOL isYuYin;
@property(nonatomic,strong)id<PassDelegate>delegate;

//扫街第几个传过来的
@property (nonatomic)int index;
@end
