//
//  PoiViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/10.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//
#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//获取RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "PoiViewController.h"
#import "SearchHistoryTableViewCell.h"
#import "SearchModel.h"
#import "DidianModel.h"
#import "SearchResultViewController.h"
#import "MyAlert.h"
#import "MapViewController.h"
#import "XuandianModel.h"
#import "ZhoubianJilu.h"
#import "ZhoubianViewController.h"
#import "TXYConfig.h"
//#import "ChooseTypeViewController.h"
#import "ScanNewViewController.h"
#import "FireToGps.h"
#import "AppDelegate.h"
#import "TotleScanViewController.h"

@interface PoiViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSString *_cityName;   // 检索城市名
       // 检索关键字
    NSString * _keyWord;
    int currentPage;       //  当前页
    
}



@end

@implementation PoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
       _dataArray = [[NSMutableArray alloc]init];
    }
    _isHis = YES;
    //判断是否为历史记录
    if (_isHis) {
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        // NSArray* array = [userPoint objectForKey:@"history"];
        NSArray* array = [userPoint arrayForKey:@"history"];
        NSLog(@"array = %@",array);
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        for (int i = 0; i< userArray.count; i++) {
            NSLog(@"111111111111111111111111111111111111111111111");
            DidianModel* model = [[DidianModel alloc]init];
            NSLog(@"22222222222222222222222222222222222");
            NSMutableDictionary *dict = userArray[i];
            NSLog(@"dict：%@",dict);
            if(![dict isKindOfClass:[NSDictionary class]]){
                NSLog(@"continue");
                continue;
            }
            model.key = dict[@"name"];
            NSLog(@"3333333333333333333333333333");
            if (dict[@"city"]) {
                model.city = dict[@"city"];
            }
            NSLog(@"44444444444444444444444444444444");
            if (dict[@"district"]) {
                model.district = dict[@"district"];
            }
            NSLog(@"55555555555555555555555555555555555");
            if (dict[@"latitudeNum"]) {
                model.latitude = dict[@"latitudeNum"];
            }
            NSLog(@"666666666666666666666666666666666666");
            if (dict[@"longitudeNum"]) {
                model.longitude = dict[@"longitudeNum"];
            }
            NSLog(@"77777777777777777777777777");
            [_dataArray addObject:model];
            NSLog(@"8888888888888888888888");
            
        }
        NSLog(@"9999999999999999999999999999");
        
    }
    NSLog(@"0000000000000000000000000");


    [self makeView];
    
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"333333333333333333333333333333");
    
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
 
    AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (_appDelegate.city) {
        _chengshi = _appDelegate.city;
    }
    self.tabBarController.tabBar.hidden = YES;
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    if (_isZhou) {
        _searchBar.placeholder  = @"周边搜索";
    }else{
    _searchBar.placeholder = @"请输入搜索内容";
    }
    _searchBar.frame = CGRectMake(50, 6, Width - 67, 36);
    [self.navigationController.navigationBar addSubview:_searchBar];
 
   // self.navigationItem.leftBarButtonItem = item;
    //实例化searchBtn
    _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchBtn.layer.cornerRadius = 3;
    _searchBtn.layer.masksToBounds = YES;
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(sousuo) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.frame = CGRectMake(Width - 48, 10, 46, 28);
     [_searchBtn setBackgroundColor:IWColor(60, 170, 249)];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchBtn.hidden = YES;
    _searchBtn.tag = 4302;
    NSLog(@"44444444444444444444444444444444444");
    [self.navigationController.navigationBar addSubview:_searchBtn];
    _isHis = YES;
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
        _dataArray = [[NSMutableArray alloc]init];
    }
    //判断是否为历史记录
    if (_isHis) {
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        // NSArray* array = [userPoint objectForKey:@"history"];
        NSArray* array = [userPoint arrayForKey:@"history"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        for (int i = 0; i< userArray.count; i++) {
            NSLog(@"111111111111111111111111111111111111111111111");
            DidianModel* model = [[DidianModel alloc]init];
            NSLog(@"22222222222222222222222222222222222");
            NSMutableDictionary *dict = userArray[i];
            NSLog(@"dict：%@",dict);
            if(![dict isKindOfClass:[NSDictionary class]]){
                NSLog(@"continue");
                continue;
            }
            model.key = dict[@"name"];
            NSLog(@"3333333333333333333333333333");
            if (dict[@"city"]) {
                model.city = dict[@"city"];
            }
            NSLog(@"44444444444444444444444444444444");
            if (dict[@"district"]) {
                model.district = dict[@"district"];
            }
            NSLog(@"55555555555555555555555555555555555");
            if (dict[@"latitudeNum"]) {
                model.latitude = dict[@"latitudeNum"];
            }
            NSLog(@"666666666666666666666666666666666666");
            if (dict[@"longitudeNum"]) {
                model.longitude = dict[@"longitudeNum"];
            }
            NSLog(@"77777777777777777777777777");
            [_dataArray addObject:model];
            NSLog(@"8888888888888888888888");
            
        }
        NSLog(@"9999999999999999999999999999");
        
    }
    if (_dataArray.count) {
        UILabel* heardView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
        heardView.text = @"历史记录";
        heardView.textAlignment = NSTextAlignmentCenter;
        _tableView.tableHeaderView = heardView;
        
        UIButton* footView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [footView setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [footView addTarget:self action:@selector(cleanHis) forControlEvents:UIControlEventTouchUpInside];
        footView.titleLabel.textAlignment = NSTextAlignmentCenter;
        footView.frame = CGRectMake(0, 0, Width, 60);
        _tableView.tableFooterView = footView;
        NSLog(@"0000000000000000000000000");
    }
       [_tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated{
   NSLog(@"555555555555555555555555555555");

}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"666666666666666666666666666666");
    _searchBtn.hidden = YES;
    _searchBar.hidden = YES;
    _isSaojie = nil;
    _tableView.delegate = nil;
    [_searchBar endEditing:YES];
    [_searchBar resignFirstResponder];
}
- (void)makeView{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isSaojie) {
        NSLog(@"saojie  a a a ");
    }
    _isHis = YES;
    
    //实例化tableView
    _tableView = [[UITableView alloc]init];
    self.tableView.frame=CGRectMake(0, 0, Width, Height + self.tabBarController.tabBar.frame.size.height - 60);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    if (_isHis) {
        NSLog(@"ishis");
    }
    NSLog(@"%d",_dataArray.count);
    if (_isHis&&_dataArray.count) {
        UILabel* heardView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
        heardView.text = @"历史记录";
        heardView.textAlignment = NSTextAlignmentCenter;
        _tableView.tableHeaderView = heardView;
        
        UIButton* footView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [footView setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [footView addTarget:self action:@selector(cleanHis) forControlEvents:UIControlEventTouchUpInside];
        footView.titleLabel.textAlignment = NSTextAlignmentCenter;
        footView.frame = CGRectMake(0, 0, Width, 60);
        _tableView.tableFooterView = footView;
    }
    
    _coord = [[TXYConfig sharedConfig]getFakeGPS];
    _poiSearch = [[BMKPoiSearch alloc]init];
    _poiSearch.delegate = self;
    currentPage = 0;
    //附近云检索，其他检索方式见详细api
    _nearBySearchOption = [[BMKNearbySearchOption alloc]init];
    //云检索基类
    _baseSearchOption = [[BMKBasePoiSearchOption alloc]init];
    
    
    //城市搜索
    _citySearch = [[BMKCitySearchOption alloc]init];
    
    
    //搜索服务类
     _suggest = [[BMKSuggestionSearch alloc]init];
    _suggest.delegate = self;
    //搜索信息类
     _option = [[BMKSuggestionSearchOption alloc]init];
    
    
    
    
 //   BOOL flag = [_poiSearch poiSearchNearBy:nearBySearchOption];
    
       
    
}
#pragma mark - 清空搜索历史
- (void)cleanHis{
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    
 //   NSArray* array = [userPoint objectForKey:@"history"];
    NSArray* array = [userPoint arrayForKey:@"history"];
    NSMutableArray* userArray = nil;
    if (array == nil){
        userArray = [NSMutableArray array];
    }else{
        userArray = [NSMutableArray arrayWithArray:array];
    }
    [userArray removeAllObjects];
    [userPoint setObject:userArray forKey:@"history"];
    [_dataArray removeAllObjects];
    //同步操作
    [userPoint synchronize];
    
    _isHis = NO;
    _tableView.tableFooterView = nil;
    _tableView.tableHeaderView = nil;
    
    [_tableView reloadData];
}

#pragma mark - 搜索按钮
- (void)sousuo{
    [self searchBarSearchButtonClicked:_searchBar];
}


#pragma mark - tableView delegate

//cell实例化
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    DidianModel* model = [[DidianModel alloc]init];
    model = _dataArray[indexPath.row];
    NSLog(@"key = %@ , district = %@,model.la = %f",model.key,model.district,[model.latitude doubleValue]);
    cell.neirongLab.text= model.key;
    cell.weizhiLab.text= @"";
    if (model.city && model.district) {
        NSLog(@"district = %@",model.district);
        cell.weizhiLab.text = [NSString stringWithFormat:@"%@%@",model.city,model.district];
    }
    if (!((int)[model.latitude doubleValue] == 0)) {
        cell.leftImg.image = [UIImage imageNamed:@"mapPicker_poi_icon_ugc@2x.png"];
       // cell.imageView.image = [UIImage imageNamed:@"xiaoqi.png"];
    }
    return cell;
}

