//
//  XuanFuViewController.m
//  TXYBaiDuNewApp
//
//  Created by 马荣辉 on 2017/1/17.
//  Copyright © 2017年 yunlian. All rights reserved.
//

#import "XuanFuViewController.h"

@interface XuanFuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)NSArray* dataArray;

@end

@implementation XuanFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [self makeData];
    [self makeView];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeData{
    _dataArray = @[@"精度1米",@"精度5米",@"精度20米",@"精度1000米"];
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
    footLab.text = @"1.精度为屏幕滑动1厘米，实际位置移动的距离。\n2.由于坐标差异问题，建议地图选择为百度地图。\n3.默认精度为5米.\n4.长按移动悬浮控制器位置";
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
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        if ([jingdu isEqualToString:@"1m"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
       // cell.detailTextLabel.text = @"默认精度";
    }
    if (indexPath.row == 1) {
        if ([jingdu isEqualToString:@"5m"] || !jingdu) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    if (indexPath.row == 2) {
        if ([jingdu isEqualToString:@"20m"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    if (indexPath.row == 3) {
        if ([jingdu isEqualToString:@"1000m"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSString* jingdu = nil;
    if (indexPath.row == 0) {
        jingdu = @"1m";
    }
    if (indexPath.row == 1) {
        jingdu = @"5m";
    }
    if (indexPath.row == 2) {
        jingdu = @"20m";
    }
    if (indexPath.row == 3) {
        jingdu = @"1000m";
    }
    if (jingdu) {
         [userPoint setObject:jingdu forKey:@"xuanfujingdu"];
        [userPoint synchronize];
        [_tableView reloadData];
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
