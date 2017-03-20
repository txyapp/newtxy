//
//  TotleMapViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/3.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TotleMapViewController.h"
#import "QmapChooseViewController.h"
#import "SaojieMapViewController.h"
#import "ScanNewViewController.h"
#import "TotleScanViewController.h"
#import "GoogleMapChooseViewController.h"
@interface TotleMapViewController ()
{
    QmapChooseViewController *Qmap;
    SaojieMapViewController *SaojieMap;
    GoogleMapChooseViewController *GoogleMap;
    NSString* whichMap;
}
@end

@implementation TotleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    Qmap = [[QmapChooseViewController alloc]init];
    Qmap.index = self.index;
    Qmap.currentPoints = self.currentPoints;
    [self addChildViewController:Qmap];
    SaojieMap = [[SaojieMapViewController alloc]init];
    SaojieMap.index = self.index;
    SaojieMap.currentPoints = self.currentPoints;
    [self addChildViewController:SaojieMap];
    GoogleMap = [[GoogleMapChooseViewController alloc]init];
    GoogleMap.index = self.index;
    GoogleMap.currentPoints = self.currentPoints;
    [self addChildViewController:GoogleMap];
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
        [self.view addSubview:SaojieMap.view];
        
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [self.view addSubview:Qmap.view];
    }
    else
    {
        [self.view addSubview:GoogleMap.view];
    }
    // Do any additional setup after loading the view.
}
-(void)sureClick
{
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [SaojieMap addClick:nil];
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [Qmap addClick:nil];
    }
    else
    {
        [GoogleMap addClick:nil];
    }
//    NSLog(@"%@",self.navigationController.viewControllers);
//    for(UIViewController *controller in self.navigationController.viewControllers)
//    {
//        if ([controller isKindOfClass:[TotleScanViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
}
//-(void)chuanzhiGPS:(XuandianModel *)model
//{
//    NSLog(@"收到消息");
//}
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
