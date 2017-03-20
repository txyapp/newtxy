//
//  ViewController.h
//  TXYGoogleTest
//
//  Created by aa on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleMapViewController : UIViewController{
    //switch
    UISwitch *_switchView;
    //右上角功能按钮
    UIButton* bem;
    //定位当前位置按钮
    UIButton* _nowBtn;
    //状态栏
    UIView *_stateView;
    //当前时间
    NSString* _time;
    //当前地址名字
    NSString* _name;
    //弹出view
    UIView *_downPushView;
    //弹出菜单计时器
    NSTimer *timer;
    //向下button
    UIButton* down;
    //是否处于弹出状态
    BOOL  _isTan;
    //记录选点的距离
    NSString* _juli;
    
    //地址
    UILabel *adress;
    //距离
    UILabel *juliLab;
    
}
@property (nonatomic)NSNumber* longitude;
@property (nonatomic)NSNumber* latitude;
@property (nonatomic) BOOL isAPP;
//是否是刚进来,如果是首次进入不弹出
@property (nonatomic)BOOL isGang;
//应用程序id
@property (nonatomic,copy)NSString* bundleID;
//搜周边
@property (nonatomic,strong)UIButton* button1;

//添加收藏
@property (nonatomic,strong)UIButton* button2;

//看全景
@property (nonatomic,strong)UIButton* button3;

//分享
@property (nonatomic,strong)UIButton* button4;
//语音搜索背景界面
@property (nonatomic,strong)UIView* yuyinBack;

//语音结果界面
@property (nonatomic,strong)UILabel* yuyinJieGuoLab;

//播放语音动画
@property (nonatomic ,strong)UIImageView* bofangView;
@property (nonatomic,strong)UIImageView* bofangView1;
@property (nonatomic,strong)UIImageView* bofangView2;
@property (nonatomic,strong)UIImageView* bofangView3;
@property (nonatomic,strong)NSTimer* timer;

//是否语音搜索
@property (nonatomic)BOOL isYuyin;
@end

