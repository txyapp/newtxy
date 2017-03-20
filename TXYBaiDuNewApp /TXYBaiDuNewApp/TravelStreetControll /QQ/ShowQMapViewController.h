//
//  ShowQMapViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
#import "QMapKit.h"
@interface ShowQMapViewController : UIViewController<PassDelegate>
@property(nonatomic,copy)NSString *bundle;
@property(nonatomic)NSOperationQueue *queue;
@property(nonatomic,copy)NSString *isCycle;
//当前扫街扫到哪里了
@property(nonatomic)int CurrentIndex;
//当前的扫街方式 用于展示不同的效果图
@property(nonatomic,copy)NSString *typeShowLine;
//当前app名字
@property(nonatomic,copy)NSString *appName;
//扫街路线对应cell的index
@property(nonatomic)int index;
@property(nonatomic,weak)id<PassDelegate>delegate;
-(void)DelButtonClick;


//暂停
@property(nonatomic)int Stop;
//控制暂停界面开关的字段

@property(nonatomic)int ztOnShowLine;
@end
