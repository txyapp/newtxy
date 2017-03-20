//
//  PersonInfoViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MyAlert.h"
#import "ChangePassViewController.h"
#import "txysec.h"
#import "MBProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "TXYTools.h"
#import "AES128.h"
#import "TXYConfig.h"
#import <BmobSDK/Bmob.h>
#import<CommonCrypto/CommonDigest.h>
@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    int status;// status =1 手机号空，邮箱有值 2手机号有值 邮箱为空 3手机号邮箱都有值
    MBProgressHUD* HUD;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *InfoArr;
@property(nonatomic,strong)NSMutableArray *applyArr;
@property(nonatomic,strong)NSMutableArray *ImgArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIButton* RenewalsBtn;
@property(nonatomic,strong)UITextField* textField;
@property(nonatomic,strong)UITextField* textField1;
@property(nonatomic,strong)UITextField* textField2;
@property(nonatomic,strong)UITextField* textField3;
@property(nonatomic,strong)UITextField* textField4;
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UILabel* timeLab;
@property(nonatomic,strong)UIBarButtonItem *editBtn;

@end


@implementation PersonInfoViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    //随便设置一个初始值
    status = 1000;
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    _editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    _editBtn.tag = 3000;
    self.navigationItem.rightBarButtonItem = _editBtn;
    self.title = @"个人信息";
    [self makeView];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"---------------------");
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(loadData) name:@"updata" object:nil];
}

- (void)makeView{


    _textField1 = [[UITextField alloc]init];
    _textField1.frame = CGRectMake(0, 0, 200, 50);
    _textField1.borderStyle = UITextBorderStyleNone;
    _textField1.textAlignment = NSTextAlignmentRight;
    _textField1.textColor = [UIColor grayColor];
    _textField1.enabled = NO;
    _textField2 = [[UITextField alloc]init];
    _textField2.frame = CGRectMake(0, 0, 200, 50);
    _textField2.textColor = [UIColor grayColor];
    _textField2.borderStyle = UITextBorderStyleNone;
    _textField2.textAlignment = NSTextAlignmentRight;
    _textField2.keyboardType = UIKeyboardTypeNumberPad;
    _textField2.enabled = NO;
    _textField3 = [[UITextField alloc]init];
    _textField3.textColor = [UIColor grayColor];
    _textField3.frame = CGRectMake(0, 0, 200, 50);
    _textField3.borderStyle = UITextBorderStyleNone;
    _textField3.textAlignment = NSTextAlignmentRight;
    _textField3.keyboardType = UIKeyboardTypeEmailAddress;
    _textField3.enabled = NO;
    _textField1.delegate = self;
    _textField2.delegate = self;
    _textField3.delegate = self;
    _backView = [[UIView alloc]init];
    _backView.frame = CGRectMake(0, 0, 200, 50);
    _RenewalsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 
    _RenewalsBtn.frame = CGRectMake(140, 10, 60, 30);
    _RenewalsBtn.layer.masksToBounds = YES;
    _RenewalsBtn.layer.cornerRadius = 10;
    [_RenewalsBtn setTitle:@"续费" forState:UIControlStateNormal];
    [_RenewalsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_RenewalsBtn setBackgroundColor:IWColor(60, 170, 249)];
    [_RenewalsBtn addTarget:self action:@selector(renewals) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_RenewalsBtn];
    _timeLab = [[UILabel alloc]init];
    _timeLab.frame = CGRectMake(0, 5, 130, 40);
    _timeLab.textColor = [UIColor grayColor];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_timeLab];
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // UIColor *myColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    //  self.appTableView.backgroundColor=IWColor(236, 235, 243);
    // self.appTableView.backgroundColor = myColor;
    self.tableView.rowHeight=45;
    //self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];
    UIView* footView = [[UIView alloc]init];
    footView.frame = CGRectMake(20, 20, Width-40, 50);
    //  footView.backgroundColor = [UIColor redColor];
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor redColor];
    sureBtn.frame = CGRectMake(0, 0, Width-40, 50);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 10;
    [sureBtn addTarget:self action:@selector(drop) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sureBtn];
    self.tableView.tableFooterView = footView;
}

