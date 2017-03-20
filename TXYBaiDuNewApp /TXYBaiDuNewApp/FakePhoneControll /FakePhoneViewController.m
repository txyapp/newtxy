//
//  FakePhoneViewController.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/11/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "FakePhoneViewController.h"
#import "FakeTableViewCell.h"
#import "FakeButton.h"
#import "CleanAppViewController.h"
#include <notify.h>
#import "AppManage.h"
#import "test.h"
#import <sys/sysctl.h>
#import <dlfcn.h>
#include <mach-o/dyld.h>
#include <notify.h>
#import <sqlite3.h>
#import "ipaManage.h"
#import "MBProgressHUD.h"
#import "Tools.h"
#import "DeviceAbout.h"
#import "KGStatusBar.h"
#import "ShezhiViewController.h"

#import "PopoverView.h"
#import "HuiFuViewController.h"
#import "GuanyuViewController.h"
#define PlistPath @"/var/mobile/Library/Preferences/txyfakephone.plist"
#define PlistPathDM @"/var/mobile/Library/Preferences/txyfakephonedm.plist"

#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define line [UIColor colorWithRed:226/255.0f green:226/255.0f blue:229/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface FakePhoneViewController ()<UITableViewDelegate,UITableViewDataSource,PassDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>{
    int isAPP;
    test * testView;
    //右侧滑动栏
    UIView* _appView;
    //滑动按钮
    UIButton* _huaBtn;
    //app tableView
    UITableView* _appTableView;
    FakeButton *btn2;
    UITableView* gaijiTabView,*mbTabView;
    UIView* xiaoView;
    NSArray *arr;
    int useArrCount;
    double r1 ;
    double g1 ;
    double b1 ;
    NSMutableArray *colors;
    CABasicAnimation* rotationAnimation,*rotationAnimation1;
    CAGradientLayer *gradientLayer,*gradientLayer1;
    UIView *mengceng;
    BOOL  isShang;
    
}
@property(nonatomic,strong)NSDictionary *allAppInfo;
@property(nonatomic,strong)NSArray *allAppArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *selectAppArray;
@property(nonatomic,strong)ipaManage *ipaMgr;
@property (strong, nonatomic)UISwitch *cleanApp;
@property (strong, nonatomic)UISwitch *cleanSafari;
@property (strong, nonatomic)UISwitch *cleanKeyChain;
@property (strong, nonatomic)UISwitch *cleanCopy;
@property (strong, nonatomic)UISwitch *set3G;
@property (strong, nonatomic)UISwitch *randomData;


@property (strong, nonatomic)UISegmentedControl *netStateSegment;
@property (strong, nonatomic)UISegmentedControl *devTypeSegment;
@property (strong, nonatomic)UISegmentedControl *devVerSegment;


@end

@implementation FakePhoneViewController

#pragma obfuscate on
-(NSMutableDictionary *)loadsetDict{
    NSMutableDictionary *dcit=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPath];
    if(dcit==nil){
        dcit=[NSMutableDictionary dictionary];
    }
    return dcit;
}
-(BOOL)wrSetDict:(NSDictionary *)dict{
    BOOL b=[dict writeToFile:PlistPath atomically:YES];
    return b;
}
//-(void)loadView
//{
//    
//}
- (void)viewWillAppear:(BOOL)animated{
    
    
    
    float high = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"high = %f",high);
    
    NSDictionary *dcit=[self loadsetDict];
    _selectAppArray = [[NSMutableArray alloc]init];
 //   NSLog(@"%@",dcit);
    _selectAppArray=[dcit objectForKey:@"selectApp"];
    if (_selectAppArray==nil) {
        _selectAppArray=[NSMutableArray array];
    }
    int i = (int)_selectAppArray.count;
    _geshuLab.text = [NSString stringWithFormat:@"%d",i];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(change) name:@"change" object:nil];
//    if (isShang) {
//        self.navigationController.navigationBar.alpha = 0;
//        
//        self.navigationController.navigationBar.userInteractionEnabled = NO;
//        self.view.frame = CGRectMake(0, 64, Width, Height);
//    }else{
//        self.navigationController.navigationBar.alpha = 1;
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        self.view.frame = CGRectMake(0, 0, Width, Height);
//    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString* isGai = [user objectForKey:@"isGai"];
  //  NSLog(@"isgai = %@",isGai);
    if (isGai) {
        _jiantou.enabled = YES;
        _tishiLab2.text = @"改机完成";
    }else{
        _jiantou.enabled = NO;
        _tishiLab2.text = @"点击开始改机";
    }
    NSString* isChu = [user objectForKey:@"isChu"];
    if (isChu) {
        
    }else{
        //清除对所有app的改机操作
        NSMutableDictionary* setDict1 = [[Tools sharedTools]getInfoDict];
        //  NSLog(@"setdict = %@",setDict1);
        [setDict1 removeObjectForKey:@"selectApp"];
        [self wrSetDict:setDict1];
        NSMutableDictionary* setDict = [[Tools sharedTools]getInfoDict];
        if (setDict) {
            NSMutableArray* array =[NSMutableArray arrayWithArray:[setDict allKeys]];
            BOOL isC = [array  containsObject:@"selectApp"];
            //   NSLog(@"%@",array);
            if (isC&&array.count > 0) {
                [array removeObject:@"selectApp"];
            }
            if (array.count > 0) {
                for (int i = 0; i<array.count;i++){
                    NSString* string = array[i];
                    [[Tools sharedTools]cancelChangeWithBundleId:string];
                }
                
                NSLog(@"撤销修改");
            }
        }
        
        //   NSLog(@"set = %@",setDict);
        //清除恢复内容
        NSString *str = GaijiPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        //清除app备份内容
        NSMutableArray* array = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Gaiji"]];
        if (array == nil) {
            array = [NSMutableArray array];
        }
        NSMutableArray* array2 = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Shezhi"]];
        if (array2 == nil) {
            array2 = [NSMutableArray array];
        }
        NSLog(@"gaiji = %@",array);
        NSLog(@"shezhi = %@",array2);
        //取出keyzhi和app备份的bundleID，不为no的是app备份
        //存放app数据备份的bundleID的数组
        NSMutableArray* bundleArr = [[NSMutableArray alloc]init];
        //存放keyzhi的数组
        NSMutableArray* keyArr = [[NSMutableArray alloc]init];
        if (array.count>0) {
            for (int i=0; i<array.count; i++) {
                NSString* keyzhi = [array2[i] objectForKey:@"keyzhi"];
                NSLog(@"array = %@",array);
                NSLog(@"array2 = %@",array2);
                NSLog(@"keyzhi = %@",keyzhi);
                if (![keyzhi isEqualToString:@"no"]) {
                    NSLog(@"bundleArr = %@",[[array[i] allValues][0] objectForKey:@"APP"]);
                    NSLog(@"array[i] = %@",array[i]);
                    NSLog(@"1");
                    [bundleArr addObject:[[array[i] allValues][0] objectForKey:@"APP"]];
                    [keyArr addObject:keyzhi];
                }
            }
            NSLog(@"bundleArr = %@",bundleArr);
            NSLog(@"keyArr = %@",keyArr);
            for (int i = 0; i < bundleArr.count; i++) {
                NSMutableArray* bunArr = [NSMutableArray arrayWithArray:bundleArr[i]];
                NSString* keyzhi1 = keyArr[i];
                for (int i = 0; i<bunArr.count; i++) {
                    [[Tools sharedTools]deleteForBackUpWithBundleId:bunArr[i] Key:keyzhi1];
                }
            }
        }
        
        [plistDict removeAllObjects];
        BOOL result=[plistDict writeToFile:GaijiPlist atomically:YES];
        if (result) {
            NSLog(@"存入成功");
        }else{
            NSLog(@"存入失败");
        }
        
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        [userPoint removeObjectForKey:@"isGai"];
        //     NSLog(@"isgai = %@",[userPoint objectForKey:@"isGai"]);
        NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
        //      NSLog(@"array = %@",dict);
        NSMutableDictionary* muDict = nil;
        if (dict == nil){
            muDict = [NSMutableDictionary dictionary];
        }else{
            muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        [muDict removeAllObjects];
        [userPoint setObject:muDict forKey:@"GaiJi"];
        isChu = @"isChu";
        [userPoint setObject:isChu forKey:@"isChu"];
        [userPoint synchronize];
        _jiantou.enabled = NO;
        _tishiLab2.text = @"点击开始改机";
        
 
    }
    
 //   NSLog(@"hei = %f",Height);
}

