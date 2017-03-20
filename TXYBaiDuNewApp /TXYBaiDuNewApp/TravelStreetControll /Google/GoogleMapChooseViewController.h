//
//  GoogleMapChooseViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/9/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import "BaseViewController.h"
@interface GoogleMapChooseViewController : UIViewController
@property(nonatomic,strong)id<PassDelegate>delegate;

@property (nonatomic)NSInteger index;
//已经选定的点
@property(nonatomic,copy)NSMutableArray *currentPoints;
- (void)addClick:(UIButton*) button;
@end
