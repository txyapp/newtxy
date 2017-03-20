//
//  TCSearchResultViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/7/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TCSearchResultViewController.h"
#import "FireToGps.h"
#import "TXYConfig.h"
#import "ZhoubianJilu.h"
#import "PopoverView.h"
#import "DidianModel.h"
#import "MBProgressHUD.h"

#import "TencentMapViewController.h"

@interface TCSearchResultViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,QMSSearchDelegate>

@end

@implementation TCSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    
    [self makeView];
    [self makeData];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

//界面将要加载时
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    for (UIView* view in self.navigationController.navigationBar.subviews) {
        if (view.tag == 4301 || view.tag == 4302) {
            view.hidden = YES;
        }
    }
    self.title = _keyWord;
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    _isSaojie = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tabBarController.tabBar.hidden = YES;
}

//上一页下一页的响应事件
- (void)qiehuan:(UIButton*)button{
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    //上一页
    if (button.tag == 2010) {
        if (_isZhou) {
            if (_currentPage>1) {
                _currentPage--;
            }
            _poiSearchOption.keyword = _keyWord;
            _poiSearchOption.page_size = 10;
            _poiSearchOption.page_index = _currentPage;
            [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:_radius];
            [_searcher searchWithPoiSearchOption:_poiSearchOption];
        }
    }
    //下一页
    if (button.tag == 2011) {
        if (_isZhou) {
            _currentPage++;
            _poiSearchOption.keyword = _keyWord;
            _poiSearchOption.page_size = 10;
            _poiSearchOption.page_index = _currentPage;
            NSLog(@"index = %d",_poiSearchOption.page_index);
            [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:_radius];
           NSLog(@"关键词 = %@,距离 = %@,地点 = %f ,%f",_poiSearchOption.keyword,_poiSearchOption.boundary,huoxing.latitude,huoxing.longitude);
            [_searcher searchWithPoiSearchOption:_poiSearchOption];
        }
    }

}



