//
//  TencentMapViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"

@interface TencentMapViewController : UIViewController<PassDelegate>{
    //右上角功能按钮
    UIButton* bem;
    //状态栏
    UIView *_stateView;
    //switch
    UISwitch *_switchView;
    
    //背景view
    UIView* _backView;
    
    //弹出view
    UIView* _tanView;
    
    //tarbar view
    UIView* _tarView;
    
    //路况
    UIButton* _btn1;
    //热了
    UIButton* _btn3;
    
    //是否处于弹出状态
    BOOL  _isTan;
    
    //定位当前位置按钮
    UIButton* _nowBtn;
    
    //记录当前位置坐标
    CLLocationCoordinate2D _coord;
    
    //记录选点的地理位置
    NSString* _weizhi;
    
    //记录当前的城市
    NSString* _chengshi;
    
    //记录选点的距离
    NSString* _juli;

    //地址
    UILabel *adress;
    //距离
    UILabel *juliLab;
    
    //是否已经添加收藏
    BOOL _isCollect;
    
    //卫星
    UIButton* weixingBtn;
    //2d
    UIButton* weixingBtn1;
    //3d
    UIButton* weixingBtn2;
    
    //向下button
    UIButton* down;
    
    //弹出view
    UIView *_downPushView;
    //弹出菜单计时器
    NSTimer *timer;
    //当前时间
    NSString* _time;
    //当前地址名字
    NSString* _name;
}
//是否是刚进来,如果是首次进入不弹出
@property (nonatomic)BOOL isGang;
//名字
@property (nonatomic,copy)NSString* mingzi;
//记录当前选点的坐标
@property (nonatomic) CLLocationCoordinate2D nowCoord;
//是否是收藏选点切过来
@property (nonatomic) BOOL isShou;

@property (nonatomic,strong)id<PassDelegate>delegate;

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

//是否是选择某个应用程序
@property (nonatomic)BOOL  isAPP;

//应用程序id
@property (nonatomic,copy)NSString* bundleID;

//是否是搜索进来的
@property (nonatomic)BOOL isSou;

//是否是定位状态
@property (nonatomic)BOOL isDing;

//是否在国外
@property (nonatomic)BOOL isOutChina;

@end