//多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XuandianModel* model = [[XuandianModel alloc]init];
    DidianModel* didian = [[DidianModel alloc]init];
    didian = _dataArray[indexPath.row];
    
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = didian.poiId;
    [_poiSearch poiDetailSearch:option];
    _keyWord = didian.key;
    NSLog(@"_keyWOrd = %@",_keyWord);
    //当不是周边搜索并且不是历史记录时添加历史记录
    if ((!_isHis)&&(!_isZhou)&&(!_isSaojie)) {
        _cityName = didian.city;
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        NSLog(@"T11111111111111111111111111");
        //NSArray* array = [userPoint objectForKey:@"history"];
        NSArray* array = [userPoint arrayForKey:@"history"];
        NSLog(@"array = %@",array);
        NSMutableArray* userArray = nil;
        NSLog(@"T22222222222222222222222");
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        NSLog(@"T3333333333333333333333333");
        NSDictionary* dict = [[NSMutableDictionary alloc]init];
        NSDictionary* doct = [[NSMutableDictionary alloc]init];
        BOOL isCun = NO;
        //判断历史记录里面是否已经存有
        for (int i = 0; i<userArray.count; i++) {
            NSLog(@"T4444444444444444444444");
            doct = userArray[i];
            NSLog(@"%@",doct);
            NSLog(@"T5555555555555555555555555");
            
            if(![doct isKindOfClass:[NSDictionary class]]){
                NSLog(@"continue");
                continue;
            }
            
            if ([doct[@"name"] isEqualToString:didian.key]) {
                isCun = YES;
                break;
            }
            NSLog(@"T666666666666666666666666");
        }
        NSLog(@"T777777777777777777777777");
        NSValue* value = [[NSValue alloc]init];
        value = didian.coordValue;
        CLLocationCoordinate2D coor2;
        [value getValue:&coor2];
        NSLog(@"T8888888888888888888888888888");
        NSLog(@"coor2.latitude = %lf",coor2.latitude);
        NSLog(@"coor2.longitude = %lf",coor2.longitude);

        if (!isCun) {
            if (didian.key) {
               [dict setValue:didian.key forKey:@"name"];
            }else{
                [dict setValue:nil forKey:@"name"];
            }
            if (didian.city) {
                [dict setValue:didian.city forKey:@"city"];
            }else{
                [dict setValue:nil forKey:@"city"];
            }
            if (didian.district) {
                [dict setValue:didian.district forKey:@"district"];
            }else{
                [dict setValue:nil forKey:@"district"];
            }
            if (!((int)[didian.latitude doubleValue] == 0)) {
                [dict setValue:didian.latitude forKey:@"latitudeNum"];
            }else{
                [dict setValue:nil forKey:@"latitudeNum"];
            }
            if (!((int)[didian.longitude doubleValue] == 0)) {
                [dict setValue:didian.longitude forKey:@"longitudeNum"];
            }else{
                [dict setValue:nil forKey:@"longitudeNum"];
            }
            [userArray insertObject:dict atIndex:0];
            [userPoint setObject:userArray forKey:@"history"];
            //同步操作
            [userPoint synchronize];
            NSLog(@"存入了历史记录");
        }
        NSLog(@"T9999999999999999999999");
    }
    if (_isZhou) {
        NSLog(@"iszhou");
    }
    if (_isHis) {
        NSLog(@"_isHis");
    }
    if (_isSaojie) {
        NSLog(@"_isSaojie");
    }
    NSLog(@"dis = %@",didian.district);
    if (didian.district) {
        NSLog(@"dis = %@",didian.district);
    }
    if (didian.latitude) {
        NSLog(@"la = %f",[didian.latitude doubleValue]);
    }
    //当是衍生词，并且没有确定地点时，用城市搜索搜一遍
    if (((int)[didian.latitude doubleValue] == 0)&&!_isHis) {
        _searchBar.text = didian.key;
        _citySearch.city = _chengshi;
        _isYan = YES;
        _citySearch.keyword = didian.key;
        NSLog(@"_citySearch.keyword = %@",_citySearch.keyword);
        NSLog(@"_citySearch.city = %@",_citySearch.city);
        BOOL iskai = [_poiSearch poiSearchInCity:_citySearch];
        if (iskai) {
            NSLog(@"城市内搜索成功");
        }else{
            [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
        }
    }
    if (_isHis) {
        NSLog(@"ishis");
    }
    if (_isSaojie) {
        NSLog(@"saojie");
    }
    NSLog(@"1= %f",[model.latitudeNum doubleValue]);
    //当不是历史记录并且有确定地点时跳转到地图
    if (!_isHis&&!_isSaojie &&!(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))) {
 
        
        model.longitudeStr = didian.longitude;
        model.latitudeStr = didian.latitude;
        model.weizhi = didian.key;
        model.latitudeNum = didian.latitude;
        model.longitudeNum = didian.longitude;
        model.whichbundle = didian.poiId;
        NSLog(@"la = %f",[didian.latitude doubleValue]);
        NSLog(@"lo = %f",[didian.longitude doubleValue]);
       
            [self.delegate chuanzhi:model];
            if (_isZhou) {
                for (UIViewController* vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MapViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
            }
            [self.navigationController popViewControllerAnimated:YES];

    
            
        }
   
    

 
    //当是历史记录，并且没有地点时，按原来方式搜索一遍
    if (_isHis && ( (int)[didian.latitude doubleValue] == 0)) {
        if (_isZhou) {
            _nearBySearchOption.keyword = _keyWord;
            _nearBySearchOption.location = [[TXYConfig sharedConfig]getFakeGPS];
            BOOL iskai = [_poiSearch poiSearchNearBy:_nearBySearchOption];
            if (iskai) {
                NSLog(@"周边搜索成功");
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }
        }else{
            AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            _chengshi = _appDelegate.city;
            
        _citySearch.city = _appDelegate.city;
            
        _citySearch.keyword = didian.key;
            NSLog(@"_citySearch.keyword = %@",_citySearch.keyword);
            NSLog(@"_citySearch.city = %@",_citySearch.city);
            BOOL iskai = [_poiSearch poiSearchInCity:_citySearch];
            if (iskai) {
                NSLog(@"城市内搜索成功");
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }

        }
    }
    //当是历史记录，并且有地点时，跳转到地图
    if (_isHis && !(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))&&!_isSaojie) {
        
        
        
        model.longitudeStr = didian.longitude;
        model.latitudeStr = didian.latitude;
        model.weizhi = didian.key;
        model.latitudeNum = didian.latitude;
        model.longitudeNum = didian.longitude;
        NSLog(@"model.latitude = %@",model.longitudeStr);
        NSLog(@"model.longitude = %@",model.latitudeStr);
        
        [self.delegate chuanzhi:model];
        if (_isZhou) {
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MapViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    //当是历史记录并且有地点并且是扫街切进来的进入扫街
    if (_isHis && !(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))&&_isSaojie) {
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([didian.latitude doubleValue], [didian.longitude doubleValue]);
        //先把百度坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coord];
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];

        
        XuandianModel* saojieModel = [[XuandianModel alloc]init];
        saojieModel.weizhi = didian.key;
        saojieModel.latitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.latitude];
        saojieModel.longitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.longitude];
        saojieModel.latitudeNum = [NSNumber numberWithDouble:gpsZuo.latitude];
        saojieModel.longitudeNum = [NSNumber numberWithDouble:gpsZuo.longitude];
        saojieModel.index = self.index;
        [self.delegate chuanzhiGPS:saojieModel];
        for(UIViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController* choose = (TotleScanViewController*)vc;
                [self.navigationController popToViewController:choose animated:YES];
            }
            
        }
    }
    //当不是历史记录并且是扫街时并且有地点跳转到扫街
    if (!_isHis&&_isSaojie&&!(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([didian.latitude doubleValue], [didian.longitude doubleValue]);
        //先把百度坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coord];
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
        
        
        XuandianModel* saojieModel = [[XuandianModel alloc]init];
        saojieModel.weizhi = didian.key;
        saojieModel.latitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.latitude];
        saojieModel.longitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.longitude];
        saojieModel.latitudeNum = [NSNumber numberWithDouble:gpsZuo.latitude];
        saojieModel.longitudeNum = [NSNumber numberWithDouble:gpsZuo.longitude];
        saojieModel.index = self.index;
        
        [self.delegate chuanzhiGPS:saojieModel];
        for(UIViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                TotleScanViewController* choose = (TotleScanViewController*)vc;
                [self.navigationController popToViewController:choose animated:YES];
            }
            
        }

    }
}



