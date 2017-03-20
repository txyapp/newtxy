//
//  ShezhiViewController.m
//  TxyFakePhone
//
//  Created by yunlian on 16/3/25.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "ShezhiViewController.h"
#import "FakeTableViewCell.h"
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
#define PlistPath @"/var/mobile/Library/Preferences/txyfakephone.plist"
#define PlistPathDM @"/var/mobile/Library/Preferences/txyfakephonedm.plist"

#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define line [UIColor colorWithRed:226/255.0f green:226/255.0f blue:229/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ShezhiViewController ()<UITableViewDataSource,UITableViewDelegate,PassDelegate>{
    MBProgressHUD* HUD;
    UIScrollView *_scroller;
}
@property(nonatomic,strong)NSDictionary *allAppInfo;
@property(nonatomic,strong)NSArray *allAppArray;
@property(nonatomic,strong)NSMutableArray *selectAppArray;
@property(nonatomic,strong)ipaManage *ipaMgr;
@property (strong, nonatomic)UISwitch *cleanApp;
@property (strong, nonatomic)UISwitch *cleanSafari;
@property (strong, nonatomic)UISwitch *cleanKeyChain;
@property (strong, nonatomic)UISwitch *cleanCopy;
@property (strong, nonatomic)UISwitch *set3G;
//@property (strong, nonatomic)UISwitch *randomData;
@property (strong, nonatomic)UISwitch *backUp;
@property (strong,nonatomic)UISwitch * shuju;
@property (strong, nonatomic)UISwitch *wifimac;
@property (strong, nonatomic)UISwitch *wifiname;
@property (strong, nonatomic)UISwitch *uuid;
@property (strong, nonatomic)UISwitch *aduuid;
@property (strong, nonatomic)UISwitch *macname;
@property (strong, nonatomic)UISegmentedControl *netStateSegment;
@property (strong, nonatomic)UISegmentedControl *devTypeSegment;
@property (strong, nonatomic)UISegmentedControl *devVerSegment;

@property(nonatomic,retain)NSMutableArray *ImgS;
@end

