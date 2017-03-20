//
//  FakePhoneViewController.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/11/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FakeButton.h"
#import "PassDelegate.h"
@interface FakePhoneViewController : UIViewController
@property(strong,nonatomic)UIView* mengcengView;
//改机前数据
@property (strong,nonatomic)UILabel* aduuidLab;
@property (strong,nonatomic)UILabel* uuidLab;
@property (strong,nonatomic)UILabel* wifimacLab;
@property (strong,nonatomic)UILabel* wifinameLab;
@property (strong,nonatomic)UILabel* devNameLab;
@property (strong,nonatomic)UILabel* devTypeLab;
@property (strong,nonatomic)UILabel* devVerLab;
@property (strong,nonatomic)UILabel* netStateLab;
@property (strong,nonatomic)UILabel* seralLab;
@property (strong,nonatomic)UILabel* sysInfoIsRandomLab;
//改机后数据
@property (strong,nonatomic)UILabel* aduuidLab2;
@property (strong,nonatomic)UILabel* uuidLab2;
@property (strong,nonatomic)UILabel* wifimacLab2;
@property (strong,nonatomic)UILabel* wifinameLab2;
@property (strong,nonatomic)UILabel* devNameLab2;
@property (strong,nonatomic)UILabel* devTypeLab2;
@property (strong,nonatomic)UILabel* devVerLab2;
@property (strong,nonatomic)UILabel* netStateLab2;
@property (strong,nonatomic)UILabel* seralLab2;
@property (strong,nonatomic)UILabel* sysInfoIsRandomLab2;

//新的页面
@property (strong,nonatomic)UIView* topView;
@property (strong,nonatomic)UIView* downView;

@property (strong,nonatomic)UIBarButtonItem* shezhiBtn1;
@property (strong,nonatomic)UIView* youhuaView1;
@property (strong,nonatomic)UIView* neirongView1;
@property (strong,nonatomic)UIView* youhuaView;
@property (strong,nonatomic)UIView* neirongView;
@property (strong,nonatomic)UILabel* geshuLab;
@property (strong,nonatomic)UILabel* tishiLab;
@property (strong,nonatomic)UILabel* tishiLab2;
@property (strong,nonatomic)UIView* dayuanView;
@property (strong,nonatomic)UIButton* jiantou;
@property (strong,nonatomic)FakeButton* shezhiBtn;
@property (strong,nonatomic)FakeButton* addBtn;
@property (strong,nonatomic)FakeButton* huifuBtn;
@property (strong,nonatomic)FakeButton* guanyuBtn;
@property (strong,nonatomic)UIView* gaijishujuView,*zhanshishujuView;
@end
