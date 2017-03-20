//
//  SetViewController.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "SetViewController.h"
#import "NSString+Hashing.h"
#import "AboutViewController.h"
#import "AppManage.h"
#import "MBProgressHUD.h"
#import "ApplicationViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "FakeApplicationViewController.h"
#import "Pingpp.h"
#import "AFNetworking.h"
#import "TXYTools.h"
#import "TXYConfig.h"
#import "UserAuth.h"
#import "UpdateViewController.h"
#import "JKAlertDialog.h"
#import "XieyiViewController.h"
#import "MobClick.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#include <notify.h>
#import "UMOnlineConfig.h"
#import "AFNetworking.h"
#import "TanchuViewController.h"
#import <BmobSDK/Bmob.h>
#import "UMOnlineConfig.h"
#import "QiehuanViewController.h"
#import "GoogleMapTileImageOperation.h"
//#import "UMSocial.h"
#import "UpdateService.h"
#import "PersonInfoViewController.h"
#import "RegistViewController.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "txysec.h"
#import "AES128.h"
#import<CommonCrypto/CommonDigest.h>
#import "XuanFuViewController.h"
//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0
#define iOS71 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView  *_tableView;
    UIView *_view;
    UILabel *_lable;
    UIButton *_machineCodeButton;
    UIButton *_buyButton;
    NSMutableArray *_allAppArray;
    UITextField *_textField;
    UITextField *_textField1;
    UILabel *_timeLable;
    NSString *whichM;
    MBProgressHUD* HUDbuy;
    UIView *_headerView1;
    NSString            *googleCacheSize;
}
@property (nonatomic) PayPalConfiguration *payPalConfiguration;
@property(nonatomic,strong) UIImageView *vipImgView;
@property(nonatomic,strong)UIView* loginView;
@property(nonatomic,strong)UIButton* loginBtn;
@property(nonatomic,strong)UIButton* registBtn;
@property(nonatomic,strong)UIView* registView;
@property(nonatomic,strong)UILabel* usernameLab;
@property(nonatomic,strong)UILabel* dataLab;
@property(nonatomic,strong)NSMutableArray* infoArr;
@property(nonatomic,strong)UIButton* buyBtn;
@property(nonatomic)BOOL isLogin;
@property(nonatomic,strong)UISwitch* xuanfuSwitch;
@end

@implementation SetViewController
#pragma obfuscate on
-(void)viewDidLoad{
    
    //判断登录状态
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSLog(@"%@%@",user,token);
    if (user&&token) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    // _xuanfuSwitch.on = NO;
    self.tabBarController.tabBar.hidden = YES;
    NSString *str = WhichMap;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:WhichMap];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    whichM = [plistDict objectForKey:@"WhichMap"];
    googleCacheSize = @"正在计算";
    self.title = @"设置";
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    _allAppArray = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    NSLog(@"_all.count = %d",_allAppArray.count);
    [self addTableView];//添加TableView
    [self heardView];//添加heardView
    _infoArr = [[NSMutableArray alloc]init];
    if (iOS71) {
        //导航栏字体颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //导航栏背景色
        self.navigationController.navigationBar.barTintColor=IWColor(60, 170, 249);
        //返回按钮颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    }
}