@implementation ShezhiViewController

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

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
    NSLog(@"dict = %@",dict);
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
    NSString* randomData = [muDict objectForKey:@"randomData"];
    NSString* devType = [muDict objectForKey:@"devType"];
    NSString* devVer = [muDict objectForKey:@"devVer"];
    NSString* backUp = [muDict objectForKey:@"backUp"];
    NSString* keyzhi = [muDict objectForKey:@"shuju"];
    NSString* shuju = [muDict objectForKey:@"shuju"];
    NSString* macname = [muDict objectForKey:@"macname"];
    NSString* wifiname = [muDict objectForKey:@"wifiname"];
    NSString* wifimac = [muDict objectForKey:@"wifimac"];
    NSString* uuid = [muDict objectForKey:@"uuid"];
    NSString* aduuid = [muDict objectForKey:@"aduuid"];
    if ([cleanSafari isEqualToString:@"yes"]) {
        self.cleanSafari.on = YES;
    }else{
        self.cleanSafari.on = NO;
    }
    if ([cleanCopy isEqualToString:@"yes"]) {
        self.cleanCopy.on = YES;
    }else{
        self.cleanCopy.on = NO;
    }
    if ([cleanApp isEqualToString:@"yes"]) {
        self.cleanApp.on = YES;
    }else{
        self.cleanApp.on = NO;
    }
    if ([cleanKeyChain isEqualToString:@"yes"]) {
        self.cleanKeyChain.on = YES;
    }else{
        self.cleanKeyChain.on = NO;
    }
    if ([set3G isEqualToString:@"yes"]) {
        self.set3G.on = YES;
    }else{
        self.set3G.on = NO;
    }
    if ([wifimac isEqualToString:@"yes"]) {
        self.wifimac.on = YES;
    }else{
        self.wifimac.on = NO;
    }
    if ([wifiname isEqualToString:@"yes"]) {
        self.wifiname.on = YES;
    }else{
        self.wifiname.on = NO;
    }
    if ([uuid isEqualToString:@"yes"]) {
        self.uuid.on = YES;
    }else{
        self.uuid.on = NO;
    }
    if ([aduuid isEqualToString:@"yes"]) {
        self.aduuid.on = YES;
    }else{
        self.aduuid.on = NO;
    }
    if ([macname isEqualToString:@"yes"]) {
        self.macname.on = YES;
    }else{
        self.macname.on = NO;
    }
    if ([devType isEqualToString:@"iPhone"]) {
        self.devTypeSegment.selectedSegmentIndex = 0;
    }else if([devType isEqualToString:@"iPad"]){
        self.devTypeSegment.selectedSegmentIndex = 1;
    }else{
        self.devTypeSegment.selectedSegmentIndex = 2;
    }
    if ([devVer isEqualToString:@"iOS7"]) {
        self.devVerSegment.selectedSegmentIndex = 0;
    }else if([devVer isEqualToString:@"iOS8"]){
        self.devVerSegment.selectedSegmentIndex = 1;
    }else if([devVer isEqualToString:@"iOS9"]){
        self.devVerSegment.selectedSegmentIndex = 2;
    }else{
        self.devVerSegment.selectedSegmentIndex = 3;
    }
    if ([backUp isEqualToString:@"yes"]) {
        self.backUp.on = YES;
    }else{
        self.backUp.on = NO;
    }
    if ([shuju isEqualToString:@"yes"]) {
        self.shuju.on = YES;
    }else{
        self.shuju.on = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   // NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    self.ImgS = [NSMutableArray arrayWithCapacity:0];
    [self loadImage];
    [self makeView];
}
//去选中图标的个数
-(void)loadImage
{
    [self.ImgS removeAllObjects];
    NSMutableDictionary *dcit=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPath];
    if(dcit==nil){
        dcit=[NSMutableDictionary dictionary];
    }
    NSArray* selectAppArray = [dcit valueForKey:@"selectApp"];
    for (int i = 0;  i< selectAppArray.count; i ++) {
        UIImage *img =[[AppManage sharedAppManage] getIconForBundleId:selectAppArray[i]];
        if (img) {
           [self.ImgS addObject:img];
        }
        else
        {
            [self.ImgS addObject:[UIImage imageNamed:@"morenapp"]];
        }
    }
    [self.ImgS addObject:[UIImage imageNamed:@"11111111"]];
   // [self.ImgS addObject:[UIImage imageNamed:@"morenapp"]];
}