//退出登录
- (void)drop{
    //退出登录
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,LoginOut];//116
    NSDictionary *userDic = @{@"username":user,@"token":token};
    NSString *userString =[self convertToJSONData:userDic];
    NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
    NSString *stringR = [self convertToJSONData:requestDic];
  //  NSLog(@"string ===== %@",stringR);
    NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
   // NSString *bbbb = [NSString stringWithFormat:@"%s",bb];
    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"116",@"flag":@"4"};
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
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict=responseObject;
        NSLog(@"%@",responseDict);
        if (responseDict) {
            int state = [responseDict[@"status"] integerValue];
            if (state == 0) {
                NSString *data = responseDict[@"data"];
                NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
               // NSString *bbbb11 = [NSString stringWithFormat:@"%s",bb11];
               // NSLog(@"enc111 : %@",bbbb11);
                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                if ([dic1[@"status"] integerValue]==0) {
                    NSLog(@"%@",dic1[@"msg"]);
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NewUserStatus"];
                    //退出登录后把开关权限关闭
                    NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                    [setDict setObject:@(0) forKey:@"authValue"];
                    [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                    [[TXYConfig sharedConfig] setToggleWithBool:NO];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [LoginHUD removeFromSuperview];
                    MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUDasd];
                    HUDasd.labelText = dic[@"msg"];
                    //如果设置此属性则当前的view置于后台
                    HUDasd.dimBackground = YES;
                    HUDasd.yOffset = 20;
                    HUDasd.mode = MBProgressHUDModeText;
                    [HUDasd show:YES];
                    [HUDasd hide:YES afterDelay:2];
                }
            }
            else if (state==1)
            {
                NSLog(@"数据验证失败");
                [LoginHUD removeFromSuperview];
                MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUDasd];
                HUDasd.labelText = @"数据验证失败";
                //如果设置此属性则当前的view置于后台
                HUDasd.dimBackground = YES;
                HUDasd.yOffset = 20;
                HUDasd.mode = MBProgressHUDModeText;
                [HUDasd show:YES];
                [HUDasd hide:YES afterDelay:2];
            }
            else
            {
                NSLog(@"数据验证失败");
                [LoginHUD removeFromSuperview];
                MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUDasd];
                HUDasd.labelText = @"数据验证失败";
                //如果设置此属性则当前的view置于后台
                HUDasd.dimBackground = YES;
                HUDasd.yOffset = 20;
                HUDasd.mode = MBProgressHUDModeText;
                [HUDasd show:YES];
                [HUDasd hide:YES afterDelay:2];            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LoginHUD removeFromSuperview];
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