-(void)change{
//    if (isShang) {
//        self.navigationController.navigationBar.hidden = YES;
//        self.navigationController.navigationBar.alpha = 0;
//        self.navigationController.navigationBar.userInteractionEnabled = NO;
//        _topView.frame = CGRectMake(0, 24, Width, Height /5 *3);
//        [_gaijishujuView setFrame:CGRectMake(0,_youhuaView.frame.origin.y +_youhuaView.frame.size.height + 80, Width, Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height)];
//    }else{
//        self.navigationController.navigationBar.hidden = NO;
//        self.navigationController.navigationBar.alpha = 1;
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        _topView.frame = CGRectMake(0, 0, Width, Height /5 *3);
//    }
  //  NSLog(@"hei = %f",Height);
    if (isShang) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationController.navigationBar.alpha = 0;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        });
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"change" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"111");
}
- (void)fanhui{
    _dayuanView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidLoad {
   // self.navigationController.navigationBar.translucent = YES;
    isShang = NO;
    r1 = 140;
    b1 = 90;
    g1 = 89;
    [super viewDidLoad];
    self.selectAppArray = [[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    useArrCount = 0;
    //导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor=IWColor(60, 170, 249);
    //返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"改机";
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;

    //获取全部app
    self.ipaMgr=[[ipaManage alloc]init];
    _allAppInfo=[self.ipaMgr installedApps];
    _allAppArray=[self.allAppInfo allKeys];
    

   
    self.view.backgroundColor=Color;
    
    
    
    
    arr = [NSArray arrayWithObjects:@"清理app",@"清理剪切板",@"清理keyChain",@"清理Safari",@"修改设备类型",@"修改系统版本",@"uuid",@"aduuid",@"wifi地址",@"wifi名字",@"设备名字",@"修改网络类型",@"数据备份", nil];
//    CGFloat W=self.view.frame.size.width;
//    CGFloat H=self.view.frame.size.height;
//    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, W , H-44) style:UITableViewStylePlain];
//    if([[UIDevice currentDevice].systemVersion doubleValue]<7.0){
//        self.tableView.frame=CGRectMake(0, 0, W , H-44-49);
//    }
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
//    self.tableView.rowHeight=50;
//    self.tableView.tableHeaderView=[self headView];
//    self.tableView.tableFooterView=[[UIView alloc]init];
//    self.tableView.backgroundColor=[UIColor clearColor];
//    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//    [self.view addSubview:self.tableView];
//    
//    //针对整个设备
//    self.cleanSafari = [[UISwitch alloc] initWithFrame:CGRectZero];
//    self.cleanCopy = [[UISwitch alloc] initWithFrame:CGRectZero];
//    
//    //针对某个APP
//    self.cleanApp = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [self.cleanApp addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
//    self.cleanKeyChain = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [self.cleanKeyChain addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
//    self.set3G = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [self.set3G addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
//    self.randomData = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [self.randomData addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
//    self.devTypeSegment=[[UISegmentedControl alloc]initWithItems:@[@"iPhone",@"iPad",@"默认"]];
//    
//    self.devVerSegment=[[UISegmentedControl alloc]initWithItems:@[@"iOS7",@"iOS8",@"iOS9",@"默认"]];
//    
//    
//    self.mengcengView = [[UIView alloc]init];
//    self.mengcengView.frame = CGRectMake(0, 0, Width, Height);
//    self.mengcengView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mengceng)];
//    [self.mengcengView addGestureRecognizer:tap];
//    self.mengcengView.hidden = YES;
//    [self.view addSubview:self.mengcengView];
//    
//    UIView* view = [[UIView alloc]init];
//    view.backgroundColor  = [UIColor clearColor];
//    _appTableView = [[UITableView alloc]init];
//    _appTableView.delegate = self;
//    _appTableView.dataSource = self;
//    _appTableView.frame = CGRectMake(1,64 , Width/2 - 30, Height - 113);
//    _appTableView.tag = 3001;
//    _appTableView.backgroundView.backgroundColor = [UIColor blackColor];
//    [view addSubview:_appTableView];
//    testView = [[test alloc]initWithView:view parentView:self.view];
//    testView.drawState = 1;
//    testView.delegate = self;
//    [self.view addSubview:testView];
    [self makeView];
}

//初始化改机数据
- (void)chushihua{

}

//页面定制
- (void)makeView{
    self.view.backgroundColor = IWColor(60, 170, 249);
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, Width, Height /5 *3);
    _topView.backgroundColor = IWColor(60, 170, 249);
    [self.view addSubview:_topView];
    xiaoView = [[UIView alloc]init];
    xiaoView.frame = CGRectMake(0, -64, Width, 64);
    xiaoView.backgroundColor  = IWColor(60, 170, 249);
    xiaoView.hidden = YES;
    [_topView addSubview:xiaoView];
  
    //_shezhiBtn1= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_setting_press"] style:UIBarButtonItemStylePlain target:self action:@selector(chushihua)];
//    _shezhiBtn1 = [[UIBarButtonItem alloc]initWithTitle:@"初始化" style:UIBarButtonItemStylePlain target:self action:@selector(chushihua)];
//    self.navigationItem.rightBarButtonItem = _shezhiBtn1;
    
    //优化view
    
    _youhuaView1 = [[UIView alloc]init];
    _youhuaView1.frame = CGRectMake(Width/4 -10, Width/8 - 10, Width / 2+20, Width/2 +20);
    _youhuaView1.layer.masksToBounds = YES;
    _youhuaView1.layer.cornerRadius = (Width /2 +20)/ 2 ;
    _youhuaView1.backgroundColor = [UIColor whiteColor];
    _neirongView1 = [[UIView alloc]init];
    _neirongView1.frame = CGRectMake(Width/4 -8, Width/8 - 8, Width / 2+16, Width/2 +16);
    _neirongView1.layer.masksToBounds = YES;
    _neirongView1.layer.cornerRadius = (Width /2 +16)/ 2 ;
    _neirongView1.backgroundColor = IWColor(60, 170, 249);
    [_topView addSubview:_youhuaView1];
    [_topView addSubview:_neirongView1];
    _youhuaView = [[UIView alloc]init];
    _youhuaView.frame = CGRectMake(Width / 4, Width / 8, Width / 2, Width / 2);
    _youhuaView.layer.masksToBounds = YES;
    _youhuaView.layer.cornerRadius = Width / 4;
   [_topView addSubview:_youhuaView];
    
    
    
    //内容view
    _neirongView = [[UIView alloc]init];
    _neirongView.frame = CGRectMake(Width/4+2, Width /8 +2, Width/2-4, Width/2-4);
    _neirongView.layer.masksToBounds = YES;
    _neirongView.layer.cornerRadius = (Width-2) / 4;
    _neirongView.backgroundColor = IWColor(60, 170, 249);
    UITapGestureRecognizer* gaijiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xinji)];
    [_neirongView addGestureRecognizer:gaijiTap];
    [_topView addSubview:_neirongView];
    //app个数label
    _geshuLab = [[UILabel alloc]init];
    _geshuLab.frame = CGRectMake(_neirongView.frame.size.width /4, _neirongView.frame.size.width/4, _neirongView.frame.size.width/2, _neirongView.frame.size.width /2);
  //  _geshuLab.backgroundColor = [UIColor redColor];
    _geshuLab.textAlignment = NSTextAlignmentCenter;
    _geshuLab.textColor = [UIColor whiteColor];
    _geshuLab.font = [UIFont systemFontOfSize:_geshuLab.frame.size.width /7*6];
    [_neirongView addSubview:_geshuLab];
    //提示label
    _tishiLab = [[UILabel alloc]init];
    _tishiLab.text = @"已选APP";
    _tishiLab.textAlignment = NSTextAlignmentCenter;
    _tishiLab.textColor = [UIColor whiteColor];
    _tishiLab.frame = CGRectMake(_neirongView.frame.size.width / 4, _neirongView.frame.size.width /10, _neirongView.frame.size.width/2, _neirongView.frame.size.width/6);
    _tishiLab.font = [UIFont systemFontOfSize:_neirongView.frame.size.width / 12];
    [_neirongView addSubview:_tishiLab];
    
    _tishiLab2 = [[UILabel alloc]init];
    _tishiLab2.text = @"点击开始改机";
    _tishiLab2.textAlignment = NSTextAlignmentCenter;
    _tishiLab2.textColor = [UIColor whiteColor];
    _tishiLab2.frame = CGRectMake(_neirongView.frame.size.width / 4, _neirongView.frame.size.width/12*9, _neirongView.frame.size.width/2, _neirongView.frame.size.width/6);
    _tishiLab2.font = [UIFont systemFontOfSize:_neirongView.frame.size.width /14];
    [_neirongView addSubview:_tishiLab2];
    
    
    
    //大圆view
    _dayuanView = [[UIView alloc]init];
    _dayuanView.frame = CGRectMake(-Width/2, Height / 5*3 -50, Width *2, Width*2);
    _dayuanView.backgroundColor = [UIColor whiteColor];
    _dayuanView.layer.masksToBounds = YES;
    _dayuanView.layer.cornerRadius = Width;
    [self.view addSubview:_dayuanView];
    //箭头图
    _jiantou = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_jiantou setBackgroundImage:[UIImage imageNamed:@"uc_step_next@2x"] forState:UIControlStateNormal];
  //  _jiantou.transform=CGAffineTransformMakeRotation(M_PI/2);
    
    [_jiantou addTarget:self action:@selector(shanglai) forControlEvents:UIControlEventTouchUpInside];
    [_dayuanView addSubview:_jiantou];
    //设置btn
    _shezhiBtn=[FakeButton buttonWithType:UIButtonTypeSystem];
   // UIImage *img1=[UIImage imageNamed:@"gaoji"];
  //  [_shezhiBtn setImage:img1 forState:UIControlStateNormal];
    [_shezhiBtn setBackgroundImage:[UIImage imageNamed:@"shezhineirong"] forState:UIControlStateNormal];
    //[_shezhiBtn setTitle:@"设置" forState:UIControlStateNormal];
    [_shezhiBtn addTarget:self action:@selector(shezhi) forControlEvents:UIControlEventTouchUpInside];
    UILabel * shezhiLab = [[UILabel alloc]init];
    shezhiLab.text = @"设置";
    UITapGestureRecognizer* shezhiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shezhi)];
    shezhiTap.numberOfTapsRequired = 1;
    shezhiTap.numberOfTouchesRequired = 1;
    [shezhiLab addGestureRecognizer:shezhiTap];
    shezhiLab.font = [UIFont systemFontOfSize:13];
    shezhiLab.textColor = [UIColor grayColor];
    shezhiLab.textAlignment = NSTextAlignmentCenter;
    [_dayuanView addSubview:shezhiLab];
    [_dayuanView addSubview:_shezhiBtn];
    //恢复btn
    _huifuBtn=[FakeButton buttonWithType:UIButtonTypeSystem];
  //  UIImage *img2=[UIImage imageNamed:@"huifu"];
  //  [_huifuBtn setImage:img2 forState:UIControlStateNormal];
  //  [_huifuBtn setTitle:@"恢复" forState:UIControlStateNormal];
    [_huifuBtn addTarget:self action:@selector(huifu) forControlEvents:UIControlEventTouchUpInside];
    [_huifuBtn setBackgroundImage:[UIImage imageNamed:@"huifuneirong"] forState:UIControlStateNormal];
    
    UILabel * huifuLab = [[UILabel alloc]init];
    huifuLab.text = @"恢复";
    UITapGestureRecognizer* huifuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huifu)];
    [huifuLab addGestureRecognizer:huifuTap];
    huifuTap.numberOfTapsRequired = 1;
    huifuTap.numberOfTouchesRequired = 1;
    huifuLab.font = [UIFont systemFontOfSize:13];
    huifuLab.textColor = [UIColor grayColor];
    
    huifuLab.textAlignment = NSTextAlignmentCenter;
    [_dayuanView addSubview:huifuLab];
    [_dayuanView addSubview:_huifuBtn];
    //app选择btn
    _addBtn=[FakeButton buttonWithType:UIButtonTypeSystem];
  //  UIImage *img3=[UIImage imageNamed:@"xinji"];
 //   [_addBtn setImage:img3 forState:UIControlStateNormal];
   // [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"tianjianeirong"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addApp) forControlEvents:UIControlEventTouchUpInside];
    UILabel * xuanzeLab = [[UILabel alloc]init];
    xuanzeLab.text = @"初始化";
    UITapGestureRecognizer* xuanzeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addApp)];
    [xuanzeLab addGestureRecognizer:xuanzeTap];
    xuanzeTap.numberOfTapsRequired = 1;
    xuanzeTap.numberOfTouchesRequired = 1;
    xuanzeLab.font = [UIFont systemFontOfSize:13];
    xuanzeLab.textColor = [UIColor grayColor];
    xuanzeLab.userInteractionEnabled = YES;
    xuanzeLab.textAlignment = NSTextAlignmentCenter;
    [_dayuanView addSubview:xuanzeLab];
    [_dayuanView addSubview:_addBtn];
    //关于btn
    _guanyuBtn=[FakeButton buttonWithType:UIButtonTypeSystem];
  //  UIImage *img4=[UIImage imageNamed:@"guanyuneirong"];
    [_guanyuBtn setBackgroundImage:[UIImage imageNamed:@"guanyuneirong"] forState:UIControlStateNormal];
    _guanyuBtn.backgroundColor = [UIColor whiteColor];
  //  [_guanyuBtn setImage:img4 forState:UIControlStateNormal];
