//
//  TCSearchViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TCSearchViewController.h"
#import "MBProgressHUD.h"
#import "TXYConfig.h"
#import "AppDelegate.h"
#import "DidianModel.h"
#import "SearchHistoryTableViewCell.h"
#import "TencentMapViewController.h"
#import "FireToGps.h"
#import "TotleScanViewController.h"

@interface TCSearchViewController ()<QMSSearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    
}


@end

@implementation TCSearchViewController

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    [self makeData];
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    _searchBtn.hidden = NO;
    _searchBar.hidden = NO;
  }

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"666666666666666666666666666666");
    _searchBtn.hidden = YES;
    _searchBar.hidden = YES;
    _isSaojie = nil;
    _tableView.delegate = nil;
    [_searchBar endEditing:YES];
    [_searchBar resignFirstResponder];
    [_searchBtn removeFromSuperview];
    [_searchBar removeFromSuperview];
}

- (void)makeData{
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
        _dataArray = [[NSMutableArray alloc]init];
    }
    //判断是否为历史记录
    if (_isHis) {
        NSString *str = TencentPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:TencentPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray* userArray = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"History"]];
        if (userArray == nil) {
            userArray = [NSMutableArray array];
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

- (void)makeView{
    _dataArray = [NSMutableArray array];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    if (_isZhou) {
        _searchBar.placeholder  = @"周边搜索";
    }else{
        _searchBar.placeholder = @"请输入搜索内容";
    }
    if (_isYuYin) {
        _searchBar.text = _keyWord1;
    }
    if (iOS7) {
        _searchBar.frame = CGRectMake(50, 6, Width - 67, 36);
    }else{
        _searchBar.frame = CGRectMake(70, 6, Width - 80, 36);
    }
    
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
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isSaojie) {
        NSLog(@"saojie  a a a ");
    }
    _isHis = YES;
    if (_isYuYin) {
        _isHis = NO;
    }
    
    //实例化tableView
    _tableView = [[UITableView alloc]init];
    self.tableView.frame=CGRectMake(0, 0, Width, Height + self.tabBarController.tabBar.frame.size.height);
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
    
    //创建搜索类
    self.searcher = [[QMSSearcher alloc] init];
    [self.searcher setDelegate:self];
    //创建衍生词搜索类
    _suggestionSearchOption = [[QMSSuggestionSearchOption alloc]init];
    //创建poi搜索类
    _poiSearchOption = [[QMSPoiSearchOption alloc] init];
    //设置搜索城市
    [_poiSearchOption setBoundaryByRegionWithCityName:_chengshi autoExtend:NO];
    if (_isYuYin) {
        _suggestionSearchOption.keyword = _searchBar.text;
        if (_chengshi) {
            _suggestionSearchOption.region = _chengshi;
        }
        [self.searcher searchWithSuggestionSearchOption:_suggestionSearchOption];
    }
}