-(void)payOver:(NSNotification *)notification{
    NSString *msg=nil;
    if (notification.object) {
        msg=notification.object;
    }else{
        msg=@"支付成功 请重启软件";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  
    [[UserAuth sharedUserAuth] authValueFormWeb];
    [self reSetBuyStatus];
}

//购买
- (void)buyTXY{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付宝支付",@"微信支付",@"充值卡支付", nil];
    [alert setTag:3001];
    [alert show];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    _tableView.delegate = nil;
//    _tableView.dataSource = nil; 
}
-(void)updataUI
{
    //购买成功 然后调用这个方法
    //请求个人信息
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (user && token ) {
        //说明有账号 此时验证vip
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,GetUserInfo];//117
        NSDictionary *userDic = @{@"username":user,@"token":token};
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
       // NSLog(@"string ===== %@",stringR);
        NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"117",@"flag":@"4"};
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseDict) {
                int state = [responseDict[@"status"] integerValue];
                if (state == 0) {
                    NSString *data = responseDict[@"data"];
                    if(!data) return ;
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    if ([dic1[@"status"] integerValue]==0) {
                        //判断dic 的 vip字段
                        NSDictionary *dic = dic1[@"user_info"];
                        
                        if (dic[@"expire_time"]) {
                            int time = [dic[@"expire_time"] integerValue];
                            if(time !=0)
                            {
                                [[NSUserDefaults standardUserDefaults]setObject:[self timeFormatted:time] forKey:@"expiretime"];
                            }
                            else
                            {
                                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"expiretime"];
                            }
                        }
                        int isVip = [dic[@"vip"] integerValue];
                        if (isVip == 0) {
                            //非会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(0) forKey:@"authValue"];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                        }
                        else
                        {
                            //会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(1) forKey:@"authValue"];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                        }
                        if (user&&token) {
                            _isLogin = YES;
                            _usernameLab.text = user;
                            if ([[TXYTools sharedTools] isCanOpen]) {
                                self.vipImgView.image=[UIImage imageNamed:@"vip"];
                                _dataLab.hidden = NO;
                                _dataLab.text = [NSString stringWithFormat:@"到期时间:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"expiretime"]];
                                _buyBtn.hidden = YES;
                                _dataLab.hidden = NO;
                                _dataLab.frame = CGRectMake((Width - 200)/2, 60, 200, 30);
                                _usernameLab.frame = CGRectMake(0, 10, Width, 40);
                                _registView.frame = CGRectMake(0, 75, Width, 100);
                                _headerView1.frame = CGRectMake(0, 0, Width, 180);
                                NSLog(@"daoqishijian = %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"expiretime"]);
                            }else{
                                _dataLab.text = [NSString stringWithFormat:@"非会员"];
                                _buyBtn.hidden = NO;
                                _dataLab.hidden = YES;
                                _usernameLab.frame = CGRectMake(0, 5, Width, 40);
                                _buyBtn.frame = CGRectMake((Width - 160)/2 , 50, 160, 35);
                                _buyBtn.layer.cornerRadius = 17.5;
                                _registView.frame = CGRectMake(0, 75, Width, 90);
                                _headerView1.frame = CGRectMake(0, 0, Width, 170);
                                self.vipImgView.image=[UIImage imageNamed:@"noVip"];
                            }
                            _tableView.tableHeaderView = _headerView1;
                            _registView.hidden = NO;
                            _loginView.hidden = YES;
                        }else{
                            self.vipImgView.image=[UIImage imageNamed:@"noVip"];
                            _isLogin = NO;
                            _registView.hidden = YES;
                            _loginView.hidden = NO;
                        }
                        NSLog(@"@--------------@");
                        self.tabBarController.tabBar.hidden = NO;
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            googleCacheSize = [GoogleMapTileImageOperation getMapTileCacheSize];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_tableView reloadData];
                            });
                        });
                        
                        [_allAppArray removeAllObjects];
                        [[AppManage sharedAppManage]getAllAppArray];
                        NSMutableArray* array = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
                        NSLog(@"array = %@",array);
                        for (int i = 0; i<array.count;i++ ) {
                            NSLog(@"name = %@",[[AppManage sharedAppManage] getAppNameForBundleId:array[i]]);
                            if (![[AppManage sharedAppManage] getAppNameForBundleId:array[i]]) {
                                [[TXYConfig sharedConfig]deleteLocationWithBundleId:array[i]];
                            }
                        }
                        _allAppArray = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
                        [_infoArr removeAllObjects];
                        if (_isLogin) {
                            [_infoArr addObject:@"个人信息"];
                            [_infoArr addObject:@"联系客服"];
                         //   [_infoArr addObject:@"开启悬浮控制器"];
                        }else{
                            [_infoArr addObject:@"联系客服"];
                       //     [_infoArr addObject:@"开启悬浮控制器"];
                        }
                        [_tableView reloadData];
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUDasd];
            HUDasd.labelText = @"服务器请求失败,请检查网络";
            //如果设置此属性则当前的view置于后台
            HUDasd.dimBackground = YES;
            HUDasd.yOffset = 20;
            HUDasd.mode = MBProgressHUDModeText;
            [HUDasd show:YES];
            [HUDasd hide:YES afterDelay:2];
        }];
    }
}
//转化时间
- (NSString *)timeFormatted:(int)totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:localeDate];
    NSLog(@"strDate=%@",strDate);
    return strDate;
}
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updataUI) name:@"updata" object:nil];
    //判断登录状态
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *time = [[NSUserDefaults standardUserDefaults]objectForKey:@"expiretime"];
    NSLog(@"%@%@",user,token);
    if (user&&token) {
        _isLogin = YES;
        _usernameLab.text = user;
        if ([[TXYTools sharedTools] isCanOpen]) {
            self.vipImgView.image=[UIImage imageNamed:@"vip"];
            _dataLab.hidden = NO;
            _dataLab.text = [NSString stringWithFormat:@"到期时间:%@",time];
            _buyBtn.hidden = YES;
            _dataLab.frame = CGRectMake((Width - 200)/2, 60, 200, 30);
            _usernameLab.frame = CGRectMake(0, 10, Width, 40);
            _registView.frame = CGRectMake(0, 75, Width, 100);
            _headerView1.frame = CGRectMake(0, 0, Width, 180);
            NSLog(@"daoqishijian = %@",time);
        }else{
            _dataLab.text = [NSString stringWithFormat:@"非会员"];
            _buyBtn.hidden = NO;
            _dataLab.hidden = YES;
            self.vipImgView.image=[UIImage imageNamed:@"noVip"];
            _usernameLab.frame = CGRectMake(0, 5, Width, 40);
            _buyBtn.frame = CGRectMake((Width - 160)/2 , 50, 160, 35);
            _buyBtn.layer.cornerRadius = 17.5;
            _registView.frame = CGRectMake(0, 75, Width, 90);
            _headerView1.frame = CGRectMake(0, 0, Width, 170);
        }
        
        _registView.hidden = NO;
        _loginView.hidden = YES;
        _tableView.tableHeaderView = _headerView1;
    }else{
        self.vipImgView.image=[UIImage imageNamed:@"noVip"];
        _isLogin = NO;
        _registView.hidden = YES;
        _loginView.hidden = NO;
        _headerView1.frame = CGRectMake(0, 0, Width, 150);
        _buyBtn.hidden = NO;
        _buyBtn.frame = CGRectMake((Width - 160)/2 , 80, 160, 40);
        _buyBtn.layer.cornerRadius = 20;
        _tableView.tableHeaderView = _headerView1;
    }
    
    [_allAppArray removeAllObjects];
    [[AppManage sharedAppManage]getAllAppArray];
    NSMutableArray* array = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    NSLog(@"array = %@",array);
    for (int i = 0; i<array.count;i++ ) {
        NSLog(@"name = %@",[[AppManage sharedAppManage] getAppNameForBundleId:array[i]]);
        if (![[AppManage sharedAppManage] getAppNameForBundleId:array[i]]) {
            [[TXYConfig sharedConfig]deleteLocationWithBundleId:array[i]];
        }
    }
    _allAppArray = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    [_infoArr removeAllObjects];
    if (_isLogin) {
        [_infoArr addObject:@"个人信息"];
        [_infoArr addObject:@"联系客服"];
   //     [_infoArr addObject:@"开启悬浮控制器"];
    }else{
        [_infoArr addObject:@"联系客服"];
     //   [_infoArr addObject:@"开启悬浮控制器"];
    }
//    [_tableView reloadData];
    self.tabBarController.tabBar.hidden = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        googleCacheSize = [GoogleMapTileImageOperation getMapTileCacheSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
  //  self.tabBarController.tabBar.hidden=NO;
    if (!iOS71) {
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
        UIView *contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame=CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height+tabBar.bounds.size.height);
    }
 
}


