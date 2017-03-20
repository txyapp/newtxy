//
//  LoginViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "LoginTextFiled.h"
#import "ForgetViewController.h"
#import "txysec.h"
#import "TXYTools.h"
#import "RegistViewController.h"
#import "MBProgressHUD.h"
#import "AES128.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView  *_tableView,*_histeryTab;
    //账号 密码
    LoginTextFiled *_zhTextFlied,*_mmTextFiled;
    //图片
    UIImageView *imageViewUser,*imageViewPwd;
    UIButton *btnUser,*btnPwd;
    //标记密码是否可见
    int open,editing,IsRemember;
    //账号 密码
    NSString *userName,*passWord;
    //
    UIView *backV;
    //
    NSMutableArray *userArr;
}
@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
//    _tableView.delegate = nil;
//    _tableView.dataSource = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    open = 0;
    editing=0;
    IsRemember=0;
    self.navigationController.navigationBar.hidden = YES;
    userArr = [NSMutableArray arrayWithCapacity:0];
    [self initUI];
    [self loadData];
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    long long int date = (long long int)time;
//    NSLog(@"date----%lld",date);
    // Do any additional setup after loading the view.
}
//获取历史记录账号密码
-(void)loadData
{
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
   // NSLog(@"plistDict======%@",plistDict);
    NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
    NSMutableArray* userarray = nil;
    if (registArray == nil){
        userarray = [NSMutableArray array];
    }else{
        userarray = [NSMutableArray arrayWithArray:registArray];
    }
    for (NSDictionary *dic  in userarray) {
        if (dic[@"userName"]) {
            [userArr addObject:dic[@"userName"]];
        }
    }
    NSLog(@"userarr123 = %@",userArr);
}
//界面
-(void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height ) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    if (Height < 490) {
         _tableView.rowHeight = 45;
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//确保TablView能够正确的调整大小
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, -20, Width,Height);
    //(id)(IWColor(44, 119, 172)).CGColor
    layer.colors = [NSArray arrayWithObjects:(id)(IWColor(60, 170, 248)).CGColor,(id)(IWColor(42, 110, 160)).CGColor, nil];
//     layer.locations = @[@0.0f,@0.6f,@1.0f];
//    layer.startPoint = CGPointMake(0, 0);
//    layer.endPoint = CGPointMake(1, 0);
    [_tableView.layer insertSublayer:layer atIndex:0];
    
    
    //historyTab
    backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    backV.backgroundColor  = [UIColor clearColor];
    
    _histeryTab = [[UITableView alloc] initWithFrame:CGRectMake(12, 245, Width-24, 200) style:(UITableViewStylePlain)];
    if (Height < 490) {
          _histeryTab = [[UITableView alloc] initWithFrame:CGRectMake(12, 165, Width-24, 200) style:(UITableViewStylePlain)];
    }
    /// 设置圆角
    _histeryTab.layer.cornerRadius = 7;
    _histeryTab.layer.masksToBounds = YES;
    /// 设置边框
    _histeryTab.layer.borderWidth = 1;
    _histeryTab.layer.borderColor = [[UIColor whiteColor] CGColor];
    _histeryTab.delegate = self;
    _histeryTab.dataSource = self;
    _histeryTab.rowHeight = 50;
    if (Height < 490) {
        _histeryTab.rowHeight = 45;
    }
    _histeryTab.tag = 6000;
    _histeryTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _histeryTab.backgroundColor = [UIColor whiteColor];
    [backV addSubview:_histeryTab];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, _histeryTab.frame.origin.y - 5)];
    view1.backgroundColor = [UIColor clearColor];
    [backV addSubview:view1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _histeryTab.frame.origin.y + _histeryTab.frame.size.height +5   , Width, Height - (_histeryTab.frame.origin.y + _histeryTab.frame.size.height +5))];
    view2.backgroundColor = [UIColor clearColor];
    [backV addSubview:view2];
    
    //headview
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, Width, 180)];
    if (Height < 490) {
        headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, Width, 100)];
    }
    //headerView.backgroundColor =IWColor(60, 170, 249);
    _tableView.tableHeaderView = headerView;
    
    UIButton *backB = [UIButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(10, 10, 25, 25);
    [backB setImage:[UIImage imageNamed:@"fanhui1111.png"] forState:UIControlStateNormal];
    //backB.backgroundColor  = [UIColor whiteColor];
    [backB addTarget:self action:@selector(backToV) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backB];

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(75, 50, Width-150, 60)];
    if (Height < 490) {
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(75, 20, Width-150, 40)];
    }
    titleLab.text = @"天下游";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:45];
    if (Height < 490) {
        titleLab.font = [UIFont systemFontOfSize:25];
    }
    titleLab.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLab];
    UIImageView *titleV;
    titleV = [[UIImageView alloc]initWithFrame:CGRectMake(Width/3 - 20, 113, Width/3 + 40, 30)];
    if (Height < 490) {
        titleV = [[UIImageView alloc]initWithFrame:CGRectMake(Width/3 - 20, 63, Width/3 + 40, 30)];
    }
    titleV.image = [UIImage imageNamed:@"zhuanzhu@2x"];
    [headerView addSubview:titleV];
    UIView *footView;
    if (Height < 490) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 150)];

    }else{
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - 340)];
    }
   // footView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footView;
    
    //登陆按钮
    int h = Height-340;
    if (Height < 490) {
        h = Height-300;
    }
    UIButton *loginB = [UIButton buttonWithType:UIButtonTypeCustom];
    loginB.frame = CGRectMake(25, h/5, Width-50, 45);
    if (Height < 490) {
        loginB.frame = CGRectMake(25, h/5, Width-50, 35);
    }
    [loginB.layer setMasksToBounds:YES];
    loginB.layer.cornerRadius=20;
    if (Height < 490) {
        loginB.layer.cornerRadius=15;
    }
