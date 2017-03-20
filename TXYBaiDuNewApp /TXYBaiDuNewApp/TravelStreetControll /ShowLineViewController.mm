//
//  ShowLineViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ShowLineViewController.h"
#import "DataBaseManager.h"
#import "XuandianModel.h"
#import "TXYConfig.h"
#import "TXYTools.h"
#import "SimpleOperation.h"
#import "MySaveDataManager.h"
#import "juhua.h"
#import "MyAlert.h"
#import "ChooseTypeViewController.h"
#import "ScanNewViewController.h"
#import "ProgressHUD.h"
#import "TotleScanViewController.h"
#import "TotleShowLineViewController.h"
#import "MapTypeDataManager.h"
#import "TravelStreetViewController.h"
#import "ScanPointManager.h"
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
@interface ShowLineViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    // annotation
    BMKPointAnnotation* myAnnotation;
    NSMutableArray *dataLine;
    NSTimer *_timer;
    NSString *curApp;
    NSLock *lock1;
    //角度
    double Angle;
    dispatch_queue_t concurrentQueue;
    //
    UILabel *AppNameLab,*typeLab,*LongLab,*LatLab;
    UIButton *_button1,*_button2,*_btn3;
    BMKPointAnnotation *item;
    UIImageView *customView;
    int aSingle;
    int start;
    //记录开始或者暂停
    int isStop;
    ScanPointManager *manager;
}
@end