//界面生成
- (void)makeView{
    _currentPage = 1;
    _radius = 1000;
    //搜索类实例化
    _searcher = [[QMSSearcher alloc]init];
    [_searcher setDelegate:self];
    _poiSearchOption = [[QMSPoiSearchOption alloc]init];
    if (_isZhou) {
        _zhouBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       
        _zhouBtn.frame = CGRectMake(0, 64, Width /2, 36);
  
        [_zhouBtn setTitle:@"搜索半径" forState:UIControlStateNormal];
        _zhouBtn.tag = 1000;
        [_zhouBtn addTarget:self action:@selector(zhoubianBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _paiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _paiBtn.frame = CGRectMake(Width/2, 64, Width /2, 36);
        [_paiBtn setTitle:@"排序方式" forState:UIControlStateNormal];
        _paiBtn.tag = 1001;
        [_paiBtn addTarget:self action:@selector(zhoubianBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_zhouBtn];
        [self.view addSubview:_paiBtn];
        
    }
    //实例化tableView
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 100, Width, Height - 100);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    
    [self.view addSubview:_tableView];
            NSLog(@"jin");
            _bview = [[UIView alloc]init];
            _bview.frame = CGRectMake(0, 0, Width, 60);
            
            _upBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _upBtn.frame = CGRectMake(Width / 7, 15, Width / 7, 30);
            _upBtn.tag = 2010;
            [_upBtn setTitle:@"上一页" forState:UIControlStateNormal];
            [_upBtn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
            
            _downBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _downBtn.frame = CGRectMake(Width / 7 * 5, 15, Width / 7, 30);
            _downBtn.tag = 2011;
            [_downBtn setTitle:@"下一页" forState:UIControlStateNormal];
            [_downBtn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
            
            _yeLab = [[UILabel alloc]init];
            _yeLab.frame = CGRectMake(Width / 7*3-16, 15, Width/7+30, 30);
            _yeLab.textAlignment = NSTextAlignmentCenter;
            _yeLab.text = [NSString stringWithFormat:@"%d/%d",_poiSearchOption.page_index,_poiSearchResult.count/10+1];
    
            UIView* xian1 = [[UIView alloc]init];
            xian1.frame = CGRectMake(Width/7*3-20, 15, 1, 30);
            xian1.backgroundColor = [UIColor grayColor];
            if (_currentPage == 1) {
                _upBtn.enabled = NO;
            }
            if (_currentPage == _poiSearchResult.count / 10 +1) {
                _downBtn.enabled = NO;
            }
            if (_currentPage > 1 && _currentPage < _poiSearchResult.count / 10 +1) {
                _downBtn.enabled = YES;
                _upBtn.enabled = YES;
            }
            
            UIView* xian2 = [[UIView alloc]init];
            xian2.frame = CGRectMake(Width/7*4+20, 15, 1, 30);
            xian2.backgroundColor = [UIColor grayColor];
            
            
            
            [_bview addSubview:_upBtn];
            [_bview addSubview:_downBtn];
            [_bview addSubview:xian1];
            [_bview addSubview:xian2];
            [_bview addSubview:_yeLab];
            _tableView.tableFooterView = _bview;
}

- (void)makeData{
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }else{
        _dataArray = [NSMutableArray array];
    }
 
    for (int i = 0; i < _poiSearchResult.dataArray.count; i++) {
        QMSPoiData* data = _poiSearchResult.dataArray[i];
        [_dataArray addObject:data];
    }
   
    [_tableView reloadData];
    
}

//周边button事件
- (void)zhoubianBtn:(UIButton*)button{
    ZhoubianJilu* jilu = [ZhoubianJilu shared];
    CLLocationCoordinate2D coord;
    if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getFakeGPS].latitude, [[TXYConfig sharedConfig]getFakeGPS].longitude);
    }else{
        coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
    }
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
    //搜索半径
    if (button.tag == 1000) {
        CGPoint point;
        if (iOS7) {
            point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , button.frame.origin.y + button.frame.size.height + 10);
        }else{
            point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , 90 + 10);
        }
        _currentPage = 1;
        NSArray *titles = @[@"1000米",@"2000米",@"5000米"];
        PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
    
            if (index == 0) {
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[0]] forState:UIControlStateNormal];
                _radius = 1000;
                _poiSearchOption.page_index = _currentPage;
                [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:_radius];
                [_searcher searchWithPoiSearchOption:_poiSearchOption];
                
            }
            if (index == 1) {
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[1]] forState:UIControlStateNormal];
                _radius = 2000;
                _poiSearchOption.page_index = _currentPage;
                [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:_radius];
                [_searcher searchWithPoiSearchOption:_poiSearchOption];
            }
            if (index == 2) {
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[2]] forState:UIControlStateNormal];
                _radius = 5000;
                _poiSearchOption.page_index = _currentPage;
                [_poiSearchOption setBoundaryByNearbyWithCenterCoordinate:huoxing radius:_radius];
                NSLog(@"关键词 = %@,距离 = %@,地点 = %f ,%f",_poiSearchOption.keyword,_poiSearchOption.boundary,huoxing.latitude,huoxing.longitude);
                [_searcher searchWithPoiSearchOption:_poiSearchOption];
            }
        };
        [pop show];
        
        
    }
    //排序方式
    if (button.tag == 1001) {
        _currentPage = 1;
        CGPoint point;
        if (iOS7) {
            point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , button.frame.origin.y + button.frame.size.height + 10);
        }else{
            point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , 90 + 10);
        }
        
        NSArray *titles = @[@"距离由远到近排序",@"距离由近到远排序"];
        PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
            if (index == 0) {
                
                [_paiBtn setTitle:[NSString stringWithFormat:@"%@",titles[0]] forState:UIControlStateNormal];
                jilu.tcpaixu = 0;
                //降序
                _poiSearchOption.orderby = @"_distance desc";
                _poiSearchOption.page_index = _currentPage;
                [_searcher searchWithPoiSearchOption:_poiSearchOption];
            }
            if (index == 1) {
                [_paiBtn setTitle:[NSString stringWithFormat:@"%@",titles[1]] forState:UIControlStateNormal];
                jilu.tcpaixu = 1;
                //由近到远
                _poiSearchOption.orderby = @"_distance asc";
                _poiSearchOption.page_index = _currentPage;
                [_searcher searchWithPoiSearchOption:_poiSearchOption];
            }
        };
        [pop show];
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
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"请稍后";
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(0.5);
    } completionBlock:^{
        NSLog(@"共有搜索结果%d",poiSearchResult.count);
        NSLog(@"搜索结果 %d",poiSearchResult.dataArray.count);
        [_dataArray removeAllObjects];
        for (int i = 0; i < poiSearchResult.dataArray.count; i++) {
            QMSPoiData* data = poiSearchResult.dataArray[i];
            NSLog(@"index = %d,name = %@",poiSearchOption.page_index,data.title);
            [_dataArray addObject:data];
        }
        NSLog(@"_data = %d",_dataArray.count);
        NSLog(@"currentpage = %d",_currentPage);
        if (poiSearchOption.page_index == 1 &&poiSearchResult.count <10) {
            _upBtn.enabled = NO;
            _downBtn.enabled = NO;
        }
        if (poiSearchOption.page_index == 1 &&poiSearchResult.count>10) {
            _upBtn.enabled = NO;
            _downBtn.enabled = YES;
        }
        if (poiSearchOption.page_index == poiSearchResult.count / 10 +1 && poiSearchOption.page_index > 1) {
            _downBtn.enabled = NO;
            _upBtn.enabled = YES;
        }
        if (poiSearchOption.page_index == 1&&poiSearchResult.count / 10 >1){
            _downBtn.enabled = YES;
            _upBtn.enabled = NO;
        }
        if (poiSearchOption.page_index > 1 && poiSearchOption.page_index < poiSearchResult.count / 10 +1) {
            _downBtn.enabled = YES;
            _upBtn.enabled = YES;
        }
        _yeLab.text = [NSString stringWithFormat:@"%d/%d",poiSearchOption.page_index,poiSearchResult.count/10+1];
        NSLog(@"%@",_yeLab.text);
        [_tableView reloadData];

        }];

    
  }