//    loginB.layer.borderColor = [[UIColor whiteColor] CGColor];
//    loginB.layer.borderWidth = 1;
    [loginB setTitle:@"登  陆" forState:UIControlStateNormal];
    loginB.backgroundColor = IWColor(59, 166, 242);
    [loginB addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loginB];
    //注册
    UIButton *registerB = [UIButton buttonWithType:UIButtonTypeCustom];
    registerB.frame = CGRectMake(25, h/5 + 65, Width-50, 45);
    if (Height < 490) {
        registerB.frame = CGRectMake(25, h/5 + 50, Width-50, 35);
    }
    [registerB.layer setMasksToBounds:YES];
    registerB.layer.cornerRadius=20;
    if (Height < 490) {
        registerB.layer.cornerRadius=15;
    }
//    registerB.layer.borderWidth = 1;
//    registerB.layer.borderColor = [[UIColor whiteColor] CGColor];
    [registerB setTitle:@"注 册" forState:UIControlStateNormal];
    registerB.backgroundColor = IWColor(59, 166, 242);
    [registerB addTarget:self action:@selector(registerBClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:registerB];
    //协议按钮
    
    UIButton *agreeB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    agreeB.frame = CGRectMake(25, h - 60, Width - 50, 30);
    if (Height < 490) {
        agreeB.frame = CGRectMake(25, h/5+100, Width - 50, 30);
    }
    [agreeB setTitle:@"《天下游用户协议》" forState:UIControlStateNormal];
    [agreeB setTitleColor:IWColor(122, 179, 221) forState:UIControlStateNormal];
    agreeB.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:agreeB];
    [self addAGesutreRecognizerForYourView];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestured)]; // 手势类型随你喜欢。
    tapGesture.delegate = self;
    [view1 addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestured)]; // 手势类型随你喜欢。
    tapGesture1.delegate = self;
    [view2 addGestureRecognizer:tapGesture1];
    [self.view addSubview:backV];
    backV.hidden = YES;
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