@implementation ShowLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.isCycle);
    dataLine = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    item = [[BMKPointAnnotation alloc]init];
    [_mapView addAnnotation:item];
    aSingle = 10;
    start = 10;
    curApp = nil;
    isStop = self.Stop;
    [self getModel];
    //[_mapView removeAnnotations:_mapView.annotations];
    concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    manager = [ScanPointManager defaultManager];
    //检查单例中是否存在当前点
    [self chargeExist];
    // Do any additional setup after loading the view.
}
//检查单例中是否存在当前点
-(void)chargeExist
{
    NSDictionary *pointDic = [NSDictionary dictionaryWithDictionary:manager.dic];
    NSLog(@"%@",pointDic);
    if ([[pointDic allKeys]containsObject:[self.bundle stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
        aSingle   =1;
        NSDictionary *dic = (NSDictionary *)pointDic[[self.bundle stringByReplacingOccurrencesOfString:@"." withString:@""]];
        if (dic) {
            Angle = [dic[@"jiaodu"] doubleValue];
            DBResultModel model;
            NSData *lastData = dic[@"model"];
            [lastData getBytes:&model length:sizeof(DBResultModel)];
            MKMapPoint q;
            q.x = model.x;
            q.y = model.y;
            CLLocationCoordinate2D c;
            c = MKCoordinateForMapPoint(q);
            CLLocationCoordinate2D  c1 =[[FireToGps sharedIntances]hhTrans_bdGPS:c];
            
            item.coordinate = c1;
            customView.transform = CGAffineTransformMakeRotation(M_PI*Angle/180);
            LongLab.text =[NSString stringWithFormat:@"当前经度:%f",model.longtitude];
            LatLab.text =[NSString stringWithFormat:@"当前纬度:%f",model.latitude];
            [_mapView setCenterCoordinate:c1];
        }
    }
}
-(void)change:(NSNotification *)notification
{
    aSingle   =1;
    NSDictionary *dic = (NSDictionary *)notification.object;
    if (dic) {
        Angle = [dic[@"jiaodu"] doubleValue];
        if ([dic[@"boundle"] isEqualToString:self.bundle]) {
            NSLog(@"%@",[NSThread currentThread]);
            DBResultModel model;
            NSData *lastData = dic[@"model"];
            [lastData getBytes:&model length:sizeof(DBResultModel)];
            MKMapPoint q;
            q.x = model.x;
            q.y = model.y;
            CLLocationCoordinate2D c;
            c = MKCoordinateForMapPoint(q);
            CLLocationCoordinate2D  c1 =[[FireToGps sharedIntances]hhTrans_bdGPS:c];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                item.coordinate = c1;
                customView.transform = CGAffineTransformMakeRotation(M_PI*Angle/180);
                LongLab.text =[NSString stringWithFormat:@"当前经度:%f",model.longtitude];
                LatLab.text =[NSString stringWithFormat:@"当前纬度:%f",model.latitude];
                [_mapView setCenterCoordinate:c1];
            });
        }
    }
}
//gps转换为百度坐标
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps
{
    CLLocationCoordinate2D bdGps;
    long double huo_x=fireGps.longitude;
    long double huo_y=fireGps.latitude;
    long double z = (long double)sqrt(huo_x * huo_x + huo_y * huo_y) +(long double) 0.00002 * sin(huo_y * x_pi);
    long double theta =(long double) atan2(huo_y, huo_x) +(long double) 0.000003 * cos(huo_x * x_pi);
    bdGps.longitude = z * cos(theta) + 0.0065;
    bdGps.latitude = z * sin(theta) + 0.006;
    return bdGps;
}
//地图
-(void)makeUI
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"default_feedback_icon_blue_delete_normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(DelButtonClick)];
    self.navigationItem.rightBarButtonItem = item1;
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-110)];
    [self.view addSubview:_mapView];
    _mapView.delegate=self;
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-110, self.view.frame.size.width, 110)];
    AppNameLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, (self.view.frame.size.width -10)/2, (downView.frame.size.height-20)/3)];
    AppNameLab.text =[NSString stringWithFormat:@"当前应用: %@",self.appName];
    AppNameLab.font = [UIFont systemFontOfSize:13];
    [downView addSubview:AppNameLab];
    
    typeLab  = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, (self.view.frame.size.width -10)/2, (downView.frame.size.height-20)/3)];
    typeLab.font =[UIFont systemFontOfSize:13];
    if ([self.typeShowLine intValue]==0) {
        typeLab.text = @"扫街方式: 步行";
    }
    else if ([self.typeShowLine intValue]==1)
    {
        typeLab.text = @"扫街方式: 驾车";
    }
    else
    {
        typeLab.text = @"扫街方式: 飞机";
    }
    [downView addSubview:typeLab];
    
    LongLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width -10)/2+5, 5, (self.view.frame.size.width -10)/2, (downView.frame.size.height-20)/3)];
    LongLab.text = @"当前经度:";
    LongLab.font = [UIFont systemFontOfSize:13];
    [downView addSubview:LongLab];
    
    LatLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width -10)/2+5, 40, (self.view.frame.size.width -10)/2, (downView.frame.size.height-20)/3)];
    LatLab.text = @"当前纬度:";
    LatLab.font = [UIFont systemFontOfSize:13];
    [downView addSubview:LatLab];
    [self.view addSubview:downView];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button1.tag = 7000;
    [_button1 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button1.frame = CGRectMake(10, 75, self.view.frame.size.width / 2 , 35);
    UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_feedback_btn_write.png"]];
    imageView1.frame = CGRectMake(0, 0, 30, 30);
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.view.frame.size.width/2 - 40, 30)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"修改配置";
    [_button1 addSubview:label1];
    [_button1 addSubview:imageView1];
    [downView addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button2.tag = 7001;
    [_button2 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
    _button2.frame = CGRectMake(self.view.frame.size.width/2+10, 75, self.view.frame.size.width / 2, 50);
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang1.png"]];
    imageView2.frame = CGRectMake(0, 0, 30, 30);
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.view.frame.size.width/2 - 40, 30)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"添加收藏";
    [_button2 setShowsTouchWhenHighlighted:NO];
    [_button2 addSubview:label2];
    [_button2 addSubview:imageView2];
    [downView addSubview:_button2];
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.tag = 8002;
    _btn3.frame = CGRectMake(5,self.view.frame.size.height-170, 72*0.8, 46*0.8);
    if (isStop ==0) {
        //
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"ks.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"zt.png"] forState:UIControlStateNormal];
    };
    [_btn3 addTarget:self action:@selector(stopOrstartScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
}
//此为暂停或者开始操作
-(void)stopOrstartScan
{
    if (self.ztOnShowLine == 0) {
        [KGStatusBar showWithStatus:@"扫街未开始,请开启扫街"];
    }else
    {
        isStop = !isStop;
        if (isStop ==0) {
            //
            [_btn3 setBackgroundImage:[UIImage imageNamed:@"ks.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btn3 setBackgroundImage:[UIImage imageNamed:@"zt.png"] forState:UIControlStateNormal];
        }
        NSDictionary *dic = @{@"isStop":[NSNumber numberWithInt:isStop],@"bundle":self.bundle};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:dic];
    }
    
}
-(void)segClick:(UIButton *)sender
{
    if (sender.tag == 7000) {
        //修改配置
        int exist =0;
        for(SimpleOperation *op in self.queue.operations)
        {
            NSLog(@"%@",op.whichSingle);
            if ([self.bundle isEqualToString:op.whichSingle]) {
                exist ++;
            }
        }
        if (exist>0) {
            [KGStatusBar showWithStatus:@"正在扫街,不能修改配置"];
        }
        else
        {
            TotleScanViewController *type = [[TotleScanViewController alloc]init];
            NSLog(@"bundle is :%@",self.bundle);
            type.boundle = self.bundle;
            type.delegate = self;
            for(UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[TravelStreetViewController class]]) {
                    TravelStreetViewController *tr = (TravelStreetViewController *)controller;
                    type.delegate = tr;
                }
            }
            type.isShowLine = 1;
            [self.navigationController pushViewController:type animated:YES];
        }
    }
    else
    {
        if (![curApp isEqualToString:self.bundle]) {
        //添加收藏
            MySaveDataManager *manager = [MySaveDataManager shareInatance];
            if (![manager chargeListInDB])
            {
                [manager creatTabel];
            }
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
            NSString *dateTime = [formate stringFromDate:[NSDate date]];
            NSLog(@"%@",dateTime);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[[DataBaseManager shareInatance] getPotionsFrom:self.bundle] copy]];
            [manager saveFileRecordwithPotions:arr withDate:dateTime];
            curApp = self.bundle;
        }
        else
        {
            [KGStatusBar showWithStatus:@"请勿重复收藏"];
        }
    }
}
//点击开始
-(void)click
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animationMove) userInfo:nil repeats:YES];
}
-(void)DelButtonClick
{
    int exist =0;
    NSLog(@"%@",self.queue.operations);
    for(SimpleOperation *op in self.queue.operations)
    {
        NSLog(@"%@",op.whichSingle);
        if ([self.bundle isEqualToString:op.whichSingle]) {
            op.IsDel = 1;
            [op cancel];
            exist ++;
        }
    }
    //删除当前路线
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    MapTypeDataManager *mapManager = [MapTypeDataManager shareInatance];
    [[TXYConfig sharedConfig]stopScanStreetWithBundleId:self.bundle];
    if ([dataManager deleteCurrentLines:self.bundle]&&[mapManager deleteMapTypeWithBundle:self.bundle]) {
        NSLog(@"删除成功");
        [((TotleShowLineViewController *)self.parentViewController)delDelegate:self.bundle];
    }
    else
    {
        [KGStatusBar showWithStatus:@"删除失败"];
        NSLog(@"删除失败");
    }

}
-(void)animationMove
{
    BMKPointAnnotation *item1 = [[BMKPointAnnotation alloc]init];
    dispatch_async(concurrentQueue, ^(){
        for (int i =0; i <dataLine.count; i++) {
            XuandianModel *model  = dataLine[i];
            CLLocationCoordinate2D c;
            c.longitude = model.longtitude;
            c.latitude = model.latitude;
            //NSLog(@"%f   %f    %d",model.latitude,model.longtitude,i);
            item1.coordinate = c;
            NSLog(@"即将描绘");
            //[lock lock];
            if (i<dataLine.count -1) {
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"开始描绘");
                [_mapView removeAnnotations:[_mapView annotations]];
                [_mapView addAnnotation:item1];
            });
            //[lock unlock];
            [NSThread sleepForTimeInterval:model.waiteSeconds==0?1.5:model.waiteSeconds];
        }
    });
}
//大头针的代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (aSingle ==10) {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            if (start == 10) {
                newAnnotationView.image = [UIImage imageNamed:@"start"];
            }
            else  {
                newAnnotationView.image = [UIImage imageNamed:@"end"];
            }
            return newAnnotationView;
        }
    }
    else
    {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
            newAnnotationView.image = nil;
            UIImage *img = nil;
            if ([self.typeShowLine intValue]==0) {
                //步行
                img=[UIImage imageNamed:@"people.png"];
                newAnnotationView.image = img;
                return newAnnotationView;
            }
            else if([self.typeShowLine intValue]==1)
            {
                //汽车
                img=[UIImage imageNamed:@"drive.png"];
            }
            else
            {
                //飞机
                img=[UIImage imageNamed:@"aeroplane.png"];
            }
            customView = [[UIImageView alloc]initWithFrame:CGRectMake(-img.size.height/2,-img.size.width/4, 40, 40)];
            customView.image = img;
            [newAnnotationView addSubview:customView];
            return newAnnotationView;
        }
    }
    return nil;
}
//得到数据
-(void)getModel
{
    //经纬度:116.390840, 39.784183
    // item = [[BMKPointAnnotation alloc]init];
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    dataLine =  [[dataManager getLinesFrom:self.bundle] copy];
    NSLog(@"%lu",(unsigned long)dataLine.count);
    
    
    BMKMapPoint *temppoints = new BMKMapPoint[dataLine.count];
    //XuandianModel *model = dataLine[]
    for(int i = 0;i <dataLine.count;i++)
    {
        NSData *lastData  = dataLine[i];
        DBResultModel model;
        [lastData getBytes:&model length:sizeof(DBResultModel)];
        CLLocationCoordinate2D c;
        c.longitude = model.longtitude;
        c.latitude = model.latitude;
        if(i==0){
            BMKPointAnnotation  *Sitem = [[BMKPointAnnotation alloc]init];
            Sitem.coordinate = c;
            start = 10;
            [_mapView addAnnotation:Sitem];
        }else if(i==dataLine.count-1){
            BMKPointAnnotation  *Eitem = [[BMKPointAnnotation alloc]init];
            Eitem.coordinate = c;
            start = 11;
            [_mapView addAnnotation:Eitem];
        }
        
        temppoints[i] = BMKMapPointForCoordinate(c);
    }
    
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:dataLine.count];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(change:) name:@"change" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"change" object:nil];
    self.tabBarController.tabBar.hidden = NO;
    _mapView.delegate = nil;
    _mapView = nil;
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