//    [_guanyuBtn setTitle:@"关于" forState:UIControlStateNormal];
    [_guanyuBtn addTarget:self action:@selector(guanyu) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * guanyuLab = [[UILabel alloc]init];
    guanyuLab.text = @"关于";
    UITapGestureRecognizer* dianjiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanyu)];
    dianjiTap.numberOfTapsRequired = 1;
    dianjiTap.numberOfTouchesRequired = 1;
    [guanyuLab addGestureRecognizer:dianjiTap];
    dianjiTap.numberOfTapsRequired = 1;
    dianjiTap.numberOfTouchesRequired = 1;
    guanyuLab.font = [UIFont systemFontOfSize:13];
    guanyuLab.textColor = [UIColor grayColor];
    guanyuLab.userInteractionEnabled = YES;
    
    guanyuLab.textAlignment = NSTextAlignmentCenter;
    [_dayuanView addSubview:guanyuLab];
    [_dayuanView addSubview:_guanyuBtn];
    
    if ([[DeviceAbout sharedDevice]getDeviceType] == iPhone) {
        _addBtn.frame = CGRectMake(Width + Width / 6, Width /8, Width / 8, Width/8);
        xuanzeLab.frame = CGRectMake(_addBtn.frame.origin.x, _addBtn.frame.origin.y + Width/8, Width/8, 15);
        _shezhiBtn.frame = CGRectMake(Width - Width / 4, Width /8, Width /8, Width/8);
        shezhiLab.frame = CGRectMake(_shezhiBtn.frame.origin.x, _shezhiBtn.frame.origin.y + Width/8, Width/8, 15);
        _huifuBtn.frame = CGRectMake(Width - Width / 4, Width /4 + 30, Width / 8, Width/8);
        huifuLab.frame = CGRectMake(_huifuBtn.frame.origin.x, _huifuBtn.frame.origin.y + Width/8, Width/8, 15);
        _guanyuBtn.frame = CGRectMake(Width + Width / 6 , Width /4 + 30, Width / 8, Width/8);
        guanyuLab.frame = CGRectMake(_guanyuBtn.frame.origin.x, _guanyuBtn.frame.origin.y + Width/8, Width/8, 15);
        _jiantou.frame = CGRectMake(_dayuanView.frame.size.width / 2 -20, _dayuanView.frame.size.width / 120 , 30, 30);
    }
    if ([[DeviceAbout sharedDevice]getDeviceType] == iPad) {
        _addBtn.frame = CGRectMake(Width + Width / 6, Width /8, Width / 10, Width/10);
        xuanzeLab.frame = CGRectMake(_addBtn.frame.origin.x, _addBtn.frame.origin.y + Width/10, Width/10, 15);
        _jiantou.frame = CGRectMake(_dayuanView.frame.size.width / 2 -20, _dayuanView.frame.size.width / 80 , 30, 30);
        _shezhiBtn.frame = CGRectMake(Width - Width / 4, Width /8, Width /10, Width/10);
        shezhiLab.frame = CGRectMake(_shezhiBtn.frame.origin.x, _shezhiBtn.frame.origin.y + Width/10, Width/10, 15);
        _huifuBtn.frame = CGRectMake(Width - Width / 4, Width /4 + 30, Width / 10, Width/10);
        huifuLab.frame = CGRectMake(_huifuBtn.frame.origin.x, _huifuBtn.frame.origin.y + Width/10, Width/10, 15);
        _guanyuBtn.frame = CGRectMake(Width + Width / 6 , Width /4 + 30, Width / 10, Width/10);
        guanyuLab.frame = CGRectMake(_guanyuBtn.frame.origin.x, _guanyuBtn.frame.origin.y + Width/10, Width/10, 15);
    }
    if (Height == 480) {
        _addBtn.frame = CGRectMake(Width + Width / 6, Width /14, Width / 12, Width/12);
        xuanzeLab.frame = CGRectMake(_addBtn.frame.origin.x-5, _addBtn.frame.origin.y + Width/10, Width/12+20, 15);
        _jiantou.frame = CGRectMake(_dayuanView.frame.size.width / 2 -20, _dayuanView.frame.size.width / 80 , 30, 30);
        _shezhiBtn.frame = CGRectMake(Width - Width / 4, Width /14, Width /12, Width/12);
        shezhiLab.frame = CGRectMake(_shezhiBtn.frame.origin.x, _shezhiBtn.frame.origin.y + Width/10, Width/10, 15);
        _huifuBtn.frame = CGRectMake(Width - Width / 4, Width /7 + 30, Width / 12, Width/12);
        huifuLab.frame = CGRectMake(_huifuBtn.frame.origin.x, _huifuBtn.frame.origin.y + Width/10, Width/10, 15);
        _guanyuBtn.frame = CGRectMake(Width + Width / 6 , Width /7 + 30, Width / 12, Width/12);
        guanyuLab.frame = CGRectMake(_guanyuBtn.frame.origin.x, _guanyuBtn.frame.origin.y + Width/10, Width/10, 15);
    }
    //改机数据view
    _gaijishujuView = [[UIView alloc]init];
    _gaijishujuView.frame = CGRectMake(0,Height + _youhuaView.frame.origin.y +_youhuaView.frame.size.height+ 20, Width, Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height);
    _gaijishujuView.backgroundColor = [UIColor whiteColor];
    gaijiTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, _gaijishujuView.frame.size.height - 130) style:UITableViewStyleGrouped];
    gaijiTabView.delegate = self;
    gaijiTabView.dataSource = self;
    gaijiTabView.backgroundColor = [UIColor whiteColor];
    [_gaijishujuView addSubview:gaijiTabView];
    UIView* wanchengView = [[UIView alloc]init];
    wanchengView.frame = CGRectMake(0, gaijiTabView.frame.size.height-20, Width, 70);
    wanchengView.backgroundColor = [UIColor whiteColor];
    UIButton* wanchengBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [wanchengBtn setBackgroundColor:IWColor(60, 170, 249)];
   // [wanchengBtn setBackgroundImage:[UIImage imageNamed:@"btn_more_normal@2x"] forState:UIControlStateNormal];
    [wanchengBtn setTitle:@"完成" forState:UIControlStateNormal];
    wanchengBtn.frame = CGRectMake(10, 20, Width - 20, 50);
    wanchengBtn.layer.masksToBounds = YES;
    wanchengBtn.layer.cornerRadius = 20;
    [wanchengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wanchengBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [wanchengBtn addTarget:self action:@selector(xiaqu) forControlEvents:UIControlEventTouchUpInside];
    [wanchengView addSubview:wanchengBtn];
    [_gaijishujuView addSubview:wanchengView];
    [self.view addSubview:_gaijishujuView];
    //展示的tableview
    _zhanshishujuView = [[UIView alloc]init];
    _zhanshishujuView.frame = CGRectMake(0,Height/5*2 + 30, Width, 180);
    _zhanshishujuView.backgroundColor = IWColor(60, 170, 249);
    _zhanshishujuView.hidden = YES;
    mbTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, 180) style:UITableViewStylePlain];
    mbTabView.delegate = self;
    mbTabView.dataSource = self;
    mbTabView.backgroundColor = [UIColor clearColor];
    mbTabView.tag = 6666;
   // mbTabView.backgroundColor = [UIColor whiteColor];
    //mbTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    useArrCount = arr.count -1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:useArrCount inSection:0];
    [mbTabView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_zhanshishujuView addSubview:mbTabView];
    mbTabView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_zhanshishujuView];
    
    //蒙层
    mengceng = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, _youhuaView.frame.origin.y +_youhuaView.frame.size.height+ 20)];
    mengceng.backgroundColor  = [UIColor clearColor];
    mengceng.hidden = YES;
    [self.view addSubview:mengceng];
}

- (void)shanglai{
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    isShang = YES;
    NSDictionary *dcit=[self loadsetDict];
    _selectAppArray = [[NSMutableArray alloc]init];
 //   NSLog(@"%@",dcit);
    _selectAppArray=[dcit objectForKey:@"selectApp"];
    if (_selectAppArray==nil) {
        _selectAppArray=[NSMutableArray array];
    }
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
 //   NSLog(@"isgai = %@",[user objectForKey:@"isGai"]);
    
   // [gaijiTabView reloadData];
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_gaijishujuView)];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [_gaijishujuView setFrame:CGRectMake(0,_youhuaView.frame.origin.y +_youhuaView.frame.size.height+ 20, Width, Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height)];
    [UIView commitAnimations];
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_dayuanView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_dayuanView setCenter:CGPointMake(_dayuanView.center.x, _dayuanView.center.y + 500)];
    [UIView commitAnimations];
    mengceng.hidden = NO;
    //self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    xiaoView.hidden = NO;
    _tishiLab2.text = @"改机完成";
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_topView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_topView setCenter:CGPointMake(_topView.center.x, _topView.center.y - 72)];
    [UIView commitAnimations];
    //[gaijiTabView reloadData];
}

- (void)guanyu{
    GuanyuViewController* guanyu = [[GuanyuViewController alloc]init];
    [self.navigationController pushViewController:guanyu animated:YES];
}




- (void)shezhi{
    ShezhiViewController* szvc = [[ShezhiViewController  alloc]init];
    [self.navigationController pushViewController:szvc animated:YES];
//   [gaijiTabView reloadData];
//    [mbTabView reloadData];
}
//初始化
- (void)addApp{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"您确定要恢复到初始化状态吗" message:@"初始化状态将会删除您所有改机操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [dialog show];
}

- (void)switchClick:(UISwitch*)sender{
    NSMutableDictionary *setDict1=[self loadsetDict];
  //  NSLog(@"setdict = %@",setDict1);
 //   NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    if (selectAppArray.count < 1) {
        if (sender.on == YES) {
            sender.on = NO;
        }else{
            sender.on = NO;
        }
        [KGStatusBar showWithStatus:@"您还没有选择APP,请先选择APP"];
    }
}
//代理方法
- (void)mengcengDown{
    //[testView handleTap];
   
    self.mengcengView.hidden = YES;
    NSMutableDictionary *setDict=[self loadsetDict];
    [setDict setObject:self.selectAppArray forKey:@"selectApp"];
  //  NSLog(@"setdict = %@",setDict);
    [self wrSetDict:setDict];
}
- (void)mengcengUp{
    self.mengcengView.hidden = NO;
 //   NSLog(@"nihaoi");
}

- (void)mengceng{
   
    self.mengcengView.hidden = YES;
    NSMutableDictionary *setDict=[self loadsetDict];
    [setDict setObject:self.selectAppArray forKey:@"selectApp"];
 //   NSLog(@"%@",setDict);
    [self wrSetDict:setDict];
    [testView handleTap];
}
//滑动按钮
- (void)huadong:(UIButton*)button{
    if (button.tag == 2001) {
        self.tabBarController.tabBar.hidden = YES;
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_appView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        button.frame = CGRectMake(Width/3 -20,(Height - 50)/2, 20, 50);
        [button setBackgroundImage:[UIImage imageNamed:@"default_navi_routemode_right_normal"] forState:UIControlStateNormal];
        [_appView setFrame:CGRectMake(Width/3, 70, Width/3*2, Height)];
        [UIView commitAnimations];
        button.tag = 2002;
    }
    else{
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_appView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        button.frame = CGRectMake(Width - 20, (Height - 50)/2, 20, 50);
        [button setBackgroundImage:[UIImage imageNamed:@"default_navi_routemode_left_normal"] forState:UIControlStateNormal];
        [_appView setFrame:CGRectMake(Width,70 , Width/3*2, Height)];
        [UIView commitAnimations];
        self.tabBarController.tabBar.hidden = YES;
        button.tag = 2001;
        
    }
}




