//
//  TotleScanViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TotleScanViewController.h"
#import "QScanViewController.h"
#import "ScanNewViewController.h"
#import "GoogleScanViewController.h"
@interface TotleScanViewController ()
{
    QScanViewController *Qscan;
    ScanNewViewController *Scan;
    GoogleScanViewController *GoogleScan;
    NSString* whichMap;
}
@end

@implementation TotleScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    Qscan = [[QScanViewController alloc]init];
    Qscan.boundle = self.boundle;
    Qscan.isShowLine = self.isShowLine;
    [self addChildViewController:Qscan];
    Scan = [[ScanNewViewController alloc]init];
    Scan.boundle = self.boundle;
    Scan.isShowLine = self.isShowLine;
    [self addChildViewController:Scan];
    GoogleScan = [[GoogleScanViewController alloc]init];
    GoogleScan.boundle = self.boundle;
    GoogleScan.isShowLine = self.isShowLine;
    [self addChildViewController:GoogleScan];
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
    whichMap = [plistDict objectForKey:@"WhichMap"];
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [self.view addSubview:Scan.view];
        
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [self.view addSubview:Qscan.view];
        
    }
    else
    {
        [self.view addSubview:GoogleScan.view];
    }
    // Do any additional setup after loading the view.
}
-(void)sureClick
{
        if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
            //此时界面应该是跳转百度的
            [Scan sure];
        }
        else if([whichMap isEqualToString:@"tencent"])
        {
            [Qscan sure];
        }
        else
        {
            [GoogleScan sure];
        }
}
-(void)chuanzhi:(XuandianModel *)model
{
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [Scan chuanzhi:model];
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [Qscan chuanzhi:model];
    }
    else
    {
        [GoogleScan chuanzhi:model];
    }
}
- (void)chuanzhiGPS:(XuandianModel *)model{
    //NSLog(@"model.la = %f",[model.latitudeNum doubleValue]);
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [Scan chuanzhiGPS:model];
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [Qscan chuanzhiGPS:model];
    }
    else
    {
        [GoogleScan chuanzhiGPS:model];
    }
}
-(void)chuanLines:(NSArray *)arr
{
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [Scan chuanLines:arr];
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [Qscan chuanLines:arr];
    }
    else{
        [GoogleScan chuanLines:arr];
    }
}
-(void)backTravelStreet
{
    self.tabBarController.selectedIndex = 2;
    [self.delegate refrush];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)backTravelStreetWith:(NSString *)bundle
{
    self.tabBarController.selectedIndex = 2;
    [self.delegate refrushWith:bundle];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
