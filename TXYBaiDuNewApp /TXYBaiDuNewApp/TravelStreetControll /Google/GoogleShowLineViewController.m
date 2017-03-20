//
//  GoogleShowLineViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/9/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleShowLineViewController.h"
#import "DataBaseManager.h"
#import "XuandianModel.h"
#import "TXYConfig.h"
#import "TXYTools.h"
#import "SimpleOperation.h"
#import "MySaveDataManager.h"
#import "juhua.h"
#import "MyAlert.h"
#import "ProgressHUD.h"
#import "TotleScanViewController.h"
#import "TotleShowLineViewController.h"
#import "MapTypeDataManager.h"
#import "TravelStreetViewController.h"
#import "TXYGoogleService.h"
#import "GoogleAnnotationView.h"
#import "GoogleAnnotation.h"
#import "TXYGeocoderService.h"
#import "GoogleMapViewUtil.h"
#import "GoogleMapTileUtil.h"
#import "FireToGps.h"
#import "GoogleTravelAnnotation.h"
#import "ScanPointManager.h"
@interface GoogleShowLineViewController ()
{
    GoogleMapScrollView *mapView;
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
    UIImageView *customView;
    int aSingle;
    int start;
    //记录当前位置
    CLLocationCoordinate2D curLocation;
    //进来时定位到扫街位置
    BOOL                 isEnterLocationCenter;
    
    UIButton                *nowButton;
    ScanPointManager *manager;
    //记录开始或者暂停
    int isStop;
}
@property (nonatomic,strong) GoogleTravelAnnotation       *annotation;
@end

