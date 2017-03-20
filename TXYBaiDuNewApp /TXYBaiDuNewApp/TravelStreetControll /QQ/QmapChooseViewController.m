//
//  QmapChooseViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/8/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "QmapChooseViewController.h"
#import "MyAnnotation.h"
#import "XuandianModel.h"
#import "ChooseTripViewController.h"
#import "ScanNewViewController.h"
#import "FireToGps.h"
#import "MyAlert.h"
#import "TotleMapViewController.h"
#import "TotleScanViewController.h"
@interface QmapChooseViewController ()<UIGestureRecognizerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    QMapView *_qMapView;
    QMSSearcher *_searcher;
    QMSReverseGeoCodeSearchOption *_geocode;
    QPointAnnotation* _annotation;
    
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

@property (nonatomic)BMKPointAnnotation* bannotation;
@end

@implementation QmapChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self makeView];
    temPlace = @"...";
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{
    _qMapView = nil;
    _qMapView.delegate = nil;
}

- (void)makeView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //实例化地图
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addClick:)];
    
    _qMapView = [[QMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _qMapView.delegate = self;
    //116.381354 39.902099
//    CLLocationCoordinate2D c;
//    c.latitude = 39.902099;
//    c.longitude = 116.381354;
//    [_qMapView setCenterCoordinate:c];
    [self.view addSubview:_qMapView];
    _annotation = nil;
    _count = 0;
    int num = 0;
    if (self.currentPoints.count>0) {
        for (XuandianModel *model in self.currentPoints) {
            QPointAnnotation *pointA = [[QPointAnnotation alloc]init];
            pointA.coordinate = model.currentLocation;
            pointA.subtitle = model.weizhi;
            pointA.title = [NSString stringWithFormat:@"%d",num];
            [_qMapView addAnnotation:pointA];
            if (num ==0 ) {
                [_qMapView setCenterCoordinate:model.currentLocation];
                float zoomLevel = 0.02;
                QCoordinateRegion region = QCoordinateRegionMake(model.currentLocation, QCoordinateSpanMake(zoomLevel, zoomLevel));
                [_qMapView setRegion:[_qMapView regionThatFits:region] animated:YES];
            }
            if (num == self.currentPoints.count-1) {
                last2D = model.currentLocation;
            }
            num ++;
            
        }
    }
    _searcher = [[QMSSearcher alloc] init];
    _searcher.delegate = self;
    
    
    //添加手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(longPress:)];
    [gestureRecognizer setDelegate:self];
    [_qMapView addGestureRecognizer:gestureRecognizer];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//点击手势
- (void)longPress:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:self.view];
    CLLocationCoordinate2D coo = [_qMapView convertPoint:point toCoordinateFromView:_qMapView];
    NSLog(@"经纬度:%lf, %lf", coo.longitude,  coo.latitude);
    NSLog(@"调用一次");
    if (_annotation == nil) {
        //QPointAnnotation* annotation = [[QPointAnnotation alloc] init];
        _annotation = [[QPointAnnotation alloc] init];
        [_qMapView addAnnotation:_annotation];
    }
    
    _annotation.coordinate = [_qMapView convertPoint:point toCoordinateFromView:_qMapView];
    _annotation.title = @"模拟位置";
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status==AFNetworkReachabilityStatusNotReachable) {
             [KGStatusBar showWithStatus:@"请检查网络连接"];
             return;
         }
         _geocode = [[QMSReverseGeoCodeSearchOption alloc] init];
         [_geocode setLocationWithCenterCoordinate:coo];
         [_searcher searchWithReverseGeoCodeSearchOption:_geocode];
     }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        //设置复用标识
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        QAnnotationView *annotationView = [_qMapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[QPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];;
            //显示气泡
            annotationView.canShowCallout = YES;
            annotationView.tag = 8000;
            annotationView.canShowCallout=YES;
            annotationView.annotation = annotation;
            [_qMapView selectAnnotation:_annotation animated:YES];
        }
        //设置图标
//        [annotationView setImage:[UIImage imageNamed:@"pin_red@2x"]];
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button1 addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 9000;
        annotationView.rightCalloutAccessoryView = button1;
        return annotationView;
    }
    return nil;
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
                //[self.delegate chuanzhi:model];
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
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult{
    //因为返回的是字符串，分割后取出经纬度
    NSLog(@"reverseGeoCodeSearchOption.location = %@",reverseGeoCodeSearchOption.location);
    NSArray *strarray = [reverseGeoCodeSearchOption.location componentsSeparatedByString:@","];
    NSString* la;
    NSString* lo;
    CLLocationCoordinate2D coord;
    if (strarray.count == 2) {
        la = strarray[0];
        lo = strarray[1];
    }
    NSLog(@"字符串:la = %@,lo = %@",la,lo);
    coord = CLLocationCoordinate2DMake([la floatValue], [lo floatValue]);
    currentLocation = coord;
    _annotation.subtitle = reverseGeoCodeSearchResult.address;
    [_qMapView addAnnotation:_annotation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_qMapView selectAnnotation:_annotation animated:YES];
    });
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    _time = locationString;
    _name =[NSString stringWithFormat:@"%@",reverseGeoCodeSearchResult.address] ;
    _longitude = [NSNumber numberWithDouble:_annotation.coordinate.longitude];
    _latitude = [NSNumber numberWithDouble:_annotation.coordinate.latitude];
    NSLog(@"_name is :%@",_name);
    if (last2D.latitude !=0) {
        QMapPoint point1 = QMapPointForCoordinate(last2D);
        QMapPoint point2 = QMapPointForCoordinate(_annotation.coordinate);
        _dis = QMetersBetweenMapPoints(point1,point2);
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