-(void)reSetBuyStatus{
    NSInteger value=[[UserAuth sharedUserAuth] authValueForFile];
    if(value==1){
      //  self.vipImgView.image=[UIImage imageNamed:@"vip"];
        _lable.text=@"已经购买";
        _timeLable.text = [NSString stringWithFormat:@"到期时间: %@",[self getCurrentDateString]];
        [_buyButton setTitle:@"继续购买" forState:UIControlStateNormal];
    }else{
     //   self.vipImgView.image=[UIImage imageNamed:@"noVip"];
        _timeLable.text = [NSString stringWithFormat:@"到期时间: 未购买"];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];
    }
    
}

//添加TableView
-(void)addTableView
{
    if (iOS71) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height ) style:(UITableViewStyleGrouped)];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - 64 ) style:(UITableViewStyleGrouped)];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//确保TablView能够正确的调整大小
    [self.view addSubview:_tableView];

    
}
//添加heardView
-(void)heardView
{
    //注册信息本地plist
    NSString *str = LoginPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:LoginPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSDictionary* loginDict = [plistDict objectForKey:@"loginInfo"];
    NSMutableDictionary* userLoginDict = nil;
    if (userLoginDict == nil){
        userLoginDict = [[NSMutableDictionary alloc]init];
    }else{
        userLoginDict = [NSMutableDictionary dictionaryWithDictionary:loginDict];
    }
    
    _headerView1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, Width, 180)];
    _headerView1.backgroundColor =IWColor(60, 170, 249);
    _tableView.tableHeaderView = _headerView1;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    self.vipImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noVip"]];
    self.vipImgView.frame=CGRectMake(0, 0, 60, 60);
    self.vipImgView.center=CGPointMake(Width/2, 45);
    [_headerView1 addSubview:self.vipImgView];
    
    /*_lable = [[UILabel alloc] initWithFrame:CGRectMake((Width-100)/2, 10,100, 40)];
    _lable.text = @"未购买";
    _lable.backgroundColor = IWColor(60, 170, 249);
    _lable.font = [UIFont systemFontOfSize:20];
    _lable.textColor = [UIColor whiteColor];
    _lable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_lable];*/
    
    //新版本注册登录界面
    _loginView = [[UIView alloc]init];
    _loginView.frame = CGRectMake(0, 60, Width, 100);
    _loginView.backgroundColor = [UIColor clearColor];
 
    //登录按钮
    _loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginBtn.frame = CGRectMake(Width/10*2, 35, Width/10*6, 35);
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.cornerRadius = 18;
    _loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:IWColor(60, 170, 249)];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    //注册按钮
    _registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _registBtn.frame = CGRectMake((Width - 200)/2, 50, 80, 50);
    _registBtn.layer.masksToBounds = YES;
    _registBtn.layer.cornerRadius = 10;
    [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn setBackgroundColor:IWColor(24, 118, 237)];
    [_registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_loginBtn];
   // [_loginView addSubview:_registBtn];
    
    NSLog(@"logindict = %@",loginDict);
    //新版本登录以后界面
    _registView = [[UIView alloc]init];
    _registView.frame = CGRectMake(0, 75, Width, 120);
    _registView.backgroundColor = [UIColor clearColor];
    _usernameLab = [[UILabel alloc]init];
    _usernameLab.frame = CGRectMake(0, 30, Width, 35);
    _usernameLab.textAlignment = NSTextAlignmentCenter;
    _usernameLab.textColor = [UIColor whiteColor];
    NSString* username = [loginDict objectForKey:@"username"];
    NSLog(@"username = %@",username);
    _usernameLab.text = username;
    _usernameLab.font = [UIFont systemFontOfSize:27];
    _usernameLab.backgroundColor = [UIColor clearColor];
    _dataLab = [[UILabel alloc]init];
    _dataLab.frame = CGRectMake((Width - 200)/2, 80, 200, 30);
    _dataLab.textAlignment = NSTextAlignmentCenter;
    _dataLab.textColor = [UIColor whiteColor];
    NSString* expiredata = [loginDict objectForKey:@"expiredate"];
    NSLog(@"expiredate = %@",expiredata);
   // _dataLab.text = [NSString stringWithFormat:@"到期时间:%@",expiredata];
    _dataLab.font = [UIFont systemFontOfSize:19];
    _dataLab.backgroundColor = [UIColor clearColor];
    //购买按钮
    _buyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _buyBtn.frame = CGRectMake((Width - 160)/2 , 80, 160, 40);
    [_buyBtn setTitle:@"购买享受更多服务" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn setBackgroundColor:IWColor(60, 170, 249)];
    [_buyBtn addTarget:self action:@selector(buyTXY) forControlEvents:UIControlEventTouchUpInside];
    _buyBtn.layer.masksToBounds = YES;
    _buyBtn.layer.cornerRadius = 7;
    _buyBtn.layer.borderWidth = 1;
    _buyBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_registView addSubview:_usernameLab];
    [_registView addSubview:_dataLab];
     [_registView addSubview:_buyBtn];
    [_headerView1 addSubview:_registView];
    [_headerView1 addSubview:_loginView];
    if (_isLogin) {
        _loginView.hidden = YES;
        _registView.hidden = NO;
        _buyBtn.hidden = YES;
        _headerView1.frame = CGRectMake(0, 0, Width, 180);
    }else{
        _headerView1.frame = CGRectMake(0, 0, Width, 150);
        _buyBtn.hidden = YES;
        _loginView.hidden = NO;
        _registView.hidden = YES;
    }
    //老版本机器码界面
    /*
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake((Width-300)/2, 75,300, 40)];
    _timeLable.text = [NSString stringWithFormat:@"到期时间: %@",[self getCurrentDateString]];
    _timeLable.font = [UIFont systemFontOfSize:16];
    _timeLable.backgroundColor = IWColor(60, 170, 249);
    _timeLable.textColor = [UIColor whiteColor];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_timeLable];
    
    _machineCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *deviceID = [[TXYTools sharedTools] machineCode];
    
    NSMutableString *devideID = [[NSMutableString alloc] init];
    for (int i = 0; i < 4; i++) {
        [devideID appendString:[deviceID substringWithRange:NSMakeRange(i*4, 4)]];
        if (i != 3) {
            [devideID appendString:@"-"];
        }
    }
    
    [_machineCodeButton setTitle:[NSString stringWithFormat:@"机器码 %@",devideID]  forState:(UIControlStateNormal)];
    [_machineCodeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _machineCodeButton.frame = CGRectMake(20, 105, Width-10*4, 40);
    if (iOS71) {
        _machineCodeButton.titleLabel.tintColor=[UIColor whiteColor];
    }
    _machineCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_machineCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //_machineCodeButton.backgroundColor = [UIColor whiteColor];
    [_machineCodeButton addTarget:self action:@selector(machineCode) forControlEvents:(UIControlEventTouchUpInside)];
    //_machineCodeButton.layer.cornerRadius = 20;
    
    [headerView addSubview:_machineCodeButton];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyButton setTitle:@"购买" forState:(UIControlStateNormal)];
    _buyButton.frame = CGRectMake(0, 0,Width*0.8, 40);
    _buyButton.center=CGPointMake(Width/2, 170);
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_buyButton addTarget:self action:@selector(buy) forControlEvents:(UIControlEventTouchUpInside)];
    _buyButton.layer.borderWidth = 1;
    _buyButton.layer.cornerRadius = 20;
    _buyButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    [headerView addSubview:_buyButton];
    */
    
    //版权view
    /*UIView* banView = [[UIView alloc]init];
    banView.frame = CGRectMake(0, Height  , Width, 50);
    UILabel* lab1 = [[UILabel alloc]init];
    lab1.text = @"Copyright@2006-2018";
    lab1.frame = CGRectMake(0, 0, Width, 20);
    lab1.textAlignment = 1;
    lab1.textColor = [UIColor grayColor];
    
    UILabel* lab2 = [[UILabel alloc]init];
    lab2.text = @"北京天下在线科技有限公司";
    lab2.frame = CGRectMake(0, 20, Width, 20);
    lab2.textAlignment = 1;
    lab2.textColor = [UIColor grayColor];
    
    [banView addSubview:lab1];
    [banView addSubview:lab2];
    
    _tableView.tableFooterView = banView;*/
}
#pragma mark - 登录
//登录
- (void)login{
    LoginViewController* lgvc = [[LoginViewController alloc]init];
    self.tabBarController.tabBar.hidden= YES;
    [self.navigationController pushViewController:lgvc animated:YES];
}
#pragma mark - 注册
//注册
- (void)regist{
    RegistViewController* registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

//获得到期时间
- (NSString *)getCurrentDateString
{
    NSString *endTime=[[TXYConfig sharedConfig]getDaoQiTime];
    NSLog(@"%@",endTime);
    if (endTime.length<10) {
        return @"非会员";
    }else{
        endTime=[endTime substringToIndex:10];
        return endTime;
    }
    
    /*NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;*/
}

-(void)machineCode
{
    NSString *deviceID = [[TXYTools sharedTools] machineCode];
    
    NSMutableString *devideID = [[NSMutableString alloc] init];
    for (int i = 0; i < 4; i++) {
        [devideID appendString:[deviceID substringWithRange:NSMakeRange(i*4, 4)]];
        if (i != 3) {
            [devideID appendString:@"-"];
        }
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:devideID];
    MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    toast.mode = MBProgressHUDModeText;
    //CFBundleInternalVersion
    toast.labelText = [NSString stringWithFormat:@"机器码已复制"];
    toast.margin = 10.f;
    toast.yOffset = 150.f;
    toast.removeFromSuperViewOnHide = YES;
    [toast hide:YES afterDelay:1];
    return;
}

-(void)buy
{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付宝支付",@"微信支付",@"银联支付",@"充值卡",@"Paypal支付", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付宝支付",@"微信支付",@"银联支付",@"充值卡", nil];
    [alert setTag:1];
    [alert show];
}