-(void)xinji{
    
    
    
    NSMutableDictionary *setDict1=[self loadsetDict];
 //   NSLog(@"setdict = %@",setDict1);
//    NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
  //  NSLog(@"array = %@",dict);
    
    //先撤销上次的修改
    for (int i = 0; i<selectAppArray.count; i++) {
        NSString* bundleid = selectAppArray[i];
        [[Tools sharedTools]cancelChangeWithBundleId:bundleid];
    }
    NSMutableDictionary* muDict = nil;
    //
    if (dict == nil){
        muDict = [NSMutableDictionary dictionary];
    }else{
        muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    NSString* cleanSafari = [muDict objectForKey:@"cleanSafari"];
    NSString* cleanCopy = [muDict objectForKey:@"cleanCopy"];
    NSString* cleanApp = [muDict objectForKey:@"cleanApp"];
    NSString* cleanKeyChain = [muDict objectForKey:@"cleanKeyChain"];
    NSString* set3G = [muDict objectForKey:@"set3G"];
 //   NSString* randomData = [muDict objectForKey:@"randomData"];
    NSString* devType = [muDict objectForKey:@"devType"];
    NSString* devVer = [muDict objectForKey:@"devVer"];
    NSString* backUp = [muDict objectForKey:@"backUp"];
    NSString* keyzhi = [muDict objectForKey:@"shuju"];
    NSString* shuju = [muDict objectForKey:@"shuju"];
    NSString* uuid = [muDict objectForKey:@"uuid"];
    NSString* aduuid = [muDict objectForKey:@"aduuid"];
    NSString* wifimac = [muDict objectForKey:@"wifimac"];
    NSString* wifiname = [muDict objectForKey:@"wifiname"];
    NSString* macname = [muDict objectForKey:@"macname"];
    if ([shuju isEqualToString:@"yes"]) {
        isAPP = 1;
    }else{
        isAPP = 2;
    }
    NSLog(@"dict = %@",dict);
    if (dict.count <1 ||(selectAppArray.count < 1 && [[dict objectForKey:@"cleanSafari"] isEqualToString:@"no"] && [[dict objectForKey:@"cleanCopy"] isEqualToString:@"no"])) {
        [KGStatusBar showWithStatus:@"请先设置改机内容"];
        return;
    }
//    if (selectAppArray.count < 1) {
//        [KGStatusBar showWithStatus:@"请先选择app"];
//        return;
//    }
   // self.navigationController.navigationBar.hidden = YES;
    isShang = YES;
  

    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    xiaoView.hidden = NO;
    
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_topView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_topView setCenter:CGPointMake(_topView.center.x, _topView.center.y - 72)];
    _tishiLab2.text = @"正在改机";
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_dayuanView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_dayuanView setCenter:CGPointMake(_dayuanView.center.x, _dayuanView.center.y + 500)];
    [UIView commitAnimations];
    _zhanshishujuView.hidden = NO;
    mengceng.hidden = NO;
    //这个是页面z轴旋转
//    static float angle = 0;
//    angle += 0.3f;
//    
//    CATransform3D transloate = CATransform3DMakeTranslation(0, 0, -200);
//    CATransform3D rotate = CATransform3DMakeRotation(angle, 10, 0, 0);
//    CATransform3D mat = CATransform3DConcat(rotate, transloate);
//    [UIView beginAnimations:@"animation" context:(__bridge void *)(self.view)];
//    [UIView setAnimationDuration:0.7];
//    [UIView setAnimationDelegate:self];
//    self.view.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 800);
//    [UIView commitAnimations];
    
    colors = nil;
    if (colors == nil) {
        colors = [[NSMutableArray alloc] initWithCapacity:0];
        UIColor *color1 = nil;
        color1 = IWColor(60, 170, 249);
        [colors addObject:(id)[color1 CGColor]];
        color1 = [UIColor whiteColor];
        [colors addObject:(id)[color1 CGColor]];
        color1 = Color;
        [colors addObject:(id)[color1 CGColor]];
        color1 = [UIColor lightGrayColor];
        [colors addObject:(id)[color1 CGColor]];
    }
    _youhuaView1.backgroundColor = [UIColor clearColor];
    // _youhuaView.backgroundColor = [UIColor whiteColor];
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue =[NSNumber numberWithFloat: 0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    // rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    rotationAnimation.speed = 0.2;
    gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:colors];
    gradientLayer.frame =  CGRectMake(Width / 4, Width / 8, Width / 2, Width / 2);
    //gradientLayer.mask = shapeLayer;
    //在 (20, 20, 100, 100) 位置绘制一个颜色渐变的层
    [_youhuaView.layer addSublayer:gradientLayer];
    [_youhuaView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [gradientLayer addAnimation:rotationAnimation forKey:@"GradientRotateAniamtion"];
    
    
    
    //youhuaview1
    rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.fromValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation1.toValue = [NSNumber numberWithFloat:-M_PI * 2.0];
    // rotationAnimation.duration = duration;
    rotationAnimation1.cumulative = YES;
    rotationAnimation1.repeatCount = INT32_MAX;
    rotationAnimation1.speed = 0.1;
    gradientLayer1 = [CAGradientLayer layer];
    [gradientLayer1 setColors:colors];
    gradientLayer1.frame =  CGRectMake(Width / 4, Width / 8, Width / 2, Width / 2);
    //gradientLayer.mask = shapeLayer;
    //在 (20, 20, 100, 100) 位置绘制一个颜色渐变的层
    [_youhuaView1.layer addSublayer:gradientLayer1];
    [_youhuaView1.layer addAnimation:rotationAnimation forKey:@"rotation"];
    [gradientLayer1 addAnimation:rotationAnimation forKey:@"GradientRotate"];
    
    
    //让mbtable滚动
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(mbTableView:) userInfo:nil repeats:YES];
    
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSString *  timeString=[dateformatter stringFromDate:senddate];

    //删除数据的字典
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    //清理app数据
//    NSLog(@"clean = %@",cleanApp);
 //   NSLog(@"shuju = %@",shuju);
    if([cleanApp isEqualToString:@"yes"] || [shuju isEqualToString:@"yes"]){
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (int i = 0; i<selectAppArray.count; i++) {
                  //  NSLog(@"%@",selectAppArray[i]);
                    [[Tools sharedTools]killAppForBundleId:selectAppArray[i]];
                }
                if ([shuju isEqualToString:@"yes"]) {
            //        NSLog(@"zhangasdasdaasdasdasdasd");
                   
                    [[Tools sharedTools]BackupAppDataWithBundleId:selectAppArray withKey:timeString :^(NSDictionary *dict) {
                        
                    }];
                    keyzhi = timeString;
                }else{
                    keyzhi = @"no";
                }
                if([cleanApp isEqualToString:@"yes"]){
              
                     [[Tools sharedTools]cleanAppDataWithBundleId:selectAppArray];
                }
            }
        }
    }
    //清理safari
    if([cleanSafari isEqualToString:@"yes"]){
        NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
        if(deleteDict==nil){
            deleteDict =[NSMutableDictionary dictionary];
        }
        [deleteDict setObject:@(YES) forKey:@"safari"];
        [deleteDict writeToFile:PlistPathDM atomically:YES];
       
    }
    //清理keyChain
    if([cleanKeyChain isEqualToString:@"yes"]){
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                if ([backUp isEqualToString:@"yes"]) {
                    [[Tools sharedTools]cleanKeyChainWithBundleId:selectAppArray];
                }else{
                    [[Tools sharedTools]cleanKeyChainWithBundleId:selectAppArray];
                }
            }
        }
    }
    notify_post("com.txy.start");
    //剪切板内容
    NSString *pasteBoardStr = nil;
    //清理剪切版
    if([cleanCopy isEqualToString:@"yes"]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteBoardStr =pasteboard.string;
        pasteboard.string = @"";
    }
    //模拟3G
    if([set3G isEqualToString:@"yes"]){
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]set3G:YES WithBundleId:bundleID];
                }
            }
        }
    }
    /*
     [randomSysDict setObject:[self randomStringWithLength:10] forKey:@"devName"];
     [randomSysDict setObject:[self randomStringWithLength:12] forKey:@"seral"];
     
     NSString *randomUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
     [randomSysDict setObject:randomUUID forKey:@"UUID"];
     
     NSString *randomADUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
     [randomSysDict setObject:randomADUUID forKey:@"ADUUID"];
     
     [randomSysDict setObject:[self randomStringWithLength:6] forKey:@"WiFiName"];
     
     NSString *randomWiFiMAC=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2]];
     [randomSysDict setObject:randomWiFiMAC forKey:@"WiFiMAC"];

     */
    //随机参数
    if([uuid isEqualToString:@"yes"]){
      //uuid
        NSString *randomUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setUUID:randomUUID WithBundleId:bundleID];
                }
            }
        }
    }
      //aduuid
    if([aduuid isEqualToString:@"yes"]){
        NSString *randomADUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setADUUID:randomADUUID WithBundleId:bundleID];
                }
            }
        }
    }else{
        
    }
        //wifiname
    if([wifiname isEqualToString:@"yes"]){
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setWiFiName:[self randomStringWithLength:6] WithBundleId:bundleID];
                }
            }
        }
    }
        //wifi mac
    if([wifimac isEqualToString:@"yes"]){
        NSString *randomWiFiMAC=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2]];
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setWiFiMAC:randomWiFiMAC WithBundleId:bundleID];
                }
            }
        }
    }
        //设备名称
    if([macname isEqualToString:@"yes"]){
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevName:[self randomStringWithLength:10] WithBundleId:bundleID];
                }
            }
        }
    }
        //序列号
//        if ([selectAppArray isKindOfClass:[NSArray class]]) {
//            if (selectAppArray.count > 0) {
//                for (NSString * bundleID in selectAppArray) {
//                    [[Tools sharedTools]setSeral:[self randomStringWithLength:12] WithBundleId:bundleID];
//                }
//            }
//        }
    
    //设备类型
    if ([devType isEqualToString:@"iPhone"]) { //iphone
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevType:iPhone WithBundleId:bundleID];
                }
            }
        }
    }else if([devType isEqualToString:@"iPad"]){ //ipad
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevType:iPad WithBundleId:bundleID];
                }
            }
        }
    }else if([devType isEqualToString:@"moren"]){//默认
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevType:cancel WithBundleId:bundleID];
                }
            }
        }
    }
    
    //设备版本
  //  NSLog(@"%d",(int)self.devVerSegment.selectedSegmentIndex);
    if ([devVer isEqualToString:@"iOS7"]) { //ios7
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
               //     NSLog(@"bundleid = %@",bundleID);
                    [[Tools sharedTools]setDevVersion:fiOS7 WithBundleId:bundleID];
                }
            }
        }
    }else if([devVer isEqualToString:@"iOS8"]){ //ios8
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevVersion:fiOS8 WithBundleId:bundleID];
                }
            }
        }
    }else if([devVer isEqualToString:@"iOS9"]){ //ios9
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevVersion:fiOS9 WithBundleId:bundleID];
                }
            }
        }
    }else if([devVer isEqualToString:@"moren"]){//默认
        if ([selectAppArray isKindOfClass:[NSArray class]]) {
            if (selectAppArray.count > 0) {
                for (NSString * bundleID in selectAppArray) {
                    [[Tools sharedTools]setDevVersion:cancel2 WithBundleId:bundleID];
                }
            }
        }
    }
    
    