#pragma mark - tableView delegate


//多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArray.count;
}

/*
 NSString* _name;			///<POI名称
 NSString* _uid;
	NSString* _address;		///<POI地址
	NSString* _city;			///<POI所在城市
	NSString* _phone;		///<POI电话号码
	NSString* _postcode;		///<POI邮编
	int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
	CLLocationCoordinate2D _pt;	///<POI坐标
 */

//定义cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]init];
    }
    //当当前城市有结果时

        QMSPoiData* model = _dataArray[indexPath.row];
        //距离
        UILabel* lab0 = [[UILabel alloc]init];
        lab0.textAlignment = 2;
        lab0.frame = CGRectMake(Width - 100, 5, 90, 17);
        lab0.textColor = [UIColor grayColor];
        //把gps转为火星
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
        //把火星转为百度
        CLLocationCoordinate2D baidu = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
        //把搜索点的火星转百度
        CLLocationCoordinate2D baidu2 = [[FireToGps sharedIntances]hhTrans_bdGPS:model.location];
        BMKMapPoint po1 = BMKMapPointForCoordinate(baidu);
        BMKMapPoint po2 = BMKMapPointForCoordinate(baidu2);
        _dis = BMKMetersBetweenMapPoints(po1,po2);
        if (_dis > 1000) {
            lab0.text = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
        }else{
            lab0.text = [NSString stringWithFormat:@"%.f米",_dis];
        }
        [cell addSubview:lab0];
        //名字
        UILabel* lab1 = [[UILabel alloc]init];

        lab1.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row,model.title];
        //当为公交站时
        if (model.type == 1) {
            lab1.text = [NSString stringWithFormat:@"%ld.%@(公交站)",(long)indexPath.row,model.title];
        }
        //当为地铁站时
        if (model.type == 2) {
            lab1.text = [NSString stringWithFormat:@"%ld.%@(地铁站)",(long)indexPath.row,model.title];
        }
        lab1.frame = CGRectMake(10, 5, Width - 100, 17);
        [cell addSubview:lab1];
        //位置
        UILabel* lab2 = [[UILabel alloc]init];
        lab2.text = [NSString stringWithFormat:@"%@",model.address];
        lab2.font = [UIFont systemFontOfSize:10.0];
        [lab2 setTextColor:[UIColor grayColor]];
        lab2.frame = CGRectMake(27, 25, Width - 80, 26);
        lab2.numberOfLines = 0;
        lab2.lineBreakMode = NSLineBreakByCharWrapping;
        [cell addSubview:lab2];
        
    return cell;
}

//选中cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isZhou && !_isSaojie ) {
        
        QMSPoiData* _info2 = _dataArray[indexPath.row];
        
        XuandianModel*model = [[XuandianModel alloc]init];
        
        model.latitude = _info2.location.latitude;
        model.longtitude = _info2.location.longitude;
        model.weizhi = _info2.title;
        model.latitudeStr = [NSString stringWithFormat:@"%lf",_info2.location.latitude];
        model.longitudeStr = [NSString stringWithFormat:@"%lf",_info2.location.longitude];
        model.latitudeNum  = [NSNumber numberWithDouble:_info2.location.latitude];
        model.longitudeNum = [NSNumber numberWithDouble:_info2.location.longitude];
        
        
        [self.delegate chuanzhi:model];
        //如果是应用程序地图选点，跳转到地图
        if (self.isAPP) {
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[TencentMapViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    //如果有内容并且是扫街
    if ( _isSaojie) {
        BMKPoiInfo* _info = _dataArray[indexPath.row];
        CLLocationCoordinate2D coord = _info.pt;
        //先把百度坐标转为火星坐标
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:coord];
        //再把火星坐标转为gps坐标
        CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
        
        
        XuandianModel* saojieModel = [[XuandianModel alloc]init];
        saojieModel.weizhi = _info.name;
        saojieModel.latitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.latitude];
        saojieModel.longitudeStr = [NSString stringWithFormat:@"%lf",gpsZuo.longitude];
        saojieModel.longitudeNum = [NSNumber numberWithDouble:gpsZuo.longitude];
        saojieModel.latitudeNum = [NSNumber numberWithDouble:gpsZuo.latitude];
        saojieModel.index = self.index;
        [self.delegate chuanzhiGPS:saojieModel];
        for(UIViewController *vc in self.navigationController.viewControllers)
        {
//            if ([vc isKindOfClass:[ScanNewViewController class]]) {
//                [self.navigationController popToViewController:vc animated:YES];
//                break;
//            }
            
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