- (void)fanhui{
    NSMutableDictionary *setDict1=[self loadsetDict];
    //   NSLog(@"setdict = %@",setDict1);
    //   NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
    //  NSLog(@"array = %@",dict);
    NSMutableDictionary* muDict = nil;
    if (dict == nil){
        muDict = [NSMutableDictionary dictionary];
    }else{
        muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    if (self.cleanSafari.on) {
        [muDict setObject:@"yes" forKey:@"cleanSafari"];
    }else{
        [muDict setObject:@"no" forKey:@"cleanSafari"];
    }
    if (self.cleanCopy.on) {
        [muDict setObject:@"yes" forKey:@"cleanCopy"];
    }else{
        [muDict setObject:@"no" forKey:@"cleanCopy"];
    }
    if (self.cleanApp.on) {
        [muDict setObject:@"yes" forKey:@"cleanApp"];
    }else{
        [muDict setObject:@"no" forKey:@"cleanApp"];
    }
    if (self.cleanKeyChain.on) {
        [muDict setObject:@"yes" forKey:@"cleanKeyChain"];
    }else{
        [muDict setObject:@"no" forKey:@"cleanKeyChain"];
    }
    if (self.set3G.on) {
        [muDict setObject:@"yes" forKey:@"set3G"];
    }else{
        [muDict setObject:@"no" forKey:@"set3G"];
    }
    if (self.backUp.on) {
        [muDict setObject:@"yes" forKey:@"backUp"];
    }else{
        [muDict setObject:@"no" forKey:@"backUp"];
    }
    if (self.wifiname.on) {
        [muDict setObject:@"yes" forKey:@"wifiname"];
    }else{
        [muDict setObject:@"no" forKey:@"wifiname"];
    }
    if (self.wifimac.on) {
        [muDict setObject:@"yes" forKey:@"wifimac"];
    }else{
        [muDict setObject:@"no" forKey:@"wifimac"];
    }
    if (self.uuid.on) {
        [muDict setObject:@"yes" forKey:@"uuid"];
    }else{
        [muDict setObject:@"no" forKey:@"uuid"];
    }
    if (self.aduuid.on) {
        [muDict setObject:@"yes" forKey:@"aduuid"];
    }else{
        [muDict setObject:@"no" forKey:@"aduuid"];
    }
    if (self.macname.on) {
        [muDict setObject:@"yes" forKey:@"macname"];
    }else{
        [muDict setObject:@"no" forKey:@"macname"];
    }
    if (self.devTypeSegment.selectedSegmentIndex == 0) {
        [muDict setObject:@"iPhone" forKey:@"devType"];
    }
    if (self.devTypeSegment.selectedSegmentIndex == 1) {
        [muDict setObject:@"iPad" forKey:@"devType"];
    }
    if (self.devTypeSegment.selectedSegmentIndex == 2) {
        [muDict setObject:@"moren" forKey:@"devType"];
    }
    if (self.devVerSegment.selectedSegmentIndex == 0) {
        [muDict setObject:@"iOS7" forKey:@"devVer"];
    }
    if (self.devVerSegment.selectedSegmentIndex == 1) {
        [muDict setObject:@"iOS8" forKey:@"devVer"];
    }
    if (self.devVerSegment.selectedSegmentIndex == 2) {
        [muDict setObject:@"iOS9" forKey:@"devVer"];
    }
    if (self.devVerSegment.selectedSegmentIndex == 3) {
        [muDict setObject:@"moren" forKey:@"devVer"];
    }
    if (self.shuju.on) {
        //判断磁盘空间是否充足
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在计算磁盘空间,请稍后";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //显示对话框
        [HUD show:YES];
        //        [HUD showAnimated:YES whileExecutingBlock:^{
        //
        //        } completionBlock:^{
        //            //操作执行完后取消对话框
        //            [HUD removeFromSuperview];
        //
        //        }];
        if (7) {
            // __block  float kongjian = 0;
            //         __block  int jishu = 0;
            __block  float cipan = [[Tools sharedTools] deviceFreeSpace];
            ipaManage *imaMgr=[[ipaManage alloc]init];
            NSMutableArray* lujingArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < selectAppArray.count; i++) {
                NSDictionary *appDict=[[imaMgr installedApps] objectForKey:selectAppArray[i]];
                NSString *appDataPath=[appDict objectForKey:@"boundDataContainerURL"];
                [lujingArr addObject:appDataPath];
            }
            [[Tools sharedTools]folderSizeAtPath:lujingArr WithBlock:^(float size) {
                NSLog(@"app大小 = %f",size);
                if (cipan < (size +300/1024)) {
                    [KGStatusBar showWithStatus:@"磁盘空间不足，不建议备份APP数据"];
                    [muDict setObject:@"no" forKey:@"shuju"];
                    self.shuju.on = NO;
                    [userPoint setObject:muDict forKey:@"GaiJi"];
                    [userPoint synchronize];
                    [HUD hide:YES];
                }else{
                    self.shuju.on = YES;
                    [muDict setObject:@"yes" forKey:@"shuju"];
                    [userPoint setObject:muDict forKey:@"GaiJi"];
                    [userPoint synchronize];
                    NSLog(@"mudict = %@",muDict);
                    [self.navigationController popViewControllerAnimated:YES];
                    [HUD hide:YES];
                }
            }];
            
        }
    }else{
        [muDict setObject:@"no" forKey:@"shuju"];
        [userPoint setObject:muDict forKey:@"GaiJi"];
        [userPoint synchronize];
        NSLog(@"mudict = %@",muDict);
      //  self.tabBarController.tabBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)baocun{
 //    NSLog(@"mudict = %@",muDict);
//    [userPoint setObject:muDict forKey:@"GaiJi"];
//    [userPoint synchronize];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeView{
    self.tabBarController.tabBar.hidden = YES;
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
 //   NSLog(@"array = %@",dict);
    NSMutableDictionary* muDict = nil;
    if (dict == nil){
        muDict = [NSMutableDictionary dictionary];
    }else{
        muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(baocun)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    self.title = @"设置改机内容";
    self.view.backgroundColor = [UIColor whiteColor];
    //针对某个APP
    self.cleanApp = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.cleanApp addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.cleanKeyChain = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.cleanKeyChain addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.set3G = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.set3G addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.wifiname = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.wifiname addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.wifimac = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.wifimac addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.uuid = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.uuid addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.aduuid = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.aduuid addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.macname = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.macname addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    [self.backUp addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.backUp = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.shuju = [[UISwitch alloc]initWithFrame:CGRectZero];
    [self.shuju addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    self.devTypeSegment=[[UISegmentedControl alloc]initWithItems:@[@"iPhone",@"iPad",@"默认"]];
    self.devVerSegment=[[UISegmentedControl alloc]initWithItems:@[@"iOS7",@"iOS8",@"iOS9",@"默认"]];
    NSString* string = [muDict objectForKey:@"devVer"];
    if ([string isEqualToString:@"iOS7"]) {
        self.devVerSegment.selectedSegmentIndex = 0;
    }else if([string isEqualToString:@"iOS8"]){
        self.devVerSegment.selectedSegmentIndex = 1;
    }else if([string isEqualToString:@"iOS9"]){
        self.devVerSegment.selectedSegmentIndex = 2;
    }else{
        self.devVerSegment.selectedSegmentIndex = 3;
    }
    NSString* string2 = [muDict objectForKey:@"devType"];
    if ([string2 isEqualToString:@"iPhone"]) {
        self.devTypeSegment.selectedSegmentIndex = 0;
    }else if([string2 isEqualToString:@"iPad"]){
        self.devTypeSegment.selectedSegmentIndex = 1;
    }else{
        self.devTypeSegment.selectedSegmentIndex = 2;
    }


        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width , Height-64) style:UITableViewStylePlain];
        if([[UIDevice currentDevice].systemVersion doubleValue]<7.0){
            self.tableView.frame=CGRectMake(0, 0,Width, Height-44-49);
        }
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.rowHeight=50;
     //   self.tableView.tableHeaderView=[self headView];
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[UIColor clearColor];
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [self.view addSubview:self.tableView];
    
   // 针对整个设备
        self.cleanSafari = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.cleanCopy = [[UISwitch alloc] initWithFrame:CGRectZero];
    
      }

- (UIView*)headView{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = IWColor(60, 170, 249);
    view.frame = CGRectMake(0, 0, 0, 30);
    UILabel* lab = [[UILabel alloc]init];
    lab.backgroundColor = IWColor(60, 170, 249);
    lab.text = @"针对整个设备";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:15];
    lab.frame = CGRectMake(0, 0, Width, 30);
    [view addSubview:lab];
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView* view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, Width, 40);
        view.backgroundColor = Color;
        UILabel* label = [[UILabel alloc]init];
        label.frame = CGRectMake(20, 10, Width, 20);
        label.text = @"针对整个设备";
        label.backgroundColor = Color;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        return view;
    }
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = Color;
    view.frame = CGRectMake(0, 0, Width, Width/6.5+20+30);
    //    UILabel* label = [[UILabel alloc]init];
    //    label.frame = CGRectMake(20, 10, Width, 20);
    //    label.text = @"针对某个APP";
    //    label.backgroundColor = Color;
    //    label.textColor = [UIColor grayColor];
    //    label.font = [UIFont systemFontOfSize:14];
    //    [view addSubview:label];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, Width, 30);
    btn.backgroundColor = Color;
    [btn setTitle:@"添加app" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    [view addSubview:btn];
    
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, Width, Width/6.5+20)];
    _scroller.backgroundColor = [UIColor whiteColor];
    _scroller.showsHorizontalScrollIndicator=NO;
    _scroller.showsVerticalScrollIndicator=NO;
    _scroller.contentSize = CGSizeMake(self.ImgS.count*(Width/6.5 +Width/13)+10, Width/6.5);
    
    for (int i = 0; i < self.ImgS.count;  i++) {
        UIButton *appimg = nil;
        //                if (i==0) {
        //                    appimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0 , Width/6.5, Width/6.5)];
        //                }else{
        //
        //                }
        // appimg = [[UIButton alloc]initWithFrame:CGRectMake((0.5+1.5*i)*Width/6.5 -10, 10 , Width/6.5, Width/6.5)];
        appimg = [UIButton buttonWithType:UIButtonTypeCustom];
        appimg.frame = CGRectMake((0.5+1.5*i)*Width/6.5 -10, 10 , Width/6.5, Width/6.5);
        appimg.layer.borderWidth = 1;
        appimg.layer.borderColor = Color.CGColor;
        appimg.layer.masksToBounds = YES;
        appimg.layer.cornerRadius = 5;
        [appimg setImage:self.ImgS[i] forState:UIControlStateNormal];
        [_scroller addSubview:appimg];
        [appimg addTarget:self action:@selector(addApp) forControlEvents:UIControlEventTouchUpInside];
        //        if (i == self.ImgS.count -1) {
        //            [appimg addTarget:self action:@selector(addApp) forControlEvents:UIControlEventTouchUpInside];
        //        }
    }
    [view addSubview:_scroller];
    return view;
}