//    //初始化进度框，置于当前的View当中
//   MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    
//    //如果设置此属性则当前的view置于后台
//    HUD.dimBackground = YES;
//    
//    //设置对话框文字
//    HUD.labelText = @"请稍等";
//    
//    //显示对话框
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        //对话框显示时需要执行的操作
//        sleep(2);
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.labelText = @"修改成功";
//        sleep(1);
//    } completionBlock:^{
//        //操作执行完后取消对话框
//        [HUD removeFromSuperview];
//        //新机后刷新界面
//        [self shanglai];
//    }];
    
  self.tabBarController.tabBar.hidden = YES;
    _jiantou.enabled = YES;
    
    //数据备份
    if ([backUp isEqualToString:@"yes"]||[shuju isEqualToString:@"yes"]) {
        NSString *str = GaijiPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
 //       NSLog(@"plistdit = %@",plistDict);
        
        //设置内容存入plist
  
        NSArray* arr1 = [plistDict objectForKey:@"Shezhi"];
  //      NSLog(@"array = %@",arr1);
        NSMutableArray* userArray1 = nil;
        if (arr1 == nil){
            userArray1 = [NSMutableArray array];
        }else{
            userArray1 = [NSMutableArray arrayWithArray:arr1];
        }
        //剪切板内容的存储
        if (pasteBoardStr) {
           [muDict setObject:pasteBoardStr forKey:@"pasteBoard"];
        }
        [userArray1 insertObject:muDict atIndex:0];
        //清理app，key等的key值存储
        [muDict setObject:keyzhi forKey:@"keyzhi"];
        //存入plist文件
        
        [plistDict setObject:userArray1 forKey:@"Shezhi"];
     //   NSLog(@"plist = %@",plistDict);
        //改机内容存入plist
        NSArray* array = [plistDict objectForKey:@"Gaiji"];
     //   NSLog(@"array = %@",array);
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
               //获取当前改机内容
        NSMutableDictionary* neirongDit;
        neirongDit = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* setDict = [[Tools sharedTools]getInfoDict];
        NSLog(@"setDict = %@",setDict);
        NSDictionary* dict5;
        if (setDict&&self.selectAppArray.count > 0) {
            dict5 = [setDict objectForKey:[self.selectAppArray objectAtIndex:0]];
        }else{
            dict5 = [[NSDictionary alloc]init];
        }
        NSString*aduuid1 = [[DeviceAbout sharedDevice]getADUUID];
        if ([dict5 objectForKey:@"ADUUID"]) {
            aduuid1 = [dict5 objectForKey:@"ADUUID"];
        }
        [neirongDit setObject:aduuid1 forKey:@"ADUUID"];
        NSString*uuid1 = [[DeviceAbout sharedDevice]getUUID];
        if ([dict5 objectForKey:@"UUID"]) {
            uuid1 = [dict5 objectForKey:@"UUID"];
        }
        [neirongDit setObject:uuid1 forKey:@"UUID"];
        NSDictionary* dict = [[DeviceAbout sharedDevice]fetchSSIDInfo];
     //   NSLog(@"dcit = %@",dict);
        NSString*WiFiMAC ;
        if (dict) {
            WiFiMAC = [dict objectForKey:@"BSSID"];
        }
        if ([dict5 objectForKey:@"WiFiMAC"]) {
            WiFiMAC = [dict5 objectForKey:@"WiFiMAC"];
        }
        [neirongDit setObject:WiFiMAC forKey:@"WiFiMAC"];
        NSString*WiFiName;
        if (dict) {
            WiFiName = [dict objectForKey:@"SSID"];
        }
        if ([dict5 objectForKey:@"WiFiName"]) {
            WiFiName = [dict5 objectForKey:@"WiFiName"];
        }
        [neirongDit setObject:WiFiName forKey:@"WiFiName"];
        NSString*devName = [[DeviceAbout sharedDevice]getDeviceName];
        if ([dict5 objectForKey:@"devName"]) {
            devName = [dict5 objectForKey:@"devName"];
        }
        [neirongDit setObject:devName forKey:@"devName"];
        NSString*devType;
        if ([[DeviceAbout sharedDevice]getDeviceType] == iPhone) {
            devType = @"iPhone";
        }
        if ([[DeviceAbout sharedDevice]getDeviceType] == iPad) {
            devType = @"iPad";
        }
        if ([dict5 objectForKey:@"devType"]&&(![[dict5 objectForKey:@"devType"] isEqualToString:@""])) {
            devType = [dict5 objectForKey:@"devType"];
        }
        [neirongDit setObject:devType forKey:@"devType"];
        NSString*devVer;
        devVer = [[DeviceAbout sharedDevice]getDeviceIOS];
        if ([dict5 objectForKey:@"devVer"]&&(![[dict5 objectForKey:@"devVer"] isEqualToString:@""])) {
            devVer = [dict5 objectForKey:@"devVer"];
        }
        [neirongDit setObject:devVer forKey:@"devVer"];
        NSString*netState;
        netState = [[DeviceAbout sharedDevice]getNetWorkStates];
        if ([dict5 objectForKey:@"netState"]) {
            netState = [dict5 objectForKey:@"netState"];
        }
        [neirongDit setObject:netState forKey:@"netState"];
        [neirongDit setObject:selectAppArray forKey:@"APP"];
        NSMutableDictionary* gaijiDit = [[NSMutableDictionary alloc]init];
        [gaijiDit setObject:neirongDit forKey:timeString];
        [userArray insertObject:gaijiDit atIndex:0];
        //存入plist文件
        [plistDict setObject:userArray forKey:@"Gaiji"];
        NSLog(@"plist = %@",plistDict);
        BOOL result=[plistDict writeToFile:GaijiPlist atomically:YES];
            if (result) {
                NSLog(@"存入成功");
                [muDict setObject:@"no" forKey:@"shuju"];
            }else{
                NSLog(@"存入失败");
            }
        [gaijiTabView reloadData];
        //改机完成后关闭备份app按钮
        
        [userPoint setObject:@"yes" forKey:@"isGai"];
        NSLog(@"mudict = %@",muDict);
        [userPoint setObject:muDict forKey:@"GaiJi"];
        [userPoint synchronize];
    }
     
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tishiLab2.text = @"改机完成";
    });
}
//mbtable滚动实现
-(void)mbTableView:(NSTimer *)timer
{
    IWColor(60, 170, 249);
  
    if (useArrCount >=0) {
        r1 -= 80/12;
        g1 += 80/12;
        b1 += 160/12;
        xiaoView.backgroundColor = IWColor(r1, g1, b1);
        _topView.backgroundColor = IWColor(r1, g1, b1);
        _zhanshishujuView.backgroundColor = IWColor(r1, g1, b1);
        self.view.backgroundColor = IWColor(r1, g1, b1);
        _neirongView.backgroundColor = IWColor(r1, g1, b1);
        _neirongView1.backgroundColor = IWColor(r1, g1, b1);
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
        
   //     NSLog(@"array = %@",dict);
        NSMutableDictionary *muDict = nil;
        if (dict == nil){
            muDict = [NSMutableDictionary dictionary];
        }else{
            muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        NSString* cleanSafari = [muDict objectForKey:@"cleanSafari"];
        NSString* cleanCopy = [muDict objectForKey:@"cleanCopy"];
        NSString* cleanApp = [muDict objectForKey:@"cleanApp"];
        NSString* cleanKeyChain = [muDict objectForKey:@"cleanKeyChain"];
        NSString* set3G = [muDict objectForKey:@"set3G"];
     //   NSString* randomData = [muDict objectForKey:@"randomData"];
        NSString* devType = [muDict objectForKey:@"devType"];
        NSString* devVer = [muDict objectForKey:@"devVer"];
        NSString* backUp = [muDict objectForKey:@"backUp"];
        NSString* shuju = [muDict objectForKey:@"shuju"];
        NSString* wifimac = [muDict objectForKey:@"wifimac"];
        NSString* wifiname = [muDict objectForKey:@"wifiname"];
        NSString* uuid = [muDict objectForKey:@"uuid"];
        NSString* aduuid = [muDict objectForKey:@"aduuid"];
        NSString* macname = [muDict objectForKey:@"macname"];
       // [NSArray arrayWithObjects:@"清理app",@"清理剪切板",@"清理keyChain",@"清理Safari",@"修改设备类型",@"修改系统版本",@"设置随机参数",@"修改网络类型", nil]
        NSMutableArray *valuesArr = [NSMutableArray arrayWithObjects:cleanApp,cleanCopy,cleanKeyChain,cleanSafari,devType,devVer,uuid,aduuid,wifimac,wifiname,macname,set3G,backUp,shuju, nil];
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:useArrCount inSection:0];
        NSString * single =valuesArr[useArrCount];
     //   NSLog(@"%@",[muDict allValues]);
     //   NSLog(@"single:%@",single);
        
         UITableViewCell *cell = [mbTabView cellForRowAtIndexPath:indexPath];
        if ([single isEqualToString:@"yes"] || (![single isEqualToString:@"moren"] && ![single isEqualToString:@"no"])) {
            for (UIView *l  in cell.contentView.subviews) {
                if ([l isKindOfClass:[UITextField class]]) {
                    UITextField *lab =  (UITextField *)l;
                    lab.text = @"完成";
                    lab.textColor = [UIColor redColor];
                }
            }
        }
       
        [mbTabView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        [timer invalidate];
        [gradientLayer removeFromSuperlayer];
        [gradientLayer1 removeFromSuperlayer];
        _youhuaView1.backgroundColor = [UIColor whiteColor];
    }
    useArrCount --;
    if (useArrCount <0) {
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_zhanshishujuView)];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [_zhanshishujuView setFrame:CGRectMake(0,Height + 500, Width, 180)];
        [UIView commitAnimations];
        
        NSDictionary *dcit=[self loadsetDict];
        _selectAppArray = [[NSMutableArray alloc]init];
    //    NSLog(@"%@",dcit);
        _selectAppArray=[dcit objectForKey:@"selectApp"];
        if (_selectAppArray==nil) {
            _selectAppArray=[NSMutableArray array];
        }
        
         NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:0 inSection:0];
        [gaijiTabView scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_gaijishujuView)];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [_gaijishujuView setFrame:CGRectMake(0,_youhuaView.frame.origin.y +_youhuaView.frame.size.height+ 20, Width, Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height)];
        [UIView commitAnimations];
    }
}
-(void)gaoji{
//    //选择作用范围
//    CleanAppViewController *cleanCtrl=[[CleanAppViewController alloc]initWithSelectApp:self.selectAppArray];
//    [self.navigationController pushViewController:cleanCtrl animated:YES];
//    cleanCtrl.selectAppArrayBlock=^(NSMutableArray *selectAppArray){
//        self.selectAppArray=selectAppArray;
//        NSMutableDictionary *setDict=[self loadsetDict];
//        [setDict setObject:selectAppArray forKey:@"selectApp"];
//        NSLog(@"%@",setDict);
//        [self wrSetDict:setDict];
//    };
//    
//    if (testView.drawState == 1) {
//        testView.drawState = 0;
//        NSLog(@"1");
//    }else{
//        testView.drawState = 1;
//        NSLog(@"0");
//    }
    self.mengcengView.hidden = NO;
    [testView handleTap];
    
}

-(void)huifu{
    HuiFuViewController *huifu = [[HuiFuViewController alloc]init];
    huifu.delegate = self;
//    [self.navigationController pushViewController:huifu animated:YES];
   // UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:huifu];
  //  nav .modalPresentationStyle = UIModalPresentationPopover;
   // nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:nav animated:YES completion:nil];
    
    [self.navigationController pushViewController:huifu animated:YES];
}

