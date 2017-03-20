//
//  ChooseTypeViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import <MapKit/MapKit.h>

@interface ChooseTypeViewController : UIViewController<PassDelegate>
//app
@property(nonatomic,copy)NSString *boundle;
//红绿灯时间
@property(nonatomic)int redWaitSeconds;
//是否循环
@property(nonatomic)int isCycle;
//出行方式
@property(nonatomic)int tripType;
//路线类型
@property(nonatomic)int linesType;
//扫街频率
@property(nonatomic)double rate;
@property(nonatomic,weak)id<PassDelegate>delegate;
//是否在节点提醒
@property(nonatomic)int isAlertOn;
//扫街后是否保持终点不变
@property(nonatomic)int isState;
@end
