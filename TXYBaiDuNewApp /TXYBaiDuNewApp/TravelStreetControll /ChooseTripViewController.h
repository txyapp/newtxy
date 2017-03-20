//
//  ChooseTripViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PassDelegate.h"
@interface ChooseTripViewController : UIViewController<PassDelegate>

@property(nonatomic,strong)id<PassDelegate>delegate;
//出行方式
@property (nonatomic)NSInteger index;

//存储点的数组
@property(nonatomic,copy)NSMutableArray *pointArr;
@property(nonatomic,copy)NSMutableArray *linesArr;
//此应用的bunldid
@property(nonatomic,copy)NSString *boundle;
//是否循环显示
@property(nonatomic)int isCicycle;
//红绿灯停留时间
@property(nonatomic)int redWaiteSeconds;
@end