//登陆
-(void)login
{
    NSLog(@"IsRemember == %d",IsRemember);
    MBProgressHUD* LoginHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:LoginHUD];
    //对话框显示时需要执行的操作
    LoginHUD.mode = MBProgressHUDModeCustomView;
    LoginHUD.labelText = @"请稍后";
    //如果设置此属性则当前的view置于后台
    LoginHUD.dimBackground = YES;
    //显示对话框
    [LoginHUD showAnimated:YES whileExecutingBlock:^{

     
    } completionBlock:^{
        //操作执行完后取消对话框
    }];

    [self registerText];
    NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
    NSDictionary *userDic = nil;
    if (clientid) {
        userDic = @{@"username":_zhTextFlied.text,@"password":_mmTextFiled.text,@"clientid":clientid};
    }
    else
    {
        userDic = @{@"username":_zhTextFlied.text,@"password":_mmTextFiled.text};
    }
//    NSLog(@"%@",userDic);
    NSString *userString =[self convertToJSONData:userDic];
    NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
    NSString *stringR = [self convertToJSONData:requestDic];
    NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
    
    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"111",@"flag":@"4"};
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,LoginApi];
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict=responseObject;
        NSLog(@"responseDict = %@",responseDict);
        if (responseDict) {
            [LoginHUD removeFromSuperview];
            int state = [responseDict[@"status"] integerValue];
            NSLog(@"%@",[responseDict[@"status"] class]);
            if (state == 0) {
                //本机器码
                NSString *data = responseDict[@"data"];
                if(!data) return ;
                NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic status = %d",[dic[@"status"] integerValue]);
                if ([dic[@"status"] integerValue]==0) {
                    if (dic[@"token"]) {
                        NSLog(@"%@",dic[@"token"]);
                        [[NSUserDefaults standardUserDefaults]setObject:dic[@"token"] forKey:@"token"];
                    }
                    if (dic[@"username"]) {
                        NSLog(@"%@",dic[@"username"]);
                        [[NSUserDefaults standardUserDefaults]setObject:dic[@"username"] forKey:@"userName"];
                    }
                    if (dic[@"expiretime"]) {
                        int time = [dic[@"expiretime"] integerValue];
                        if(time !=0)
                        {
                            [[NSUserDefaults standardUserDefaults]setObject:[self timeFormatted:time] forKey:@"expiretime"];
                            NSLog(@"time = %@",[self timeFormatted:time]);
                        }
                        else
                        {
                            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"expiretime"];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
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
                    //登录成功的时候记住账号
                    //把会员状态存储起来,1是会员但未注册0是非会员未注册
                    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"NewUserStatus"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
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
                  //  NSLog(@"plistDict======%@",plistDict);
                   // NSMutableArray *getUser = plistDict[@"LoginUserName"];
                    NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
                    NSMutableArray* getUser = nil;
                    if (registArray == nil){
                        getUser = [NSMutableArray array];
                    }else{
                        getUser = [NSMutableArray arrayWithArray:registArray];
                    }
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:getUser];
                    //第一次时直接写入
                    if (arr.count == 0) {
                        NSDictionary *dic = @{@"userName":_zhTextFlied.text,@"passWord":IsRemember==1?_mmTextFiled.text:@"123",@"remember":[NSString stringWithFormat:@"%d",IsRemember]};
                        [getUser insertObject:dic atIndex:0];
                        [plistDict setObject:getUser forKey:@"LoginUserName"];
                        BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                        if (result) {
                            NSLog(@"存入成功");
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            return ;
                        }else{
                            NSLog(@"存入失败");
                        }
                    }else{
                        int exist = -1;
                        for(int i = 0;i<arr.count;i++)
                        {
                            NSDictionary *dic = arr[i];
                            if ([dic[@"userName"] isEqualToString:_zhTextFlied.text]) {
                                exist = i;
                            }
                        }
                        if (exist == -1) {
                            //表示没有这个账号存在
                            NSDictionary *dic = @{@"userName":_zhTextFlied.text,@"passWord":IsRemember==1?_mmTextFiled.text:@"123",@"remember":[NSString stringWithFormat:@"%d",IsRemember]};
                            [getUser insertObject:dic atIndex:0];
                            [plistDict setObject:getUser forKey:@"LoginUserName"];
                            BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                            if (result) {
                                NSLog(@"存入成功");
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                return ;
                            }else{
                                NSLog(@"存入失败");
                            }
                        }
                        else
                        {
                            //有这个账号的存在
                            [getUser removeObjectAtIndex:exist];
                            NSDictionary *dic = @{@"userName":_zhTextFlied.text,@"passWord":IsRemember==1?_mmTextFiled.text:@"123",@"remember":[NSString stringWithFormat:@"%d",IsRemember]};
                            [getUser insertObject:dic atIndex:0];
                            [plistDict setObject:getUser forKey:@"LoginUserName"];
                            BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                            if (result) {
                                NSLog(@"存入成功");
                                _tableView.delegate = nil;
                                _tableView.dataSource = nil;
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                return ;
                            }else{
                                NSLog(@"存入失败");
                            }
                        }
//                    for (NSDictionary *dic  in arr) {
//                        NSLog(@"_zhTextFlied.text =====  %@",_zhTextFlied.text);
//                        if (![dic[@"userName"]isEqualToString:_zhTextFlied.text]) {
//                            NSDictionary *dic = @{@"userName":_zhTextFlied.text,@"passWord":IsRemember==1?_mmTextFiled.text:@"123",@"remember":[NSString stringWithFormat:@"%d",IsRemember]};
//                            [getUser insertObject:dic atIndex:0];
//                            [plistDict setObject:getUser forKey:@"LoginUserName"];
//                            BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
//                            if (result) {
//                                NSLog(@"存入成功");
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                return ;
//                            }else{
//                                NSLog(@"存入失败");
//                            }
//                        }else if(![dic[@"remember"]isEqualToString:[NSString stringWithFormat:@"%d",IsRemember]]&&[dic[@"userName"]isEqualToString:_zhTextFlied.text]){
//                            int loca = 0;
//                            for (NSDictionary *dic  in getUser) {
//                                if ([dic[@"userName"] isEqualToString:_zhTextFlied.text]) {
//                                    loca = [getUser indexOfObject:dic];
//                                }
//                            }
//                            NSLog(@"%d",loca);
//                            [getUser removeObjectAtIndex:loca];
//                            NSDictionary *dic = @{@"userName":_zhTextFlied.text,@"passWord":IsRemember==1?_mmTextFiled.text:@"123",@"remember":[NSString stringWithFormat:@"%d",IsRemember]};
//                            [getUser insertObject:dic atIndex:0];
//                            [plistDict setObject:getUser forKey:@"LoginUserName"];
//                            BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
//                            if (result) {
//                                NSLog(@"存入成功");
//                                _tableView.delegate = nil;
//                                _tableView.dataSource = nil;
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                return ;
//                            }else{
//                                NSLog(@"存入失败");
//                            }
//                        }
//                        else if([dic[@"remember"]isEqualToString:[NSString stringWithFormat:@"%d",IsRemember]]&&[dic[@"userName"]isEqualToString:_zhTextFlied.text])
//                        {
//                            int loca = 0;
//                            for (NSDictionary *dic  in getUser) {
//                                if ([dic[@"userName"] isEqualToString:_zhTextFlied.text]) {
//                                    loca = [getUser indexOfObject:dic];
//                                }
//                                //NSLog(@"%@",dic);
//                            }
//                            [getUser exchangeObjectAtIndex:0 withObjectAtIndex:loca];
//                            NSLog(@"getUser====%@",getUser);
//                            [plistDict setObject:getUser forKey:@"LoginUserName"];
//                            BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
//                            if (result) {
//                                NSLog(@"存入成功");
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                return ;
//                            }else{
//                                NSLog(@"存入失败");
//                            }
//                        }
//                    }
                }
                }
                else
                {
                    NSLog(@"请求失败了");
                    [LoginHUD removeFromSuperview];
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                    //如果设置此属性则当前的view置于后台
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:2];
                    NSLog(@"dic[@""msg""] = %@",dic[@"msg"]);
                }
            }else{
                NSLog(@"请求失败了");
                [LoginHUD removeFromSuperview];
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"服务器验证失败";
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }
        }else{
            NSLog(@"请求失败了");
            [LoginHUD removeFromSuperview];
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"服务器验证失败";
            //如果设置此属性则当前的view置于后台
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [LoginHUD removeFromSuperview];
        NSLog(@"请求失败了");
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"服务器请求失败,请检查网络";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }];
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
-(NSString*)encodeString:(NSString*)unencodedString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)unencodedString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    
    return encodedString;
}
//历史记录
-(void)tapGestured
{
    backV.hidden = YES;
    [_zhTextFlied becomeFirstResponder];
}
//返回
-(void)backToV
{
    [self.navigationController popViewControllerAnimated:YES];
}
//注册
-(void)registerBClick
{
    //跳转注册
    RegistViewController *reg = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 6000) {
        return 1;
    }
    return 2;
}
//Section 的 row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 6000) {
        NSLog(@"userarr = %@",userArr);
        return userArr.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6000) {
        static NSString *cellIndentfier = @"AppcellIndentfier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentfier];
        }
        cell.textLabel.text=userArr[indexPath.row];
        UIButton *delB = [UIButton buttonWithType:UIButtonTypeCustom];
        delB.frame = CGRectMake(0, 0, 24, 24);
        [delB setBackgroundImage:[UIImage imageNamed:@"3144"] forState:UIControlStateNormal];
        cell.accessoryView = delB;
        delB.tag = 4000 + indexPath.row;
        [delB addTarget:self action:@selector(delHistory:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        LoginTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (userArr.count > 0) {
            ((UITextField *)[self.view viewWithTag:2000]).text = userArr[indexPath.row];
        }
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
      // NSLog(@"plistDict======%@",plistDict);
        
        NSMutableArray *getUser = plistDict[@"LoginUserName"];
        NSDictionary *dic;
        if (getUser.count >0) {
            dic = getUser[0];
        }
        NSLog(@"%@",dic);
        if (indexPath.section == 0) {
            imageViewUser=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 25, 25)];
            imageViewUser.image=[UIImage imageNamed:@"ic_login_username_checked1@2x"];
            btnUser = [UIButton buttonWithType:UIButtonTypeCustom];
            btnUser.frame = CGRectMake(Width - 65,0 , 20, 15);
            [btnUser setBackgroundImage:[UIImage imageNamed:@"ic_blue_downward_arrow@3x"] forState:UIControlStateNormal];
            [btnUser addTarget:self action:@selector(userHistory) forControlEvents:UIControlEventTouchUpInside];
            _zhTextFlied = [[LoginTextFiled alloc]initWithFrame:CGRectMake(15, 1, Width - 40, 43) drawingLeft:imageViewUser withRight:btnUser];
            if (dic) {
                _zhTextFlied.text = dic[@"userName"];
                userName = dic[@"userName"];
                IsRemember = [dic[@"remember"] integerValue];
            }
            _zhTextFlied.placeholder = @"请输入账号:";
            _zhTextFlied.textColor = [UIColor whiteColor];
            _zhTextFlied.delegate = self;
            _zhTextFlied.tag = 2000;
            _zhTextFlied.keyboardType = UIKeyboardTypeASCIICapable;
            _zhTextFlied.tintColor = [UIColor whiteColor];
            //[_zhTextFlied becomeFirstResponder];
            [cell.contentView addSubview:_zhTextFlied];
        }
        else
        {
            imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 25, 25)];
            imageViewPwd.image=[UIImage imageNamed:@"ic_login_password_checked1@2x"];
            btnPwd = [UIButton buttonWithType:UIButtonTypeCustom];
            btnPwd.frame = CGRectMake(Width - 65, 0, 18, 15);
            [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_blue_close_eye@2x"] forState:UIControlStateNormal];
            [btnPwd addTarget:self action:@selector(closeOrOpen) forControlEvents:UIControlEventTouchUpInside];
            _mmTextFiled = [[LoginTextFiled alloc]initWithFrame:CGRectMake(15, 1, Width - 40, 43) drawingLeft:imageViewPwd withRight:btnPwd];
            _mmTextFiled.secureTextEntry = YES;
            _mmTextFiled.textColor = [UIColor whiteColor];
            _mmTextFiled.tintColor = [UIColor whiteColor];
            _mmTextFiled.placeholder = @"请输入密码:";
            if (dic&&[dic[@"remember"]isEqualToString:@"1"]) {
                _mmTextFiled.text = dic[@"passWord"];
                passWord = dic[@"passWord"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_checked@2x"];
                });
            }
            IsRemember = [dic[@"remember"] integerValue];
            _mmTextFiled.delegate = self;
            _mmTextFiled.tag = 2001;
            [cell.contentView addSubview:_mmTextFiled];
        }
        return cell;
    }
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 6000) {
        return nil;
    }
    else
    {
        if (section == 1) {
            UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 80)];
            UIButton *remember = [UIButton buttonWithType:UIButtonTypeCustom];
            remember.frame = CGRectMake(20, 10, 100, 30);
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
            img.image = [UIImage imageNamed:@"ic_remember_password_normal@2x"];
            img.tag = 3000;
            [remember addSubview:img];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 70, 20)];
            lab.text = @"记住密码";
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:15];
            [remember addSubview:lab];
            [remember addTarget:self action:@selector(rememberUser:) forControlEvents:UIControlEventTouchUpInside];
            [footerV addSubview:remember];
    
            //忘记密码
            UIButton *forgetB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            forgetB.frame  = CGRectMake(Width - 100, 8, 80, 30);
            [forgetB setTitle:@"忘记密码?" forState:UIControlStateNormal];
            forgetB.titleLabel.font = [UIFont systemFontOfSize:15];
            [forgetB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [footerV addSubview:forgetB];
            [forgetB addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
            return footerV;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6000) {
        NSLog(@"%@",userArr);
        ((UITextField *)[self.view viewWithTag:2000]).text = userArr[indexPath.row];
        userName = userArr[indexPath.row];
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
     //   NSLog(@"plistDict======%@",plistDict);
        NSMutableArray *getUser = plistDict[@"LoginUserName"];
        for (NSDictionary *dic  in getUser) {
            if([dic[@"userName"] isEqualToString:userArr[indexPath.row]])
            {
                if (![dic[@"passWord"]isEqualToString:@"123"]) {
                    ((UITextField *)[self.view viewWithTag:2001]).text = dic[@"passWord"];
                    passWord = dic[@"passWord"];
                    if ([dic[@"remember"]isEqualToString:@"1"]) {
                        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_checked@2x"];
                    }
                    else if ([dic[@"remember"]isEqualToString:@"0"])
                    {
                        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_normal@2x"];
                    }
                    IsRemember = [dic[@"remember"] integerValue];
                }
                else if ([dic[@"passWord"]isEqualToString:@"123"])
                {
                    ((UITextField *)[self.view viewWithTag:2001]).text = @"";
                    if ([dic[@"remember"]isEqualToString:@"1"]) {
                        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_checked@2x"];
                    }
                    else if ([dic[@"remember"]isEqualToString:@"0"])
                    {
                        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_normal@2x"];
                    }
                    IsRemember = [dic[@"remember"] integerValue];
                }
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        backV.hidden = YES;
    }
}

//删除历史记录
-(void)delHistory:(UIButton*)btn
{
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
  //  NSLog(@"plistDict======%@",plistDict);
    // NSMutableArray *getUser = plistDict[@"LoginUserName"];
    NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
    NSMutableArray* getUser = nil;
    if (registArray == nil){
        getUser = [NSMutableArray array];
    }else{
        getUser = [NSMutableArray arrayWithArray:registArray];
    }
    [getUser removeObjectAtIndex:btn.tag - 4000];
    [userArr removeObjectAtIndex:btn.tag - 4000];
    [plistDict setObject:getUser forKey:@"LoginUserName"];
    BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
    if (result) {
        [_histeryTab reloadData];
    }else{
        NSLog(@"存入失败");
    }
}
//记住密码
-(void)rememberUser:(UIButton *)sender
{
    IsRemember = !IsRemember;
    if (IsRemember == 0) {
        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_normal@2x"];
        //ic_remember_password_checked
    }
    else
    {
        ((UIImageView *)[self.view viewWithTag:3000]).image =[UIImage imageNamed:@"ic_remember_password_checked@2x"];
    }
    NSLog(@"IsRemember ===== %d",IsRemember);
}
//忘记密码
-(void)forget
{
    //跳转忘记密码界面
    ForgetViewController *forgetV = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forgetV animated:YES];
}
//点击历史记录
-(void)userHistory
{
    backV.hidden = !backV.hidden;
    if (backV.hidden == YES) {
        [_zhTextFlied becomeFirstResponder];
    }else{
        if ([_zhTextFlied becomeFirstResponder]) {
            [_zhTextFlied resignFirstResponder];
        }
        if ([_mmTextFiled becomeFirstResponder]) {
            [_mmTextFiled resignFirstResponder];
        }
    }
    [_histeryTab reloadData];
}
//点击密码可见不可见
-(void)closeOrOpen
{
    open = !open;
    NSLog(@"__open :%d",open);
    if (editing==1&&open==1) {
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_white_open_eye@2x"] forState:UIControlStateNormal];
    }
    if (editing==1&&open==0) {
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_white_close_eye@2x"] forState:UIControlStateNormal];
    }
    if (editing==0&&open==1) {
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_blue_open_eye@2x"] forState:UIControlStateNormal];
    }
    if (editing==0&&open==0) {
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_blue_close_eye@2x"] forState:UIControlStateNormal];
    }
    if (open==1) {
        _mmTextFiled.secureTextEntry = NO;
    }
    else
    {
        _mmTextFiled.secureTextEntry = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 6000) {
        return 2;
    }
    if (section == 0) {
        return 15;
    }
    else
    {
        return 30;
    }
}
#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    //账号
    if (textField.tag == 2000) {
        imageViewUser.image=[UIImage imageNamed:@"ic_login_username_checked@2x"];
        [btnUser setBackgroundImage:[UIImage imageNamed:@"ic_white_downward_arrow@3x"] forState:UIControlStateNormal];
        _zhTextFlied.textColor = [UIColor whiteColor];
    }
    if (textField.tag == 2001) {
        editing = 1;
        imageViewPwd.image=[UIImage imageNamed:@"ic_login_password_checked@2x"];
        if (editing==1&&open==1) {
            [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_white_open_eye@2x"] forState:UIControlStateNormal];
        }
        if (editing==1&&open==0) {
            [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_white_close_eye@2x"] forState:UIControlStateNormal];
        }
        _mmTextFiled.textColor = [UIColor whiteColor];
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_white_close_eye@2x"] forState:UIControlStateNormal];
    }
    
    
    //密码
}
// 指定是否允许文本字段结束编辑，允许的话，文本字段会失去first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 2000) {
        imageViewUser.image=[UIImage imageNamed:@"ic_login_username_checked1@2x"];
        [btnUser setBackgroundImage:[UIImage imageNamed:@"ic_blue_downward_arrow@3x"] forState:UIControlStateNormal];
        _zhTextFlied.textColor = [UIColor whiteColor];
    }
    if (textField.tag == 2001) {
        imageViewPwd.image=[UIImage imageNamed:@"ic_login_password_checked1@2x"];
        [btnPwd setBackgroundImage:[UIImage imageNamed:@"ic_blue_close_eye@2x"] forState:UIControlStateNormal];
        _mmTextFiled.textColor = [UIColor whiteColor];
    }

    userName =  _zhTextFlied.text;
    passWord = _mmTextFiled.text;
    return YES;
}
- (void)addAGesutreRecognizerForYourView

{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)]; // 手势类型随你喜欢。
    tapGesture.delegate = self;
    [_tableView addGestureRecognizer:tapGesture];
}
- (void) tapGesturedDetected:(UITapGestureRecognizer *)recognizer

{
    [_zhTextFlied resignFirstResponder];
    [_mmTextFiled resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_zhTextFlied resignFirstResponder];
    [_mmTextFiled resignFirstResponder];
}
// 文本框失去first responder 时，执行
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    
}
-(void)registerText
{
    [_zhTextFlied resignFirstResponder];
    [_mmTextFiled resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
