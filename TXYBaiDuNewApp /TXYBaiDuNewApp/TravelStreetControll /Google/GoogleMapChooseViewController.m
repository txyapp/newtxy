//
//  GoogleMapChooseViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/9/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapChooseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "XuandianModel.h"
#import "ChooseTripViewController.h"
#import "ScanNewViewController.h"
#import "FireToGps.h"
#import "MyAlert.h"
#import "TotleMapViewController.h"
#import "TotleScanViewController.h"
#import "TXYGoogleService.h"
#import "GoogleAnnotationView.h"
#import "GoogleAnnotation.h"
#import "TXYGeocoderService.h"
#import "GoogleMapViewUtil.h"
#import "GoogleMapTileUtil.h"
#import "FireToGps.h"
#import "GoogleTravelAnnotation.h"
@interface GoogleMapChooseViewController ()<UIGestureRecognizerDelegate,GoogleMapViewDelegate,TXYReverseGeocoderProtocol,TXYGeocoderProtocol>
{
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D last2D;
    GoogleMapScrollView *mapView;
}
@property int count;
@property (nonatomic,strong) GoogleTravelAnnotation       *annotation;
@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* time;
@property (nonatomic)NSNumber* longitude;
@property (nonatomic)NSNumber* latitude;
@property (nonatomic)CLLocationDistance dis;
@end

@implementation GoogleMapChooseViewController
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [mapView removeAllTravelAnnotations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView = [[TXYGoogleService mapManager] getMapScrollView];
    mapView.mapViewDelegate = self;
    [self.view addSubview:mapView];
    
    [mapView removeAllAnnotations];
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button1 addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 9000;
    int num = 0;
    if (self.currentPoints.count>0) {
        for (XuandianModel *model in self.currentPoints) {
            GoogleTravelAnnotation *annotation = [[GoogleTravelAnnotation alloc] init];
            annotation.annotationTitle = nil;
            annotation.coordinate = model.currentLocation;
            [mapView addMapTravelAnnotation:annotation];
            if (num ==0 ) {
                [mapView setMapCenter:model.currentLocation animated:YES];
            }
            if (num == self.currentPoints.count-1) {
                last2D = model.currentLocation;
            }
            num ++;
            
        }
    }
    self.annotation = [[GoogleTravelAnnotation alloc] initWithAddButton:button1];
    // Do any additional setup after loading the view.
}
- (void)googleMapScrollView:(GoogleMapScrollView *)mapScrollView didTapLocationCoordinate:(CLLocationCoordinate2D)tapCoordinate
{
     NSLog(@"%f %f",tapCoordinate.latitude,tapCoordinate.longitude);
     self.annotation.annotationTitle = @"解析中...";
     self.annotation.coordinate = tapCoordinate;
     [mapScrollView addMapTravelAnnotation:self.annotation];
     [[TXYGeocoderService defaultService] reverseGeoCoderWithCoordinate:tapCoordinate andHandlerObject:self];
}
- (void)didReverseGeocodeSuccessWithStreetInfo:(NSString *)info
{
    self.annotation.annotationTitle = info;
}

- (void)didReverseGeocodeFailedWithInfo:(NSString *)info
{
    self.annotation.annotationTitle = info;
}

- (void)didReverseGeocodeSuccessWithStreetInfo:(NSString *)info andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.annotation.annotationTitle = info;
    currentLocation = coordinate;
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    _time = locationString;
    _name =info ;
    _longitude = [NSNumber numberWithDouble:coordinate.longitude];
    _latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSLog(@"_name is :%@",_name);
    if (last2D.latitude !=0) {
        CLLocation *start = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLLocation *end = [[CLLocation alloc]initWithLatitude:last2D.latitude longitude:last2D.longitude];
        _dis =   [start distanceFromLocation:end];
    }
    else
    {
        _dis = 0;
    }
    NSLog(@"当前距离%.1f",_dis);
    
    _count ++;
}

- (void)didGeocoderSuccessWithResults:(NSArray *)results
{
    //    NSLog(@"search results : %@",results);
}

- (void)didGeocoderFailedWithInfo:(NSString *)failedInfo
{
    NSLog(@"search failed : %@",failedInfo);
}
- (void)addClick:(UIButton*) button {
    //添加收藏夹
    if (_annotation) {
        if (button.tag == 9000) {
            CLLocationCoordinate2D gpsZuo;
            gpsZuo.latitude = [_latitude doubleValue];
            gpsZuo.longitude = [_longitude doubleValue];
            
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
