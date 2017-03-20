//
//  HuiFuViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/7.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
@interface HuiFuViewController : UIViewController<PassDelegate>
@property(nonatomic)UITableView *AppTable;
@property(nonatomic,strong)id<PassDelegate>delegate;
@end