-(NSMutableDictionary *)randomSysInfo{
    //生成随机系统参数
    NSMutableDictionary *randomSysDict=[NSMutableDictionary dictionary];
    
    [randomSysDict setObject:[self randomStringWithLength:10] forKey:@"devName"];
    [randomSysDict setObject:[self randomStringWithLength:12] forKey:@"seral"];
    
    NSString *randomUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
    [randomSysDict setObject:randomUUID forKey:@"UUID"];
    
    NSString *randomADUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
    [randomSysDict setObject:randomADUUID forKey:@"ADUUID"];
    
    [randomSysDict setObject:[self randomStringWithLength:6] forKey:@"WiFiName"];
    
    NSString *randomWiFiMAC=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2]];
    [randomSysDict setObject:randomWiFiMAC forKey:@"WiFiMAC"];
    
    return randomSysDict;
}

-(NSString *)randomStringWithLength:(int)length{
    //NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    NSString *result=@"";
    for (int i=0; i<length; i++) {
        int x = arc4random() % shuffledAlphabet.count;
        result = [NSString stringWithFormat:@"%@%@",result,shuffledAlphabet[x]];
    }
    return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag ==6666) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (!(tableView.tag ==6666)) {
        if (section == 0) {
            return 8;
        }else{
            return 14;
        }
    }
    return arr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
    NSLog(@"gaiji = %@",dict);
    NSMutableDictionary* muDict = nil;
    if (dict == nil){
        muDict = [NSMutableDictionary dictionary];
    }else{
        muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    NSString* cleanSafari = [muDict objectForKey:@"cleanSafari"];
    NSString* cleanCopy = [muDict objectForKey:@"cleanCopy"];
    NSString* cleanApp = [muDict objectForKey:@"cleanApp"];
    NSString* cleanKeyChain = [muDict objectForKey:@"cleanKeyChain"];
    NSString* set3G = [muDict objectForKey:@"set3G"];
    //   NSString* randomData = [muDict objectForKey:@"randomData"];
    NSString* devType = [muDict objectForKey:@"devType"];
    NSString* devVer = [muDict objectForKey:@"devVer"];
    NSString* backUp = [muDict objectForKey:@"backUp"];
    NSString* keyzhi = [muDict objectForKey:@"shuju"];
    NSString* shuju = [muDict objectForKey:@"shuju"];
    NSString* uuid = [muDict objectForKey:@"uuid"];
    NSString* aduuid = [muDict objectForKey:@"aduuid"];
    NSString* wifimac = [muDict objectForKey:@"wifimac"];
    NSString* wifiname = [muDict objectForKey:@"wifiname"];
    NSString* macname = [muDict objectForKey:@"macname"];
    if (tableView.tag == 6666) {
        NSString *CellIdentifier = @"cell";
        //[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row]
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }else{
            cell.textLabel.text=nil;
            cell.detailTextLabel.text=nil;
            cell.imageView.image=nil;
            cell.accessoryView=nil;
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageNamed:@"table_exam"];
        UITextField *typeLab = [[UITextField alloc]initWithFrame:CGRectMake(Width - 80, 15, 70, 30)];
        typeLab.text = @"未启用";
        typeLab.textColor = Color;
        [cell.contentView addSubview:typeLab];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *isGai = [user objectForKey:@"isGai"];
        FakeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[FakeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
        }else{
            cell.textLabel.text=nil;
            cell.detailTextLabel.text=nil;
            cell.imageView.image=nil;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        NSMutableDictionary* setDict = [[Tools sharedTools]getInfoDict];
    //    NSLog(@"setDict = %@",setDict);
        NSDictionary* dict5;
        if (setDict&&self.selectAppArray.count > 0) {
            dict5 = [setDict objectForKey:[self.selectAppArray objectAtIndex:0]];
        }else{
            dict5 = [[NSDictionary alloc]init];
        }
     //   NSLog(@"dict5 = %@",dict5);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel* lab1 = [[UILabel alloc]init];
        
        lab1.adjustsFontSizeToFitWidth = YES;
        //   lab1.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:lab1];
        UILabel* lab2 = [[UILabel alloc]init];
        lab2.adjustsFontSizeToFitWidth = YES;
        lab2.textColor = [UIColor blackColor];
        //  lab2.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:lab2];
        
        if(indexPath.section == 1){
            if (indexPath.row==0) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"清理APP:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([cleanApp isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
           //         NSLog(@"lab2.text = %@",lab2.text);
          //          NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==1) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc] init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"清理Safari:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.textColor = [UIColor blackColor];
                lab1.text = @"未启用";
                if ([cleanSafari isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
             //       NSLog(@"lab2.text = %@",lab2.text);
             //       NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==2) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"清理剪切板:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textColor = [UIColor blackColor];
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([cleanCopy isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
               //     NSLog(@"lab2.text = %@",lab2.text);
               //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==3) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"清理KeyChain:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([cleanKeyChain isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
              //      NSLog(@"lab2.text = %@",lab2.text);
              //      NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==4) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"设置网络:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([set3G isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
             //       NSLog(@"lab2.text = %@",lab2.text);
              //      NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==5) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"设备名字:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([macname isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
               //     NSLog(@"lab2.text = %@",lab2.text);
               //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==6) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"wifi名字:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([wifiname isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
                    //     NSLog(@"lab2.text = %@",lab2.text);
                    //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==7) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"wifi地址:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([wifimac isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
                    //     NSLog(@"lab2.text = %@",lab2.text);
                    //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==8) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"uuid";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([uuid isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
                    //     NSLog(@"lab2.text = %@",lab2.text);
                    //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==9) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"aduuid:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([aduuid isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
                    //     NSLog(@"lab2.text = %@",lab2.text);
                    //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==10) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"设备类型:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if (![devType isEqualToString:@"moren"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
               //     NSLog(@"lab2.text = %@",lab2.text);
               //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==11) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"系统版本:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if (![devVer isEqualToString:@"moren"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
               //     NSLog(@"lab2.text = %@",lab2.text);
               //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==12) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"参数备份(不包含APP数据):";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if ([backUp isEqualToString:@"yes"]) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
              //      NSLog(@"lab2.text = %@",lab2.text);
               //     NSLog(@"dict5 = %@",dict5);
                }
            }
            if (indexPath.row==13) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,120, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"参数和APP数据备份:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(160, 5, Width - 220, 30);
                lab1.textAlignment = NSTextAlignmentRight;
                nameLab.font = [UIFont systemFontOfSize:15];
                lab1.text = @"未启用";
                if (isAPP == 1) {
                    lab1.text = @"完成";
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
                //    NSLog(@"lab2.text = %@",lab2.text);
                //    NSLog(@"dict5 = %@",dict5);
                }
            }

        }
        
        if (indexPath.section == 0) {
            
            
            
            if (indexPath.row==7) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                //   cell.backgroundColor = Color;
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,70, 30);
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.text = @"aduuid:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(110, 5, Width - 120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                nameLab.font = [UIFont systemFontOfSize:15];
                NSLog(@"ADUUID1 =%@ ",[dict5 objectForKey:@"ADUUID"]);
                NSLog(@"ADUUID2 = %@",[[DeviceAbout sharedDevice]getADUUID]);
                if ([dict5 objectForKey:@"ADUUID"]&&[aduuid isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"ADUUID"];
                    imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
                    lab1.textColor = IWColor(60, 170, 249);
               //     NSLog(@"lab2.text = %@",lab2.text);
                //    NSLog(@"dict5 = %@",dict5);
                }else{
                    lab1.text = [[DeviceAbout sharedDevice]getADUUID];
                }
            }
            if (indexPath.row==6) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5, 70, 30);
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.text = @"uuid:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(110, 5,Width - 120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                NSLog(@"uuid1 =%@ ",[dict5 objectForKey:@"UUID"]);
                NSLog(@"uuid2 = %@",[[DeviceAbout sharedDevice]getUUID]);
                if ([dict5 objectForKey:@"UUID"]&&[uuid isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"UUID"];
                    lab1.textColor = IWColor(60, 170, 249);
                }else{
                    lab1.text = [[DeviceAbout sharedDevice]getUUID];
                }
            }
            if (indexPath.row==5) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,80, 30);
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.text = @"wifi地址:";
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(120, 5, Width-120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                NSDictionary* dict = [[DeviceAbout sharedDevice]fetchSSIDInfo];
              //  NSLog(@"dcit = %@",dict);
                if (dict) {
                    lab1.text = [dict objectForKey:@"BSSID"];
                }
                if ([dict5 objectForKey:@"WiFiMAC"]&&[wifimac isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"WiFiMAC"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
            if (indexPath.row==4) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5, 80, 30);
                nameLab.text = @"wifi名字:";
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(120, 5, Width-120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                lab1.text = [[DeviceAbout sharedDevice]getUUID];
                NSDictionary* dict = [[DeviceAbout sharedDevice]fetchSSIDInfo];
           //     NSLog(@"dcit = %@",dict);
                if (dict) {
                    lab1.text = [dict objectForKey:@"SSID"];
                }
                if ([dict5 objectForKey:@"WiFiName"]&&[wifiname isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"WiFiName"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
            if (indexPath.row==0) {
                //cell.textLabel.text=@"设备名称:";
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5, 80, 30);
                nameLab.text = @"设备名字:";
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.text = [[DeviceAbout sharedDevice]getDeviceName];
                lab1.frame = CGRectMake(120, 5, Width - 120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                if ([dict5 objectForKey:@"devName"]&&[macname isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"devName"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
            if (indexPath.row==1) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5,80, 30);
                nameLab.text = @"设备类型:";
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(120, 5, Width-120, 30);
                lab1.textAlignment = NSTextAlignmentLeft;
                if ([[DeviceAbout sharedDevice]getDeviceType] == iPhone) {
                    lab1.text = @"iPhone";
                }
                if ([[DeviceAbout sharedDevice]getDeviceType] == iPad) {
                    lab1.text = @"iPad";
                }
                if ([dict5 objectForKey:@"devType"]&&(![[dict5 objectForKey:@"devType"] isEqualToString:@""])) {
                    lab1.text = [dict5 objectForKey:@"devType"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
            if (indexPath.row==2) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5, 80, 30);
                nameLab.text = @"设备版本:";
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(120, 5, Width -120, 30);
                lab1.text = [[DeviceAbout sharedDevice]getDeviceIOS];
                lab1.textAlignment = NSTextAlignmentLeft;
                if ([dict5 objectForKey:@"devVer"]&&(![[dict5 objectForKey:@"devVer"] isEqualToString:@""])) {
                    lab1.text = [dict5 objectForKey:@"devVer"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
            if (indexPath.row==3) {
                UIImageView* imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(10, 10, 20, 20);
                imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
                [cell.contentView addSubview:imageView];
                UILabel* nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(40, 5, 80, 30);
                nameLab.text = @"手机网络:";
                nameLab.font = [UIFont systemFontOfSize:15];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                lab1.frame = CGRectMake(120, 5, Width-100, 30);
                lab1.text = [[DeviceAbout sharedDevice]getNetWorkStates];
                lab1.textAlignment = NSTextAlignmentLeft;
                if ([dict5 objectForKey:@"netState"]&&[set3G isEqualToString:@"yes"]) {
                    lab1.text = [dict5 objectForKey:@"netState"];
                    lab1.textColor = IWColor(60, 170, 249);
                }
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 6666) {
        return 60;
    }
    else
    {
        return 40;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 6666) {
        return 0;
    }
    else
    {
        return 30;
    }
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 6666) {
        return nil;
    }
    else
    {
        UIView* view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, Width, 30);
        view.backgroundColor = [UIColor whiteColor];
        UILabel* lab1 = [[UILabel alloc]init];
        UIButton* imageBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        [imageBtn setBackgroundImage:[UIImage imageNamed:@"default_common_navibar_prev_normal"] forState:UIControlStateNormal];
        imageBtn.frame = CGRectMake(Width/2-20, 0, 40, 40);
        imageBtn.transform=CGAffineTransformMakeRotation(M_PI/2+M_PI);
        [imageBtn addTarget:self action:@selector(xiaqu) forControlEvents:UIControlEventTouchUpInside];
        
        lab1.textColor = [UIColor grayColor];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.frame = CGRectMake(0, 0, Width, 30);
        UILabel* lab2 = [[UILabel alloc]init];
        lab2.text = @"改机后";
        lab2.textColor = [UIColor grayColor];
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.frame = CGRectMake(Width/8*5, 0, Width/4, 30);
      //  [view addSubview:imageBtn];
        [view addSubview:lab1];
       // [view addSubview:lab2];
        UIView* xian = [[UIView alloc]init];
        xian.backgroundColor = Color;
        xian.frame = CGRectMake(0, 29, Width, 1);
        [view addSubview:xian];
        if (section == 0) {
            lab1.text = @"改机数据";
        }
        else
        {
            lab1.text = @"改机操作";
        }
        
        return view;
    }
    return nil;
}
- (void)xiaqu{
    self.tabBarController.tabBar.hidden = YES;
     self.navigationController.navigationBar.hidden = NO;
   // [self viewWillAppear:YES];
    isShang = NO;
    mengceng.hidden = YES;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_gaijishujuView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_gaijishujuView setFrame:CGRectMake(0, Height+ Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height, Width, Height -_youhuaView.frame.origin.y - 20 - _youhuaView.frame.size.height)];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_dayuanView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_dayuanView setFrame:CGRectMake(-Width/2, Height / 5*3 -50, Width *2, Width*2)];
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_topView)];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [_topView setFrame:CGRectMake(0, 0, Width, Height /5 *3)];
    [UIView commitAnimations];
    
    
    _zhanshishujuView.hidden = YES;
    _zhanshishujuView.frame =CGRectMake(0,Height/5*2, Width, 180);
    useArrCount = arr.count -1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:useArrCount inSection:0];
    [mbTabView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    NSArray *cells =   [mbTabView visibleCells];
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = (UITableViewCell *)cells[i];
        for (UIView *l  in cell.contentView.subviews) {
            if ([l isKindOfClass:[UITextField class]]) {
                UITextField *lab =  (UITextField *)l;
                lab.text = @"未启用";
                lab.textColor = [UIColor grayColor];
            }
        }
    }
    r1 = 140;
    b1 = 90;
    g1 = 89;
    
    [gradientLayer removeFromSuperlayer];
    [gradientLayer1 removeFromSuperlayer];
    _youhuaView1.backgroundColor = [UIColor whiteColor];
   // [gaijiTabView reloadData];
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
   
}

-(void)devTypeChange:(UISegmentedControl *)sender{
    NSMutableDictionary *setDict1=[self loadsetDict];
 //   NSLog(@"setdict = %@",setDict1);
 //   NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    if (selectAppArray.count < 1) {
        sender.selectedSegmentIndex = 2;
        [KGStatusBar showWithStatus:@"您还没有选择APP,请先选择APP"];
    }else{
    int num=(int)sender.selectedSegmentIndex;
    if (num==0) {
        NSLog(@"iphone");
    }else if (num==1){
        NSLog(@"ipad");
    }else if (num == 2){
        NSLog(@"默认");
    }
    }
}
-(void)devVersionChange:(UISegmentedControl *)sender{
    NSMutableDictionary *setDict1=[self loadsetDict];
//    NSLog(@"setdict = %@",setDict1);
//    NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    if (selectAppArray.count < 1) {
        sender.selectedSegmentIndex = 3;
        [KGStatusBar showWithStatus:@"您还没有选择APP,请先选择APP"];
    }else{
    int num=(int)sender.selectedSegmentIndex;
    if (num==0) {
        NSLog(@"ios7");
    }else if (num==1){
        NSLog(@"ios8");
    }else if (num==2){
        NSLog(@"ios9");
    }else if (num == 3){
        NSLog(@"默认");
    }
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//{
//    if (tableView.tag == 3001) {
//        return nil;
//    }
//    if (section == 0) {
//        return @"针对整个设备";
//    }else if (section ==1){
//        
//        return @"针对某个APP";
//    }
//    return nil;
//}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)updateSwitchAtIndexPath:(UISwitch *)switchView{
    NSLog(@"%@",switchView.on?@"yes":@"no");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"0");
//        NSMutableDictionary *setDict1=[self loadsetDict];
//    //    NSLog(@"setdict = %@",setDict1);
//    //    NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
//        NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
//      //  NSLog(@"d = %lu",selectAppArray.count);
//        if ([selectAppArray isKindOfClass:[NSArray class]]) {
//            if (selectAppArray.count > 0) {
//                for (NSString * bundleID in selectAppArray) {
//                    [[Tools sharedTools]cancelChangeWithBundleId:bundleID];
//                }
//            }
//        }
        //清除对所有app的改机操作
        NSMutableDictionary* setDict1 = [[Tools sharedTools]getInfoDict];
      //  NSLog(@"setdict = %@",setDict1);
        [setDict1 removeObjectForKey:@"selectApp"];
        [self wrSetDict:setDict1];
        NSMutableDictionary* setDict = [[Tools sharedTools]getInfoDict];
        if (setDict) {
            NSMutableArray* array =[NSMutableArray arrayWithArray:[setDict allKeys]];
            BOOL isC = [array  containsObject:@"selectApp"];
         //   NSLog(@"%@",array);
            if (isC&&array.count > 0) {
                [array removeObject:@"selectApp"];
            }
            if (array.count > 0) {
                for (int i = 0; i<array.count;i++){
                    NSString* string = array[i];
                    [[Tools sharedTools]cancelChangeWithBundleId:string];
                }
                
                NSLog(@"撤销修改");
            }
        }
       
     //   NSLog(@"set = %@",setDict);
        //清除恢复内容
        NSString *str = GaijiPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
         //清除app备份内容
        NSMutableArray* array = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Gaiji"]];
        if (array == nil) {
            array = [NSMutableArray array];
        }
        NSMutableArray* array2 = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Shezhi"]];
        if (array2 == nil) {
            array2 = [NSMutableArray array];
        }
        NSLog(@"gaiji = %@",array);
        NSLog(@"shezhi = %@",array2);
        //取出keyzhi和app备份的bundleID，不为no的是app备份
        //存放app数据备份的bundleID的数组
        NSMutableArray* bundleArr = [[NSMutableArray alloc]init];
        //存放keyzhi的数组
        NSMutableArray* keyArr = [[NSMutableArray alloc]init];
        if (array.count>0) {
            for (int i=0; i<array.count; i++) {
                NSString* keyzhi = [array2[i] objectForKey:@"keyzhi"];
                NSLog(@"array = %@",array);
                NSLog(@"array2 = %@",array2);
                NSLog(@"keyzhi = %@",keyzhi);
                if (![keyzhi isEqualToString:@"no"]) {
                    NSLog(@"bundleArr = %@",[[array[i] allValues][0] objectForKey:@"APP"]);
                    NSLog(@"array[i] = %@",array[i]);
                    NSLog(@"1");
                    [bundleArr addObject:[[array[i] allValues][0] objectForKey:@"APP"]];
                    [keyArr addObject:keyzhi];
                }
            }
            NSLog(@"bundleArr = %@",bundleArr);
            NSLog(@"keyArr = %@",keyArr);
            for (int i = 0; i < bundleArr.count; i++) {
                NSMutableArray* bunArr = [NSMutableArray arrayWithArray:bundleArr[i]];
                NSString* keyzhi1 = keyArr[i];
                for (int i = 0; i<bunArr.count; i++) {
                    [[Tools sharedTools]deleteForBackUpWithBundleId:bunArr[i] Key:keyzhi1];
                }
            }
        }
        
        [plistDict removeAllObjects];
        BOOL result=[plistDict writeToFile:GaijiPlist atomically:YES];
        if (result) {
            NSLog(@"存入成功");
        }else{
            NSLog(@"存入失败");
        }
        
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        [userPoint removeObjectForKey:@"isGai"];
   //     NSLog(@"isgai = %@",[userPoint objectForKey:@"isGai"]);
        NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
  //      NSLog(@"array = %@",dict);
        NSMutableDictionary* muDict = nil;
        if (dict == nil){
            muDict = [NSMutableDictionary dictionary];
        }else{
            muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        [muDict removeAllObjects];
        [userPoint setObject:muDict forKey:@"GaiJi"];
        [userPoint synchronize];
        //初始化进度框，置于当前的View当中
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请稍后";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //显示对话框
        [HUD showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1);
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"恢复成功";
            sleep(1);
        } completionBlock:^{
            //操作执行完后取消对话框
            [HUD removeFromSuperview];
  //          NSLog(@"d = %lu",selectAppArray.count);
            NSMutableDictionary *setDict2=[self loadsetDict];
            self.selectAppArray = [setDict2 valueForKey:@"selectApp"];
            if (_selectAppArray==nil) {
                _selectAppArray=[NSMutableArray array];
            }
            int i = (int)_selectAppArray.count;
            _geshuLab.text = [NSString stringWithFormat:@"%d",i];
            _jiantou.enabled = NO;
            _tishiLab2.text = @"点击开始改机";
        }];

    }else{
        NSLog(@"1");
        
    }
}