/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 int _totalPoiNum;		///<本次POI搜索的总结果数
	int _currPoiNum;			///<当前页的POI结果数
	int _pageNum;			///<本次POI搜索的总页数
	int _pageIndex;			///<当前页的索引
	
	NSArray* _poiInfoList;	///<POI列表，成员是BMKPoiInfo
	NSArray* _cityList;		///<城市列表，成员是BMKCityListInfo
 
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    SearchResultViewController* srvc = [[SearchResultViewController alloc]init];
    NSLog(@"poiResult.totalPoiNum = %d",poiResult.totalPoiNum);
    NSLog(@"poiResult.currPoiNum = %d",poiResult.currPoiNum);
    NSLog(@"poiResult.pageNum = %d",poiResult.pageNum);
    NSLog(@"poiResult.pageIndex = %d",poiResult.pageIndex);
    NSLog(@"poiResult.poiInfoList = %@",poiResult.poiInfoList);
    NSLog(@"poiResult.cityList = %@",poiResult.cityList);
  
    srvc.keyWord = _keyWord;
    if (!_isZhou) {
        srvc.cityName = _chengshi;
    }
    if (!_isHis) {
        srvc.keyWord = _searchBar.text;

    }
    if (_isYuYin) {
        srvc.keyWord = _keyWord1;
        srvc.cityName = _chengshi;
    }
    if (_isYan) {
         srvc.keyWord = _keyWord;
    }
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
    NSLog(@"有没有东西");
    if (errorCode == BMK_SEARCH_NO_ERROR)
        
    {
        //不是周边搜索时，并且历史记录没有，添加历史记录
        if ((!_isZhou)&&(!_isHis)&&(!_isYuYin)) {
            NSLog(@"添加至收藏夹");
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            
           // NSArray* array = [userPoint objectForKey:@"history"];
            NSArray* array = [userPoint arrayForKey:@"history"];
            NSMutableArray* userArray = nil;
            if (array == nil){
                userArray = [NSMutableArray array];
            }else{
                userArray = [NSMutableArray arrayWithArray:array];
            }
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            NSMutableDictionary* doct = [[NSMutableDictionary alloc]init];
            BOOL isCun = NO;
            //判断历史记录里面是否已经存有
            for (int i = 0; i<userArray.count; i++) {
                NSLog(@"rrr");
                doct = userArray[i];
                NSLog(@"dict:%@",doct);
                if(![doct isKindOfClass:[NSDictionary class]]){
                    NSLog(@"continue");
                    continue;
                }
                
                if ([doct[@"name"] isEqualToString:_searchBar.text]) {
                    isCun = YES;
                    break;
                }
                
            }
            
            if (!isCun) {
                [dict setValue:_searchBar.text forKey:@"name"];
                [dict setValue:_citySearch.city forKey:@"city"];
                [dict setValue:nil forKey:@"district"];
                [dict setValue:nil forKey:@"latitudeNum"];
                [dict setValue:nil forKey:@"longitudeNum"];
                
                [userArray insertObject:dict atIndex:0];
                [userPoint setObject:userArray forKey:@"history"];
                //同步操作
                [userPoint synchronize];
                NSLog(@"存入了历史记录");
            }

        }
       
        
    
    
        srvc.poiResult = poiResult;
      
        
        //是否有内容
        if (poiResult.totalPoiNum == 0) {
            srvc.isYes = NO;
  
        }else{
            srvc.isYes = YES;
         
        }
        if (srvc.isYes) {
            NSLog(@"isYes");
        }
        srvc.coord = _coord;
   
        
        //是否为周边搜索
        srvc.isZhou = self.isZhou;
        srvc.nearBySearchOption = [[BMKNearbySearchOption alloc]init];
        srvc.nearBySearchOption = self.nearBySearchOption;
        srvc.isAPP = self.isAPP;
        srvc.isSaojie = self.isSaojie;
        srvc.index = self.index;
        if (self.isSaojie) {
            for(UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[TotleScanViewController class]]) {
                    TotleScanViewController* choose = (TotleScanViewController*)vc;
                    srvc.delegate = choose;
                }
                
            }    

        }
        
        [self.navigationController pushViewController:srvc animated:YES];
        
        }
    /*
    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    BMK_SEARCH_KEY_ERROR,///<key错误
    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
     */
    if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        [MyAlert ShowAlertMessage:@"检索词有歧义" title:@"检索失败"];
    }
    if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        [MyAlert ShowAlertMessage:@"检索地址有岐义" title:@"检索失败"];
    }
    if (errorCode ==  BMK_SEARCH_RESULT_NOT_FOUND){
        [MyAlert ShowAlertMessage:@"没有找到检索结果" title:@"检索失败"];
    }
    if (errorCode == BMK_SEARCH_NETWOKR_ERROR||errorCode == BMK_SEARCH_NETWOKR_TIMEOUT){
        [MyAlert ShowAlertMessage:@"网络连接错误,请检查网络" title:@"检索失败"];
    }
   
    
    NSLog(@"cuowu = %d",errorCode);
}