@implementation GoogleShowLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.isCycle);
    dataLine = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    aSingle = 10;
    start = 10;
    isStop = self.Stop;
    curApp = nil;
    [self getModel];
    self.annotation = [[GoogleTravelAnnotation alloc] initWithTravelView];
    customView = [[UIImageView alloc]initWithFrame:CGRectMake(0,20, 40, 40)];
    if ([self.typeShowLine integerValue]==0) {
        customView.image = [UIImage imageNamed:@"people.png"];
    }
    else if ([self.typeShowLine integerValue]==1) {
        customView.image = [UIImage imageNamed:@"drive.png"];
    }
    else
    {
        customView.image = [UIImage imageNamed:@"aeroplane.png"];
    }
    [self.annotation.annotationView addSubview:customView];
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
            NSLog(@"%@",[NSThread currentThread]);
            DBResultModel model;
            NSData *lastData = dic[@"model"];
            [lastData getBytes:&model length:sizeof(DBResultModel)];
            MKMapPoint q;
            q.x = model.x;
            q.y = model.y;
            CLLocationCoordinate2D c1;
            c1 = MKCoordinateForMapPoint(q);
            CLLocationCoordinate2D c = [[FireToGps sharedIntances]gcj02Decrypt:c1.latitude gjLon:c1.longitude];
            nowButton.hidden = NO;
            self.annotation.coordinate = c;
            curLocation = c;
            self.annotation.annotationTitle = nil;
            if ([self.typeShowLine intValue]==0) {
                
            }else{
                customView.transform = CGAffineTransformMakeRotation(M_PI*Angle/180);
            }
            LongLab.text =[NSString stringWithFormat:@"当前经度:%f",model.longtitude];
            LatLab.text =[NSString stringWithFormat:@"当前纬度:%f",model.latitude];
            if (!isEnterLocationCenter) {
                isEnterLocationCenter = YES;
                [mapView addMapTravelAnnotation:self.annotation];
                [mapView setMapCenter:c animated:YES];
            }
        }
    }
}
//地图
-(void)makeUI
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"default_feedback_icon_blue_delete_normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(DelButtonClick)];
    self.navigationItem.rightBarButtonItem = item1;
    
    mapView = [[TXYGoogleService mapManager] getMapScrollView];
    [self.view addSubview:mapView];
    
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-110, self.view.frame.size.width, 110)];
    AppNameLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, (self.view.frame.size.width -10)/2, (downView.frame.size.height-20)/3)];
    AppNameLab.text =[NSString stringWithFormat:@"当前应用: %@",self.appName];
    AppNameLab.font = [UIFont systemFontOfSize:13];
    downView.backgroundColor = [UIColor whiteColor];
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
    
    nowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nowButton setBackgroundImage:[UIImage imageNamed:@"map_icon_location@3x.png"] forState:UIControlStateNormal];
    [nowButton addTarget:self action:@selector(dangqian) forControlEvents:UIControlEventTouchUpInside];
    nowButton.frame = CGRectMake(5, Height - 160, 50, 50);
    [self.view addSubview:nowButton];
    nowButton.hidden = YES;
    
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
    //_btn3.hidden = YES;
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
//跳转当前位置
-(void)dangqian{
    if (curLocation.latitude!=0) {
       [mapView setMapCenter:curLocation animated:YES];
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
            CLLocationCoordinate2D c1;
            c1 = MKCoordinateForMapPoint(q);
            CLLocationCoordinate2D c = [[FireToGps sharedIntances]gcj02Decrypt:c1.latitude gjLon:c1.longitude];
            dispatch_sync(dispatch_get_main_queue(), ^{
                nowButton.hidden = NO;
                self.annotation.coordinate = c;
                curLocation = c;
                self.annotation.annotationTitle = nil;
                if ([self.typeShowLine intValue]==0) {
                }else{
                    customView.transform = CGAffineTransformMakeRotation(M_PI*Angle/180);
                }
                LongLab.text =[NSString stringWithFormat:@"当前经度:%f",model.longtitude];
                LatLab.text =[NSString stringWithFormat:@"当前纬度:%f",model.latitude];
                if (!isEnterLocationCenter) {
                    isEnterLocationCenter = YES;
                    [mapView addMapTravelAnnotation:self.annotation];
                    [mapView setMapCenter:c animated:YES];
                }
//                [mapView setMapCenter:c animated:YES];
            });
        }
    }
}
-(void)getModel
{
    //经纬度:116.390840, 39.784183
    // item = [[BMKPointAnnotation alloc]init];
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    dataLine =  [[dataManager getLinesFrom:self.bundle] copy];
    NSLog(@"%lu",(unsigned long)dataLine.count);
    
    int a = dataLine.count;
    CLLocationCoordinate2D *tempCll = malloc(a*sizeof(CLLocationCoordinate2D));
    //XuandianModel *model = dataLine[]
    for(int i = 0;i <dataLine.count;i++)
    {
        NSData *lastData  = dataLine[i];
        DBResultModel model;
        [lastData getBytes:&model length:sizeof(DBResultModel)];
        CLLocationCoordinate2D c;
        c .latitude  = model.latitude;
        c.longitude = model.longtitude;
        if(i==0){
            [mapView setMapCenter:c animated:YES];
            GoogleTravelAnnotation *startAnnotation = [[GoogleTravelAnnotation alloc] init];
            startAnnotation.annotationTitle = nil;
            startAnnotation.annotationImageName = @"scanStart";
            startAnnotation.coordinate = c;
            [mapView addMapTravelAnnotation:startAnnotation];
        }else if(i==dataLine.count-1){
            GoogleTravelAnnotation *endAnnotation = [[GoogleTravelAnnotation alloc] init];
            endAnnotation.annotationTitle = nil;
            endAnnotation.annotationImageName = @"scanEnd";
            endAnnotation.coordinate = c;
            [mapView addMapTravelAnnotation:endAnnotation];
        }
        tempCll[i] = CLLocationCoordinate2DMake(c.latitude, c.longitude);
        NSValue *valuep = [NSValue value:&tempCll[i] withObjCType:@encode(CLLocationCoordinate2D)];
        [[TXYGoogleService mapManager] addMapLineCoordinateValue:valuep];
    }
//    [[TXYGoogleService mapManager] showMapLine];
    tempCll = nil;
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
            for(UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[TravelStreetViewController class]]) {
                    TravelStreetViewController *tr = (TravelStreetViewController *)controller;
                    type.delegate = tr;
                }
            }
            type.isShowLine =1;
            [self.navigationController pushViewController:type animated:YES];
        }
    }
    else
    {
        if (![curApp isEqualToString:self.bundle]) {
            //添加收藏
            MySaveDataManager *manager1 = [MySaveDataManager shareInatance];
            if (![manager1 chargeListInDB])
            {
                [manager1 creatTabel];
            }
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
            NSString *dateTime = [formate stringFromDate:[NSDate date]];
            NSLog(@"%@",dateTime);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[[DataBaseManager shareInatance] getPotionsFrom:self.bundle] copy]];
            [manager1 saveFileRecordwithPotions:arr withDate:dateTime];
            curApp = self.bundle;
        }
        else
        {
            [KGStatusBar showWithStatus:@"请勿重复收藏"];
        }
    }
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
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(change:) name:@"change" object:nil];
    isEnterLocationCenter = NO;
    [mapView removeAllAnnotations];
    [[TXYGoogleService mapManager] showMapLine];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"change" object:nil];
    self.tabBarController.tabBar.hidden = NO;
    [[[TXYGoogleService mapManager] getMapScrollView] removeAllTravelAnnotations];
    [[TXYGoogleService mapManager] removeMapLineInfos];
    [[TXYGoogleService mapManager] dismissLine];
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
