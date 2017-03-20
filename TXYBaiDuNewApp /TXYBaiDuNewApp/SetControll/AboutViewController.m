//
//  AboutViewController.m
//  TXYBaiDuNewApp
//
//  Created by Macmini1 on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "AboutViewController.h"
#import "MBProgressHUD.h"
//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_tableArray;
}
@end

@implementation AboutViewController
#pragma obfuscate on
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于天下游";
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = IWColor(236, 236, 236);
    [self addtableView];
}
//
-(void)addtableView
{
   _tableArray = @[@"www.txyapp.com", @"QQ:800061106", @"TEL:4000758977"];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width-57)/2, 40, 57, 57)];
    [logoView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoView];
    
    if (iOS7) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height ) style:(UITableViewStyleGrouped)];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - 64 ) style:(UITableViewStyleGrouped)];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, Width, 160)];
    headerView.backgroundColor =IWColor(60, 170, 249);
    _tableView.tableHeaderView=headerView;
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoA"]];
    imgView.center=CGPointMake(self.view.frame.size.width*0.5, 85);
    [headerView addSubview:imgView];
    
    /*UILabel* labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, screenSize.width, 20)];
    [labelTitle setText:@"天下游"];
    [labelTitle setTextColor:IWColor(0, 0, 0)];
    [labelTitle setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:18]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:labelTitle];*/
    
    //mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSeparatorColor:IWColor(204, 204, 204)];
    [self.view addSubview:_tableView];
    
    
    UIView* banView = [[UIView alloc]init];
    banView.frame = CGRectMake(0, Height  , Width, 50);
    UILabel* lab1 = [[UILabel alloc]init];
    lab1.text = @"Copyright@2006-2018";
    lab1.frame = CGRectMake(0, 0, Width, 20);
    lab1.textAlignment = 1;
    lab1.textColor = [UIColor grayColor];
    
    UILabel* lab2 = [[UILabel alloc]init];
    lab2.text = @"北京天下在线科技有限公司";
    lab2.frame = CGRectMake(0, 20, Width, 20);
    lab2.textAlignment = 1;
    lab2.textColor = [UIColor grayColor];
    
    [banView addSubview:lab1];
    [banView addSubview:lab2];
    
    _tableView.tableFooterView = banView;
   
}
/**
 *  UITableViewDataSource
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 55)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0f]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:IWColor(0, 0, 0)];
        [cell.contentView addSubview:titleLabel];
        titleLabel.tag = 1000;
        
        UIView *cellBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 54)];
        [cellBg setBackgroundColor:[UIColor whiteColor]];
        cell.backgroundView = cellBg;
        
        UIView *cellSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 54)];
        [cellSelected setBackgroundColor:IWColor(204, 204, 204)];
        cell.selectedBackgroundView = cellSelected;
        
        /*UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 54, screenSize.width, 1)];
        [seperator setBackgroundColor:IWColor(193, 193, 193)];
        [cell.contentView addSubview:seperator];*/
        
    }
    UILabel *title = (UILabel *)[cell viewWithTag:1000];
    
    title.text = [_tableArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSString *path = [NSString stringWithFormat:@"http://www.txyapp.com"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    }
    if (indexPath.row == 1) {
        /*UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"800061106";
        
        MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        toast.mode = MBProgressHUDModeText;
        toast.labelText = [NSString stringWithFormat:@"QQ号码已复制到粘贴版"];
        toast.margin = 10.f;
        toast.yOffset = 150.f;
        toast.removeFromSuperViewOnHide = YES;
        [toast hide:YES afterDelay:2];*/
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=800061106&version=1&src_type=web"];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    if (indexPath.row == 2) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000758977"];
   
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        /*NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=800061106&version=1&src_type=web"];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }*/
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