//返回搜索的结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        
        
        [_dataArray removeAllObjects];
        for (int i = 0; i < result.keyList.count; i++)
        {
            DidianModel * model = [[DidianModel alloc]init];
            model.key = [result.keyList objectAtIndex:i];
            model.city = [result.cityList objectAtIndex:i];
            model.district = [result.districtList objectAtIndex:i];
            model.poiId = [result.poiIdList objectAtIndex:i];
            model.coordValue = [result.ptList objectAtIndex:i];
            
            
            NSValue* value = [[NSValue alloc]init];
            value = model.coordValue;
            CLLocationCoordinate2D coor2;
            [value getValue:&coor2];
            NSLog(@"coor2.latitude = %lf",coor2.latitude);
            NSLog(@"coor2.longitude = %lf",coor2.longitude);
            
            model.latitude = [NSNumber numberWithDouble:coor2.latitude];
            model.longitude = [NSNumber numberWithDouble:coor2.longitude];
            
            NSLog(@"model.latitude = %@",model.latitude);
            
            NSLog(@"key = %@",[result.keyList objectAtIndex:i]);
       
        
            NSLog(@"city = %@",[result.cityList objectAtIndex:i]);
        
        
            NSLog(@"district = %@",[result.districtList objectAtIndex:i]);
        
        
            NSLog(@"poi = %@",[result.poiIdList objectAtIndex:i]);
            
            [_dataArray addObject:model];
        }
        NSLog(@"_dataArray1 = %@",_dataArray);
    }
    NSLog(@"_dataArray = %@",_dataArray);
    [_tableView reloadData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - searchbar delegate

//当处于编辑模式时
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   
   
    
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

//当输入文字时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //当输入文本时
    if (searchText.length > 0) {
        if (!_isZhou) {
    
            _searchBtn.hidden = NO;
            searchBar.frame = CGRectMake(50, 6, Width - 100, 36);

            NSLog(@"打字了");
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            //开启检索衍生词
            _option.keyword = _searchBar.text;
            _option.cityname = _chengshi;
            BOOL isOk = [_suggest suggestionSearch:_option];
            if (isOk) {
                NSLog(@"搜索成功");
            }else{
                NSLog(@"搜索失败");
            }
            _isHis = NO;
            _tableView.tableHeaderView = nil;
            _tableView.tableFooterView = nil;

        }
        
    }
    //删除文本时
    else
    {
        searchBar.frame = CGRectMake(50, 6, Width-75, 36);
        _searchBtn.hidden = YES;
        _isHis = YES;
        [_dataArray removeAllObjects];
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
       // NSArray* array = [userPoint objectForKey:@"history"];
        NSArray* array = [userPoint arrayForKey:@"history"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        if (userArray.count) {
            for (int i = 0; i< userArray.count; i++) {
                NSLog(@"111111111111111111111111111111111111111111111");
                DidianModel* model = [[DidianModel alloc]init];
                NSLog(@"22222222222222222222222222222222222");
                NSMutableDictionary *dict = userArray[i];
                NSLog(@"dict：%@",dict);
                if(![dict isKindOfClass:[NSDictionary class]]){
                    NSLog(@"continue");
                    continue;
                }
                model.key = dict[@"name"];
                NSLog(@"3333333333333333333333333333");
                if (dict[@"city"]) {
                    model.city = dict[@"city"];
                }
                NSLog(@"44444444444444444444444444444444");
                if (dict[@"district"]) {
                    model.district = dict[@"district"];
                }
                NSLog(@"55555555555555555555555555555555555");
                if (dict[@"latitudeNum"]) {
                    model.latitude = dict[@"latitudeNum"];
                }
                NSLog(@"666666666666666666666666666666666666");
                if (dict[@"longitudeNum"]) {
                    model.longitude = dict[@"longitudeNum"];
                }
                NSLog(@"77777777777777777777777777");
                [_dataArray addObject:model];
                NSLog(@"8888888888888888888888");
                
            }

            NSLog(@"Ddataarray = %d",(int)_dataArray.count);
            UILabel* heardView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
            heardView.text = @"历史记录";
            heardView.textAlignment = NSTextAlignmentCenter;
            _tableView.tableHeaderView = heardView;
            
            UIButton* footView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [footView setTitle:@"清空历史记录" forState:UIControlStateNormal];
            [footView addTarget:self action:@selector(cleanHis) forControlEvents:UIControlEventTouchUpInside];
            footView.titleLabel.textAlignment = NSTextAlignmentCenter;
            footView.frame = CGRectMake(0, 0, Width, 60);
            _tableView.tableFooterView = footView;
        }
          [_tableView reloadData];
        }
}


//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    //如果是周边搜索
    if (_isZhou) {
        _nearBySearchOption.pageIndex = currentPage; //第几页
        _nearBySearchOption.pageCapacity = 10;  //最多几页
        _nearBySearchOption.keyword = _searchBar.text;   //检索关键字
        _nearBySearchOption.location = _coord; // poi检索点
        ZhoubianJilu* _jilu = [ZhoubianJilu shared];
        //检索范围
        if (_jilu.radius) {
            _nearBySearchOption.radius = _jilu.radius;
        }
        
        if (_jilu.paixu == 1) {
            _nearBySearchOption.sortType = 0;
        }
        if (_jilu.paixu == 2) {
            _nearBySearchOption.sortType = 1;
        }
        
        NSLog(@"关键字 = %@",_nearBySearchOption.keyword);
        NSLog(@"检索点 = %f",_nearBySearchOption.location.latitude);
        NSLog(@"检索半径 = %d",_nearBySearchOption.radius);
        
        BOOL zhou = [_poiSearch poiSearchNearBy:_nearBySearchOption];
        if (zhou) {
            NSLog(@"周边搜索成功");
            
        }else{
            NSLog(@"z周边搜索失败");
        }
       
    }else{
    _citySearch.keyword = _searchBar.text;
        
    _citySearch.city = _chengshi;
    
        
    NSLog(@"城市= %@",_chengshi);
    NSLog(@"关键字= %@",_searchBar.text);
    
    BOOL flag = [_poiSearch poiSearchInCity:_citySearch];
    
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
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
