//
//  SearchViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "SearchViewController.h"

#import "SaojieMapViewController.h"
#import "QmapChooseViewController.h"
#import "CollectViewController.h"
//#import "GoogleMapController.h"
#import "ChooseTripViewController.h"
//#import "ChooseTypeViewController.h"
#import "ScanNewViewController.h"
#import "PoiViewController.h"
#import "TXYConfig.h"
#import "PassDelegate.h"
#import "TotleMapViewController.h"
#import "TotleScanViewController.h"
#import "TCSearchViewController.h"
#import "GoogleSearchViewController.h"
//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,PassDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIView* stateView;

@property(nonatomic,retain)NSString  *tableTitle;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UIView *aView;

@property (nonatomic,strong)UITextField* searchBar;

@property (nonatomic,strong)UIButton* searchBtn;

@property (nonatomic,strong)UITableView* tableView;

@property (nonatomic,strong)NSArray* dataArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dataMake];
    
    [self makeView];
    
}

//自定义navbar
-(void)customNavBar
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.117 green:0.117 blue:0.156 alpha:1]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.aView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, Width, 44)];
    self.aView.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:236/255.0 alpha:1.0];
    
    
    
    [self.view addSubview:_aView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.frame = CGRectMake(15, 15 , 44, 20);
    //[btn addTarget:self action:@selector(backsaleInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.aView addSubview:btn];
    self.view.backgroundColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
}
- (void)dataMake{
    self.dataArray = [NSArray arrayWithObjects:@"我的位置",@"北京",@"东京",@"南京",@"西京",@"郑州",@"清除搜索历史", nil];
}


- (void)makeView{
    self.tabBarController.tabBar.hidden = YES;
    
    _stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, 44)];
    _stateView.layer.cornerRadius = 2;
    _stateView.layer.masksToBounds = YES;
    _stateView.layer.borderWidth = 1;
    _stateView.layer.borderColor = [UIColor grayColor].CGColor;
    _stateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_stateView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 145, 20)];
    lab.text = @"搜地点、查公交、找线路";
    lab.font = [UIFont systemFontOfSize:13];
    UIView *search = [[UIView alloc]initWithFrame:CGRectMake(50, 0, Width - 130, 42)];
    search.backgroundColor = [UIColor whiteColor];
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 16, 16)];
    searchIcon.image = [UIImage imageNamed:@"icon_search@2x.png"];
    [search addSubview:searchIcon];
    [search addSubview:lab];
    UITapGestureRecognizer* tapS = [[UITapGestureRecognizer alloc]init];
    [tapS addTarget:self action:@selector(searchBtnClick)];
    [_stateView addGestureRecognizer:tapS];
    
    [_stateView addSubview:search];
    
    [self.view addSubview:_stateView];
    
    
    //        _searchBar = [[UITextField alloc]init];
    //        _searchBar.frame = CGRectMake(0, 64, Width - 60, 44);
    //        //边框样式
    //        _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    //        //背景内容
    //        _searchBar.placeholder = @"请输入内容";
    //        _searchBar.delegate = self;
    //        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    //        _searchBar.clearButtonMode = UITextFieldViewModeAlways;
    //
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _searchBtn.frame = CGRectMake(Width - 57, 65, 56, 42);
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //  _searchBtn.backgroundColor = [UIColor blueColor];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setBackgroundColor:IWColor(60, 170, 249)];
    UIView* _backView = [[UIView alloc]init];
    _backView.frame = CGRectMake(0, 108, Width, 52);
    _backView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_backView];
    
    //地图选点
    UIButton* xuandianBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    xuandianBtn.frame = CGRectMake(0, 0, Width/2, 51);
    [xuandianBtn setTitle:@"地图选点" forState:UIControlStateNormal];
    xuandianBtn.backgroundColor = [UIColor whiteColor];
    [xuandianBtn addTarget:self action:@selector(xuandianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:xuandianBtn];
    
    
    //收藏夹
    UIButton* shoucangBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shoucangBtn.frame = CGRectMake(Width / 2, 0, Width /2, 51);
    shoucangBtn.backgroundColor = [UIColor whiteColor];
    [shoucangBtn setTitle:@"收藏夹" forState:UIControlStateNormal];
    [shoucangBtn addTarget:self action:@selector(shoucangBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:shoucangBtn];
    
    
    UIView* xianView = [[UIView alloc]init];
    xianView.frame = CGRectMake(Width / 2, 10, 1, 32);
    xianView.backgroundColor = [UIColor grayColor];
    [_backView addSubview:xianView];
    
    
    //        _tableView = [[UITableView alloc]init];
    //        _tableView.delegate = self;
    //        _tableView.dataSource = self;
    //        _tableView.frame = CGRectMake(0, 160, Width, Height - 160);
    //        _tableView.rowHeight = 50;
    //        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //
    //
    //        [self.view addSubview:_tableView];
    [self.view addSubview:_searchBtn];
    [self.view addSubview:_searchBar];
    
}

#pragma mark - tableView delegate

//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]init];
       
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    
    
    return cell;
}

