//
//  TotleShowLineViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TotleShowLineViewController.h"
#import "ShowLineViewController.h"
#import "ShowQMapViewController.h"
#import "DataBaseManager.h"
#import "GoogleShowLineViewController.h"
@interface TotleShowLineViewController ()
{
    ShowLineViewController *BShow;
    ShowQMapViewController *QShow;
    GoogleShowLineViewController *GoogleShow;
    NSString* whichMap;
    DataBaseManager *dataManager;
}
@end

@implementation TotleShowLineViewController
@synthesize whichMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [DataBaseManager shareInatance];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"default_feedback_icon_blue_delete_normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(DelButtonClick)];
    self.navigationItem.rightBarButtonItem = item1;
    BShow = [[ShowLineViewController alloc]init];
    BShow.bundle = self.bundle;
    BShow.appName= self.appName;
    BShow.CurrentIndex =self.CurrentIndex;
    BShow.typeShowLine  = [dataManager chargeWhichType:self.bundle];
    BShow.queue =self.queue;
    BShow.isCycle = self.isCycle;
    BShow.index = self.index;
    BShow.Stop = self.Stop;
    BShow.ztOnShowLine = self.ztOnShowLine;
    [self addChildViewController:BShow];
    QShow = [[ShowQMapViewController alloc]init];
    QShow.bundle = self.bundle;
    QShow.appName= self.appName;
    QShow.CurrentIndex =self.CurrentIndex;
    QShow.typeShowLine  = [dataManager chargeWhichType:self.bundle];
    QShow.queue =self.queue;
    QShow.isCycle = self.isCycle;
    QShow.index = self.index;
    QShow.Stop = self.Stop;
    QShow.ztOnShowLine = self.ztOnShowLine;
    [self addChildViewController:QShow];
    GoogleShow = [[GoogleShowLineViewController alloc]init];
    GoogleShow.bundle = self.bundle;
    GoogleShow.appName= self.appName;
    GoogleShow.CurrentIndex =self.CurrentIndex;
    GoogleShow.typeShowLine  = [dataManager chargeWhichType:self.bundle];
    GoogleShow.queue =self.queue;
    GoogleShow.isCycle = self.isCycle;
    GoogleShow.index = self.index;
    GoogleShow.Stop = self.Stop;
    GoogleShow.ztOnShowLine = self.ztOnShowLine;
    [self addChildViewController:GoogleShow];
//    NSString *str = WhichMap;
//    NSMutableDictionary *plistDict;
//    if (str) {
//        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:WhichMap];
//        if (plistDict==nil) {
//            plistDict=[NSMutableDictionary dictionary];
//        }
//    }else{
//        plistDict=[NSMutableDictionary dictionary];
//    }
//    whichMap = [plistDict objectForKey:@"WhichMap"];
    whichMap = self.whichMap;
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [self.view addSubview:BShow.view];
        
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [self.view addSubview:QShow.view];
        
    }
    else
    {
        [self.view addSubview:GoogleShow.view];
    }
    // Do any additional setup after loading the view.
}

-(void)DelButtonClick
{
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        [BShow DelButtonClick];
    }
    else if([whichMap isEqualToString:@"tencent"])
    {
        [QShow DelButtonClick];
    }
    else
    {
        [GoogleShow DelButtonClick];
    }
}
-(void)delDelegate:(NSString *)bundle
{
    [self.delegate DelCellAtIndex:self.bundle];
    [self.navigationController popViewControllerAnimated:YES];
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