#define key1 @"123456789"
#define key2 @"987654321"
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1) {
        if (buttonIndex ==1) {
            [self PingppWithType:PaypalBtnAlipay];//ping++ 支付
        }else if (buttonIndex == 2){
            [self PingppWithType:PaypalBtnWx];
        }else if (buttonIndex == 3){
            [self PingppWithType:PaypalBtnUp];
        }else if (buttonIndex == 4){
            [self rechargepay];
        }
        else if (buttonIndex == 5){
            [self createPaypalOrder];//Paypal支付
        }
    }
    if (alertView.tag==2) {
        if (buttonIndex == 0) {
            return;
        }
        UITextField* tf1 = [alertView textFieldAtIndex:0];
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        if (![tf1.text isEqualToString:@""]) {
            NSString* sn = tf1.text;
            NSString* uname = _usernameLab.text;
            NSString*code = [NSString stringWithFormat:@"%@%@%@",both_pub_key,sn,uname];
            NSString* vcode = [self sha1:code];
            NSDictionary *dic = @{@"sn":sn,@"uname":uname,@"vcode":vcode};
            NSDictionary *oldDic = @{@"sn":@"T14492473011427504147a",@"uname":@"yuanxing1981",@"vcode":@"dc47602b4c2b849d7176b62c08241edd90f4d961"};
            AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
            mgr.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [NSString stringWithFormat:@"%@",chongzhika];
            NSLog(@"dic = %@ url = %@ oldDic = %@",dic,url,oldDic);
            NSString* newurl = @"http://ipay.txyapp.com:8181/appsrv/mobi/charge";
            NSString* xindeUrl = @"http://daili.txyapp.com:8181/appsrv/mobi/charge";
            [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *responseDict=responseObject;
                NSLog(@"responseDict = %@",responseDict);
                if (responseObject) {
                    NSString* cd = responseDict[@"cd"];
                    NSString* message = responseDict[@"message"];
                    if ([cd isEqualToString:@"1"]) {//充值成功
                        //会员
                        NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                        [setDict setObject:@(1) forKey:@"authValue"];
                        [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                         //如果充值是本号，刷新页面
                            [self updataUI];
                        HUD.labelText = message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                    if ([cd isEqualToString:@"-1"]) {//没卡号
                        HUD.labelText = message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                    if ([cd isEqualToString:@"-2"]) {//没该用户
                        HUD.labelText = message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                    if ([cd isEqualToString:@"-3"]) {//有卡但是卡用过了
                        HUD.labelText = message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                    if ([cd isEqualToString:@"-4"]) {//服务内部错
                        HUD.labelText = message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                    if ([cd isEqualToString:@"-5"]) {//校验没通过
                        HUD.labelText =message;
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.5];
                        return;
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"----------------------%@",error);
                HUD.labelText = @"网络连接失败,请检查网络";
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.5];
                return;

               
            }];
            
        }else{
            HUD.labelText = @"卡号不能为空";
            //如果设置此属性则当前的view置于后台
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:0.7];
            return;
        }
    }
    if (alertView.tag==3 && buttonIndex==1) {
        [[NSFileManager defaultManager] removeItemAtPath:kSetPlist error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:WhichMap error:nil];
        NSString *dbPath5=[NSString stringWithFormat:@"%@/Library/Caches/5.db", NSHomeDirectory()];
        NSString *dbPath6=[NSString stringWithFormat:@"%@/Library/Caches/6.db", NSHomeDirectory()];
        [[NSFileManager defaultManager] removeItemAtPath:dbPath5 error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:dbPath6 error:nil];
        
        [GoogleMapTileImageOperation clearMapTileDiskCache];
        
        NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
        [userDe removeObjectForKey:@"history"];
        [userDe removeObjectForKey:@"historyGMP"];
        [userDe removeObjectForKey:@"collect"];
        [userDe removeObjectForKey:@"First"];
        [userDe synchronize];
        exit(0);
    }
    
    if (alertView.tag==4) {
        if (buttonIndex == 1) {
            NSLog(@"更新");
            [self rewriteAppCydiaHtml];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"cydia://url/%@/cydia.html", docDir]]];
            NSLog(@"%@",docDir);
            exit(0);
  
        }else if(buttonIndex==2){
             MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
             [self.view addSubview:hud];
             hud.mode=MBProgressHUDModeIndeterminate;
             [hud show:YES];
             
             NSString *url=[UMOnlineConfig getConfigParams:@"url"];
             NSLog(@"%@",url);
             
             //下载准备
             NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
             AFHTTPRequestOperation *requestOper=[[AFHTTPRequestOperation alloc]initWithRequest:request];
             // 下载
             // 指定文件保存路径，将文件保存在沙盒中
             NSString *cachePath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
             NSString *filePath=[cachePath stringByAppendingPathComponent:@"txy.deb"];
             filePath=@"/var/mobile/Library/Preferences/txy.deb";
             NSLog(@"%@",filePath);
             requestOper.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
             //监听下载进度
             [requestOper setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                 CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
                 hud.progress=precent;
                 hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(precent*100)];
             }];
             //下载结果
             [requestOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"下载成功");
                 hud.labelText = @"正在安装";
                 system("killall -9 Cydia");
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        notify_post("com.txyupdata.start");
                 });
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"下载失败");
             [hud removeFromSuperview];
             if (error) {
             NSLog(@"%@",error);
             }
             }];
             
             [requestOper start];
        }else{
            NSLog(@"取消");
            
        }
    }
    if (alertView.tag == 3001) {
        if (buttonIndex ==1) {
            [self Alipay];
        }else if (buttonIndex == 2){
            [self Wxpay];
        }
        if (buttonIndex == 3){
            NSLog(@"haahaha");
            [self rechargepay];
        }
    }
}
//支付宝支付
-(void)Alipay
{
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (user && token) {
        NSDictionary *userDic = @{@"username":user ,@"token":token};
        NSLog(@"%@",userDic);
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
       // NSLog(@"string ===== %@",stringR);
        NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
        
        
        //NSString *stringBody = [self encodeString:bbbb];
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"301",@"flag":@"4"};
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,buildAliPayOrder];//301
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseDict) {
                int state = [responseDict[@"status"] integerValue];
                NSLog(@"%@",[responseDict[@"status"] class]);
                if (state == 0) {
                    //创建成功
                    NSString *data = responseDict[@"data"];
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
                    //请求成功以后 开始创建订单
                    if(dic)
                    {
                        NSString *orderString = dic[@"data"];
                        NSString *appScheme = @"alisdkdemo";
                        // NOTE: 调用支付结果开始支付
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@ class == %@",resultDic,[resultDic[@"resultStatus"]class]);
                            if (resultDic) {
                                if ([resultDic[@"resultStatus"] integerValue]==9000) {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"支付成功";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==8000)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"正在处理中";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==4000)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"订单支付失败";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==5000)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"重复请求";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6001)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"用户中途取消";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6002)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"网络连接出错";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6004)
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"支付结果未知";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else
                                {
                                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUDbuy];
                                    HUDbuy.labelText = @"支付错误";
                                    HUDbuy.dimBackground = YES;
                                    HUDbuy.yOffset = 20;
                                    HUDbuy.mode = MBProgressHUDModeText;
                                    [HUDbuy show:YES];
                                    [HUDbuy hide:YES afterDelay:0.7];
                                    return ;
                                }
                            }
                        }];
                    }
                }
                else
                {
                    HUDbuy = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUDbuy];
                    HUDbuy.labelText = @"订单创建失败";
                    HUDbuy.dimBackground = YES;
                    HUDbuy.yOffset = 20;
                    HUDbuy.mode = MBProgressHUDModeText;
                    [HUDbuy show:YES];
                    [HUDbuy hide:YES afterDelay:0.7];
                    return ;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
