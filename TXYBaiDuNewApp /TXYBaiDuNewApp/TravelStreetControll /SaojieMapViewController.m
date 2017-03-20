//
//  SaojieMapViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/24.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "SaojieMapViewController.h"
#import <MapKit/MapKit.h>

#import "MyAnnotation.h"
#import "XuandianModel.h"
#import "ChooseTripViewController.h"
//#import "ChooseTypeViewController.h"
#import "ScanNewViewController.h"
#import "WGS84TOGCJ02.h"
#import "FireToGps.h"
#import "MyAlert.h"
#import "TotleScanViewController.h"
#import "TotleMapViewController.h"
@interface SaojieMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>{
    CLLocationManager* _manager;
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D last2D;
    NSString *temPlace;
}

@property int count;

@property (nonatomic,strong) BMKReverseGeoCodeOption* pt1;

@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* time;
@property (nonatomic)NSNumber* longitude;
@property (nonatomic)NSNumber* latitude;

@property (nonatomic)CLLocationDistance dis;

@property (nonatomic, strong) BMKGeoCodeSearch* search1;

@property (nonatomic,copy)NSString* didian;

@property (nonatomic,retain)BMKPointAnnotation* annotation;

@end

@implementation SaojieMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    temPlace = @"...";
}

-(void)viewDidDisappear:(BOOL)animated{
    _mapView = nil;
    _mapView.delegate = nil;
}

- (void)makeView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //实例化地图
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addClick:)];
    
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _annotation = nil;
    _count = 0;
    int num = 0;
    if (self.currentPoints.count>0) {
        for (XuandianModel *model in self.currentPoints) {
            BMKPointAnnotation *pointA = [[BMKPointAnnotation alloc]init];
            pointA.coordinate = model.currentLocation;
            pointA.subtitle = model.weizhi;
            pointA.title = [NSString stringWithFormat:@"%d",num];
            [_mapView addAnnotation:pointA];
            if (num ==0 ) {
                [_mapView setCenterCoordinate:model.currentLocation];
                float zoomLevel = 0.02;
                BMKCoordinateRegion region = BMKCoordinateRegionMake(model.currentLocation, BMKCoordinateSpanMake(zoomLevel, zoomLevel));
                [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
            }
            if (num == self.currentPoints.count-1) {
                last2D = model.currentLocation;
            }
            num ++;
            
        }
    }
    _search1 = [[BMKGeoCodeSearch alloc]init];
    _search1.delegate = self;
    
    
    //添加手势
    UITapGestureRecognizer *lPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_mapView addGestureRecognizer:lPress];
    
}

//点击手势
- (void)longPress:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:self.view];
    CLLocationCoordinate2D coo = [_mapView convertPoint:point toCoordinateFromView:_mapView];
    NSLog(@"经纬度:%lf, %lf", coo.longitude,  coo.latitude);
    NSLog(@"调用一次");
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc]init];
        [_mapView addAnnotation:_annotation];
    }
    _annotation.coordinate = [_mapView convertPoint:point toCoordinateFromView:_mapView];
    _annotation.title = @"模拟位置";
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status==AFNetworkReachabilityStatusNotReachable) {
             [KGStatusBar showWithStatus:@"请检查网络连接"];
             return;
         }
         BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption
                                                                 alloc]init];
         reverseGeocodeSearchOption.reverseGeoPoint = coo;
         [_search1 reverseGeoCode:reverseGeocodeSearchOption];
     }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    /*
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
     */
    static NSString * ID=@"annoView";
    //从缓存池中取出打头阵的View
    BMKPinAnnotationView *annoView=(BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView==nil) {
        annoView=[[BMKPinAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:ID];
        annoView.tag = 8000;
        annoView.canShowCallout=YES;
        annoView.annotation = annotation;
        [_mapView selectAnnotation:_annotation animated:YES];
        
        /*
         annoView.image = nil;
         UIImageView *customView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
         customView.image = [UIImage imageNamed:@"aeroplane@2x.png"];
         customView.transform = CGAffineTransformMakeRotation(- M_PI/20);
         [annoView addSubview:customView];
         */
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button1 addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 9000;
        annoView.rightCalloutAccessoryView = button1;
        
    }
    
    return annoView;
}

