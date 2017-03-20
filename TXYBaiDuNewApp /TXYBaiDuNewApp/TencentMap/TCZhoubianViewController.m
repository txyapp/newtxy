//
//  TCZhoubianViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TCZhoubianViewController.h"
#import <QMapSearchKit/QMapSearchKit.h>
#import "TXYConfig.h"
#import "FireToGps.h"
#import "MyAlert.h"
#import "TCSearchResultViewController.h"
#import "MBProgressHUD.h"
#import "TencentMapViewController.h"
#import "AppDelegate.h"

@interface TCZhoubianViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,QMSSearchDelegate>{
    UITableView* _tableView;
    UISearchBar* _searchBar;
    NSMutableArray* _dataArray;
    NSMutableArray *arr1,*arr2,*arr3,*arr4,*arr5,*totleArr;;
}
//搜索基类
@property (nonatomic,strong)QMSSearcher *searcher;
//搜索类
@property (nonatomic,strong)QMSPoiSearchOption *poiSearchOption;
@end

@implementation TCZhoubianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr1 = [NSMutableArray arrayWithObjects:@"公交车",@"地铁站",@"加油站",@"停车场",@"火车票代售点",@"长途车站", nil];
    arr2 = [NSMutableArray arrayWithObjects:@"美食",@"快餐",@"中餐",@"西餐",@"川菜",@"火锅",@"甜点饮品",@"茶餐厅",@"肯德基", nil];
    arr3 = [NSMutableArray arrayWithObjects:@"酒店",@"快捷酒店",@"星级酒店",@"旅馆",@"青年旅社",@"公寓式酒店", nil];
    arr4 = [NSMutableArray arrayWithObjects:@"KTV",@"电影院",@"咖啡店",@"购物",@"健身",@"酒吧",@"网吧",@"景点",@"洗浴足疗", nil];
    arr5 = [NSMutableArray arrayWithObjects:@"ATM",@"公测",@"药店",@"便利店",@"超市",@"银行",@"医院",@"美容美发",@"宠物服务", nil];
    totleArr = [NSMutableArray arrayWithObjects:arr1,arr2,arr3,arr4,arr5, nil];
    //生成界面
    [self makeView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [_searchBar removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(50, 6, Width - 67, 36);
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar addSubview:_searchBar];
    _tableView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
     self.tabBarController.tabBar.hidden = YES;
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView{
   // self.tabBarController.tabBar.hidden = YES;
    //返回按钮
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    
    //searchBar

    
    //主页面
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, Width, Height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //创建搜索类
    self.searcher = [[QMSSearcher alloc] init];
    [self.searcher setDelegate:self];
    //创建衍生词搜索类
    //创建poi搜索类
    _poiSearchOption = [[QMSPoiSearchOption alloc] init];
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    //如果是周边搜索
    _poiSearchOption.keyword = _searchBar.text;
    _poiSearchOption.page_size = 10;
    [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:1000];
 //   [_searcher searchWithPoiSearchOption:_poiSearchOption];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [totleArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //取消cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else
    {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    int num = [totleArr[indexPath.section] count];
    for (int i = 0; i < num; i ++) {
        UIButton *cusBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cusBtn.frame = CGRectMake(10 + i%3 *(Width -20)/3,  0 + i/3 *50, (Width-20)/3 , 50);
        [cusBtn setTitle:totleArr[indexPath.section][i] forState:UIControlStateNormal];
        cusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cusBtn.titleLabel.textColor = [UIColor blackColor];
        cusBtn.tag = indexPath.section*1000+i;
        [cusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cusBtn.layer.borderWidth = 1;
        cusBtn.layer.borderColor = Color.CGColor;
        [cell.contentView addSubview:cusBtn];
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int len = [totleArr[indexPath.section] count];
    switch (indexPath.section) {
        case 0:
            return [totleArr[indexPath.section] count]/3*50;
            break;
        case 1:
            return [totleArr[indexPath.section] count]/3*50;
            break;
        case 2:
            return [totleArr[indexPath.section] count]/3*50;
            break;
        case 3:
            return [totleArr[indexPath.section] count]/3*50;
            break;
        case 4:
            return [totleArr[indexPath.section] count]/3*50;
            break;
        default:
            break;
    }
    return 50*len;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, Width, 40);
    //view.backgroundColor = Color;
    UILabel* label = [[UILabel alloc]init];
    label.frame = CGRectMake(30, 10, Width, 20);
    //label.backgroundColor = Color;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    switch (section) {
        case 1:
            label.text = @"美食畅饮";
            break;
        case 2:
            label.text = @"酒店住宿";
            break;
        case 3:
            label.text = @"娱乐休闲";
            break;
        case 4:
            label.text = @"生活服务";
            break;
        case 0:
            label.text = @"交通出行";
        default:
            break;
    }
    return view;
}

#pragma mark - 按钮点击方法
- (void)btnClick:(UIButton*)button{
    int sec = button.tag/1000;
    int row = button.tag - sec* 1000;
    NSString* string = totleArr[sec][row];
    NSLog(@"string = %@",string);
    [_searchBar resignFirstResponder];
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    //如果是周边搜索
    if (_isZhou) {
        _poiSearchOption.keyword = string;
        [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:1000];
        NSLog(@"搜索关键字 =%@,地点 = %@",_poiSearchOption.keyword,_poiSearchOption.boundary);
        [_searcher searchWithPoiSearchOption:_poiSearchOption];
    }else{
        _poiSearchOption.keyword = string;
        _poiSearchOption.page_size = 20;
        NSLog(@"搜索关键字 =%@,地点 = %@",_poiSearchOption.keyword,_poiSearchOption.boundary);
        [_searcher searchWithPoiSearchOption:_poiSearchOption];
        
    }
}

#pragma mark - 搜索回调

//查询出现错误
- (void)searchWithSearchOption:(QMSSearchOption *)searchOption
              didFailWithError:(NSError*)error{
    NSLog(@"error = %@",error);
}
//poi查询结果回调函数
- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption
                 didReceiveResult:(QMSPoiSearchResult *)poiSearchResult{
    NSLog(@"共有搜索结果%d",poiSearchResult.count);
    NSLog(@"搜索结果 %d",poiSearchResult.dataArray.count);
    
    if (poiSearchResult.count == 0) {
        [MyAlert ShowAlertMessage:@"很抱歉" title:@"当前位置没有搜索结果"];
    }else{
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请稍后";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //显示对话框
        [HUD showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1);
        } completionBlock:^{
            TCSearchResultViewController* tcres = [[TCSearchResultViewController alloc]init];
            for(UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[TencentMapViewController class]]) {
                    TencentMapViewController* choose = (TencentMapViewController*)vc;
                    tcres.delegate = choose;
                }
            }
            tcres.isZhou = YES;
            tcres.keyWord = poiSearchOption.keyword;
            tcres.poiSearchResult = poiSearchResult;
            [self.navigationController pushViewController:tcres animated:YES];
         //   self.tabBarController.tabBar.hidden = YES;
        }];
    }
        
}
#pragma mark - searchbar delegate

