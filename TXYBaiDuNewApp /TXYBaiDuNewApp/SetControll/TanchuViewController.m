//
//  TanchuViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/2/22.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TanchuViewController.h"

@interface TanchuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* _tableView;
    NSArray* _dataArray;
}

@end

@implementation TanchuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    [self makeView];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
}

- (void)makeView{
    _dataArray = @[@"不计时",@"5秒",@"10秒",@"20秒"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setSeparatorColor:IWColor(204, 204, 204)];
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* time = [userPoint objectForKey:@"Time"];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        if ([time isEqualToString:@"no"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (indexPath.row == 1) {
        if ([time isEqualToString:@"5s"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (indexPath.row == 2) {
        if ([time isEqualToString:@"10s"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (indexPath.row == 3) {
        if ([time isEqualToString:@"20s"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
 
    cell.textLabel.text = _dataArray[indexPath.row];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* time = [userPoint objectForKey:@"Time"];
    NSLog(@"1 = %@",time);
      //不计时
    if (indexPath.row == 0) {
        [userPoint setObject:@"no" forKey:@"Time"];
        [userPoint synchronize];
    }
    //5秒
    if (indexPath.row == 1) {
        [userPoint setObject:@"5s" forKey:@"Time"];
        [userPoint synchronize];
    }
    //10秒
    if (indexPath.row == 2) {
        [userPoint setObject:@"10s" forKey:@"Time"];
        [userPoint synchronize];
    }
    //20秒
    if (indexPath.row == 3) {
        [userPoint setObject:@"20s" forKey:@"Time"];
        [userPoint synchronize];
    }
    [_tableView reloadData];
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