//微信支付
-(void)Wxpay
{
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (user && token) {
        NSDictionary *userDic = @{@"username":user,@"token":token};
        NSLog(@"%@",userDic);
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
      //  NSLog(@"string ===== %@",stringR);
        NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
        
        
        //NSString *stringBody = [self encodeString:bbbb];
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"302",@"flag":@"4"};
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        //mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,buildWXOrder];//302
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseObject) {
                int state = [responseDict[@"status"] integerValue];
                NSLog(@"%@",[responseDict[@"status"] class]);
                if (state == 0) {
                    NSString *data = responseDict[@"data"];
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
                    if([dic[@"status"] integerValue]==0)
                    {
                        //表示创建订单成功
                        PayReq *request = [[PayReq alloc]init];
                        request.partnerId = dic[@"partnerid"];
                        request.prepayId= dic[@"prepayid"];
                        request.package = dic[@"package"];
                        request.nonceStr= dic[@"noncestr"];
                        request.timeStamp= [dic[@"timestamp"] doubleValue];
                        request.sign= dic[@"sign"];
                        [WXApi sendReq:request];
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted  error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}


- (void)rewriteAppCydiaHtml
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cydia" ofType:@"html"];
    NSString *CydiaLogo = [[NSBundle mainBundle] pathForResource:@"Cydia_logo" ofType:@"png"];
    NSString *CydiaBtn = [[NSBundle mainBundle] pathForResource:@"Cydia_btn" ofType:@"png"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSString *log_text = [[NSString alloc] initWithData:
                          [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########LOGO" withString:CydiaLogo];
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########BTN" withString:CydiaBtn];
    [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //BOOL bRet = [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //    NSLog(@"write result %d", bRet);
}

//充值卡
-(void)rechargepay
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入卡号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _textField = [[UITextField alloc]init];
    _textField = [alert textFieldAtIndex:0];
    _textField.placeholder = @"充值卡号";
    alert.delegate = self;
    [alert setTag:2];
    [alert show];
}

//ping++ 支付
-(void)PingppWithType:(channelType)channeltype
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = [NSString stringWithFormat:@"正在创建订单"];
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1];
    
    NSString *channelStr;
    if (channeltype == PaypalBtnAlipay) {
        channelStr = @"alipay";
    }else if (channeltype ==PaypalBtnWx){
        channelStr = @"wx";
    }else if (channeltype == PaypalBtnUp){
        channelStr = @"upacp";
    }
    NSString *machineCode= [[TXYTools sharedTools] machineCode];
    NSString *string = [NSString stringWithFormat:@"http://pay.txyapp.com/Plug/ping/pay.php?channel=%@&cardid=54&carduser=%@&daihao=11223344&&user",channelStr,machineCode];
    NSLog(@"---------------%@",string);
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"---------------%@",request);
    request.HTTPMethod = @"GET";
    request.timeoutInterval=20;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请重试。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        }
        NSString *resStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resStr);
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
        NSLog(@"%@",resDict);
        
        NSLog(@"OK");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UserAuth sharedUserAuth] authValueFormWeb];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (int i=0; i<15; i++) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reSetBuyStatus];
                    });
                    sleep(1);
                }
            });
            
        });
    
        [Pingpp createPayment:resStr
               viewController:self
                 appURLScheme:@"txynewbaidu"
               withCompletion:^(NSString *result, PingppError *error) {
                   NSLog(@"%@ %@",result,error);
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                       NSLog(@"OK");
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [[UserAuth sharedUserAuth] authValueFormWeb];
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               for (int i=0; i<15; i++) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self reSetBuyStatus];
                                    });
                                   sleep(1);
                               }
                           });
    
                       });
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.labelText = @"支付确认中";
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功 请重启软件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                           [alert show];
                       });
                       
                   } else {
                       // 支付失败或取消
                       NSLog(@"%@",error);
                       NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                       [alert show];
                   }
               }];
    }];
}

