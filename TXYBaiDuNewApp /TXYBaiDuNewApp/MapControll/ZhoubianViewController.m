//
//  ZhoubianViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ZhoubianViewController.h"
#import "PoiViewController.h"
#import "ZhoubianJilu.h"
#import "MyAlert.h"
#import "SearchResultViewController.h"
#import "TXYConfig.h"
#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]?1:0
//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0
@interface ZhoubianViewController ()<UISearchBarDelegate>{
    NSString *_cityName;   // 检索城市名
    NSString *_keyWord;    // 检索关键字
    int currentPage;            //  当前页
}

@end

@implementation ZhoubianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)makeView{
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"周边";
    
    //scroller view
    _scView = [[UIScrollView alloc]init];
    _scView.frame = CGRectMake(0, 108, Width, Height - 108);
    //实大小
    _scView.contentSize = CGSizeMake(Width, 500);
    
    _scView.backgroundColor = [UIColor whiteColor];
    
    //垂直滚动条
    _scView.showsHorizontalScrollIndicator = NO;
    
    //水平滚动条
    _scView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scView];
    
    //周边按钮
    
    UIView* btnView = [[UIView alloc]init];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.frame = CGRectMake(0, -30, Width, (Width - 50)/2 + 80);
    [_scView addSubview:btnView];
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 2001;
    [button1 setBackgroundColor:[UIColor whiteColor]];
    button1.frame = CGRectMake(10, 0, (Width - 50)/4, (Width - 50)/4);
 //   button1.layer.masksToBounds = YES;
  //    button1.layer.cornerRadius = 8;
  //  button1.layer.borderWidth = 1;
    [button1 setBackgroundImage:[UIImage imageNamed:@"dianying.png"] forState:UIControlStateNormal];
    [btnView addSubview:button1];
    UILabel* label1 = [[UILabel alloc]init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"电影";
    label1.backgroundColor = [UIColor whiteColor];
    label1.frame = CGRectMake(10, (Width - 50)/4, (Width - 50)/4, 30);
    [btnView addSubview:label1];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2002;
    [button2 setBackgroundColor:[UIColor whiteColor]];
    button2.frame = CGRectMake(20 +(Width - 50)/4 , 0, (Width - 50)/4, (Width - 50)/4);
   // button2.layer.masksToBounds = YES;
   // button2.layer.cornerRadius = 8;
   // button2.layer.borderWidth = 1;
    [button2 setBackgroundImage:[UIImage imageNamed:@"meishi.png"] forState:UIControlStateNormal];
    [btnView addSubview:button2];
    UILabel* label2 = [[UILabel alloc]init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"美食";
    label2.backgroundColor = [UIColor whiteColor];
    label2.frame = CGRectMake(20 +(Width - 50)/4, (Width - 50)/4, (Width - 50)/4, 30);
    [btnView addSubview:label2];
    
    UIButton* button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 2003;
    [button3 setBackgroundColor:[UIColor whiteColor]];
    button3.frame = CGRectMake(30 +(Width - 50)/4*2, 0, (Width - 50)/4, (Width - 50)/4);
  //  button3.layer.masksToBounds = YES;
   // button3.layer.cornerRadius = 8;
   // button3.layer.borderWidth = 1;
    [button3 setBackgroundImage:[UIImage imageNamed:@"jiudian.png"] forState:UIControlStateNormal];
    [btnView addSubview:button3];
    UILabel* label3 = [[UILabel alloc]init];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"酒店";
    label3.backgroundColor = [UIColor whiteColor];
    label3.frame = CGRectMake(30 +(Width - 50)/4*2,(Width - 50)/4, (Width - 50)/4, 30);
    [btnView addSubview:label3];
    
    UIButton* button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button4 setBackgroundColor:[UIColor whiteColor]];
    button4.tag = 2004;
    button4.frame = CGRectMake(40 +(Width - 50)/4*3, 0, (Width - 50)/4, (Width - 50)/4);
  //  button4.layer.masksToBounds = YES;
   // button4.layer.cornerRadius = 8;
   // button4.layer.borderWidth = 1;
    [button4 setBackgroundImage:[UIImage imageNamed:@"gongjiao.png"] forState:UIControlStateNormal];
    [btnView addSubview:button4];
    UILabel* label4 = [[UILabel alloc]init];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"公交站";
    label4.backgroundColor = [UIColor whiteColor];
    label4.frame = CGRectMake(40 +(Width - 50)/4*3, (Width - 50)/4, (Width - 50)/4, 30);
    [btnView addSubview:label4];
    
    UIButton* button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button5 setBackgroundColor:[UIColor whiteColor]];
    button5.frame = CGRectMake(10 , (Width - 50)/4 + 40, (Width - 50)/4, (Width - 50)/4);
  //  button5.layer.masksToBounds = YES;
  //  button5.layer.cornerRadius = 8;
    button5.tag = 2005;
   // button5.layer.borderWidth = 1;
    [button5 setBackgroundImage:[UIImage imageNamed:@"gouwu.png"] forState:UIControlStateNormal];
    [btnView addSubview:button5];
    UILabel* label5 = [[UILabel alloc]init];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = @"购物";
    label5.backgroundColor = [UIColor whiteColor];
    label5.frame = CGRectMake(10, (Width - 50)/2 + 40, (Width - 50)/4, 30);
    [btnView addSubview:label5];
    
    UIButton* button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button6 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button6 setBackgroundColor:[UIColor whiteColor]];
    button6.frame = CGRectMake(20 +(Width - 50)/4, (Width - 50)/4 + 40, (Width - 50)/4, (Width - 50)/4);
  //  button6.layer.masksToBounds = YES;
    button6.tag = 2006;
  //  button6.layer.cornerRadius = 8;
 //   button6.layer.borderWidth = 1;
    [button6 setBackgroundImage:[UIImage imageNamed:@"jichang.png"] forState:UIControlStateNormal];
    [btnView addSubview:button6];
    UILabel* label6 = [[UILabel alloc]init];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = @"机场";
    label6.backgroundColor = [UIColor whiteColor];
    label6.frame = CGRectMake(20 +(Width - 50)/4, (Width - 50)/2 + 40, (Width - 50)/4, 30);
    [btnView addSubview:label6];
    
    UIButton* button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button7 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button7 setBackgroundColor:[UIColor whiteColor]];
    button7.frame = CGRectMake(30 +(Width - 50)/4*2, (Width - 50)/4 + 40, (Width - 50)/4, (Width - 50)/4);
  //  button7.layer.masksToBounds = YES;
    button7.tag = 2007;
  //  button7.layer.cornerRadius = 8;
  //  button7.layer.borderWidth = 1;
    [button7 setBackgroundImage:[UIImage imageNamed:@"ktv.png"] forState:UIControlStateNormal];
    [btnView addSubview:button7];
    UILabel* label7 = [[UILabel alloc]init];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.text = @"KTV";
    label7.backgroundColor = [UIColor whiteColor];
    label7.frame = CGRectMake(30 +(Width - 50)/4*2, (Width - 50)/2 + 40, (Width - 50)/4, 30);
    [btnView addSubview:label7];
    
    UIButton* button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button8 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button8 setBackgroundColor:[UIColor whiteColor]];
    button8.frame = CGRectMake(40 +(Width - 50)/4*3, (Width - 50)/4 + 40, (Width - 50)/4, (Width - 50)/4);
  //  button8.layer.masksToBounds = YES;
    button8.tag = 2008;
  //  button8.layer.cornerRadius = 8;
   // button8.layer.borderWidth = 1;
    [button8 setBackgroundImage:[UIImage imageNamed:@"jingdian.png"] forState:UIControlStateNormal];
    [btnView addSubview:button8];
    UILabel* label8 = [[UILabel alloc]init];
    label8.textAlignment = NSTextAlignmentCenter;
    label8.text = @"景点";
    label8.backgroundColor = [UIColor whiteColor];
    label8.frame = CGRectMake(40 +(Width - 50)/4*3, (Width - 50)/2 + 40, (Width - 50)/4, 30);
    [btnView addSubview:label8];
    
    _poiSearch = [[BMKPoiSearch alloc]init];
    _poiSearch.delegate = self;
    currentPage = 0;

    //判断系统版本是否高于6  然后规划stateBar高度
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
    UIView *search = [[UIView alloc]initWithFrame:CGRectMake(90, 0, Width - 130, 42)];
    search.backgroundColor = [UIColor whiteColor];
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 16, 16)];
    searchIcon.image = [UIImage imageNamed:@"icon_search@2x.png"];
    [search addSubview:searchIcon];
    [search addSubview:lab];
    UITapGestureRecognizer* tapS = [[UITapGestureRecognizer alloc]init];
    [tapS addTarget:self action:@selector(searchTap)];
    [_stateView addGestureRecognizer:tapS];
    
    [_stateView addSubview:search];
    
    [self.view addSubview:_stateView];
    
    //扩展view
    _kuoView = [[UIView alloc]init];
    _kuoView.frame = CGRectMake(0, btnView.frame.origin.y + btnView.frame.size.height, Width, 200);
    
    //车主
    UILabel* cheLab = [[UILabel alloc]init];
    cheLab.frame = CGRectMake(10, 5, (Width - 60)/5, 30);
    cheLab.text = @"车主";
    cheLab.textAlignment = 1;
    NSArray* arr1 = [NSArray arrayWithObjects:@"停车场",@"加油站",@"加气站",@"4s店", nil];
    for (int i = 0; i< 4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:arr1[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((Width -60)/5*(i+1) + (i+1)*10, 5, (Width-60)/5, 30);
        button.tag = 9006;
        [_kuoView addSubview:button];
    }
    [_kuoView addSubview:cheLab];
    
    //餐饮
    UILabel* canLab = [[UILabel alloc]init];
    canLab.frame = CGRectMake(10, 40, (Width - 60)/5, 30);
    canLab.text = @"餐饮";
    canLab.textAlignment = 1;
    NSArray* arr2 = [NSArray arrayWithObjects:@"快餐",@"火锅",@"咖啡厅",@"麦当劳", nil];
    for (int i = 0; i< 4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:arr2[i] forState:UIControlStateNormal];
        button.tag =9006;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((Width -60)/5*(i+1) + (i+1)*10, 40, (Width-60)/5, 30);
        [_kuoView addSubview:button];
    }
    [_kuoView addSubview:canLab];
    
    //住宿
    UILabel* zhuLab = [[UILabel alloc]init];
    zhuLab.frame = CGRectMake(10, 80, (Width - 60)/5, 30);
    zhuLab.text = @"住宿";
    zhuLab.textAlignment = 1;
    NSArray* arr3 = [NSArray arrayWithObjects:@"宾馆",@"星级酒店",@"快捷酒店",@"招待所", nil];
    for (int i = 0; i< 4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:arr3[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((Width -60)/5*(i+1) + (i+1)*10, 80, (Width-60)/5, 30);
        button.tag = 9006;
        [_kuoView addSubview:button];
    }
    [_kuoView addSubview:zhuLab];


    //银行
    UILabel* yinLab = [[UILabel alloc]init];
    yinLab.frame = CGRectMake(10, 120, (Width - 60)/5, 30);
    yinLab.text = @"银行";
    yinLab.textAlignment = 1;
    NSArray* arr4 = [NSArray arrayWithObjects:@"ATM",@"工行",@"建行",@"农行", nil];
    for (int i = 0; i< 4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:arr4[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((Width -60)/5*(i+1) + (i+1)*10, 120, (Width-60)/5, 30);
        button.tag = 9006;
        [_kuoView addSubview:button];
    }
    [_kuoView addSubview:yinLab];
    
    //生活
    UILabel* lifeLab = [[UILabel alloc]init];
    lifeLab.frame = CGRectMake(10, 160, (Width - 60)/5, 30);
    lifeLab.text = @"生活";
    lifeLab.textAlignment = 1;
    NSArray* arr5 = [NSArray arrayWithObjects:@"网吧",@"商场",@"厕所",@"快递", nil];
    for (int i = 0; i< 4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:arr5[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((Width -60)/5*(i+1) + (i+1)*10, 160, (Width-60)/5, 30);
        button.tag = 9006;
        [_kuoView addSubview:button];
    }
    [_kuoView addSubview:lifeLab];
    
    [_scView addSubview:_kuoView];
}

- (void)buttonClick:(UIButton*)button{
    _nearBySearchOption.location = _coord;
    
    if (button.tag == 2001) {
        _nearBySearchOption.keyword = @"电影";
        _keyWord = @"电影";
    }
    if (button.tag == 2002) {
        _nearBySearchOption.keyword = @"美食";
        _keyWord = @"美食";
    }
    if (button.tag == 2003) {
        _nearBySearchOption.keyword = @"酒店";
        _keyWord = @"酒店";
    }
    if (button.tag == 2004) {
        _nearBySearchOption.keyword = @"公交站";
        _keyWord = @"公交站";
    }
    if (button.tag == 2005) {
        _nearBySearchOption.keyword = @"购物";
        _keyWord = @"购物";
    }
    if (button.tag == 2006) {
        _nearBySearchOption.keyword = @"机场";
        _keyWord = @"机场";
    }
    if (button.tag == 2007) {
        _nearBySearchOption.keyword = @"KTV";
        _keyWord = @"KTV";
    }
    if (button.tag == 2008) {
        _nearBySearchOption.keyword = @"景点";
        _keyWord = @"景点";
    }
    if (button.tag == 9006) {
        _nearBySearchOption.keyword = button.titleLabel.text;
        _keyWord = button.titleLabel.text;
    }
    NSLog(@"关键字 = %@",_nearBySearchOption.keyword);
    NSLog(@"检索点 = %f",_nearBySearchOption.location.latitude);
    NSLog(@"检索半径 = %d",_nearBySearchOption.radius);
    
    BOOL flag =   [_poiSearch poiSearchNearBy:_nearBySearchOption];
    if (flag) {
        NSLog(@"周边搜索成功");
    }else{
        NSLog(@"周边搜索失败");
    }
}


- (void)searchTap{
    PoiViewController* povc = [[PoiViewController alloc]init];
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MapViewController class]]) {
            povc.delegate =(MapViewController*)vc;
        }
    }
    povc.coord = _coord;
    povc.isZhou = YES;
    povc.isAPP = self.isAPP;
    povc.bundleID = self.bundleID;
    [self.navigationController pushViewController:povc animated:YES];
}
/*
 typedef enum{
 BMK_SEARCH_NO_ERROR =0,///<检索结果正常返回
 BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
 BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
 BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
 BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
 BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
 BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
 BMK_SEARCH_KEY_ERROR,///<key错误
 BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
 BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
 BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
 }BMKSearchErrorCode;
*/


- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    SearchResultViewController* srvc = [[SearchResultViewController alloc]init];
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[MapViewController class]]) {
            MapViewController* choose = (MapViewController*)vc;
            srvc.delegate = choose;
        }
        if ([vc isKindOfClass:[ZhoubianViewController class]]) {
            ZhoubianViewController* zhouvc = (ZhoubianViewController*)vc;
            srvc.dele = zhouvc;
        }
        
    }
    for ( int i = 0; i < 12; i++) {
        if (i  == errorCode) {
            NSLog(@"i = %d ",errorCode);
        }
    }
    
    if (errorCode == BMK_SEARCH_NO_ERROR)
        
    {
        NSLog(@"poiResult.totalPoiNum = %d",poiResult.totalPoiNum);
        NSLog(@"poiResult.currPoiNum = %d",poiResult.currPoiNum);
        NSLog(@"poiResult.pageNum = %d",poiResult.pageNum);
        NSLog(@"poiResult.pageIndex = %d",poiResult.pageIndex);
        NSLog(@"poiResult.poiInfoList = %@",poiResult.poiInfoList);
        NSLog(@"poiResult.cityList = %@",poiResult.cityList);
        
        srvc.poiResult = poiResult;
        if (_keyWord) {
             srvc.keyWord = _keyWord;
        }
        if (_nearBySearchOption.keyword) {
            srvc.keyWord = _nearBySearchOption.keyword;
        }
        
        //是否有内容
        if (poiResult.totalPoiNum == 0) {
            srvc.isYes = NO;
        }else{
            srvc.isYes = YES;
        }
        if (srvc.isYes) {
            NSLog(@"isYes");
        }
        if (_coord.latitude) {
            srvc.coord = _coord;
        }
        
        
        //是否为周边搜索
        srvc.isZhou = YES;
        srvc.isAPP = self.isAPP;
        srvc.bundleID = self.bundleID;
        srvc.coord = _nearBySearchOption.location;
        srvc.nearBySearchOption = [[BMKNearbySearchOption alloc]init];
        srvc.nearBySearchOption = self.nearBySearchOption;
        [self.navigationController pushViewController:srvc animated:YES];
    }
 
    if (errorCode == 1) {
        [MyAlert ShowAlertMessage:@"检索词有岐义" title:@"温馨提示"];
    }
    if (errorCode == 2) {
        [MyAlert ShowAlertMessage:@"检索地址有岐义" title:@"温馨提示"];
    }
    if (errorCode == 3) {
        [MyAlert ShowAlertMessage:@"该城市不支持公交搜索" title:@"温馨提示"];
    }
    if (errorCode == 4) {
        [MyAlert ShowAlertMessage:@"不支持跨城市公交" title:@"温馨提示"];
    }
    if (errorCode == 5) {
        [MyAlert ShowAlertMessage:@"该周边没有搜索结果" title:@"温馨提示"];
    }
    if (errorCode == 6) {
        [MyAlert ShowAlertMessage:@"网络连接错误,请检查网络" title:@"温馨提示"];
    }
    if (errorCode == 7) {
        [MyAlert ShowAlertMessage:@"网络连接错误,请检查网络" title:@"温馨提示"];
    }
    if (errorCode == 8) {
        [MyAlert ShowAlertMessage:@"网络连接错误,请检查网络" title:@"温馨提示"];
    }
}


#pragma mark - 实现代理方法
//实现代理方法
-(void)chuanzhi:(XuandianModel *)model
{
    _nearBySearchOption.keyword = model.time;
    
    
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(model.latitude, model.longtitude);
    ZhoubianJilu* jilu = [ZhoubianJilu shared];
    if (jilu.radius) {
        _nearBySearchOption.radius = jilu.radius;
    }
    if (jilu.paixu == 1) {
        _nearBySearchOption.sortType = 0;
    }else{
        _nearBySearchOption.sortType = 1;
    }
    
    _nearBySearchOption.location = coord;
    
    BOOL isZ = [_poiSearch poiSearchNearBy:_nearBySearchOption];
    if (isZ) {
        NSLog(@"zhoubiansousuochenggong");
    }else{
        [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 搜索按钮
- (void)sousuo{
    [self searchBarSearchButtonClicked:_searchBar];
    
    
}


#pragma mark - tableView delegate


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