//当处于编辑模式时
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    
}
//当输入文字时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //当输入文本时
    if (searchText.length > 0) {
        _tableView.hidden = YES;
    }
    //删除文本时
    else
    {
        _tableView.hidden = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > 0) {
        NSLog(@"text=%@",textField.text);
    }
    
    NSLog(@"stribg=%@",string);
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"打字完成");
    
}

//- (void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length > 0) {
//        NSLog(@"textView.text = %@",textView.text);
//    }else{
//        NSLog(@"quxiao");
//    }
//}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length > 0) {
        NSLog(@"textView.text = %@",textView.text);
    }else{
        NSLog(@"quxiao");
    }
    
}

//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    //如果是周边搜索
    if (_isZhou) {
        _poiSearchOption.keyword = _searchBar.text;
        [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:1000];
        NSLog(@"搜索关键字 =%@,地点 = %@",_poiSearchOption.keyword,_poiSearchOption.boundary);
        [_searcher searchWithPoiSearchOption:_poiSearchOption];
    }else{
        _poiSearchOption.keyword = _searchBar.text;
        _poiSearchOption.page_size = 20;
        NSLog(@"搜索关键字 =%@,地点 = %@",_poiSearchOption.keyword,_poiSearchOption.boundary);
        [_searcher searchWithPoiSearchOption:_poiSearchOption];
        
    }
}

#pragma mark - 滑动取消键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    [_searchBar resignFirstResponder];
    if (self.tabBarController.tabBar.hidden == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
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