-(void)changeAfter :(int)which
{
    isAPP = 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        NSLog(@"我已经收到第%d条消息",which);
        //取出恢复的改机内容
        NSString *str = GaijiPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
   //     NSLog(@"plistdit = %@",plistDict);
        NSArray* array = [plistDict objectForKey:@"Gaiji"];
   //     NSLog(@"array = %@",array);
        NSMutableDictionary* gaijiDit1 = [[NSMutableDictionary alloc]initWithDictionary:array[which]];
        //取出恢复的设置内容
        NSArray* shezhiArr = [plistDict objectForKey:@"Shezhi"];
    //    NSLog(@"shezhiArr = %@",shezhiArr);
        NSDictionary* dict = [[NSMutableDictionary alloc]initWithDictionary:shezhiArr[which]];
        
     
        //取出恢复的app
        NSMutableArray* selectAppArray = [[NSMutableArray alloc]init];
        NSMutableDictionary* gaijiDit = [gaijiDit1 allValues][0];
        selectAppArray=[gaijiDit objectForKey:@"APP"];
        int i = selectAppArray.count;
        _geshuLab.text = [NSString stringWithFormat:@"%d",i];
        if (_selectAppArray==nil) {
            _selectAppArray=[NSMutableArray array];
        }
    //    NSLog(@"gajiDit = %@",gaijiDit);
    //    NSLog(@"selectApp = %@",selectAppArray);
        NSMutableDictionary *setDict=[self loadsetDict];
        [self.selectAppArray removeAllObjects];
        self.selectAppArray = [NSMutableArray arrayWithArray:selectAppArray];
        //先撤销上次的修改
        for (int i = 0; i<self.selectAppArray.count; i++) {
            NSString* bundleid = self.selectAppArray[i];
            [[Tools sharedTools]cancelChangeWithBundleId:bundleid];
        }
        
        [setDict setObject:selectAppArray forKey:@"selectApp"];
    //    NSLog(@"setdict = %@",setDict);
        [self wrSetDict:setDict];
        //进行改机操作
        self.navigationController.navigationBar.alpha = 0;
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        xiaoView.hidden = NO;
        
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_topView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        [_topView setCenter:CGPointMake(_topView.center.x, _topView.center.y - 72)];
        _tishiLab2.text = @"正在改机";
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_dayuanView)];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        [_dayuanView setCenter:CGPointMake(_dayuanView.center.x, _dayuanView.center.y + 500)];
        [UIView commitAnimations];
        _zhanshishujuView.hidden = NO;
        mengceng.hidden = NO;
        //这个是页面z轴旋转
        //    static float angle = 0;
        //    angle += 0.3f;
        //
        //    CATransform3D transloate = CATransform3DMakeTranslation(0, 0, -200);
        //    CATransform3D rotate = CATransform3DMakeRotation(angle, 10, 0, 0);
        //    CATransform3D mat = CATransform3DConcat(rotate, transloate);
        //    [UIView beginAnimations:@"animation" context:(__bridge void *)(self.view)];
        //    [UIView setAnimationDuration:0.7];
        //    [UIView setAnimationDelegate:self];
        //    self.view.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 800);
        //    [UIView commitAnimations];
        
        colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:0];
            UIColor *color1 = nil;
            color1 = IWColor(60, 170, 249);
            [colors addObject:(id)[color1 CGColor]];
            color1 = [UIColor whiteColor];
            [colors addObject:(id)[color1 CGColor]];
            color1 = Color;
            [colors addObject:(id)[color1 CGColor]];
            color1 = [UIColor lightGrayColor];
            [colors addObject:(id)[color1 CGColor]];
        }
        _youhuaView1.backgroundColor = [UIColor clearColor];
        // _youhuaView.backgroundColor = [UIColor whiteColor];
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0 ];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        // rotationAnimation.duration = duration;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INT32_MAX;
        rotationAnimation.speed = 0.2;
        gradientLayer = [CAGradientLayer layer];
        [gradientLayer setColors:colors];
        gradientLayer.frame =  CGRectMake(Width / 4, Width / 8, Width / 2, Width / 2);
        //gradientLayer.mask = shapeLayer;
        //在 (20, 20, 100, 100) 位置绘制一个颜色渐变的层
        [_youhuaView.layer addSublayer:gradientLayer];
        [_youhuaView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [gradientLayer addAnimation:rotationAnimation forKey:@"GradientRotateAniamtion"];
        
        
        
        //youhuaview1
        rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation1.fromValue = [NSNumber numberWithFloat:M_PI];
        rotationAnimation1.toValue = [NSNumber numberWithFloat:-M_PI * 2.0];
        // rotationAnimation.duration = duration;
        rotationAnimation1.cumulative = YES;
        rotationAnimation1.repeatCount = INT32_MAX;
        rotationAnimation1.speed = 0.1;
        gradientLayer1 = [CAGradientLayer layer];
        [gradientLayer1 setColors:colors];
        gradientLayer1.frame =  CGRectMake(Width / 4, Width / 8, Width / 2, Width / 2);
        //gradientLayer.mask = shapeLayer;
        //在 (20, 20, 100, 100) 位置绘制一个颜色渐变的层
        [_youhuaView1.layer addSublayer:gradientLayer1];
        [_youhuaView1.layer addAnimation:rotationAnimation forKey:@"rotation"];
        [gradientLayer1 addAnimation:rotationAnimation forKey:@"GradientRotate"];
        
        
        //让mbtable滚动
        [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(mbTableView:) userInfo:nil repeats:YES];
        NSString* cleanSafari = [dict objectForKey:@"cleanSafari"];
        NSString* cleanCopy = [dict objectForKey:@"cleanCopy"];
        NSString* cleanApp = [dict objectForKey:@"cleanApp"];
        NSString* cleanKeyChain = [dict objectForKey:@"cleanKeyChain"];
        NSString* set3G = [dict objectForKey:@"set3G"];
     //   NSString* randomData = [dict objectForKey:@"randomData"];
        NSString* devType = [dict objectForKey:@"devType"];
        NSString* devVer = [dict objectForKey:@"devVer"];
        NSString* backUp = [dict objectForKey:@"backUp"];
        NSString* keyzhi = [dict objectForKey:@"keyzhi"];
        NSString* shuju = [dict objectForKey:@"shuju"];
        NSString* wifiname = [dict objectForKey:@"wifiname"];
        NSString* wifimac = [dict objectForKey:@"wifimac"];
        NSString* macname = [dict objectForKey:@"macname"];
        NSString* uuid = [dict objectForKey:@"uuid"];
        NSString* aduuid = [dict objectForKey:@"aduuid"];
        //删除数据的字典
        NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
        if(deleteDict==nil){
            deleteDict =[NSMutableDictionary dictionary];
        }
        NSLog(@"%@  shuju:%@",cleanApp,shuju);
        //恢复app数据
        if( [shuju isEqualToString:@"yes"]){
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (![keyzhi isEqualToString:@"no"]) {
                    for (int i = 0; i<selectAppArray.count; i++) {
                        [[Tools sharedTools]killAppForBundleId:selectAppArray[i]];
                    }
                    //NSLog(@"%@",selectAppArray[i]);
                    [[Tools sharedTools] recoverAppWhitBundleId:selectAppArray WithKey:keyzhi];
                    NSLog(@"%@",selectAppArray);
                }
            }
        }
        //清理safari
        if([cleanSafari isEqualToString:@"yes"]){
            NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
            if(deleteDict==nil){
                deleteDict =[NSMutableDictionary dictionary];
            }
            [deleteDict setObject:@(YES) forKey:@"safari"];
            [deleteDict writeToFile:PlistPathDM atomically:YES];
        }
        //清理keyChain
        if([cleanKeyChain isEqualToString:@"yes"]){
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    if ([backUp isEqualToString:@"yes"]) {
                        [[Tools sharedTools]cleanKeyChainWithBundleId:selectAppArray];
                    }else{
                        [[Tools sharedTools]cleanKeyChainWithBundleId:selectAppArray];
                    }
                }
            }
        }
        notify_post("com.txy.start");
        //清理剪切版
        if([cleanCopy isEqualToString:@"yes"]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string = @"";
        }
        //pasteBoard
        NSString *pasteBoardStr=[gaijiDit objectForKey:@"pasteBoard"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteBoardStr) {
            pasteboard.string = pasteBoardStr;
        }
        //模拟3G
        if([set3G isEqualToString:@"yes"]){
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]set3G:YES WithBundleId:bundleID];
                    }
                }
            }
        }
        /*
         [randomSysDict setObject:[self randomStringWithLength:10] forKey:@"devName"];
         [randomSysDict setObject:[self randomStringWithLength:12] forKey:@"seral"];
         
         NSString *randomUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
         [randomSysDict setObject:randomUUID forKey:@"UUID"];
         
         NSString *randomADUUID=[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[self randomStringWithLength:8],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:4],[self randomStringWithLength:12]];
         [randomSysDict setObject:randomADUUID forKey:@"ADUUID"];
         
         [randomSysDict setObject:[self randomStringWithLength:6] forKey:@"WiFiName"];
         
         NSString *randomWiFiMAC=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2],[self randomStringWithLength:2]];
         [randomSysDict setObject:randomWiFiMAC forKey:@"WiFiMAC"];
         
         */
        //随机参数
        if([uuid isEqualToString:@"yes"]){
            //uuid
            NSString *randomUUID=[gaijiDit objectForKey:@"UUID"];
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setUUID:randomUUID WithBundleId:bundleID];
                    }
                }
            }
        }
            //aduuid
         if([aduuid isEqualToString:@"yes"]){
            NSString *randomADUUID=[gaijiDit objectForKey:@"ADUUID"];;
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setADUUID:randomADUUID WithBundleId:bundleID];
                    }
                }
            }
         }
            //wifiname
         if([wifiname isEqualToString:@"yes"]){
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setWiFiName:[gaijiDit objectForKey:@"WiFiName"] WithBundleId:bundleID];
                    }
                }
            }
         }
            //wifi mac
         if([wifimac isEqualToString:@"yes"]){
            NSString *randomWiFiMAC=[NSString stringWithFormat:@"%@",[gaijiDit objectForKey:@"WiFiMAC"]];
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setWiFiMAC:randomWiFiMAC WithBundleId:bundleID];
                    }
                }
            }
         }
            //设备名称
         if([macname isEqualToString:@"yes"]){
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevName:[gaijiDit objectForKey:@"devName"] WithBundleId:bundleID];
                    }
                }
            }
         }
            //序列号
