//
//  QmapChooseViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import "BaseViewController.h"
#import "QMapKit.h"
#import <QMapSearchKit/QMapSearchKit.h>
@interface QmapChooseViewController : UIViewController<QMapViewDelegate,QMSSearchDelegate>

@property(nonatomic,strong)id<PassDelegate>delegate;

@property (nonatomic)NSInteger index;
//已经选定的点
@property(nonatomic,copy)NSMutableArray *currentPoints;
- (void)addClick:(UIButton*) button;
@end