//data
-(void)loadData{
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
        NSLog(@"%@",bbbb);
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"117",@"flag":@"4"};
//        MBProgressHUD* LoginHUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:LoginHUD];
//        //对话框显示时需要执行的操作
//        LoginHUD.mode = MBProgressHUDModeCustomView;
//        LoginHUD.labelText = @"请稍后";
//        //如果设置此属性则当前的view置于后台
//        LoginHUD.dimBackground = YES;
//        //显示对话框
//        [LoginHUD showAnimated:YES whileExecutingBlock:^{
//            
//            
//        } completionBlock:^{
//            //操作执行完后取消对话框
//        }];
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseDict) {
                int state = [responseDict[@"status"] integerValue];
                if (state == 0) {
                    NSString *data = responseDict[@"data"];
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                   // NSLog(@"enc111 : %@",bbbb11);
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    if ([dic1[@"status"] integerValue]==0) {
                        //判断dic 的 vip字段
                        NSDictionary *dic = dic1[@"user_info"];
                        self.dataArr=[NSMutableArray arrayWithArray:@[@"用户名",@"手机号",@"邮箱"]];
                        self.ImgArr=[NSMutableArray arrayWithArray:@[@"32.png",@"31.png"]];
                        NSString* call;
                        NSString* email;
                        if ([self isTel:dic[@"phonenumber"]]) {
                            call =dic[@"phonenumber"];
                        }else{
                            call  = @"未完善";
                        }
                        if ([self isEmail:dic[@"email"]]) {
                            email = dic[@"email"];
                        }else{
                            email = @"未完善";
                        }
//                        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"expiretime"] isEqualToString:@"0"]) {
//                            _timeLab.text = @"非会员";
//                            [_RenewalsBtn setTitle:@"购买" forState:UIControlStateNormal];
//                        }else{
//                            _timeLab.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"expiretime"];
//                        }
                        self.dataArray = [NSMutableArray arrayWithArray:@[user,call,email]];
//                        if (dic[@"expire_time"]) {
//                            int time = [dic[@"expire_time"] integerValue];
//                            _timeLab.text = [self timeFormatted:time];
//                        }
                        if (dic[@"expire_time"]) {
                            int time = [dic[@"expire_time"] integerValue];
                            if(time !=0)
                            {
                                [[NSUserDefaults standardUserDefaults]setObject:[self timeFormatted:time] forKey:@"expiretime"];
                                int time = [dic[@"expire_time"] integerValue];
                                _timeLab.text = [self timeFormatted:time];
                                [_RenewalsBtn setTitle:@"续费" forState:UIControlStateNormal];
                                NSLog(@"time = %@",[self timeFormatted:time]);
                            }
                            else
                            {
                                _timeLab.text = @"非会员";
                                [_RenewalsBtn setTitle:@"购买" forState:UIControlStateNormal];
                                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"expiretime"];
                            }
                        }
                        NSLog(@"dataarray = %@",self.dataArray);
                        int isVip = [dic[@"vip"] integerValue];
                        if (isVip == 0) {
                            //非会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(0) forKey:@"authValue"];
                            _timeLab.text = @"非会员";
                            [_RenewalsBtn setTitle:@"购买" forState:UIControlStateNormal];
                            [[TXYConfig sharedConfig] setToggleWithBool:NO];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                        }
                        else
                        {
                            //会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(1) forKey:@"authValue"];
                            int time = [dic[@"expire_time"] integerValue];
                            _timeLab.text = [self timeFormatted:time];
                            [_RenewalsBtn setTitle:@"续费" forState:UIControlStateNormal];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                        }
                        [_tableView reloadData];
                    }
                    else
                    {
                        NSLog(@"数据验证失败");
               //         [LoginHUD removeFromSuperview];
                        MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:HUDasd];
                        HUDasd.labelText = @"数据验证失败";
                        //如果设置此属性则当前的view置于后台
                        HUDasd.dimBackground = YES;
                        HUDasd.yOffset = 20;
                        HUDasd.mode = MBProgressHUDModeText;
                        [HUDasd show:YES];
                        [HUDasd hide:YES afterDelay:2];
                        NSLog(@"%@",dic1[@"msg"]);
                    }
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"数据验证失败");
      //      [LoginHUD removeFromSuperview];
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
//续费
- (void)renewals{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付宝支付",@"微信支付",@"充值卡支付", nil];
    [alert setTag:3001];
    [alert show];
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 3001) {
        if (buttonIndex ==1) {
            [self Alipay];
        }else if (buttonIndex == 2){
            [self Wxpay];
        }
        if (buttonIndex == 3) {
            [self rechargepay];
        }
    }
    if (alertView.tag==2) {
        if (buttonIndex == 0) {
            return;
        }
        UITextField* tf1 = [alertView textFieldAtIndex:0];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        if (![tf1.text isEqualToString:@""]) {
            NSString* sn = tf1.text;
            NSString* uname = _textField1.text;
            NSString*code = [NSString stringWithFormat:@"%@%@%@",both_pub_key,sn,uname];
            NSString* vcode = [self sha1:code];
            NSDictionary *dic = @{@"sn":sn,@"uname":uname,@"vcode":vcode};
            NSDictionary *oldDic = @{@"sn":@"T14492473011427504147a",@"uname":@"yuanxing1981",@"vcode":@"dc47602b4c2b849d7176b62c08241edd90f4d961"};
            AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
            mgr.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [NSString stringWithFormat:@"%@",chongzhika];
            NSLog(@"dic = %@ url = %@ oldDic = %@",dic,url,oldDic);
            NSString* newurl = @"http://ipay.txyapp.com:8181/appsrv/mobi/charge";
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
                            [self loadData];
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
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"支付成功";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==8000)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"正在处理中";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==4000)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"订单支付失败";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==5000)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"重复请求";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6001)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"用户中途取消";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6002)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"网络连接出错";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else if ([resultDic[@"resultStatus"] integerValue]==6004)
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"支付结果未知";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                                else
                                {
                                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"支付错误";
                                    HUD.dimBackground = YES;
                                    HUD.yOffset = 20;
                                    HUD.mode = MBProgressHUDModeText;
                                    [HUD show:YES];
                                    [HUD hide:YES afterDelay:0.7];
                                    return ;
                                }
                            }
                        }];
                    }
                }
                else
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"订单创建失败";
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:0.7];
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
       // NSLog(@"string ===== %@",stringR);
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
//接受微信的支付回调


