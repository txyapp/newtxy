//
//  RegistViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/12/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "RegistViewController.h"
#import "MBProgressHUD.h"
#import "LoginTextFiled.h"
#import<CoreText/CoreText.h>
#import "txysec.h"
#import "TXYTools.h"
#import <HealthKit/HealthKit.h>
#import "AES128.h"
#import "NSString+Hashing.h"
#import "SecurityUtil.h"
#import "aes.h"
#import <cpp/aes.h>
@interface RegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LoginTextFiled* textField1;
@property(nonatomic,strong)LoginTextFiled* textField2;
@property(nonatomic,strong)LoginTextFiled* textField3;
@property(nonatomic,strong)LoginTextFiled* textField4;
@property(nonatomic,strong)NSMutableArray*  arrayFTab;
@property(nonatomic,strong)UIView* footView;
@property(nonatomic,strong)UIButton* sureBtn;
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* password;
@property(nonatomic,copy)NSString* repeatpassword;
@property(nonatomic,copy)NSString* emailnumber;
@end

@implementation RegistViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = YES;
    [super viewDidLoad];
    self.title = @"注册";
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [self makeView];
}

- (void)makeView{
    _arrayFTab = [NSMutableArray arrayWithArray:@[@"用户名:",@"登录密码:",@"确认密码:",@"邮箱/手机号:"]];
    long number;
    number = 20.0f/5;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:@"用户名:"];
    [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[_arrayFTab[0] length]-2)];
    CFRelease(num);
    UILabel* lab1 = [[UILabel alloc]init];
    lab1.text = @"用户名:";
    [lab1 setAttributedText:string];
    lab1.frame = CGRectMake(0, 0, 65, 40);
    _textField1 = [[LoginTextFiled alloc]initWithFrame:CGRectMake(10, 0, Width-20, 50) drawingLeft:lab1 withRight:nil];
    _textField1.leftView = lab1;
    _textField1.tag = 3000;
    _textField1.borderStyle = UITextBorderStyleRoundedRect;
    [_textField1 setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    _textField1.textAlignment = NSTextAlignmentLeft;
    _textField1.textColor = [UIColor grayColor];
    if (Width == 320) {
        NSString* holderText = @"请输入字母数字或下划线(6~20位)";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:@"请输入字母数字或下划线(6~20位)"];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:IWColor(200, 200, 205)
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:13]
                            range:NSMakeRange(0, holderText.length)];
        _textField1.attributedPlaceholder = placeholder;
    }else{
        _textField1.placeholder = @"请输入字母数字或下划线(6~20位)";
    }

    UILabel* lab2 = [[UILabel alloc]init];
    lab2.text = @"登录密码:";
    lab2.frame= CGRectMake(0, 0, 78, 40);
    _textField2 = [[LoginTextFiled alloc]initWithFrame:CGRectMake(10, 0, Width-20, 50) drawingLeft:lab2 withRight:nil];
    _textField2.frame = CGRectMake(10, 0, Width-20, 50);
    _textField2.tag = 3001;
    _textField2.borderStyle = UITextBorderStyleRoundedRect;
    _textField2.textAlignment = NSTextAlignmentLeft;
    _textField2.textColor = [UIColor grayColor];
    if (Width == 320) {
        NSString* holderText = @"请输入数字或字母(6~20位)";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:IWColor(200, 200, 205)
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:14]
                            range:NSMakeRange(0, holderText.length)];
        _textField2.attributedPlaceholder = placeholder;
    }else{
        _textField2.placeholder = @"请输入数字或字母(6~20位)";
    }
    _textField2.secureTextEntry = YES;
    UILabel* lab3 = [[UILabel alloc]init];
    lab3.text = @"确认密码:";
    lab3.frame = CGRectMake(0, 0, 80, 40);
    _textField3 = [[LoginTextFiled alloc]initWithFrame:CGRectMake(10, 0, Width-20, 50) drawingLeft:lab3 withRight:nil];
    _textField3.frame = CGRectMake(10, 0, Width-20, 50);
    _textField3.tag = 3002;
    _textField3.borderStyle = UITextBorderStyleRoundedRect;
    _textField3.textAlignment = NSTextAlignmentLeft;
    _textField3.textColor = [UIColor grayColor];
    _textField3.secureTextEntry = YES;
    if (Width == 320) {
        NSString* holderText = @"请输入数字或字母(6~20位)";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:IWColor(200, 200, 205)
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:14]
                            range:NSMakeRange(0, holderText.length)];
        _textField3.attributedPlaceholder = placeholder;
    }else{
        _textField3.placeholder = @"请输入数字或字母(6~20位)";
    }
    UILabel* lab4 = [[UILabel alloc]init];
    lab4.frame = CGRectMake(0, 0, 103, 40);
    lab4.text = @"邮箱/手机号:";
    _textField4 = [[LoginTextFiled alloc]initWithFrame:CGRectMake(10, 0, Width-20, 50) drawingLeft:lab4 withRight:nil];
    _textField4.frame = CGRectMake(10, 0, Width-20, 50);
    _textField4.tag = 3003;
    _textField4.borderStyle = UITextBorderStyleRoundedRect;
    _textField4.textAlignment = NSTextAlignmentLeft;
    _textField4.textColor = [UIColor grayColor];
    if (Width == 320) {
        NSString* holderText = @"请输入邮箱或者手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:IWColor(200, 200, 205)
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:14]
                            range:NSMakeRange(0, holderText.length)];
        _textField4.attributedPlaceholder = placeholder;
    }else{
        _textField4.placeholder = @"请输入邮箱或者手机号";
    }
    _textField1.delegate = self;
    _textField2.delegate = self;
    _textField3.delegate = self;
    _textField4.delegate = self;
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=50;
    _footView = [[UIView alloc]init];
    _footView.frame = CGRectMake(20, 20, Width-40, 50);
    _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sureBtn setTitle:@"注册" forState:UIControlStateNormal];
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
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    if (![self isUser:_username]) {
        HUD.labelText = @"请输入正确的用户名";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.7];
        return;
    }else if (![self isPassword:_password]){
        HUD.labelText = @"请输入正确的密码";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.7];
        return;
    }else if(![_password isEqualToString:_repeatpassword]){
        HUD.labelText = @"两次密码不一样";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.7];
        return;
    }else if(!([self isValidateCall:_emailnumber]||[self isValidateEmail:_emailnumber])){
        HUD.labelText = @"请输入正确的手机号或邮箱";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.7];
        return;
    }
    NSString* isCallOrEmail = @"unknow";
    if ([self isValidateCall:_textField4.text]) {
        isCallOrEmail = @"call";
    }
    if ([self isValidateEmail:_textField4.text]) {
        isCallOrEmail = @"email";
    }
    
    //这里进行注册操作
     NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
    NSDictionary *userDic = nil;
    if(clientid){
        userDic = @{@"username":_username,@"password":_password,@"emailnumber":_emailnumber,@"code":DeviceNum,@"code_type":@"2",@"clientid":clientid};
    }
    else
    {
        userDic = @{@"username":_username,@"password":_password,@"emailnumber":_emailnumber,@"code":DeviceNum,@"code_type":@"2"};
    }
    
   
    NSLog(@"%@",userDic);
    NSString *userString =[self convertToJSONData:userDic];
    NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
    NSString *stringR = [self convertToJSONData:requestDic];
   // NSLog(@"string ===== %@",stringR);
    //char *bb = enc_data_impl(stringR.UTF8String);
    NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
    NSLog(@"enc : %@",bbbb);
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
    
    //NSString *stringBody = [self encodeString:bbbb];
    NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"110",@"flag":@"4"};
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,RegisterApi];
    [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict=responseObject;
        NSLog(@"%@",responseDict);
        if ([responseDict[@"status"] integerValue]==0) {
            NSString *data = responseDict[@"data"];
            //char *bb11 = dec_data_impl(data.UTF8String);
            NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
          //  NSLog(@"enc111 : %@",bbbb11);
            NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
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
                    NSDictionary* codeDic = [plistDict objectForKey:@"existCode"];
                    NSMutableDictionary* existCodeDic = nil;
                    if (codeDic == nil){
                        existCodeDic = [[NSMutableDictionary alloc]init];
                    }else{
                        existCodeDic = [NSMutableDictionary dictionaryWithDictionary:codeDic];
                    }
                    [existCodeDic setObject:@"yes" forKey:@"existMachine"];
                    [plistDict setObject:existCodeDic forKey:@"existCode"];
                    [plistDict writeToFile:LoginPlist atomically:YES];
                }
                //登录成功的时候记住账号
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
                //NSMutableArray *getUser = plistDict[@"LoginUserName"];
                NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
                NSMutableArray* getUser = nil;
                if (registArray == nil){
                    getUser = [NSMutableArray array];
                }else{
                    getUser = [NSMutableArray arrayWithArray:registArray];
                }
                NSDictionary *dic = @{@"userName":_username,@"passWord":@"123",@"remember":[NSString stringWithFormat:@"%d",0]};
                [getUser insertObject:dic atIndex:0];
                [plistDict setObject:getUser forKey:@"LoginUserName"];
                BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                if (result) {
                    NSLog(@"存入成功");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    NSLog(@"存入失败");
                }
            }
            else
            {
                //
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

//用户名正则
- (BOOL)isUser:(NSString*)user{
    NSString *MOBILE = @"^[a-zA-Z0-9_]{6,20}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:user];
}

//密码正则
- (BOOL)isPassword:(NSString*)password{
    NSString *MOBILE = @"^[a-zA-Z0-9]{6,20}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:password];
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
//手机号正则
- (BOOL)isValidateCall:(NSString*)call{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:call];
}
//邮箱正则
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
    if (section == 3) {
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
    if (indexPath.section == 3) {
        [cell.contentView addSubview:_textField4];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_textField1.isFirstResponder ||_textField2.isFirstResponder || _textField3.isFirstResponder ||_textField4.isFirstResponder) {
        [_textField1 resignFirstResponder];
        [_textField2 resignFirstResponder];
        [_textField3 resignFirstResponder];
        [_textField4 resignFirstResponder];
    }
}
// 指定是否允许文本字段结束编辑，允许的话，文本字段会失去first responder
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 3000) {
        _username = textField.text;
    }
    if (textField.tag == 3001) {
        _password = textField.text;
    }
    if (textField.tag == 3002) {
        _repeatpassword = textField.text;
    }
    if (textField.tag == 3003) {
        _emailnumber = textField.text;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerText
{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
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
