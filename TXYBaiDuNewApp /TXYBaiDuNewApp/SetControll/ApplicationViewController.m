//
//  ApplicationViewController.m
//  TXYBaiDuNewApp
//
//  Created by Macmini1 on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ApplicationViewController.h"
#import "TXYTools.h"
#import "AppManage.h"
#import "MBProgressHUD.h"
#import "MapViewController.h"
#import "TXYConfig.h"

//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]



//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0

@interface ApplicationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;

    NSArray *_allAppArray;
    MBProgressHUD *_HUD;
    NSMutableArray *checkArr;

}
@end

@implementation ApplicationViewController

#pragma obfuscate on
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    checkArr  = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    self.title = @"应用程序";
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
    
 
    
    [self addTableView];//添加TableView
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    _tableView.frame = CGRectMake(0, 0, Width, Height -64 );
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
}



-(void)addTableView
{
    _tableView = [[UITableView alloc] init];
  
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setSeparatorColor:IWColor(204, 204, 204)];
    [self.view addSubview:_tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _allAppArray = [[NSArray alloc]initWithArray:[[AppManage sharedAppManage]getAllAppArray]];
//    NSLog(@"array = %@",_allAppArray);
    
    return _allAppArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    if ([checkArr containsObject:_allAppArray[indexPath.row]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [[AppManage sharedAppManage] getAppNameForBundleId:_allAppArray[indexPath.row]];
    cell.imageView.image = [[AppManage sharedAppManage] getIconForBundleId:_allAppArray[indexPath.row]];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        [[TXYConfig sharedConfig]deleteLocationWithBundleId:_allAppArray[indexPath.row]];
        checkArr  = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    }else{
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        if ((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0 && (int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0) {
            [[TXYConfig sharedConfig]setLocationWithBundleId:_allAppArray[indexPath.row] andType:0 andGPS:[[TXYConfig sharedConfig]getRealGPS]];
        }else{
            [[TXYConfig sharedConfig]setLocationWithBundleId:_allAppArray[indexPath.row] andType:1 andGPS:[[TXYConfig sharedConfig]getFakeGPS]];
        }
        checkArr  = [NSMutableArray arrayWithArray:[[TXYConfig sharedConfig]getAllBundleIdForLoca]];
    }
    [_tableView reloadData];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    

    
    
    
}


/**
 *  NAV  doneButtonTapped
 */
-(void)doneButtonTapped
{
    [self.delegate chuancan:checkArr];
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
