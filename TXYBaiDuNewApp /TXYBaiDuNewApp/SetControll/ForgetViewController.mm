//
//  ForgetViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/12/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "ForgetViewController.h"
#import "LoginTextFiled.h"
#import<CoreText/CoreText.h>
#import "txysec.h"
#import "MBProgressHUD.h"
#import "AES128.h"
@interface ForgetViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView  *_tableView;
    NSMutableArray *arrayFTab,*arrayFP;
    NSString *userName,*getType,*getNum,*passWord,*rePassWord;
    int time;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    time = 60;
    arrayFTab = [NSMutableArray arrayWithCapacity:0];
    arrayFP = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
//数据
-(void)loadData
{
    arrayFTab = [NSMutableArray arrayWithArray:@[@"用户名",@"验证方式",@"验证码",@"新密码",@"确认密码"]];
    arrayFP = [NSMutableArray arrayWithArray:@[@"请输入用户名",@"请输入邮箱或手机号",@"请输入验证码",@"请输入密码",@"请重新输入密码"]];
}
-(void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = [UIColor whiteColor];
   // _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//确保TablView能够正确的调整大小
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    [self addAGesutreRecognizerForYourView];
}
#pragma mark TableDelegate
//Section 的 row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentfier = @"AppcellIndentfier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentfier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
   // lab.text  = arrayFTab[indexPath.row];
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:arrayFTab[indexPath.row]];
    long number;
    if ([arrayFTab[indexPath.row] length] == 4) {
        number = 0.0f;
    }
    else if ([arrayFTab[indexPath.row] length] == 3) {
        number = 34.0f/4;
    }
    else
    {
        number = 34.0f;
    }
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[arrayFTab[indexPath.row] length]-1)];
    CFRelease(num);
    [lab setAttributedText:string];
    lab.textAlignment= NSTextAlignmentLeft;
    UIButton *getNumB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getNumB setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getNumB setTintColor:[UIColor whiteColor]];
    getNumB.backgroundColor = IWColor(60, 170, 249);
    getNumB.frame = CGRectMake(0, 0, 100, 40);
    getNumB.tag = 6000;
    [getNumB.layer setMasksToBounds:YES];
    [getNumB addTarget:self action:@selector(getNum) forControlEvents:UIControlEventTouchUpInside];
    getNumB.layer.cornerRadius=5;
    UITextField *filed;
    if (indexPath.row != 2) {
      filed = [[LoginTextFiled alloc]initWithFrame:CGRectMake(5, 1, Width -10 , 43) drawingLeft:lab withRight:nil];
        if(indexPath.row == 3||indexPath.row == 4){
            filed.secureTextEntry = YES;
    }
    }else
    {
        filed = [[LoginTextFiled alloc]initWithFrame:CGRectMake(5, 1, Width -10, 43) drawingLeft:lab withRight:getNumB];
    }
    filed.placeholder = arrayFP[indexPath.row];
    filed.tag = 3000+indexPath.row;
    filed.delegate = self;
    filed.textColor = [UIColor blackColor];
    [cell.contentView addSubview:filed];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 200;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *Foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 200)];
    //Foot.backgroundColor = [UIColor redColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, Width-100, 30)];
    lab.text = @"*请按要求填写以上内容";
    lab.textColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [Foot addSubview:lab];
    
    UIButton *getBackB = [UIButton buttonWithType:UIButtonTypeCustom];
    getBackB.frame = CGRectMake(50, Foot.frame.size.height - 70, Width-100, 50);
    [getBackB setTitle:@"提交" forState:UIControlStateNormal];
    getBackB.backgroundColor = IWColor(60, 170, 249);
    [getBackB.layer setMasksToBounds:YES];
    getBackB.layer.cornerRadius=10;
    [getBackB addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [Foot addSubview:getBackB];
    return Foot;
}
#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    if (textField.tag == 3000) {
        //用户名
        userName = textField.text;
    }
    if (textField.tag == 3001) {
        //验证方式  邮箱或者手机号
        getType = textField.text;
    }
    if (textField.tag == 3002) {
        //验证码
        getNum = textField.text;
    }
    if (textField.tag == 3003) {
        //密码
        passWord = textField.text;
    }
    if (textField.tag == 3004) {
        //重复密码
        rePassWord = textField.text;
    }
}
// 指定是否允许文本字段结束编辑，允许的话，文本字段会失去first responder
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 3000) {
        //用户名
        userName = textField.text;
    }
    if (textField.tag == 3001) {
        //验证方式  邮箱或者手机号
        getType = textField.text;
    }
    if (textField.tag == 3002) {
        //验证码
        getNum = textField.text;
    }
    if (textField.tag == 3003) {
        //密码
        passWord = textField.text;
    }
    if (textField.tag == 3004) {
        //重复密码
        rePassWord = textField.text;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
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
    for (UIView *L  in self.view.subviews) {
        //[L resignFirstResponder];
        if ([L isKindOfClass:[UITextField class]]) {
            [L resignFirstResponder];
        }
    }
}
//提交
-(void)getBack
{
    [self registerText];
    if (([self isUser:userName]&&[self isValidateCall:getType]&&[self isPassword:passWord]&&[passWord isEqualToString:rePassWord]&&getNum)||([self isValidateEmail:getType]&&[self isPassword:passWord]&&[self isUser:userName]&&[passWord isEqualToString:rePassWord]&&getNum))
    {
        NSDictionary *userDic = @{@"username":userName,@"emailnumber":getType,@"emailnumber":getType,@"yzm":getNum,@"password":passWord};
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
        
        NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
        
        //NSString *stringBody = [self encodeString:bbbb];
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"112",@"flag":@"4"};
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,ForgetApi];//112
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
            if ([responseDict[@"status"] integerValue]==0) {
                NSString *data = responseDict[@"data"];
                NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
                if ([dic[@"status"] integerValue]==0) {
                    NSLog(@"%@",dic[@"msg"]);
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
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
                    //NSMutableArray *getUser = plistDict[@"LoginUserName"];
                    NSArray* registArray = [plistDict objectForKey:@"LoginUserName"];
                    NSMutableArray* getUser = nil;
                    if (registArray == nil){
                        getUser = [NSMutableArray array];
                    }else{
                        getUser = [NSMutableArray arrayWithArray:registArray];
                    }
                    int a = 0;
                    for (NSDictionary *dic  in getUser) {
                        if ([dic[@"userName"]isEqualToString:userName]) {
                            a =  [getUser indexOfObject:dic];
                        }
                    }
                    NSDictionary *dic = @{@"userName":userName,@"passWord":@"123",@"remember":[NSString stringWithFormat:@"%d",0]};
                    if (getUser.count > 0) {
                        [getUser replaceObjectAtIndex:a withObject:dic];
                    }else{
                        [getUser addObject:dic];
                    }
                    
                    [plistDict setObject:getUser forKey:@"LoginUserName"];
                    BOOL result=[plistDict writeToFile:LoginPlist atomically:YES];
                    if (result) {
                        NSLog(@"存入成功");
                        [LoginHUD removeFromSuperview];
                        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:HUD];
                        HUD.labelText = dic[@"msg"];
                        //如果设置此属性则当前的view置于后台
                        HUD.dimBackground = YES;
                        HUD.yOffset = 20;
                        HUD.mode = MBProgressHUDModeText;
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        NSLog(@"存入失败");
                        return ;
                    }
                    // [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
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
                
            }
            else
            {
                NSLog(@"%@",dic[@"msg"]);
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
    }else if (![passWord isEqualToString:rePassWord]){
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"密码重复输入不一致";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }else{
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请输入正确的个人信息";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}
-(void)registerText
{
    [((UITextField*)[self.view viewWithTag:3000])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3001])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3002])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3003])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3004])resignFirstResponder];
}
//获取验证码
-(void)getNum
{
    [self registerText];
    if ([self isUser:userName]&&([self isValidateCall:getType]||[self isValidateEmail:getType])) {
        NSLog(@"userNameuserNameuserName%@ getTypegetTypegetTypegetTypegetType=%@",userName,getType);
        NSDictionary *userDic = @{@"username":userName,@"emailnumber":getType};
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
        
         NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
        
        //NSString *stringBody = [self encodeString:bbbb];
        NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"114",@"flag":@"4"};
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,EmailOrPhoneNum];
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if ([responseDict[@"status"] integerValue]==0) {
                NSString *data = responseDict[@"data"];
                NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"----%@ -------%@",dic,dic[@"msg"]);
                if ([dic[@"status"] integerValue]==0) {
                    NSLog(@"%@",dic[@"msg"]);
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = dic[@"msg"];
                    //如果设置此属性则当前的view置于后台
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1.2];
                    
                    [self getNumBtnChange];
                }
                else
                {
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = dic[@"msg"];
                    //如果设置此属性则当前的view置于后台
                    HUD.dimBackground = YES;
                    HUD.yOffset = 20;
                    HUD.mode = MBProgressHUDModeText;
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1.2];
                }
            }
            else
            {
                NSLog(@"%@",dic[@"msg"]);
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = dic[@"msg"];
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                HUD.yOffset = 20;
                HUD.mode = MBProgressHUDModeText;
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"服务器请求失败，请检查网络";
            //如果设置此属性则当前的view置于后台
            HUD.dimBackground = YES;
            HUD.yOffset = 20;
            HUD.mode = MBProgressHUDModeText;
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.2];
        }];
    }
    else
    {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请输入正确的个人信息";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        HUD.yOffset = 20;
        HUD.mode = MBProgressHUDModeText;
        [HUD show:YES];
        [HUD hide:YES afterDelay:0.7];
    }
}
//获取验证码以后按钮的改变
-(void)getNumBtnChange
{
    ((UIButton *)[self.view viewWithTag:6000]).userInteractionEnabled = NO;
    ((UIButton *)[self.view viewWithTag:6000]).backgroundColor = [UIColor lightGrayColor];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog:) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)myLog:(NSTimer *)timer
{
    --time;
    ((UIButton *)[self.view viewWithTag:6000]).titleLabel.text = [NSString stringWithFormat:@"%ds",time];
    [((UIButton *)[self.view viewWithTag:6000]) setTitle:[NSString stringWithFormat:@"%ds",time] forState:UIControlStateNormal];
    if (time == 0) {
        ((UIButton *)[self.view viewWithTag:6000]).userInteractionEnabled = YES;
        ((UIButton *)[self.view viewWithTag:6000]).backgroundColor = IWColor(60, 170, 249);
        ((UIButton *)[self.view viewWithTag:6000]).titleLabel.text = @"获取验证码";
        [((UIButton *)[self.view viewWithTag:6000]) setTitle:@"获取验证码" forState:UIControlStateNormal];
        time = 60;
        [timer invalidate];
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
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [((UITextField*)[self.view viewWithTag:3000])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3001])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3002])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3003])resignFirstResponder];
    [((UITextField*)[self.view viewWithTag:3004])resignFirstResponder];
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
