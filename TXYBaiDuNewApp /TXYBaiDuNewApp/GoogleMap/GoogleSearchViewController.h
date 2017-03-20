//
//  GoogleSearchViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/12.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"

@interface GoogleSearchViewController : UIViewController

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

//是否语音搜索
@property (nonatomic)BOOL isYuYin;
@property(nonatomic,strong)id<PassDelegate>delegate;

//是否某个应用程序
@property (nonatomic)BOOL isAPP;
//应用程序bundleID
@property (nonatomic,copy)NSString* bundleID;

//是否是历史记录
@property (nonatomic)BOOL isHis;

//是否是扫街切进来
@property (nonatomic,copy)NSString* isSaojie;

//扫街第几个传过来的
@property (nonatomic)int index;
@end