#pragma mark - 清空搜索历史
- (void)cleanHis{
    NSString *str = TencentPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:TencentPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSMutableArray* userArray = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"History"]];
    if (userArray == nil) {
        userArray = [NSMutableArray array];
    }
    [userArray removeAllObjects];
    [plistDict setObject:userArray forKey:@"History"];
    BOOL result=[plistDict writeToFile:TencentPlist atomically:YES];
    if (result) {
        NSLog(@"存入成功");
    }else{
        NSLog(@"存入失败");
    }
    [_dataArray removeAllObjects];
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
    NSLog(@"count = %d",_dataArray.count);
    model = _dataArray[indexPath.row];
    NSLog(@"key = %@ , district = %@,model.la = %f ,model.lo = %f",model.key,model.city,[model.latitude doubleValue],[model.longitude doubleValue]);
    cell.neirongLab.text= model.key;
    cell.weizhiLab.text= @"";
    if (model.city ) {
        cell.weizhiLab.text = [NSString stringWithFormat:@"%@",model.city];
    }
    if (!(((int)[model.latitude doubleValue] == 0)&&((int)[model.longitude doubleValue] == 0))) {
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
    //当不是周边搜索并且不是历史记录时添加历史记录
    if ((!_isZhou)&&(!_isSaojie)) {
        NSString *str = TencentPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:TencentPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray* userArray = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"History"]];
        if (userArray == nil) {
            userArray = [NSMutableArray array];
        }        NSDictionary* dict = [[NSMutableDictionary alloc]init];
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
            [plistDict setObject:userArray forKey:@"History"];
            //同步操作
            BOOL result=[plistDict writeToFile:TencentPlist atomically:YES];
            if (result) {
                NSLog(@"存入成功");
            }else{
                NSLog(@"存入失败");
            }
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
    if (_isHis) {
        NSLog(@"ishis");
    }
    if (_isSaojie) {
        NSLog(@"saojie");
    }
    NSLog(@"1= %f",[model.latitudeNum doubleValue]);
    //当不是历史记录并且有确定地点时跳转到地图
    if (!_isHis&&!_isSaojie &&!((int)[didian.latitude doubleValue] == 0)) {
        model.weizhi = didian.key;
        model.latitudeNum = didian.latitude;
        model.longitudeNum = didian.longitude;
        model.whichbundle = didian.poiId;
        NSLog(@"la = %f",[didian.latitude doubleValue]);
        NSLog(@"lo = %f",[didian.longitude doubleValue]);
        [self.delegate chuanzhi:model];
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    //当是历史记录，并且有地点时，跳转到地图
    if (_isHis && !(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))&&!_isSaojie) {
        model.weizhi = didian.key;
        model.latitudeNum = didian.latitude;
        model.longitudeNum = didian.longitude;
        NSLog(@"model.latitude = %f",[model.latitudeNum floatValue]);
        NSLog(@"model.longitude = %f  , %f",[model.longitudeNum floatValue],[didian.longitude doubleValue]);
        [self.delegate chuanzhi:model];
       [self.navigationController popViewControllerAnimated:YES];
    }
    //当是历史记录并且有地点并且是扫街切进来的进入扫街
    if (_isHis && !(((int)[didian.latitude doubleValue] == 0)&&((int)[didian.longitude doubleValue] == 0))&&_isSaojie) {
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([didian.latitude doubleValue], [didian.longitude doubleValue]);
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
        
        
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
    if (!_isHis&&_isSaojie&&!((int)[didian.latitude doubleValue] == 0)) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([didian.latitude doubleValue], [didian.longitude doubleValue]);
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:coord.latitude gjLon:coord.longitude];
        
        
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
            NSLog(@"打字了");
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            NSLog(@"CHENGSHI = %@",_chengshi);
            //开启检索衍生词
            _suggestionSearchOption.keyword = searchText;
            AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (_chengshi) {
                _suggestionSearchOption.region = _chengshi;
            }else{
                _suggestionSearchOption.region = _appDelegate.city;
            }
            NSLog(@"_suggestionSearchOption.keyword = %@,_suggestionSearchOption.region = %@",_suggestionSearchOption.keyword,_suggestionSearchOption.region);
            [_searcher searchWithSuggestionSearchOption:_suggestionSearchOption];
            _isHis = NO;
            _tableView.tableHeaderView = nil;
            _tableView.tableFooterView = nil;
    }
    //删除文本时
    else
    {
        _searchBtn.hidden = YES;
        _isHis = YES;
        [_dataArray removeAllObjects];
        NSString *str = TencentPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:TencentPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray* userArray = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"History"]];
        if (userArray == nil) {
            userArray = [NSMutableArray array];
        }        if (userArray.count) {
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
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    AppDelegate *_appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"city = %@",_appDelegate.city);
   
    
        _poiSearchOption.keyword = _searchBar.text;
        _poiSearchOption.page_size = 20;
    
        NSLog(@"搜索关键字 =%@,地点 = %@",_poiSearchOption.keyword,_poiSearchOption.boundary);
    if (_isZhou) {
          [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:1000];
    }else{
        if (_appDelegate.city) {
            [_poiSearchOption setBoundaryByRegionWithCityName:_appDelegate.city autoExtend:NO];
        }else{
            [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:1000];
        }
    }
    
        [_searcher searchWithPoiSearchOption:_poiSearchOption];
    
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
        [_dataArray removeAllObjects];
        for (int i = 0; i < poiSearchResult.dataArray.count; i++) {
            QMSPoiData* data = poiSearchResult.dataArray[i];
            DidianModel* model = [[DidianModel alloc]init];
            model.city = data.address;
            model.key = data.title;
            model.latitude = [NSNumber numberWithDouble:data.location.latitude];
            model.longitude = [NSNumber numberWithDouble:data.location.longitude];
            [_dataArray addObject:model];
        }
        NSLog(@"_data = %d",_dataArray.count);
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请稍后";
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //显示对话框
        [HUD showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1);
            HUD.mode = MBProgressHUDModeCustomView;
          //  HUD.labelText = @"恢复成功";
        } completionBlock:^{
            //操作执行完后取消对话框
            [HUD removeFromSuperview];
            [_tableView  reloadData];
        }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

//衍生词建议搜索查询结果
- (void)searchWithSuggestionSearchOption:(QMSSuggestionSearchOption *)suggestionSearchOption didReceiveResult:(QMSSuggestionResult *)suggestionSearchResult{
    NSLog(@"结果数目 = %d %d",suggestionSearchResult.count,suggestionSearchResult.dataArray.count);
        [_dataArray removeAllObjects];
        for (int i = 0; i < suggestionSearchResult.dataArray.count; i++) {
            QMSSuggestionPoiData* data = [[QMSSuggestionPoiData alloc]init];
            data = suggestionSearchResult.dataArray[i];
            NSLog(@"address = %@,title = %@,city = %@,type = %d,location.la = %f,location.lo = %f",data.address,data.title,data.city,data.type,data.location.latitude,data.location.longitude);
            DidianModel* model = [[DidianModel alloc]init];
            model.city = data.address;
            model.key = data.title;
            model.latitude = [NSNumber numberWithDouble:data.location.latitude];
            model.longitude = [NSNumber numberWithDouble:data.location.longitude];
            [_dataArray addObject:model];
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
