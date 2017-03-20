//
//  CleanAppViewController.m
//  FakePhoneApp
//
//  Created by root1 on 15/9/7.
//  Copyright (c) 2015年 root1. All rights reserved.
//

#import "CleanAppViewController.h"
#import <sys/sysctl.h>
#import <dlfcn.h>
#include <mach-o/dyld.h>
#include <notify.h>
#import <sqlite3.h>
#import "CleanAppViewController.h"
#import "ipaManage.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define PlistPath @"/var/mobile/Library/Preferences/txyfakephone.plist"
#define PlistPathDM @"/var/mobile/Library/Preferences/txyfakephonedm.plist"

#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define line [UIColor colorWithRed:226/255.0f green:226/255.0f blue:229/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface CleanAppViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)ipaManage *ipaMgr;
@property(nonatomic,strong)UITableView *appTableView;
@property(nonatomic,strong)NSDictionary *allAppInfo;
@property(nonatomic,strong)NSArray *allAppArray;
@property(nonatomic,strong)NSMutableArray *selectAppArray;

@end

@implementation CleanAppViewController

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


- (void)fanhui{
    [self save];
    [self.delegate chooseApp];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [super viewDidLoad];
    self.title=@"选择APP";
    NSMutableDictionary *setDict=[self loadsetDict];
    if ([setDict objectForKey:@"selectApp"]) {
        self.selectAppArray = [setDict objectForKey:@"selectApp"];
    }else{
        self.selectAppArray = [[NSMutableArray alloc]init];
    }
    //获取全部app
    self.ipaMgr=[[ipaManage alloc]init];
    self.allAppInfo=[self.ipaMgr installedApps];
    self.allAppArray=[self.allAppInfo allKeys];
    
    self.appTableView=[[UITableView alloc]init];
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    self.appTableView.frame=CGRectMake(0, 0, W, H - 80);
    if (!iOS7) {
        CGFloat H=self.view.frame.size.height-44;
        self.appTableView.frame=CGRectMake(0, 0, W, H);
    }
    self.appTableView.dataSource=self;
    self.appTableView.delegate=self;
    [self.view addSubview:self.appTableView];
    
    //清除按钮
//    UIButton *cleanBtn=[UIButton buttonWithType:UIButtonTypeSystem];
//    cleanBtn.bounds=CGRectMake(0, 0, 50, 40);
//    [cleanBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [cleanBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rBarButton = [[UIBarButtonItem alloc] initWithCustomView:cleanBtn];
//    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allAppArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UISwitch* _switch = [[UISwitch alloc]init];
    cell.accessoryView = _switch;
    _switch.tag = indexPath.row;
    [_switch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    //app名字
    NSString *bundleId=self.allAppArray[indexPath.row];
    cell.textLabel.text=[[self.allAppInfo objectForKey:bundleId]objectForKey:@"appName"];
    //app icon
    NSData *imgData=[self.ipaMgr bundleIconForAppID:bundleId];
    cell.imageView.image=[UIImage imageWithData:imgData];
    //app 是否选中
    if ([self.selectAppArray containsObject:bundleId]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        _switch.on = YES;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
        _switch.on = NO;
    }
    return cell;
}

- (void)switchClick:(UISwitch*)_switch{
    NSLog(@"array = %@",self.selectAppArray);
    NSString *bundleID=self.allAppArray[_switch.tag];
    BOOL isContainPath=[self.selectAppArray containsObject:bundleID];
    if (isContainPath) {
        NSLog(@"remove %@ ",bundleID);
        [self.selectAppArray removeObject:bundleID];
        _switch.on = NO;
    }else{
        NSLog(@"add %@ ",bundleID);
        [self.selectAppArray addObject:bundleID];
        _switch.on = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)save{
    NSMutableDictionary *setDict=[self loadsetDict];
    [setDict setObject:self.selectAppArray forKey:@"selectApp"];
    NSLog(@"setdict = %@",setDict);
    [self wrSetDict:setDict];
}


@end
