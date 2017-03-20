//
//  TotleScanViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
@interface TotleScanViewController : UIViewController<PassDelegate>
@property(nonatomic,copy)NSString *boundle;
@property(nonatomic,weak)id<PassDelegate>delegate;
-(void)backTravelStreet;

//地图修改配置
-(void)backTravelStreetWith:(NSString *)bundle;
//区别是是不是地图修改配置跳转过去的
@property(nonatomic)int isShowLine;
@end