//添加app
-(void )addApp{
    CleanAppViewController *cleanApp = [[CleanAppViewController alloc]init];
    cleanApp.delegate =self;
    [self.navigationController pushViewController:cleanApp animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    return 12;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [userPoint dictionaryForKey:@"GaiJi"];
  //  NSLog(@"array = %@",dict);
    NSMutableDictionary* muDict = nil;
    if (dict == nil){
        muDict = [NSMutableDictionary dictionary];
    }else{
        muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    FakeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[FakeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }else{
//        cell.textLabel.text=nil;
//        cell.detailTextLabel.text=nil;
//        cell.imageView.image=nil;
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            
            self.cleanSafari.tag=indexPath.row;
            cell.textLabel.text=@"清理Safari";
            cell.accessoryView = self.cleanSafari;
            self.cleanSafari.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"清空剪切板";
            self.cleanCopy.tag=indexPath.row;
            cell.accessoryView = self.cleanCopy;
            self.cleanCopy.onTintColor = IWColor(60, 170, 249);
        }
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row==0) {
            
            self.cleanApp.tag=indexPath.row;
            cell.textLabel.text=@"清理App数据";
            cell.accessoryView = self.cleanApp;
            self.cleanApp.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"清理KeyChain";
            self.cleanKeyChain.tag=indexPath.row;
            cell.accessoryView = self.cleanKeyChain;
            self.cleanKeyChain.onTintColor = IWColor(60, 170, 249);
        }
        
        if (indexPath.row==2) {
            cell.textLabel.text=@"模拟手机网络";
            self.set3G.tag=indexPath.row;
            cell.accessoryView = self.set3G;
            self.set3G.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==3) {
            cell.textLabel.text=@"uuid";
            
            self.uuid.tag=indexPath.row;
            cell.accessoryView = self.uuid;
            self.uuid.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==4) {
            cell.textLabel.text=@"aduuid";
            
            self.aduuid.tag=indexPath.row;
            cell.accessoryView = self.aduuid;
            self.aduuid.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==5) {
            cell.textLabel.text=@"wifi地址";
            
            self.wifimac.tag=indexPath.row;
            cell.accessoryView = self.wifimac;
            self.wifimac.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==6) {
            cell.textLabel.text=@"wifi名字";
            
            self.wifiname.tag=indexPath.row;
            cell.accessoryView = self.wifiname;
            self.wifiname.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==7) {
            cell.textLabel.text=@"设备名字";
            
            self.macname.tag=indexPath.row;
            cell.accessoryView = self.macname;
            self.macname.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row==8) {
            cell.textLabel.text=@"设备类型";
            self.devTypeSegment.bounds=CGRectMake(0, 0, 150, 30);
     //       self.devTypeSegment.selectedSegmentIndex = 2;
            [self.devTypeSegment addTarget:self action:@selector(devTypeChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = self.devTypeSegment;
        }
        if (indexPath.row==9) {
            cell.textLabel.text=@"设备版本";
            self.devVerSegment.bounds=CGRectMake(0, 0, 180, 30);
     //       self.devVerSegment.selectedSegmentIndex = 3;
            [self.devVerSegment addTarget:self action:@selector(devVersionChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = self.devVerSegment;
        }
        if (indexPath.row ==10) {
            cell.textLabel.text = @"参数备份(不包含APP数据)";
            self.backUp.tag=indexPath.row;
            cell.accessoryView = self.backUp;
            self.backUp.onTintColor = IWColor(60, 170, 249);
        }
        if (indexPath.row == 11) {
            cell.textLabel.text = @"参数和APP数据备份";
            self.shuju.tag = indexPath.row;
            cell.accessoryView = self.shuju;
            self.shuju.onTintColor = IWColor(60, 170, 249);
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1 ){
        return Width/6.5+50;
    }
    return 30;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
  //  NSLog(@"setdict = %@",setDict1);
  //  NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
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
- (void)switchClick:(UISwitch*)sender{
  
    NSMutableDictionary *setDict1=[self loadsetDict];
  //  NSLog(@"setdict = %@",setDict1);
  //  NSLog(@"selectapp = %@",[setDict1 valueForKey:@"selectApp"]);
    NSArray* selectAppArray = [setDict1 valueForKey:@"selectApp"];
    if (selectAppArray.count < 1) {
        
        if (sender.on == YES) {
            sender.on = NO;
        }else{
            sender.on = NO;
        }
        [KGStatusBar showWithStatus:@"您还没有选择APP,请先选择APP"];
    }
    if (sender.tag == 11) {
        
        if (sender.on == YES) {
             [KGStatusBar showErrorWithStatus:@"备份APP数据会占用较大内存空间,改机时间可能较长,完成后该开关会关闭"];
        }else{
        }
    }
}

//passdelegate
-(void)chooseApp
{
    NSLog(@"%@",_scroller.subviews);
    for (UIButton *subview in _scroller.subviews) {
        [subview removeFromSuperview];
    }
    NSLog(@"%@",_scroller.subviews);
    [self loadImage];
    _scroller.contentSize = CGSizeMake(self.ImgS.count*(Width/6.5 +Width/13)+10, Width/6.5);
    for (int i = 0; i < self.ImgS.count;  i++) {
        UIButton *appimg = nil;
        //                if (i==0) {
        //                    appimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0 , Width/6.5, Width/6.5)];
        //                }else{
        //
        //                }
        // appimg = [[UIButton alloc]initWithFrame:CGRectMake((0.5+1.5*i)*Width/6.5 -10, 10 , Width/6.5, Width/6.5)];
        appimg = [UIButton buttonWithType:UIButtonTypeCustom];
        appimg.frame = CGRectMake((0.5+1.5*i)*Width/6.5 -10, 10 , Width/6.5, Width/6.5);
        appimg.layer.borderWidth = 1;
        appimg.layer.borderColor = Color.CGColor;
        appimg.layer.masksToBounds = YES;
        appimg.layer.cornerRadius = 5;
        [appimg setImage:self.ImgS[i] forState:UIControlStateNormal];
        [_scroller addSubview:appimg];
        [appimg addTarget:self action:@selector(addApp) forControlEvents:UIControlEventTouchUpInside];
        //        if (i == self.ImgS.count -1) {
        //
        //        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
