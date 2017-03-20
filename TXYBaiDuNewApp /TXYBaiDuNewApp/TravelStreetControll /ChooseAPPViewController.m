//
//  ChooseAPPViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ChooseAPPViewController.h"
#import "ChooseTripViewController.h"
#import "UserAuth.h"
#import "TXYTools.h"
#import "AppManage.h"
#import "TXYConfig.h"
#import "DataBaseManager.h"
#import "ChooseTypeViewController.h"
#import "TravelStreetViewController.h"
#import "ScanNewViewController.h"
#import "QScanViewController.h"
#import "TotleScanViewController.h"

@interface ChooseAPPViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *allAppArray;
}

@property (nonatomic,strong)UITableView* tableView;

@property (nonatomic)BOOL isAll;

@property (nonatomic)long  row;



@property (nonatomic,strong)UIBarButtonItem *leftItem;

@end

@implementation ChooseAPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    allAppArray = [NSMutableArray arrayWithCapacity:0];
    if (!iOS7) {
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
        self.tabBarController.tabBar.hidden=YES;
        
        UIView *contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame=CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height+tabBar.bounds.size.height);
        
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
    self.isAll = NO;
    self.row = -1;
    [self chargeApp];
    [self makeView];
}
//判断app是否已经规划好路线
-(void)chargeApp
{
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    allAppArray = [NSMutableArray arrayWithArray:[[AppManage sharedAppManage]getAllAppArray]];
    NSLog(@"%lu",(unsigned long)allAppArray.count);
    for (int i = allAppArray.count-1 ; i--;) {
        if ([dataManager isExistRecordWithID:allAppArray[i]]) {
            [allAppArray removeObjectAtIndex:i];
        }
    }
    NSLog(@"%lu",(unsigned long)allAppArray.count);
}
- (void)makeView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"天下游";
    //tableView
    self.tableView = [[UITableView alloc]init];
    
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    self.tableView.frame=CGRectMake(0, 0, W, H);
//    if (!iOS7) {
//        
//        CGFloat H=self.view.frame.size.height-44;
//        self.tableView.frame=CGRectMake(0, 0, W, H);
//        
//    }
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    
}

#pragma mark - tableView delegate
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"array = %@",allAppArray);
    
    return allAppArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]init];
        
    }
    //选中cell时无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
     cell.textLabel.text = [[AppManage sharedAppManage] getAppNameForBundleId:allAppArray[indexPath.row]];
     cell.imageView.image = [[AppManage sharedAppManage] getIconForBundleId:allAppArray[indexPath.row]];
    if (indexPath.row == _row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (1) {
//        ChooseTypeViewController *type = [[ChooseTypeViewController alloc]init];
//        type.boundle = allAppArray[indexPath.row];
//        for(UIViewController *controller in self.navigationController.viewControllers)
//        {
//            if ([controller isKindOfClass:[TravelStreetViewController class]]) {
//                TravelStreetViewController *travel = (TravelStreetViewController *)controller;
//                type.delegate =travel;
//            }
//        }
//        [self.navigationController pushViewController:type animated:YES];
//    }else{
//      
//    }
    
    TotleScanViewController *totleScan = [[TotleScanViewController alloc]init];
    totleScan.boundle = allAppArray[indexPath.row];
    
    
//    ScanNewViewController *scan = [[ScanNewViewController alloc]init];
//    scan.boundle = allAppArray[indexPath.row];
//    
//    QScanViewController *qscan = [[QScanViewController alloc]init];
//    qscan.boundle = allAppArray[indexPath.row];
    for(UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[TravelStreetViewController class]]) {
            TravelStreetViewController *travel = (TravelStreetViewController *)controller;
            totleScan.delegate =travel;
        }
    }
    [self.navigationController pushViewController:totleScan animated:YES];
//    ScanNewViewController *scan = [[ScanNewViewController alloc]init];
//    [self.navigationController pushViewController:scan animated:YES];

}




#pragma mark - 左右按钮

//确定or返回
- (void)leftButtonClick{
    
    
        if (!iOS7) {
            UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
            self.tabBarController.tabBar.hidden=NO;
            
            UIView *contentView = [self.tabBarController.view.subviews objectAtIndex:0];
            contentView.frame=CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height-tabBar.bounds.size.height);
        }else{
            self.tabBarController.tabBar.hidden = NO;
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    
    }



/*
//全选
- (void)rightButtonClick{
    
    if (self.isAll == YES) {
        self.isAll = NO;
        [_tableView reloadData];
    }
    else {
        self.isAll = YES;
        [_tableView reloadData];
    }
    
}*/



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
