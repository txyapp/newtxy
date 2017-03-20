//
//  CollectViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"

@interface CollectViewController : UIViewController
{
    UITableView *_table;
}
@property (nonatomic,strong)id<PassDelegate>delegate;
@property (nonatomic)NSInteger index;
//是否是首页切进来
@property(nonatomic,copy)NSString* isMap;

@property(nonatomic)BOOL isAPP;
@property(nonatomic,copy)NSString *bundleID;
@end