//Paypal支付
- (void)createPaypalOrder
{
    //跟天下游服务器通信  获取咱们服务器生成的订单号
    NSString *machineCode = [[TXYTools sharedTools] machineCode];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pay.txyapp.com/Plug/paypal/pay.php?cardid=54&carduser=%@&daihao=11223344&user=bs",machineCode]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary * responseJSON=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseJSON);
        [self payOrder:[responseJSON objectForKey:@"orderno"]];
    }];
    
    /*MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = [NSString stringWithFormat:@"正在创建订单"];
    HUD.removeFromSuperViewOnHide = YES;
    
    NSString *machineCode = [[TXYTools sharedTools] machineCode];
    NSString *string =[NSString stringWithFormat:@"http://pay.txyapp.com/Plug/paypal/pay.php?cardid=54&carduser=%@&daihao=11223344&user=""",machineCode];
    NSLog(@"---------%@",string);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *operation = [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _payPalConfig = [[PayPalConfiguration alloc] init];
        _payPalConfig.acceptCreditCards = NO;
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = [[NSDecimalNumber alloc] initWithString:@"19.9"];
        payment.shortDescription = @"天下游全功能版";
        payment.currencyCode = @"USD";
        _payPalConfig.acceptCreditCards = NO;
        
        PayPalPaymentViewController *payController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:_payPalConfig delegate:self];
        [self presentViewController:payController animated:YES completion:nil];
        
        [HUD hide:YES afterDelay:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HUD hide:YES afterDelay:1];
    }];*/
    
}

- (void)payOrder:(NSString *)orderNo
{
    //支付
    self.payPalConfiguration = [[PayPalConfiguration alloc] init];
    self.payPalConfiguration.acceptCreditCards = NO;
    self.payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    //sandbox 测试模式   上线时要改成production生产模式
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"19.9"];
    payment.shortDescription = @"天下游";
    payment.currencyCode = @"USD";
    //设置为咱自己生成的订单号
    payment.custom = orderNo;
    self.payPalConfiguration.acceptCreditCards = NO;
    
    PayPalPaymentViewController *payController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                        configuration:self.payPalConfiguration
                                                                                             delegate:self];
    [self presentViewController:payController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功 请重启软件" message:nil
                                                   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    NSLog(@"%@",completedPayment);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付取消" message:nil
                                                   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
}