//编辑
-(void)edit:(UIBarButtonItem *)editBtn{
    if (_editBtn.tag == 3000) {
        //点击编辑  插入cell
        //UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        //cell.textLabel.text = @"更换手机号后，可使用新手机号重置密码，请输入正确号码";
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.dataArr  insertObject:@"更换手机号后，可使用新手机号重置密码，请输入正确号码" atIndex:2];
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.dataArr  insertObject:@"更换邮箱后,可使用邮箱重置密码,请输入正确邮箱" atIndex:4];
        [_tableView insertRowsAtIndexPaths:@[path,path1] withRowAnimation:UITableViewRowAnimationNone];
        //UITableViewCell *cell1=[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        _textField2.enabled = YES;
        _textField3.enabled = YES;
        _textField2.selected = YES;
        NSLog(@"text = %@",_textField2.text);
        if ([_textField2.text isEqualToString:@"未完善"]) {
            _textField2.text = @"";
            status = 1;
        }else if ([_textField3.text  isEqualToString:@"未完善"]) {
            _textField3.text = @"";
            status = 2;
        }else{
            status = 3;
        }
        [_textField2 becomeFirstResponder];
        _editBtn.title = @"保存";
        _editBtn.tag = 3001;
        
    }
    else{
//        _textField2.enabled = NO;
//        _textField3.enabled = NO;
        //手机为空 邮箱不为空
        NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        NSString *bbbb;
        NSLog(@"status = %d",status);
        if (_textField2.text) {
            NSLog(@"_text = %@",_textField2.text);
        }else{
            NSLog(@"2");
        }
        if (status == 1) {
            if (([_textField2.text isEqualToString:@""]&&[self isEmail:_textField3.text])||([self isTel:_textField2.text]&&[self isEmail:_textField3.text])) {
                [self.dataArr removeObjectAtIndex:2];
                [self.dataArr removeObjectAtIndex:3];
                NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:4 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[path,path1] withRowAnimation:UITableViewRowAnimationNone];
                _editBtn.tag = 3000;
                NSDictionary *userDic;
                if (_textField2.text) {
                    userDic = @{@"username":user,@"email":_textField3.text,@"phonenumber":_textField2.text,@"token":token};
                }else
                {
                    userDic = @{@"username":user,@"email":_textField3.text,@"token":token};
                }
                NSLog(@"%@",userDic);
                NSString *userString =[self convertToJSONData:userDic];
                NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                NSString *stringR = [self convertToJSONData:requestDic];
              //  NSLog(@"string ===== %@",stringR);
                bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
                NSLog(@"enc : %@",bbbb);

            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                if ([_textField3.text isEqualToString:@""]) {
                   HUD.labelText = @"您已填写过邮箱,只能更改,不能删除";
                }else if(![self isEmail:_textField3.text]){
                    HUD.labelText = @"请输入正确的邮箱";
                }else if(![self isTel:_textField2.text]){
                    HUD.labelText = @"请输入正确的手机号";
                }
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:0.7];
                return;
            }
        }
        //手机不为空 邮箱为空
        if (status == 2) {
            if (([_textField3.text isEqualToString:@""]&&[self isTel:_textField2.text])||([self isTel:_textField2.text]&&[self isEmail:_textField3.text])) {
                [self.dataArr removeObjectAtIndex:2];
                [self.dataArr removeObjectAtIndex:3];
                NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:4 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[path,path1] withRowAnimation:UITableViewRowAnimationNone];
                _editBtn.tag = 3000;
                NSDictionary *userDic;
                if (_textField3.text) {
                    userDic = @{@"username":user,@"email":_textField3.text,@"phonenumber":_textField2.text,@"token":token};
                }else
                {
                    userDic = @{@"username":user,@"phonenumber":_textField2.text,@"token":token};
                }
                NSLog(@"%@",userDic);
                NSString *userString =[self convertToJSONData:userDic];
                NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                NSString *stringR = [self convertToJSONData:requestDic];
               // NSLog(@"string ===== %@",stringR);
                bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
                NSLog(@"enc : %@",bbbb);

            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                if ([_textField2.text isEqualToString:@""]) {
                    HUD.labelText = @"您已填写过手机号,只能更改,不能删除";
                }else if(![self isEmail:_textField3.text]){
                    HUD.labelText = @"请输入正确的邮箱";
                }else if(![self isTel:_textField2.text]){
                    HUD.labelText = @"请输入正确的手机号";
                }
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:0.7];
                return;
            }

        }
        //手机邮箱都不为空
        if (status == 3) {
            if (([self isTel:_textField2.text]&&[self isEmail:_textField3.text])) {
                [self.dataArr removeObjectAtIndex:2];
                [self.dataArr removeObjectAtIndex:3];
                NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:4 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[path,path1] withRowAnimation:UITableViewRowAnimationNone];
                _editBtn.tag = 3000;
                NSDictionary *userDic=@{@"username":user,@"email":_textField3.text,@"phonenumber":_textField2.text,@"token":token};
                NSLog(@"%@",userDic);
                NSString *userString =[self convertToJSONData:userDic];
                NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                NSString *stringR = [self convertToJSONData:requestDic];
              //  NSLog(@"string ===== %@",stringR);
                bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                if ([_textField2.text isEqualToString:@""]) {
                    HUD.labelText = @"您已填写过手机号,只能更改,不能删除";
                }else if([_textField3.text isEqualToString:@""]){
                    HUD.labelText = @"您已填写过邮箱,只能更改,不能删除";
                }
                else if(![self isEmail:_textField3.text]){
                    HUD.labelText = @"请输入正确的邮箱";
                }else if(![self isTel:_textField2.text]){
                    HUD.labelText = @"请输入正确的手机号";
                }
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:0.7];
                return;
            }
        }
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"121",@"flag":@"4"};
        //请求时的ui显示
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
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,ChangePhoneOrEmail];//121
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseDict) {
                int state = [responseDict[@"status"] integerValue];
                if (state == 0) {
                    NSString *data = responseDict[@"data"];
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
                    if ([dic[@"status"] integerValue]==0) {
                        NSLog(@"%@",dic[@"msg"]);
                        [LoginHUD removeFromSuperview];
                        MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:HUDasd];
                        HUDasd.labelText = @"保存成功";
                        //如果设置此属性则当前的view置于后台
                        HUDasd.dimBackground = YES;
                        HUDasd.yOffset = 20;
                        HUDasd.mode = MBProgressHUDModeText;
                        [HUDasd show:YES];
                        [HUDasd hide:YES afterDelay:0.7];
                        NSLog(@"%@",dic[@"msg"]);
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [LoginHUD removeFromSuperview];
                        MBProgressHUD* HUDasd = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:HUDasd];
                        HUDasd.labelText = dic[@"msg"];
                        //如果设置此属性则当前的view置于后台
                        HUDasd.dimBackground = YES;
                        HUDasd.yOffset = 20;
                        HUDasd.mode = MBProgressHUDModeText;
                        [HUDasd show:YES];
                        [HUDasd hide:YES afterDelay:2];
                        NSLog(@"%@",dic[@"msg"]);
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [LoginHUD removeFromSuperview];
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

//手机号匹配
- (BOOL)isTel:(NSString*)call{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:call];
}
//邮箱匹配
- (BOOL)isEmail:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count == 5 && (indexPath.row == 2|| indexPath.row ==4)) {
        return 30;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = _dataArr[indexPath.row];
        if (_dataArr.count == 3) {
            if (indexPath.row == 0) {
                cell.accessoryView = _textField1;
                _textField1.text = _dataArray[0];
            }
            if (indexPath.row == 1) {
                cell.accessoryView = _textField2;
                if (_dataArray[1]) {
                    _textField2.text = _dataArray[1];
                    NSLog(@"array1 = %@",_dataArray[1]);
                }
                
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"邮箱";
                cell.accessoryView = _textField3;
                if (_dataArray[2]) {
                    _textField3.text = _dataArray[2];
                }
                
            }
        }else{
            if (indexPath.row == 0) {
                cell.accessoryView = _textField1;
                _textField1.text = _dataArray[0];
            }
            if (indexPath.row == 1) {
                cell.accessoryView = _textField2;
                if (_dataArray[1]) {
                    _textField2.text = _dataArray[1];
                }
            }
            if (indexPath.row == 2) {
                cell.backgroundColor = IWColor(200, 200, 200);
                cell.textLabel.font = [UIFont systemFontOfSize:10];
                cell.textLabel.textColor = [UIColor redColor];
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"邮箱";
                cell.accessoryView = _textField3;
                if (_dataArray[2]) {
                    _textField3.text = _dataArray[2];
                }
            }
            if (indexPath.row == 4) {
                cell.backgroundColor = IWColor(200, 200, 200);
                cell.textLabel.font = [UIFont systemFontOfSize:10];
                cell.textLabel.textColor = [UIColor redColor];
            }
        }
  
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"会员状态";
        cell.accessoryView = _backView;
    }
    if (indexPath.section == 2) {
         cell.textLabel.text = @"修改密码";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        ChangePassViewController* chpass = [[ChangePassViewController alloc]init];
        [self.navigationController pushViewController:chpass animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_textField2.isFirstResponder || _textField3.isFirstResponder) {
        [_textField2 resignFirstResponder];
        [_textField3 resignFirstResponder];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
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
