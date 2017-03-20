//
//  ChangePassViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "ChangePassViewController.h"
#import "txysec.h"
#import "MBProgressHUD.h"
#import "TXYTools.h"
#import "AES128.h"
#import "TXYConfig.h"
@interface ChangePassViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSString *oldPassWord,*newPassWord,*reNewPassWord;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextField* textField1;
@property(nonatomic,strong)UITextField* textField2;
@property(nonatomic,strong)UITextField* textField3;
@property(nonatomic,strong)UIView* footView;
@property(nonatomic,strong)UIButton* sureBtn;
@end

@implementation ChangePassViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [self makeView];
}

- (void)makeView{
    _textField1 = [[UITextField alloc]init];
    _textField1.frame = CGRectMake(10, 0, Width-20, 50);
    _textField1.borderStyle = UITextBorderStyleRoundedRect;
    _textField1.tag = 3000;
    _textField1.secureTextEntry = YES;
    _textField1.textAlignment = NSTextAlignmentLeft;
    _textField1.textColor = [UIColor grayColor];
    _textField1.placeholder = @"请输入当前登录密码";
    _textField2 = [[UITextField alloc]init];
    _textField2.frame = CGRectMake(10, 0, Width-20, 50);
    _textField2.borderStyle = UITextBorderStyleRoundedRect;
    _textField2.textAlignment = NSTextAlignmentLeft;
    _textField2.textColor = [UIColor grayColor];
    _textField2.placeholder = @"请输入新密码";
    _textField2.secureTextEntry = YES;
    _textField2.tag = 3001;
    _textField3 = [[UITextField alloc]init];
    _textField3.frame = CGRectMake(10, 0, Width-20, 50);
    _textField3.borderStyle = UITextBorderStyleRoundedRect;
    _textField3.textAlignment = NSTextAlignmentLeft;
    _textField3.textColor = [UIColor grayColor];
    _textField3.placeholder = @"请再次输入新密码";
    _textField3.tag = 3002;
    _textField3.secureTextEntry = YES;
    _textField1.delegate = self;
    _textField2.delegate = self;
    _textField3.delegate = self;
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=50;
    _footView = [[UIView alloc]init];
    _footView.frame = CGRectMake(20, 20, Width-40, 50);
    _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.backgroundColor = IWColor(60, 170, 249);
    _sureBtn.frame = CGRectMake(0, 0, Width-40, 50);
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 10;
    [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_sureBtn];
    self.tableView.tableFooterView = _footView;
    [self.view addSubview:self.tableView];
}
//确定
- (void)sure{
    [self registerText];
    //判断密码格式是否正确
    NSLog(@"old = %@ new = %@  renew = %@",oldPassWord,newPassWord,reNewPassWord);
    if ([oldPassWord isEqualToString:@""]||[newPassWord isEqualToString:@""]||[reNewPassWord isEqualToString:@""]||!oldPassWord||!newPassWord||!reNewPassWord) {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"密码不能为空";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return;
    }
    if (![self isPassword:oldPassWord]) {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"旧密码格式不正确";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return;
    }else if(![self isPassword:newPassWord]&&![self isPassword:reNewPassWord]){
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"新密码格式不正确";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return;
    }else if (![newPassWord isEqualToString:reNewPassWord]){
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"新密码重复输入不一致";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return;
    }else if([oldPassWord isEqualToString:reNewPassWord]){
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"新旧密码不能一样";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return;
    }
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSLog(@"username = %@",user);
    NSDictionary *userDic = @{@"username":user,@"password":newPassWord,@"token":token,@"repassword":oldPassWord};
    NSString *userString =[self convertToJSONData:userDic];
    NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
    NSString *stringR = [self convertToJSONData:requestDic];
   // NSLog(@"string ===== %@",stringR);
    NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
   // NSString *bbbb = [NSString stringWithFormat:@"%s",bb];
    //NSLog(@"enc : %@",bbbb);
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
    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"115",@"flag":@"4"};
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,ChangePassWord];//115
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
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                if ([dic[@"status"] integerValue] == 0 ) {
                    NSLog(@"%@",dic[@"msg"]);
                    [LoginHUD removeFromSuperview];
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = dic[@"msg"];
                    //如果设置此属性则当前的view置于后台
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:2];
                    //密码修改成功后退出登录
                    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
                    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
                    //修改这个账号的记录密码状态
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
                    //NSLog(@"plistDict======%@",plistDict);
                    // NSMutableArray *getUser = plistDict[@"LoginUserName"];
                    NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
                    NSMutableArray* getUser = nil;
                    if (registArray == nil){
                        getUser = [NSMutableArray array];
                    }else{
                        getUser = [NSMutableArray arrayWithArray:registArray];
                    }
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:getUser];
                    int loca = 0;
                    for (NSDictionary *dic  in arr) {
                        if ([dic[@"userName"] isEqualToString:user]) {
                            loca = [getUser indexOfObject:dic];
                        }
                    }
                    NSMutableDictionary* dicter = [[NSMutableDictionary alloc]init];
                    [dicter setObject:user forKey:@"userName"];
                    [dicter setObject:@"123" forKey:@"passWord"];
                    [dicter setObject:@"0" forKey:@"remember"];
                    if (getUser.count>0) {
                        [getUser replaceObjectAtIndex:loca withObject:dicter];
                    }else{
                        [getUser addObject:dicter];
                    }

                    [plistDict setObject:getUser forKey:@"LoginUserName"];
                    BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                    if (result) {
                        NSLog(@"存入成功");
                    }else{
                        NSLog(@"存入失败");
                    }
                    //退出登录
           
                    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
                    NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,LoginOut];//116
                    NSDictionary *userDic = @{@"username":user,@"token":token};
                    NSString *userString =[self convertToJSONData:userDic];
                    NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                    NSString *stringR = [self convertToJSONData:requestDic];
                   // NSLog(@"string ===== %@",stringR);
                    char *bb = enc_data_impl(stringR.UTF8String);
                    NSString *bbbb = [NSString stringWithFormat:@"%s",bb];
                    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"116",@"flag":@"2"};
                    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *responseDict=responseObject;
                        NSLog(@"%@",responseDict);
                        if (responseDict) {
                            int state = [responseDict[@"status"] integerValue];
                            if (state == 0) {
                                NSString *data = responseDict[@"data"];
                                char *bb11 = dec_data_impl(data.UTF8String);
                                NSString *bbbb11 = [NSString stringWithFormat:@"%s",bb11];
                               // NSLog(@"enc111 : %@",bbbb11);
                                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                                if ([dic1[@"status"] integerValue]==0) {
                                    NSLog(@"%@",dic1[@"msg"]);
                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NewUserStatus"];
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
                else
                {
                    NSLog(@"%@",dic[@"msg"]);
                    //提醒服务器错误
                    [LoginHUD removeFromSuperview];
                    NSLog(@"请求失败了");
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = dic[@"msg"];
                    //如果设置此属性则当前的view置于后台
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:2];
                }
            }
            else if(state == 2)
            {
                //提醒服务器错误
                [LoginHUD removeFromSuperview];
                NSLog(@"请求失败了");
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"服务器错误";
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }
            else
            {
                //提醒数据验证错误
                [LoginHUD removeFromSuperview];
                NSLog(@"请求失败了");
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"数据验证失败";
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //提醒数据验证错误
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

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:_textField1];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.section == 1) {
        [cell.contentView addSubview:_textField2];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.section == 2) {
        [cell.contentView addSubview:_textField3];
        cell.backgroundColor = [UIColor clearColor];
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
    if (_textField1.isFirstResponder ||_textField2.isFirstResponder || _textField3.isFirstResponder) {
        [_textField1 resignFirstResponder];
        [_textField2 resignFirstResponder];
        [_textField3 resignFirstResponder];
    }
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}
// 指定是否允许文本字段结束编辑，允许的话，文本字段会失去first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 3000) {
        oldPassWord = textField.text;
    }
    if (textField.tag == 3001) {
        newPassWord = textField.text;
    }
    if (textField.tag == 3002) {
        reNewPassWord = textField.text;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
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
//密码正则
- (BOOL)isPassword:(NSString*)password{
    NSString *MOBILE = @"^[a-zA-Z0-9]{6,20}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:password];
}
-(void)registerText
{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
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
