//
//  ScanNewViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/1/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import <MapKit/MapKit.h>
#import "FireToGps.h"
@interface ScanNewViewController : UIViewController<PassDelegate>
//app
@property(nonatomic,copy)NSString *boundle;
//红绿灯时间
@property(nonatomic)int redWaitSeconds;
//扫街频率
@property(nonatomic)float rate;
//是否循环
@property(nonatomic)int isCycle;
//出行方式
@property(nonatomic)int tripType;
//路线类型
@property(nonatomic)int linesType;
//扫街后是否停留
@property(nonatomic)int isState;
@property(nonatomic,weak)id<PassDelegate>delegate;
-(void)sure;
-(void)chuanzhi:(XuandianModel *)model;
//区别是是不是地图修改配置跳转过去的
@property(nonatomic)int isShowLine;
@end
