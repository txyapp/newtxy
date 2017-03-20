//
//  TotleMapViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
@interface TotleMapViewController : UIViewController
@property(nonatomic,strong)id<PassDelegate>delegate;
@property (nonatomic)NSInteger index;
//已经选定的点
@property(nonatomic,copy)NSMutableArray *currentPoints;
@end
