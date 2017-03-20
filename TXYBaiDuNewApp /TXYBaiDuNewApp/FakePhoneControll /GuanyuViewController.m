//
//  GuanyuViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/6/13.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GuanyuViewController.h"
#import "FakeTableViewCell.h"

#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define line [UIColor colorWithRed:226/255.0f green:226/255.0f blue:229/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface GuanyuViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic,strong) NSArray        *questionsArray;
@property (nonatomic,strong) NSArray        *answersArray;

@end

@implementation GuanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    
    self.questionsArray = @[@":关于天下游改机",
                            @":关于天下游改机的操作流程",
                            @":关于改机内容的备份",
                            @":关于恢复内容",
                            @":关于清理app数据",
                            @":关于改机后某些app闪退",
                            @":关于反馈"];
    self.answersArray = @[@"改机是通过运行程序可以将您的手机的一些硬件信息和app信息更改，以实现您的一些需求。",
                          @"运行改机,需要您先设置好改机内容.(1)针对整个设备,你可直接设置.(2)针对app的设置，您需要先在添加app界面选定app以后才能设置。设置以后记得保存.设置完后回到改机界面，点击开始改机即可。PS.由于app数据备份占用空间较大，未避免重复备份，改机完成会自动关闭该按钮,如有需要下次改机前重新设置即可。",
                          @"天下游改机的备份分为参数备份和app包含参数备份两种。参数备份只会保存您除了app数据的基本改机参数如uuid，设备名字等等，不会占用您多少内存空间.app和参数备份会备份基本参数包括选定的app数据，因app数据一般比较大，会占用太多内存空间，建议您如果没必要，选定参数备份即可。",
                          @"恢复操作在恢复界面。因改机内容的备份分为两种，所以备份内容有所区分，黑色字体的是您不包含app数据的备份，蓝色字体的是您包含app数据的备份.选择您想要恢复的内容，点击即可。",
                          @"清理app数据会帮您清除app在您设备上的缓存数据以及账号信息，例如微信,清除后您需要重新输入账号密码登录,但是无法清除您的appID，所以清除后，你还是会收到该app的推送消息,例如别人给你发的信息。所以如果想要彻底清除，建议您先注销账号。",
                          @"由于一些app对系统版本有要求，例如微信，建议您改机时不要改低系统版本，例如您是ios9的系统，您的微信是适配ios9系统的，如果改低系统,可能会造成app闪退问题。",
                          @"如果您对改机有什么问题或者建议，您可以在高级i页面左上角的反馈中，给我们的客服人员留言，我们看到后会给您留言回复或者更新版本解决。"];
    
    [self makeView];
}


- (void)makeView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width , Height-64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.title = @"关于改机";
    [self.view addSubview:_tableView];
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FakeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[FakeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    UIView *labelView = [cell viewWithTag:111];
    if (labelView) {
        [labelView removeFromSuperview];
    }
    UILabel* label = [[UILabel alloc]init];
    label.tag = 111;
    label.frame = CGRectMake(5, 0, Width-10, [self getCellHeightWithContent:[self.answersArray objectAtIndex:indexPath.section] andWidth:(Width-10)]);
    [cell addSubview:label];
   // label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    label.text = [self.answersArray objectAtIndex:indexPath.section];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = Color;
    view.frame = CGRectMake(0, 0, Width, 30);
    UILabel* label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, Width, 20);
    label.backgroundColor = Color;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    label.text = [self.questionsArray objectAtIndex:section];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellHeightWithContent:[self.answersArray objectAtIndex:indexPath.section] andWidth:Width-10];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (CGFloat)getCellHeightWithContent:(NSString *)content andWidth:(CGFloat)width
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+5;
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