//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}
//地图选点
- (void)xuandianBtnClick{
    //默认百度地图
//    if ([[[TXYConfig sharedConfig]getLanguage] isEqualToString:@"System"]||![[TXYConfig sharedConfig]getLanguage]) {
//        if (WhitchLanguagesIsChina) {
//            SaojieMapViewController* sjmvc = [[SaojieMapViewController alloc]init];
//            for(UIViewController *controller in self.navigationController.viewControllers)
//            {
//                if ([controller isKindOfClass:[ChooseTypeViewController class]]) {
//                    ChooseTypeViewController *choose = (ChooseTypeViewController *)controller;
//                    sjmvc.delegate =choose;
//                }
//            }
//            sjmvc.index = self.index;
//            sjmvc.currentPoints = self.hadChoicePoints;
//            [self.navigationController pushViewController:sjmvc animated:YES];
//        }
//        else
//        {
//            GoogleMapController *googleMap = [[GoogleMapController alloc]init];
//            for(UIViewController *controller in self.navigationController.viewControllers)
//            {
//                if ([controller isKindOfClass:[ChooseTypeViewController class]]) {
//                    ChooseTypeViewController *choose = (ChooseTypeViewController *)controller;
//                    googleMap.delegate =choose;
//                }
//            }
//            googleMap.currentPoints = self.hadChoicePoints;
//            googleMap.index = self.index;
//            [self.navigationController pushViewController:googleMap animated:YES];
//        }
//    }
//    else
//    {
//        if ([[[TXYConfig sharedConfig]getLanguage] isEqualToString:@"CN"]) {
//            SaojieMapViewController* sjmvc = [[SaojieMapViewController alloc]init];
//            for(UIViewController *controller in self.navigationController.viewControllers)
//            {
//                if ([controller isKindOfClass:[ChooseTypeViewController class]]) {
//                    ChooseTypeViewController *choose = (ChooseTypeViewController *)controller;
//                    sjmvc.delegate =choose;
//                }
//            }
//            sjmvc.index = self.index;
//            sjmvc.currentPoints = self.hadChoicePoints;
//            [self.navigationController pushViewController:sjmvc animated:YES];        }
//        //如果设为英文
//        if ([[[TXYConfig sharedConfig]getLanguage] isEqualToString:@"EN"] ) {
//            GoogleMapController *googleMap = [[GoogleMapController alloc]init];
//            for(UIViewController *controller in self.navigationController.viewControllers)
//            {
//                if ([controller isKindOfClass:[ChooseTypeViewController class]]) {
//                    ChooseTypeViewController *choose = (ChooseTypeViewController *)controller;
//                    googleMap.delegate =choose;
//                }
//            }
//            googleMap.currentPoints = self.hadChoicePoints;
//            googleMap.index = self.index;
//            [self.navigationController pushViewController:googleMap animated:YES];
//        }
//    }
    TotleMapViewController *totle = [[TotleMapViewController alloc]init];
   // QmapChooseViewController *qmap = [[QmapChooseViewController alloc]init];
   // SaojieMapViewController* sjmvc = [[SaojieMapViewController alloc]init];
    for(UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[TotleScanViewController class]]) {
            TotleScanViewController *sc = (TotleScanViewController *)controller;
            totle.delegate =sc;
        }
    }
    totle.index = self.index;
    totle.currentPoints = self.hadChoicePoints;
    [self.navigationController pushViewController:totle animated:YES];
}


//收藏夹
- (void)shoucangBtn{
 
    CollectViewController* clvc = [[CollectViewController alloc]init];
    clvc.isMap = @"choicePotiens";
    for(UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[TotleScanViewController class]]) {
            TotleScanViewController *sc = (TotleScanViewController *)controller;
            clvc.delegate =sc;
        }
    }
    clvc.index = self.index;
    [self.navigationController pushViewController:clvc animated:YES];
    
}

//搜索按钮
- (void)searchBtnClick{
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
    if ([whichMap isEqualToString:@"baidu"] || !whichMap) {
        //此时界面应该是跳转百度的
        //guonei
        PoiViewController *poi = [[PoiViewController alloc]init];
        poi.isSaojie = @"poi";
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController *sc = (TotleScanViewController *)vc;
                poi.delegate = sc;
            }
        }
        poi.index = self.index;
        [self.navigationController pushViewController:poi animated:YES];
    }
    if ([whichMap isEqualToString:@"tencent"]) {
        TCSearchViewController* tcse = [[TCSearchViewController alloc]init];
        tcse.isSaojie = @"poi";
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController *sc = (TotleScanViewController *)vc;
                tcse.delegate = sc;
            }
        }
        tcse.index = self.index;
        [self.navigationController pushViewController:tcse animated:YES];
    }
    if ([whichMap isEqualToString:@"google"]) {
        GoogleSearchViewController* googlese = [[GoogleSearchViewController alloc]init];
        googlese.isSaojie = @"poi";
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController *sc = (TotleScanViewController *)vc;
                googlese.delegate = sc;
            }
        }
        googlese.index = self.index;
        [self.navigationController pushViewController:googlese animated:YES];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        //guonei
        PoiViewController *poi = [[PoiViewController alloc]init];
        poi.isSaojie = @"poi";
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController *sc = (TotleScanViewController *)vc;
                poi.delegate = sc;
            }
        }
        poi.index = self.index;
        [textField resignFirstResponder];
        [self.navigationController pushViewController:poi animated:YES];
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
