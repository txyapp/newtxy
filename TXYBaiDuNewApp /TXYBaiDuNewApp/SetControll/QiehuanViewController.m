//
//  QiehuanViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "QiehuanViewController.h"
#import "MyAlert.h"
#import "TXYConfig.h"
#import "WGS84TOGCJ02.h"

@interface QiehuanViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView* _tableView;
    NSArray* _dataArray;
    NSString* mapString;
}

@end

@implementation QiehuanViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self makeView];
    [self makeData];
}
- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
}
- (void)makeData{
     _dataArray = @[@"百度地图",@"腾讯地图",@"谷歌地图"];
}

- (void)makeView{
   
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setSeparatorColor:IWColor(204, 204, 204)];
    _tableView.rowHeight = 60;
    
    UIView* footView = [[UIView alloc]init];
    UILabel* footLab = [[UILabel alloc]init];
    footLab.text = @"1.腾讯地图不支持国外选点，地图切换至腾讯时注意不要将模拟位置定在国外。\n2.由于不同地图扫街路线不同，将会根据计算路线时的地图类型进行扫街。\n3.谷歌地图在国内定位会有一些偏差。\n4.谷歌地图正在逐步开发和优化，有什么好的建议和意见可以反馈给客服。\n5.谷歌地图扫街功能正在测试，即将发布。";
    footLab.textColor = [UIColor grayColor];
    footLab.frame = CGRectMake(20, 0, Width - 40, 150);
    footLab.numberOfLines = 0;
    footLab.font = [UIFont systemFontOfSize:13];
    [footView addSubview:footLab];
    footView.frame = CGRectMake(0, 0, Width, 150);
    _tableView.tableFooterView = footView;
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSString* whichMap = [plistDict objectForKey:@"WhichMap"];
    NSLog(@"whichmap1 = %@",whichMap);
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"baidu 50"];
        cell.detailTextLabel.text = @"默认地图";
    }
    if (indexPath.row == 1) {
        if ([whichMap isEqualToString:@"tencent"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"tengxun 50"];
        cell.detailTextLabel.text = @"适用于用腾讯地图的用户";
    }
    if (indexPath.row == 2) {
        if ([whichMap isEqualToString:@"google"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"guge 50"];
        cell.detailTextLabel.text = @"可全球定位,单独的收藏夹";
    }
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //百度地图
    if (indexPath.row == 0) {
        mapString = @"baidu";
    }
    //腾讯地图
    if (indexPath.row == 1) {
        mapString = @"tencent";
    }
    //谷歌地图
    if (indexPath.row == 2) {
        mapString = @"google";
    }
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    //判断是否坐标在国外并且切换腾讯地图
    if ([WGS84TOGCJ02 isLocationOutOfChina:coord] && [mapString isEqualToString:@"tencent"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"!!!可能无法显示地图" message:@"您目前模拟位置定在国外,切换至腾讯地图后可能无法显示地图,您还要这样做吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"切换地图引擎后您需要重启软件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
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
        if (mapString) {
            [plistDict setObject:mapString forKey:@"WhichMap"];
        }
        //同步操作
        BOOL result=[plistDict writeToFile:WhichMap atomically:YES];
        if (result) {
            NSLog(@"存入成功");
        }else{
            NSLog(@"存入失败");
        }
        [_tableView reloadData];
        exit(0);
    }else{
        mapString = @"";
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