/**
 *   UITableViewDataSource
 */

//Section 的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//Section 的 row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _infoArr.count;
    }else if(section == 1){
        return 1;
    }
    else if(section == 2){
        return 1;
    }
    else if (section == 3){
        NSLog(@"count = %d",_allAppArray.count);
        return  _allAppArray.count+1;
    }else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIndentfier = @"cellIndentfier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentfier];
        }
        if (_infoArr.count>1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"个人信息";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image=[UIImage imageNamed:@"gerenxinxi"];
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"联系客服";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image=[UIImage imageNamed:@"lianxikefu"];
            }
            
        }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"联系客服";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"lianxikefu"];
                }
        }
        /*if (indexPath.row == 1) {
            cell.textLabel.text = @"多语言环境";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"default_more_wallet"];
        }*/
        
        return cell;
    }else if (indexPath.section == 2){
        
        static NSString *cellIndentfier = @"whichMapCellIndentfier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentfier];
        }
        cell.textLabel.text = @"地图类型选择";
        NSString* ditu;
        if ([whichM isEqualToString:@"baidu"] || !whichM) {
            ditu = @"当前地图:百度";
        }
        if ([whichM isEqualToString:@"tencent"]) {
            ditu = @"当前地图:腾讯";
        }
        if ([whichM isEqualToString:@"google"]) {
            ditu = @"当前地图:谷歌";
        }
        NSLog(@"ditu = %@",ditu);
        cell.detailTextLabel.text=ditu;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image=[UIImage imageNamed:@"dituqiehuan"];
        return cell;
    }
    else if (indexPath.section == 4){
        
        static NSString *cellIndentfier = @"Indentfier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentfier];
        }
        cell.detailTextLabel.text=nil;

        if (indexPath.row == 0) {
            cell.textLabel.text = @"分享";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"fenxaingtupian@2x"];
            return cell;
        }
        /*if (indexPath.row == 1) {
            cell.textLabel.text = @"问题反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }*/
        if (indexPath.row == 1) {
            cell.textLabel.text = @"版本更新";
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"当前版本:%@",version];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"gengxin"];
            return cell;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"用户协议";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"yonghuxieyi"];
            return cell;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"恢复初始状态";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"APhuifuchuchang"];
            return cell;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"地图弹出菜单设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image=[UIImage imageNamed:@"caidan"];
            return cell;
        }
        if (indexPath.row == 5) {
            cell.textLabel.text = @"清除谷歌地图缓存";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text= googleCacheSize;
            cell.imageView.image=[UIImage imageNamed:@"B-qingchuhuancun"];
            return cell;
        }
     
        return cell;
    }
    else {
        static NSString *cellIndentfier = @"AppcellIndentfier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentfier];
            cell.tag = indexPath.row;
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.detailTextLabel.text = @"";
        if (indexPath.section == 1) {
            cell.textLabel.text = @"开启悬浮控制器";
            //     cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image=[UIImage imageNamed:@"tuoyuan-1"];
            _xuanfuSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(Width - 100, 10, 79, 36)];
            _xuanfuSwitch.onTintColor = IWColor(60, 170, 249);
            _xuanfuSwitch.tintColor = IWColor(245, 245, 245);
            [_xuanfuSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
            NSString *str = XuanFuSWPlist;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuSWPlist];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSString* xuanfu = [plistDict objectForKey:@"isXuanfu"];
            if ([xuanfu isEqualToString:@"yes"] ){
                _xuanfuSwitch.on = YES;
            }else{
                _xuanfuSwitch.on = NO;
            }
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
           
            cell.accessoryView = _xuanfuSwitch;
            UILabel * lab = [[UILabel alloc]init];
            lab.frame = CGRectMake(_xuanfuSwitch.frame.origin.x-_xuanfuSwitch.frame.size.width-110,10, 100, 30);
            // lab.backgroundColor = [UIColor redColor];
            if (!jingdu ||[jingdu isEqualToString:@""]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"精度5m  "];
            }
            if (jingdu &&![jingdu isEqualToString:@""]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"精度%@  ",jingdu];
            }
        }
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"添加特别指定位置的程序";
                cell.imageView.image=[UIImage imageNamed:@"default_path_mainicon_subway_normal@3x@2x"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                [[AppManage sharedAppManage]getAllAppArray];
                cell.textLabel.text = [[AppManage sharedAppManage] getAppNameForBundleId:[_allAppArray objectAtIndex:indexPath.row-1]];
                NSLog(@"%@",cell.textLabel.text);
                NSLog(@"1 = %@",[[AppManage sharedAppManage] getAppNameForBundleId:[_allAppArray objectAtIndex:indexPath.row-1]]);
                cell.imageView.image = [[AppManage sharedAppManage] getIconForBundleId:[_allAppArray objectAtIndex:indexPath.row-1]];
        
                //当没有设置类型时
                if ([[[TXYConfig sharedConfig]getLocationWithBundleId:[_allAppArray objectAtIndex:indexPath.row-1]][@"FakeType"] intValue] == -1) {
                    cell.detailTextLabel.text = @"";
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    
                }
                //当为地图选点时
                if ([[[TXYConfig sharedConfig]getLocationWithBundleId:[_allAppArray objectAtIndex:indexPath.row-1]][@"FakeType"] intValue]== 3) {
                    cell.detailTextLabel.text = @"地图选点";
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                //当为收藏选点时
                if ([[[TXYConfig sharedConfig]getLocationWithBundleId:[_allAppArray objectAtIndex:indexPath.row-1]][@"FakeType"] intValue] == 2) {
                    
                    cell.detailTextLabel.text = @"收藏选点";
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                //当为真实位置时
                if ([[[TXYConfig sharedConfig]getLocationWithBundleId:[_allAppArray objectAtIndex:indexPath.row-1]][@"FakeType"] intValue] == 0) {
                    cell.detailTextLabel.text = @"真实位置";
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                //当为模拟位置时
                if ([[[TXYConfig sharedConfig]getLocationWithBundleId:[_allAppArray objectAtIndex:indexPath.row-1]][@"FakeType"] intValue] == 1) {
                    cell.detailTextLabel.text = @"模拟位置";
                    
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
        }
        return cell;
    }
}

//开关按钮的点击事件
-(void)switchClick:(UISwitch *)sender
{
    if (!iOS8) {
        sender.on = NO;
        [MyAlert ShowAlertMessage:@"系统版本过低，该功能仅支持iOS8以上版本" title:@"温馨提示"];
        return;
    }
    NSString *str = XuanFuSWPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuSWPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    if (sender.on) {
        NSLog(@"dianjiyixia");
        sender.on = YES;
        [plistDict setObject:@"yes" forKey:@"isXuanfu"];
        [plistDict writeToFile:XuanFuSWPlist atomically:YES];
        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(),
                                                        (CFStringRef)@"com.chinapyg.fakecarrier-change",
                                                        NULL,
                                                        nil,
                                                        kCFNotificationDeliverImmediately|kCFNotificationPostToAllSessions);
    }else{
        sender.on = NO;
       [plistDict setObject:@"no" forKey:@"isXuanfu"];
        [plistDict writeToFile:XuanFuSWPlist atomically:YES];
        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(),
                                                        (CFStringRef)@"com.chinapyg.fakecarrier-change",
                                                        NULL,
                                                        nil,
                                                        kCFNotificationDeliverImmediately|kCFNotificationPostToAllSessions);


    }
    return;
}

