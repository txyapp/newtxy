//
//  ShouCangViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/12/2.
//  Copyright © 2015年 yunlian. All rights reserved.
//

#import "ShouCangViewController.h"
#import "TXYConfig.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define Height ([UIScreen mainScreen].bounds.size.height)
#define Width ([UIScreen mainScreen].bounds.size.width)
@interface ShouCangViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
}

@end

@implementation ShouCangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = WhichMap;
    _dataArray = [NSMutableArray array];
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
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userPoint objectForKey:@"collect"];
    NSMutableArray* userArray = nil;
    if (array == nil){
        userArray = [NSMutableArray array];
    }else{
        userArray = [NSMutableArray arrayWithArray:array];
    }
        //腾讯或者百度的收藏共享
    if ([whichMap isEqualToString:@"tencent"]||[whichMap isEqualToString:@"baidu"]||!whichMap) {
            for (int i = 0; i<userArray.count; i++) {
                NSMutableDictionary* dict = userArray[i];
                if ([dict[@"whichMap"] isEqualToString:@"baidu"]||(!dict[@"whichMap"])||[dict[@"whichMap"] isEqualToString:@"tencent"]) {
                    [_dataArray addObject:dict];
                }
            }
        }
        //谷歌单独收藏
    if ([whichMap isEqualToString:@"google"]) {
            for (int i = 0; i<userArray.count; i++) {
                NSMutableDictionary* dict = userArray[i];
                if ([dict[@"whichMap"] isEqualToString:@"google"]) {
                    [_dataArray addObject:dict];
                }
            }
        }
    [self makeView];
}


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)makeView{
    self.title = @"收藏选点";
    _tableView = [[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, Width, Height-64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
}

//多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

//cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //点
    NSMutableDictionary* dict = nil;
    if (_dataArray.count) {
        dict = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"地点:%@  添加时间:%@",dict[@"name"],dict[@"time"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:@"default_busline_icon_stopsign@2x"];
    return cell;
}

//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dict1 = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([dict1[@"latitudeNum"] doubleValue], [dict1[@"longitudeNum"] doubleValue]);
    [[TXYConfig sharedConfig]setLocationWithBundleId:self.bundleID andType:FakeGPSTypeFav andGPS:coord];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
