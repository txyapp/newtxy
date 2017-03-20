//
//  AdvancedViewController.m
//  TXYBaiDuNewApp
//
//  Created by yun on 16/6/16.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "AdvancedViewController.h"
#import "ADTableViewCell.h"
#import "FakePhoneViewController.h"
#import "PopoverView.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import "YundongViewController.h"
@interface AdvancedViewController()<UITableViewDataSource,UITableViewDelegate>{
    YWFeedbackKit* ywkit;
}

@property(nonatomic,strong)UITableView *appTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *InfoArr;
@property(nonatomic,strong)NSMutableArray *applyArr;
@property(nonatomic,strong)NSMutableArray *ImgArr;
@end

@implementation AdvancedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //实例化反馈类
    ywkit = [[YWFeedbackKit alloc]initWithAppKey:@"23346249"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor=IWColor(60, 170, 249);
    //返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"高级";
    _luntanBtn  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_note_press"] style:UIBarButtonItemStylePlain target:self action:@selector(luntan)];
    self.navigationItem.leftBarButtonItem = _luntanBtn;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self loadData];
    [self initUI];
}
//data
-(void)loadData{
    if (iOS8) {
        self.dataArr=[NSMutableArray arrayWithArray:@[@"全能改机",@"辅助功能",@"VPN"]];//,辅助功能
        self.InfoArr=[NSMutableArray arrayWithArray:@[@"功能:修改您设备的硬件信息和软件数据",@"功能:打卡拍照，运动步数",@"功能:连接整个世界"]];//,@"功能:打卡拍照，运动步数"
        self.applyArr=[NSMutableArray arrayWithArray:@[@"适用于:ios7,ios8,ios9的iPhone或iPad",@"适用于:ios7,ios8,ios9的iPhone或iPad",@"正在开发中,敬请期待..."]];//,@"适用于:ios7,ios8,ios9的iPhone或iPad"
        self.ImgArr=[NSMutableArray arrayWithArray:@[@"114.png",@"35.png",@"timg.jpeg"]];//,@"35.png"
    }else{
        self.dataArr=[NSMutableArray arrayWithArray:@[@"全能改机",@"VPN"]];//,辅助功能
        self.InfoArr=[NSMutableArray arrayWithArray:@[@"功能:修改您设备的硬件信息和软件数据",@"功能:连接整个世界"]];//,@"功能:打卡拍照，运动步数"
        self.applyArr=[NSMutableArray arrayWithArray:@[@"适用于:ios7,ios8,ios9的iPhone或iPad",@"正在开发中,敬请期待..."]];//,@"适用于:ios7,ios8,ios9的iPhone或iPad"
        self.ImgArr=[NSMutableArray arrayWithArray:@[@"114.png",@"timg.jpeg"]];//,@"35.png"
    }
}

//论坛
- (void)luntan{
    
    
    CGPoint point = CGPointMake(30,50);	
    NSArray *titles = @[@"高级论坛",@"高级反馈"];
    PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        if (index == 0) {
            NSLog(@"我是菜单一");
            
        }
        if (index == 1) {
            NSLog(@"我是菜单二");
            [ywkit makeFeedbackViewControllerWithCompletionBlock:^(YWLightFeedbackViewController *viewController, NSError *error) {
                viewController.title = @"用户反馈";
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                [self presentViewController:nav animated:YES completion:nil];
                // [self.navigationController pushViewController:viewController animated:YES];
                viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain
                                                                                                  target:self action:@selector(actionCleanMemory:)];
                viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(actionQuitFeedback)];
            }];
            
        }
        
    };
    [pop show];
}

//关闭论坛
-(void)actionQuitFeedback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionCleanMemory:(id)sender
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


//UI
-(void)initUI
{
    self.appTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.appTableView.dataSource=self;
    self.appTableView.delegate=self;
    self.appTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   // UIColor *myColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    self.appTableView.backgroundColor=IWColor(236, 235, 243);
  // self.appTableView.backgroundColor = myColor;
    self.appTableView.rowHeight=130;
    //self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.appTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;//section头部高度
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[ADTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        /*cell.textLabel.text=nil;
        cell.detailTextLabel.text=nil;
        cell.imageView.image=nil;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];*/
    }
    //[cell.contentView.subviews methodForSelector:@selector(removeFromSuperview)];
    
    [cell setTitle:self.dataArr[indexPath.section] applyText:self.applyArr[indexPath.section] info:self.InfoArr[indexPath.section]];
    [cell setBackgroundColor1:IWColor(60, 170, 249)];
    [cell setimageV:[UIImage imageNamed:self.ImgArr[indexPath.section]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iOS8) {
        if (indexPath.section == 0) {
            FakePhoneViewController* fake = [[FakePhoneViewController alloc]init];
            [self.navigationController pushViewController:fake animated:YES];
        }
        if (indexPath.section == 1) {
            YundongViewController *yudong = [[YundongViewController alloc]init];
            [self.navigationController pushViewController:yudong animated:YES];
        }
    }else{
        if (indexPath.section == 0) {
            FakePhoneViewController* fake = [[FakePhoneViewController alloc]init];
            [self.navigationController pushViewController:fake animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