/**
 *  UITableViewDelegate
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return nil;
    }else if (section ==2){
        
        return @"切换地图";
    }else if (section == 3){
        return @"特别程序";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        ApplicationViewController* applicationViewController = [[ApplicationViewController alloc] init];
        applicationViewController.hidesBottomBarWhenPushed = YES;
        applicationViewController.delegate = self;
        [self.navigationController pushViewController:applicationViewController animated:YES];
        
    }
    if (indexPath.section == 1) {
        if (iOS8) {
            XuanFuViewController* xuanfu = [[XuanFuViewController alloc]init];
            [self.navigationController pushViewController:xuanfu animated:YES];
        }else{
            [MyAlert ShowAlertMessage:@"系统版本过低，该功能仅支持iOS8以上版本" title:@"温馨提示"];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        QiehuanViewController* qhvc = [[QiehuanViewController alloc]init];
        [self.navigationController pushViewController:qhvc animated:YES];
    }
    if(indexPath.section == 3 && indexPath.row >0){
        FakeApplicationViewController *fakeApplicationVC = [[FakeApplicationViewController alloc] init];
        [[AppManage sharedAppManage] getAllAppArray];
        fakeApplicationVC.appId = _allAppArray[indexPath.row - 1];
        fakeApplicationVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:fakeApplicationVC animated:YES];
    }else if (indexPath.section == 0) {
        if (_infoArr.count>1) {
            if (indexPath.row == 0) {
 
                PersonInfoViewController* personInfo = [[PersonInfoViewController alloc]init];
                [self.navigationController pushViewController:personInfo animated:YES];
                
            }else if(indexPath.row == 1){
                AboutViewController* aboutViewController = [[AboutViewController alloc] init];
                aboutViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutViewController animated:YES];
            }else{
                
            }
            
        }else{
            if (indexPath.row == 0) {
                AboutViewController* aboutViewController = [[AboutViewController alloc] init];
                aboutViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutViewController animated:YES];
            }else{
                
            }
        }
       
    }else  if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UmengKeyT
                                              shareText:@"天下游 - 最强的营销约炮神器 网站是 www.txyapp.com"
                                             shareImage:[UIImage imageNamed:@"shaImg"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone, nil]
                                               delegate:nil];
        }
        /*if (indexPath.row == 1) {
            [self presentModalViewController:[UMFeedback feedbackModalViewController]
                                    animated:YES];
            
            //UIViewController *feedBackView = [UMFeedback feedbackViewController];
            //feedBackView.hidesBottomBarWhenPushed = YES ;
            //[self.navigationController pushViewController:feedBackView animated:YES];
            
        }*/
        if (indexPath.row == 1) {
/*            [MobClick startWithAppkey:UmengKeyT reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [MobClick setAppVersion:version];
            [MobClick checkUpdateWithDelegate:self selector:@selector(updata:)];*/
            [[UpdateService defaultService] checkUpdateBeta];

        }
        if (indexPath.row == 2) {
            XieyiViewController* xyvc = [[XieyiViewController alloc]init];
            [self.navigationController pushViewController:xyvc animated:YES];
        }
        if (indexPath.row == 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"即将初始化软件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert setTag:3];
            [alert show];
        }
        if (indexPath.row == 4) {
            TanchuViewController* tcvc = [[TanchuViewController alloc]init];
            [self.navigationController pushViewController:tcvc animated:YES];
        }
        if (indexPath.row == 5) {
            googleCacheSize = @"清除中...";
            [tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [GoogleMapTileImageOperation clearMapTileDiskCache];
                googleCacheSize = [GoogleMapTileImageOperation getMapTileCacheSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            });
            
        }
 
    }
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*- (void)updata:(NSDictionary *)appInfo{
    NSLog(@"%@",appInfo);
    NSString *update_log=[appInfo objectForKey:@"update_log"];
    NSString *newVersion=[appInfo objectForKey:@"version"];
    BOOL isupdata=[[appInfo objectForKey:@"update"] boolValue];
    if (isupdata) {
        NSString *title=[NSString stringWithFormat:@"发现新版本 v%@",newVersion];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:update_log delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"方式一：cydia更新",@"方式二：下载更新", nil];
        alert.tag=4;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=4;
        [alert show];
        
    }
}
*/
//-(void)dealloc
//{
//    self.tableView.delegate = nil;
//    self.tableView.dataSource = nil;
//}
- (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

//代理方法
- (void)chuancan:(NSMutableArray*)array{
    [_allAppArray removeAllObjects];
    _allAppArray = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];;
    [_tableView reloadData];
}


@end
