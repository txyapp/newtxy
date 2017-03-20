//
//  YundongViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "YundongViewController.h"
#import "YundongTableViewCell.h"
#import "BushuViewController.h"
#import "CameraViewController.h"
@interface YundongViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property(nonatomic,strong)UITableView *appTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *InfoArr;
@property(nonatomic,strong)NSMutableArray *applyArr;
@property(nonatomic,strong)NSMutableArray *ImgArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YundongViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [_appTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   self.view .backgroundColor = [UIColor whiteColor];
    self.title = @"打卡运动";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self makeView];
}

- (void)makeView{
    self.appTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.appTableView.dataSource=self;
    self.appTableView.delegate=self;
    self.appTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // UIColor *myColor = [UIColor colorWithWhite:0.5 alpha:0.8];
  //  self.appTableView.backgroundColor=IWColor(236, 235, 243);
    // self.appTableView.backgroundColor = myColor;
    self.appTableView.rowHeight=60;
    //self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.appTableView];
}

//data
-(void)loadData{
    self.dataArr=[NSMutableArray arrayWithArray:@[@"打卡拍照",@"运动步数"]];
//    self.InfoArr=[NSMutableArray arrayWithArray:@[@"功能:修改您设备的硬件信息和软件数据",@"功能:修改您的打卡照片及运动步数",@"功能:连接整个世界"]];
//    self.applyArr=[NSMutableArray arrayWithArray:@[@"适用于:ios7,ios8,ios9的iPhone或iPad",@"适用于:ios7,ios8,ios9的iPhone或iPad",@"正在开发中,敬请期待..."]];
    self.ImgArr=[NSMutableArray arrayWithArray:@[@"32.png",@"31.png"]];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@"打卡拍照",@"运动步数"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }else{
        /*cell.textLabel.text=nil;
         cell.detailTextLabel.text=nil;
         cell.imageView.image=nil;
         [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];*/
    }
    //[cell.contentView.subviews methodForSelector:@selector(removeFromSuperview)];
//    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, 15, 80, 40)];
//    switchView.onTintColor = IWColor(78, 157, 0);
//    switchView.tintColor = [UIColor whiteColor];
//    switchView.tag = indexPath.section + 5000;
//    [switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
//    [cell addSubview:switchView];
//    [cell setTitle:self.dataArr[indexPath.section] applyText:self.applyArr[indexPath.section] info:self.InfoArr[indexPath.section]];
//    [cell setBackgroundColor1:IWColor(60, 170, 249)];
//    [cell setimageV:[UIImage imageNamed:self.ImgArr[indexPath.section]]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        NSString *str = HeaithKit;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSNumber *kaiguan = [plistDict objectForKey:@"CameraSwitch"];
        if (kaiguan && [kaiguan intValue] == 1) {
            cell.detailTextLabel.text=@"开启";
        }else{
            cell.detailTextLabel.text=@"关闭";
        }
        cell.textLabel.text = _dataArray[indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image=[UIImage imageNamed:_ImgArr[indexPath.section]];
    }
    if (indexPath.section == 1) {
        NSString *str = HeaithKit;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSNumber *kaiguan = [plistDict objectForKey:@"SportSwitch"];
        if (kaiguan && [kaiguan intValue] == 1) {
            cell.detailTextLabel.text=@"开启";
        }else{
            cell.detailTextLabel.text=@"关闭";
        }
        cell.textLabel.text = _dataArray[indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image=[UIImage imageNamed:_ImgArr[indexPath.section]];
    }
    
    return cell;
}

- (void)switchClick:(UISwitch*)switchView{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CameraViewController *camera = [[CameraViewController alloc]init];
        [self.navigationController pushViewController:camera animated:YES];
    }
    if (indexPath.section == 1) {
        BushuViewController* bsvc = [[BushuViewController alloc]init];
        [self.navigationController pushViewController:bsvc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
