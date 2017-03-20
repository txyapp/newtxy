//
//  FakeApplicationViewController.m
//  TXYBaiDuNewApp
//
//  Created by Macmini1 on 15/9/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "FakeApplicationViewController.h"
#import "AppManage.h"
#import "TXYConfig.h"
#import "MapViewController.h"
#import "CollectViewController.h"
#import "MyAlert.h"
#import "TXYTools.h"
#import "ShouCangViewController.h"
#import "TencentMapViewController.h"
#import "GoogleMapViewController.h"
#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
@interface FakeApplicationViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation FakeApplicationViewController
#pragma obfuscate on
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setTitle:[[AppManage sharedAppManage] getAppNameForBundleId:self.appId]];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 4;
    }
    else {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdenifier = @"cell";
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdenifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"真实位置";
            if ([[[TXYConfig sharedConfig]getLocationWithBundleId:self.appId][@"FakeType"] intValue] == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }else if(indexPath.row == 1){
         cell.textLabel.text = @"模拟位置";
            if ([[[TXYConfig sharedConfig]getLocationWithBundleId:self.appId][@"FakeType"] intValue] == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
       
        }else if (indexPath.row == 2){
          cell.textLabel.text = @"收藏选点";

            if ([[[TXYConfig sharedConfig]getLocationWithBundleId:self.appId][@"FakeType"] intValue] == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }else if (indexPath.row == 3){
        cell.textLabel.text = @"地图选点";
            if ([[[TXYConfig sharedConfig]getLocationWithBundleId:self.appId][@"FakeType"] intValue] == 3) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
     return cell;
  }
//    else if (indexPath.section == 1){
//        static NSString *cellIdenifier = @"cell";
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdenifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifier];
//            
//            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
//            cell.accessoryView = switchView;
//            [switchView setOn:YES animated:NO];
//            //[switchView addTarget:self action:@selector(switchChanged:)forControlEvents:UIControlEventValueChanged];
//        }
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"开启扫街";
//        }
//
//        return cell;
//}
    else {
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"删除";
        
        [cell.textLabel setTextColor:[UIColor redColor]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //当开关开启时
        if ([[TXYConfig sharedConfig]getToggle]&&[[TXYTools sharedTools]isCanOpen]) {
            //地图选点
            if (indexPath.row == 3) {
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
                MapViewController* mpvc = [[MapViewController alloc]init];
                mpvc.isAPP = YES;
                mpvc.bundleID = self.appId;
                TencentMapViewController* tcmp = [[TencentMapViewController alloc]init];
                tcmp.isAPP = YES;
                tcmp.bundleID = self.appId;
                GoogleMapViewController* ggmp = [[GoogleMapViewController alloc]init];
                ggmp.isAPP = YES;
                ggmp.bundleID = self.appId;
                if ([whichMap isEqualToString:@"baidu"]||!whichMap) {
                     [self.navigationController pushViewController:mpvc animated:YES];
                }
                if ([whichMap isEqualToString:@"tencent"]) {
                    [self.navigationController pushViewController:tcmp animated:YES];
                }
                if ([whichMap isEqualToString:@"google"]) {
                    [self.navigationController pushViewController:ggmp animated:YES];
                }
        }
        //收藏选点
        if (indexPath.row == 2) {
                ShouCangViewController* clvc = [[ShouCangViewController alloc]init];
                clvc.bundleID = self.appId;
                [self.navigationController pushViewController:clvc animated:YES];
                   }
        //真实位置
        if (indexPath.row == 0) {
            [[TXYConfig sharedConfig]setLocationWithBundleId:self.appId andType:FakeGPSTypeReal andGPS:[[TXYConfig sharedConfig]getRealGPS]];
             NSDictionary* dict = [[TXYConfig sharedConfig]getLocationWithBundleId:self.appId];
             NSLog(@"nihao = %d",[dict[@"FakeType"] intValue]);
            [_tableView reloadData];
        }
        //模拟位置
        if (indexPath.row == 1) {
            if ((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0 && (int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0) {
                [MyAlert ShowAlertMessage:@"当前还没有选定模拟位置,请先在主页面选定模拟位置" title:@"温馨提示"];
                [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            }else{
            [[TXYConfig sharedConfig]setLocationWithBundleId:self.appId andType:FakeGPSTypeSystem andGPS:[[TXYConfig sharedConfig]getFakeGPS]];
         
           
            NSDictionary* dict = [[TXYConfig sharedConfig]getLocationWithBundleId:self.appId];
            [_tableView reloadData];
            NSLog(@"nihao = %d",[dict[@"FakeType"] intValue]);
            }
        }
        }
        else{
            [MyAlert ShowAlertMessage:@"开关未打开，请打开开关" title:@"温馨提示"];
        }
    }
    

     if (indexPath.section == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"确定删除该应用?"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert setTransform:CGAffineTransformMakeTranslation(0.0, -100.0)];  //可以调整弹出框在屏幕上的位置
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex == 1) {
        [[TXYConfig sharedConfig]deleteLocationWithBundleId:self.appId];
        [self.navigationController popViewControllerAnimated:YES];
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
