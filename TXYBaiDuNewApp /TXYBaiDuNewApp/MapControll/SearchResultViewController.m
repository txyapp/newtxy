//
//  SearchResultViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#define WhitchLanguagesIsChina [[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages]objectAtIndex:0]isEqualToString:@"zh-Hans-CN"]?1:0
//判断系统版本是否高于6
#define WhitchIOSVersionOverTop6 [[[UIDevice currentDevice] systemVersion] floatValue]>=7?1:0
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0

#import "SearchResultViewController.h"
#import "XuandianModel.h"
#import "MapViewController.h"
#import "MyAlert.h"
#import "PopoverView.h"
#import "ZhoubianJilu.h"
#import "TXYConfig.h"
#import "FireToGps.h"
//#import "ChooseTypeViewController.h"
#import "ScanNewViewController.h"
#import "MapViewController.h"
#import "TotleScanViewController.h"
@interface SearchResultViewController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
 
}

@property (nonatomic)CLLocationDistance dis;



@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    
    [self makeView];
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
    _dataArray = [[NSMutableArray alloc]init];
    NSLog(@"_poiResult.totalPoiNum = %d",_poiResult.totalPoiNum);
    NSLog(@"_poiResult.currPoiNum = %d",_poiResult.currPoiNum);
    NSLog(@"_poiResult.pageNum = %d",_poiResult.pageNum);
    NSLog(@"_poiResult.pageIndex = %d",_poiResult.pageIndex);
    NSLog(@"_poiResult.poiInfoList = %@",_poiResult.poiInfoList);
    NSLog(@"_poiResult.cityList = %@",_poiResult.cityList);
    if (_isYes) {
        NSLog(@"我是yes");
    }
    
    if (_isYes) {
        _dataArray = (NSMutableArray*)[NSArray arrayWithArray:_poiResult.poiInfoList];
        
    }else{
    _dataArray = (NSMutableArray*)[NSArray arrayWithArray:_poiResult.cityList];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    _isSaojie = nil;
    _tableView.delegate = nil;
}