//            if ([selectAppArray isKindOfClass:[NSArray class]]) {
//                if (selectAppArray.count > 0) {
//                    for (NSString * bundleID in selectAppArray) {
//                        [[Tools sharedTools]setSeral:[self randomStringWithLength:12] WithBundleId:bundleID];
//                    }
//                }
//            }
        //设备类型
        if ([devType isEqualToString:@"iPhone"]) { //iphone
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevType:iPhone WithBundleId:bundleID];
                    }
                }
            }
        }else if([devType isEqualToString:@"iPad"]){ //ipad
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevType:iPad WithBundleId:bundleID];
                    }
                }
            }
        }else if([devType isEqualToString:@"moren"]){//默认
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevType:cancel WithBundleId:bundleID];
                    }
                }
            }
        }
        
        //设备版本
        NSLog(@"%d",(int)self.devVerSegment.selectedSegmentIndex);
        if ([devVer isEqualToString:@"iOS7"]) { //ios7
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
              //          NSLog(@"bundleid = %@",bundleID);
                        [[Tools sharedTools]setDevVersion:fiOS7 WithBundleId:bundleID];
                    }
                }
            }
        }else if([devVer isEqualToString:@"iOS8"]){ //ios8
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevVersion:fiOS8 WithBundleId:bundleID];
                    }
                }
            }
        }else if([devVer isEqualToString:@"iOS9"]){ //ios9
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevVersion:fiOS9 WithBundleId:bundleID];
                    }
                }
            }
        }else if([devVer isEqualToString:@"moren"]){//默认
            if ([selectAppArray isKindOfClass:[NSArray class]]) {
                if (selectAppArray.count > 0) {
                    for (NSString * bundleID in selectAppArray) {
                        [[Tools sharedTools]setDevVersion:cancel2 WithBundleId:bundleID];
                    }
                }
            }
        }
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        [dict setValue:@"no" forKey:@"shuju"];
        [userPoint setObject:dict forKey:@"GaiJi"];
        
        NSLog(@"user = %@",userPoint);
        NSLog(@"gaijishezhi= %@",dict);
        [userPoint synchronize];
        
        [gaijiTabView reloadData];
        self.tabBarController.tabBar.hidden = YES;
        _jiantou.enabled = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _tishiLab2.text = @"改机完成";
            
        });
        
    });
    
}
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}
@end