- (void)addClick:(UIButton*) button {
    //添加收藏夹
    if (_annotation) {
        if (button.tag == 9000) {
            CLLocationCoordinate2D coor;
            CLLocationCoordinate2D gpsZuo;
            coor.latitude = [_latitude doubleValue];
            coor.longitude = [_longitude doubleValue];
            CLLocationCoordinate2D result = [[FireToGps sharedIntances]hhTrans_GCGPS:coor];
            gpsZuo = [[FireToGps sharedIntances]gcj02Decrypt:result.latitude gjLon:result.longitude];
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            
            NSArray* array = [userPoint objectForKey:@"collect"];
            NSLog(@"收藏夹有多少个%d",(int)array.count);
            NSMutableArray* userArray = nil;
            if (array == nil){
                userArray = [NSMutableArray array];
            }else{
                userArray = [NSMutableArray arrayWithArray:array];
            }
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            NSMutableDictionary* doct = [[NSMutableDictionary alloc]init];
            BOOL isCun = NO;
            //判断收藏夹里面是否已经存有
            for (int i = 0; i<userArray.count; i++) {
                doct = [NSMutableDictionary dictionaryWithDictionary:userArray[i]];
                NSLog(@"doct = %@",doct);
                int longi2 = [doct[@"longitudeNum"] doubleValue] * 1000;
                int latitude2 = [doct[@"latitudeNum"] doubleValue] * 1000;
                NSLog(@"doct1 = %lf, doct2 = %lf",[doct[@"longitudeNum"] doubleValue],[doct[@"latitudeNum"] doubleValue]);
                NSLog(@"longi2 = %d,latitude2 = %d",longi2,latitude2);
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(gpsZuo.latitude,gpsZuo.longitude);
                int longi = coord.longitude * 1000;
                int latidu = coord.latitude * 1000;
                NSLog(@"txy1 = %lf, txy2 = %lf",coord.longitude,coord.latitude);
                NSLog(@"longi = %d,latitude = %d",longi,latidu);
                if ((longi2 == longi)&&(latitude2 == latidu)) {
                    NSLog(@"%d",longi);
                    isCun = YES;
                    [KGStatusBar showWithStatus:@"已存在,不能重复收藏"];
                    break;
                }
            }
            //如果收藏夹中没有，存入收藏夹
            if (!isCun) {
                [dict setValue:_name forKey:@"name"];
                [dict setValue:_time forKey:@"time"];
                [dict setValue:_latitude forKey:@"latitude"];
                [dict setValue:_longitude forKey:@"longitude"];
                [dict setValue:[NSNumber numberWithDouble:gpsZuo.latitude] forKey:@"latitudeNum"];
                [dict setValue:[NSNumber numberWithDouble:gpsZuo.longitude] forKey:@"longitudeNum"];
                NSString* str;
                if (_dis > 1000) {
                    str = [NSString stringWithFormat:@"%.1f千米",_dis/1000];
                }else{
                    str = [NSString stringWithFormat:@"%.f米",_dis];
                }
                [dict setValue:str forKey:@"juli"];
                NSLog(@"collect = %@",dict);
                
                
                [userArray insertObject:dict atIndex:0];
                [userPoint setObject:userArray forKey:@"collect"];
                //同步操作
                [userPoint synchronize];
                //[MyAlert ShowAlertMessage:@"成功收藏" title:@"温馨提示"];
                [KGStatusBar showWithStatus:@"收藏成功"];
            }
        }
        else
        {
            if (_name) {
                XuandianModel* model = [[XuandianModel alloc]init];
                model.location = [[CLLocation alloc]initWithLatitude:_annotation.coordinate.latitude longitude:_annotation.coordinate.longitude];
                model.time = _time;
                model.weizhi = _name;
                model.currentLocation = currentLocation;
                if (_dis > 1000) {
                    model.juli = [NSString stringWithFormat:@"%.f%@",_dis/1000,@"km"];
                }else{
                    model.juli = [NSString stringWithFormat:@"%.f%@",_dis,@"m"];
                }
                model.index =(int) self.index;
                
                [((TotleMapViewController *) self.parentViewController).delegate chuanzhi:model];
                _name = nil;
                NSLog(@"%@",self.navigationController.viewControllers);
                for(UIViewController *controller in self.navigationController.viewControllers)
                {
                    if ([controller isKindOfClass:[TotleScanViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
            else
            {
                [KGStatusBar showWithStatus:@"添加失败,请检查网络连接"];
            }
        }
    }
}


//返回反地理编码信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error) {
        [KGStatusBar showWithStatus:@"网络错误"];
        return;
    }
    NSLog(@"街道号%@ 街道名%@ district%@ 城市%@ 省份%@",result.addressDetail.streetNumber,result.addressDetail.streetName,result.addressDetail.district    ,result.addressDetail.city,result.addressDetail.province);
     NSLog(@"address = %@",result.address);
    currentLocation = result.location;
    _annotation.subtitle = result.address;
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    _time = locationString;
    _longitude = [NSNumber numberWithDouble:_annotation.coordinate.longitude];
    _latitude = [NSNumber numberWithDouble:_annotation.coordinate.latitude];
    _name = _annotation.subtitle;
    [_mapView addAnnotation:_annotation];
    [_mapView selectAnnotation:_annotation animated:YES];
    if (last2D.latitude !=0) {
       BMKMapPoint po1 = BMKMapPointForCoordinate(last2D);
        BMKMapPoint po2 = BMKMapPointForCoordinate(_annotation.coordinate);
        _dis = BMKMetersBetweenMapPoints(po1,po2);
    }
    else
    {
        _dis = 0;
    }
    NSLog(@"当前距离%.1f",_dis);
    
    _count ++;
}


//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"定位错误%@",error);
    
    
    
    [mapView setShowsUserLocation:NO];
    
}

//定位停止

-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    NSLog(@"定位停止");
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