//上一页下一页的响应事件
- (void)qiehuan:(UIButton*)button{
    
    //将工具类中的gps坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
    //将火星转为百度
    CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
    //上一页
    if (button.tag == 2010) {
        if (_isZhou) {
            _nearBySearchOption.keyword = _keyWord;
            _nearBySearchOption.location = baiduZuo;
            _nearBySearchOption.pageIndex = _yeshu - 2;
            BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
            if (flag) {
                
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }
        }else{
            _citySearch.pageIndex = _yeshu - 2;
            _citySearch.keyword = _keyWord;
            _citySearch.city = _cityName;
            BOOL flag=  [_poiSearch poiSearchInCity :_citySearch];
            if (flag) {
                
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }
        }

    }
    //下一页
    if (button.tag == 2011) {
        if (_isZhou) {
            _nearBySearchOption.pageIndex = _yeshu ;
            _nearBySearchOption.keyword = _keyWord;
            _nearBySearchOption.location = baiduZuo;
            BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
            if (flag) {
                
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }
        }else{
            _citySearch.pageIndex = _yeshu ;
            _citySearch.keyword = _keyWord;
            _citySearch.city = _cityName;
            NSLog(@"_citySearch.keyword = %@",_citySearch.keyword);
            NSLog(@"_citySearch.city = %@",_citySearch.city);
            BOOL flag=  [_poiSearch poiSearchInCity: _citySearch];
            if (flag) {
                
            }else{
                [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
            }
        }
    }
}



//界面生成
- (void)makeView{
    //搜索类实例化
    _poiSearch = [[BMKPoiSearch alloc]init];
    _poiSearch.delegate = self;
    _currentPage = 0;
    //附近云检索，其他检索方式见详细api
  
    //云检索基类
    _baseSearchOption = [[BMKBasePoiSearchOption alloc]init];
    
    
    //城市搜索
    _citySearch = [[BMKCitySearchOption alloc]init];
    
    NSLog(@"关键字 = %@",_nearBySearchOption.keyword);
    NSLog(@"检索点 = %f",_nearBySearchOption.location.latitude);
    NSLog(@"检索半径 = %d",_nearBySearchOption.radius);
    
    
    
    
    //搜索服务类
    _suggest = [[BMKSuggestionSearch alloc]init];
    _suggest.delegate = self;
    //搜索信息类
    _option = [[BMKSuggestionSearchOption alloc]init];
    ZhoubianJilu* _jilu = [ZhoubianJilu shared];
    if (_jilu.radius) {
        _nearBySearchOption.radius = _jilu.radius;
    }
    _nearBySearchOption.keyword = _keyWord;
    
    if (_jilu.paixu == 1) {
        _nearBySearchOption.sortType = 0;
    }
    if (_jilu.paixu == 2) {
        _nearBySearchOption.sortType = 1;
    }
    
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
        
        if (_jilu.radius) {
            [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%d",_jilu.radius] forState:UIControlStateNormal];
        }
        if (_jilu.paixu == 1) {
            [_paiBtn setTitle:@"综合排序" forState:UIControlStateNormal];
        }
        if (_jilu.paixu == 2) {
            [_paiBtn setTitle:@"由近至远排序" forState:UIControlStateNormal];
        }
        [self.view addSubview:_zhouBtn];
        [self.view addSubview:_paiBtn];
        
    }else{
        //实例化label
        _jieguoLab = [[UILabel alloc]init];
        _jieguoLab.frame = CGRectMake(0, 64, Width, 36);
        [self.view addSubview:_jieguoLab];
    if (_isYes) {
        _jieguoLab.text = [NSString stringWithFormat:@"共搜到%d条结果",_poiResult.totalPoiNum];
    }else{
        _jieguoLab.text = @"当前城市没有搜索结果,可以看下其他有结果城市";
    }
    
    }
    //实例化tableView
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 100, Width, Height - 100);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    
    [self.view addSubview:_tableView];
    if (_isYes) {
        if (_poiResult.pageNum > 10) {
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
            _yeLab.text = [NSString stringWithFormat:@"%d/%d",_poiResult.pageIndex+1,_poiResult.pageNum-1];
            
            _yeshu = _poiResult.pageIndex + 1;
            UIView* xian1 = [[UIView alloc]init];
            xian1.frame = CGRectMake(Width/7*3-20, 15, 1, 30);
            xian1.backgroundColor = [UIColor grayColor];
            if (_yeshu == 1) {
                _upBtn.enabled = NO;
            }else{
                _upBtn.enabled = YES;
            }
            if (_yeshu == _poiResult.pageNum -1 ||_poiResult.pageNum == 1) {
                _downBtn.enabled = NO;
            }else{
                _downBtn.enabled = YES;
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

    }
    
        
}

//周边button事件
- (void)zhoubianBtn:(UIButton*)button{
    ZhoubianJilu* jilu = [ZhoubianJilu shared];
    
    //搜索半径
    if (button.tag == 1000) {
        CGPoint point;
        point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , button.frame.origin.y + button.frame.size.height + 10);
        NSArray *titles = @[@"500米",@"1000米",@"2000米",@"5000米"];
        PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
            if (index == 0) {
                
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[0]] forState:UIControlStateNormal];
                jilu.radius = 500;
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                if (flag) {
                    NSLog(@"周边搜索成功");
                    NSLog(@"半径为%d",_nearBySearchOption.radius);
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }
            }
            if (index == 1) {
               [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[1]] forState:UIControlStateNormal];
                jilu.radius = 1000;
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                _nearBySearchOption.radius = jilu.radius;
               BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                if (flag) {
                    NSLog(@"周边搜索成功");
                    NSLog(@"半径为%d",_nearBySearchOption.radius);
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }

            }
            if (index == 2) {
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[2]] forState:UIControlStateNormal];
                jilu.radius = 2000;
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                _nearBySearchOption.radius = jilu.radius;
                BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                NSLog(@"半径为%d",_nearBySearchOption.radius);
                NSLog(@"关键字%@",_nearBySearchOption.keyword);
                if (flag) {
                    NSLog(@"周边搜索成功");
                    NSLog(@"半径为%d",_nearBySearchOption.radius);
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }
            }
            if (index == 3) {
                [_zhouBtn setTitle:[NSString stringWithFormat:@"搜索半径:%@",titles[3]] forState:UIControlStateNormal];
                jilu.radius = 5000;
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                _nearBySearchOption.radius = jilu.radius;
                BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                if (flag) {
                    
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }            }
        };
        [pop show];

        
    }
    //排序方式
    if (button.tag == 1001) {
        CGPoint point;
        point = CGPointMake(button.frame.origin.x + button.frame.size.width/2 , button.frame.origin.y + button.frame.size.height + 10);
        NSArray *titles = @[@"综合排序",@"距离由近到远排序"];
        PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
            if (index == 0) {
                
                [_paiBtn setTitle:[NSString stringWithFormat:@"%@",titles[0]] forState:UIControlStateNormal];
                jilu.paixu = 1;
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                _nearBySearchOption.sortType = 0;
                [_poiSearch poiSearchNearBy:_nearBySearchOption];
                
                NSLog(@"关键字 = %@",_nearBySearchOption.keyword);
                NSLog(@"检索点 = %f",_nearBySearchOption.location.latitude);
                NSLog(@"检索半径 = %d",_nearBySearchOption.radius);
                
                
                BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                if (flag) {
                    NSLog(@"周边搜索成功");
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }

            }
            if (index == 1) {
                [_paiBtn setTitle:[NSString stringWithFormat:@"%@",titles[1]] forState:UIControlStateNormal];
                if (jilu.radius) {
                    _nearBySearchOption.radius = jilu.radius;
                }
                jilu.paixu = 2;
                [_poiSearch poiSearchNearBy:_nearBySearchOption];
                _nearBySearchOption.sortType = 1;
                BOOL flag=  [_poiSearch poiSearchNearBy:_nearBySearchOption];
                if (flag) {
                    
                }else{
                    [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
                }
            }
            
            
                  };
        [pop show];
        
        
    }
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
    if (_isYes) {
        BMKPoiInfo* _info = _dataArray[indexPath.row];
        //距离
        UILabel* lab0 = [[UILabel alloc]init];
        lab0.textAlignment = 2;
        lab0.frame = CGRectMake(Width - 100, 5, 90, 17);
        lab0.textColor = [UIColor grayColor];
        //把gps转为火星
        CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:[[TXYConfig sharedConfig]getFakeGPS].latitude bdLon:[[TXYConfig sharedConfig]getFakeGPS].longitude];
        //把火星转为百度
        CLLocationCoordinate2D baidu = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];

        BMKMapPoint po1 = BMKMapPointForCoordinate(baidu);
        BMKMapPoint po2 = BMKMapPointForCoordinate(_info.pt);
        _dis = BMKMetersBetweenMapPoints(po1,po2);
        if (_dis > 1000) {
            lab0.text = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
        }else{
            lab0.text = [NSString stringWithFormat:@"%.f米",_dis];
        }
        [cell addSubview:lab0];
        //名字
        UILabel* lab1 = [[UILabel alloc]init];
        
        lab1.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row,_info.name];
        //当为公交站时
        if (_info.epoitype == 1) {
        lab1.text = [NSString stringWithFormat:@"%ld.%@(公交站)",(long)indexPath.row,_info.name];
        }
        //当为地铁站时
        if (_info.epoitype == 3) {
            lab1.text = [NSString stringWithFormat:@"%ld.%@(地铁站)",(long)indexPath.row,_info.name];
        }
        lab1.frame = CGRectMake(10, 5, Width - 100, 17);
        [cell addSubview:lab1];
        //位置
        UILabel* lab2 = [[UILabel alloc]init];
        lab2.text = [NSString stringWithFormat:@"%@%@",_info.city,_info.address];
        lab2.font = [UIFont systemFontOfSize:10.0];
        [lab2 setTextColor:[UIColor grayColor]];
        lab2.frame = CGRectMake(27, 25, Width - 80, 12);
        [cell addSubview:lab2];

        
        //搜周边
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame = CGRectMake(10, 40, 100, 15);
        [button1 setTitle:@"搜周边" forState:UIControlStateNormal];
       // [button1 setBackgroundColor:[UIColor blueColor]];
        button1.tag = 3000+indexPath.row;
        [button1 addTarget:self action:@selector(zhoubuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加收藏
        UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(180, 40, 100, 15);
       // [button2 setBackgroundColor:[UIColor blueColor]];
        [button2 setTitle:@"添加收藏" forState:UIControlStateNormal];
        button2.tag = 2000+indexPath.row;
        
        
        //判断是否已经添加收藏夹
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
        NSArray* array = [userPoint objectForKey:@"collect"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        button2.enabled = YES;
        button2.titleLabel.textColor = nil;
        for(int i = 0;i < userArray.count;i++){
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:userArray[i]];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([dict[@"latitudeNum"] doubleValue], [dict[@"longitudeNum"] doubleValue]);
            CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:coord.latitude bdLon:coord.longitude];
            //将火星转为百度
            CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
            int la = baiduZuo.latitude * 1000;
            int lo = baiduZuo.longitude * 1000;
            
            int la1 = _info.pt.latitude* 1000;
            int lo1 = _info.pt.longitude* 1000;
            if ((la == la1)&&(lo == lo1)) {
                  
                    button2.enabled = NO;
                    button2.titleLabel.textColor = [UIColor grayColor];
                }
            }
        
        [button2 addTarget:self action:@selector(phonebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
      //  [cell addSubview:button1];
        [cell addSubview:button2];
    }else{
        //城市
        UILabel* lab = [[UILabel alloc]init];
        BMKCityListInfo* _info1= _dataArray[indexPath.row];
        NSLog(@"%@",_info1);
        NSLog(@"%@",_info1.city);
        NSLog(@"%d",_info1.num);
        lab.text = [NSString stringWithFormat:@"%@",_info1.city];
        lab.font = [UIFont systemFontOfSize:17.0];
        lab.frame = CGRectMake(10, 5, 300, 17);
        [cell addSubview:lab];
        
        //结果数目
        UILabel* lab2 = [[UILabel alloc]init];
        lab2.text = [NSString stringWithFormat:@"共有搜索结果%d个",_info1.num];
        lab2.frame = CGRectMake(12, 35, 300, 15);
        lab2.textColor = [UIColor grayColor];
        lab2.font = [UIFont systemFontOfSize:12.0];
       // [cell addSubview:lab2];
    }
    
    
    return cell;
}

//选中cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isZhou) {
        
    }
    
    
    NSLog(@"");
    if (_isYes && !_isSaojie ) {
        
        BMKPoiInfo* _info2 = _dataArray[indexPath.row];
        
        XuandianModel*model = [[XuandianModel alloc]init];
        
        model.latitude = _info2.pt.latitude;
        model.longtitude = _info2.pt.longitude;
        model.weizhi = _info2.name;
        model.latitudeStr = [NSString stringWithFormat:@"%lf",_info2.pt.latitude];
        model.longitudeStr = [NSString stringWithFormat:@"%lf",_info2.pt.longitude];
        model.latitudeNum  = [NSNumber numberWithDouble:_info2.pt.latitude];
        model.longitudeNum = [NSNumber numberWithDouble:_info2.pt.longitude];
        
        //存入搜索历史
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
        //NSArray* array = [userPoint objectForKey:@"history"];
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
            
            doct = userArray[i];
            NSLog(@"bbbbb");
            NSLog(@"dict：%@",doct);
            if(![doct isKindOfClass:[NSDictionary class]]){
                NSLog(@"continue");
                continue;
            }
            
            if ([doct[@"name"] isEqualToString:_info2.name]) {
                isCun = YES;
                break;
            }

        }
        if (!isCun) {
            [dict setValue:_info2.name forKey:@"name"];
            [dict setValue:_info2.city forKey:@"city"];
            [dict setValue:_info2.address forKey:@"district"];
            [dict setValue:[NSString stringWithFormat:@"%d",_info2.epoitype] forKey:@"epoitype"];
            [dict setValue:[NSNumber numberWithDouble:_info2.pt.latitude] forKey:@"latitudeNum"];
            [dict setValue:[NSNumber numberWithDouble:_info2.pt.longitude] forKey:@"longitudeNum"];
            [userArray insertObject:dict atIndex:0];
            [userPoint setObject:userArray forKey:@"history"];
            //同步操作
            [userPoint synchronize];
            NSLog(@"存入了历史记录");
        }
        
        
        [self.delegate chuanzhi:model];
        //如果是应用程序地图选点，跳转到地图
        if (self.isAPP) {
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MapViewController class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
    
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    if (!_isYes)     {
        _isYes = YES;
        _citySearch.keyword = _keyWord;
        BMKCityListInfo* _info12= _dataArray[indexPath.row];
        _citySearch.city = _info12.city;
        

        
        BOOL flag = [_poiSearch poiSearchInCity:_citySearch];
        
        if(flag)
        {
            NSLog(@"城市内检索发送成功");
        }
        else
        {
            NSLog(@"城市内检索发送失败");
            [MyAlert ShowAlertMessage:@"检索失败" title:@"请检查网络"];
        }
        return;
    }
    //如果有内容并且是扫街
    if (_isYes && _isSaojie) {
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
            if ([vc isKindOfClass:[TotleScanViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
            
        }    

    }
    
}

//周边按钮事件(先不写)
- (void)zhoubuttonClick:(UIButton*)button{

    

}
//收藏的按钮事件
- (void)phonebuttonClick:(UIButton*)button{
    BMKPoiInfo* _info2 = _poiResult.poiInfoList[button.tag - 2000];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_info2.phone]];
    //存储到本地收藏夹

    NSLog(@"添加至收藏夹");
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    
    NSArray* array = [userPoint objectForKey:@"collect"];
    NSMutableArray* userArray = nil;
    if (array == nil){
        userArray = [NSMutableArray array];
    }else{
        userArray = [NSMutableArray arrayWithArray:array];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* doct = [[NSMutableDictionary alloc]init];
    BOOL isCun = NO;
    
    //先把百度坐标转为火星坐标
    CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]hhTrans_GCGPS:_info2.pt];
    //再把火星坐标转为gps坐标
    CLLocationCoordinate2D gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:huoxing.latitude gjLon:huoxing.longitude];
    
    //判断收藏夹里面是否已经存有
    for (int i = 0; i<userArray.count; i++) {
        
//        doct = userArray[i];
//        if (([doct[@"longitudeNum"] doubleValue] == gpsZuo.longitude)&&([doct[@"latitudeNum"] doubleValue] == gpsZuo.latitude)) {
//            isCun = YES;
//            [MyAlert ShowAlertMessage:@"收藏夹已经添加" title:@"温馨提示"];
//            break;
//        }
        
    }
     //如果收藏夹中没有，存入收藏夹
    if (!isCun) {
        [dict setValue:_info2.name forKey:@"name"];
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        [dict setValue:locationString forKey:@"time"];
        [dict setValue:[NSNumber numberWithDouble:gpsZuo.latitude] forKey:@"latitude"];
        [dict setValue:[NSNumber numberWithDouble:gpsZuo.longitude] forKey:@"longitude"];
        [dict setValue:[NSString stringWithFormat:@"%lf",gpsZuo.latitude] forKey:@"latitudeStr"];
        [dict setValue:[NSString stringWithFormat:@"%lf",gpsZuo.longitude] forKey:@"longitudeStr"];
        [dict setValue:[NSNumber numberWithDouble:gpsZuo.latitude] forKey:@"latitudeNum"];
        [dict setValue:[NSNumber numberWithDouble:gpsZuo.longitude] forKey:@"longitudeNum"];
        [dict setValue:@"baidu" forKey:@"whichMap"];
        BMKMapPoint po1 = BMKMapPointForCoordinate(_nearBySearchOption.location);
        BMKMapPoint po2 = BMKMapPointForCoordinate(_info2.pt);
        CLLocationDistance dis1 = BMKMetersBetweenMapPoints(po1,po2);
        
        NSString* str;
        if (dis1 > 1000) {
            str = [NSString stringWithFormat:@"%.1f千米",dis1/1000];
        }else{
            str = [NSString stringWithFormat:@"%.f米",dis1];
        }
        [dict setValue:str forKey:@"juli"];
        NSLog(@"collect = %@",dict);
        
        
        [userArray insertObject:dict atIndex:0];
        [userPoint setObject:userArray forKey:@"collect"];
        button.enabled = NO;
        //同步操作
        [userPoint synchronize];

    }
   
   
}


- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
      NSLog(@"有没有东西");
    if (errorCode == BMK_SEARCH_NO_ERROR)
        
    {
        NSLog(@"poiResult.totalPoiNum = %d",poiResult.totalPoiNum);
        NSLog(@"poiResult.currPoiNum = %d",poiResult.currPoiNum);
        NSLog(@"poiResult.pageNum = %d",poiResult.pageNum);
        NSLog(@"poiResult.pageIndex = %d",poiResult.pageIndex);
        NSLog(@"poiResult.poiInfoList = %@",poiResult.poiInfoList);
        NSLog(@"poiResult.cityList = %@",poiResult.cityList);
        BMKPoiInfo* infopoi = poiResult.poiInfoList[0];
        NSLog(@"name = %@",infopoi.name);
        NSLog(@"adress = %@",infopoi.address);
        NSLog(@"city = %@",infopoi.city);
        
        _yeshu = poiResult.pageIndex + 1;
        _yeLab.text = [NSString stringWithFormat:@"%d/%d",_yeshu,poiResult.pageNum - 1];
        if (_yeshu == 1) {
            _upBtn.enabled = NO;
        }else{
            _upBtn.enabled = YES;
        }
        if (_yeshu == poiResult.pageNum -1 ) {
            _downBtn.enabled = NO;
        }else{
            _downBtn.enabled = YES;
        }
        
       //刷新数据源
        _dataArray = (NSMutableArray*)[NSArray arrayWithArray:poiResult.poiInfoList];
        _jieguoLab.text = [NSString stringWithFormat:@"共搜到%d个结果",poiResult.totalPoiNum];
        [_tableView reloadData];
        
    }
    
    NSLog(@"cuowu = %d",errorCode);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignFirstResponder];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
