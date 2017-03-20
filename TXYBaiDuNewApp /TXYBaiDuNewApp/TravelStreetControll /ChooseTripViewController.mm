//
//  ChooseTripViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ChooseTripViewController.h"
#import "XuandianTableViewCell.h"
#import "SearchViewController.h"
#import "XuandianModel.h"
#import "SaojieMapViewController.h"
#import "SaojieLuxianViewController.h"
#import "AFNetworking.h"
#import "TXYTools.h"
#import "DataBaseManager.h"
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define Height ([UIScreen mainScreen].bounds.size.height)
#define Width ([UIScreen mainScreen].bounds.size.width)

@interface ChooseTripViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,BMKRouteSearchDelegate>{
    
    BMKRouteSearch *_search;
    int planPointCounts;
    int num;//行数的变量
    NSMutableArray *temppointsA;
    //规划的点的数量
    int temPointsNum;
    //当没有线路的时候  第一个点的选择  需要线记录第一个点的时间
    int firstSeconds;
    //记录一下修改后等待的时间
    int seconds;
}

@property (nonatomic,strong)UIView* backView;
//时
@property (nonatomic,strong)NSMutableArray* arr1;
//分
@property (nonatomic,strong)NSMutableArray* arr2;
//秒
@property (nonatomic,strong)NSMutableArray* arr3;

@property (nonatomic,strong)UISegmentedControl* sc;

@property (nonatomic,strong)UITableView* table;
//增
@property (nonatomic,strong)UIButton* addBtn;

//删
@property (nonatomic,strong)UIButton* delBtn;
//换
@property (nonatomic,strong)UIButton* echangeBtn;


//左边顶栏按钮
@property (nonatomic,strong)UIBarButtonItem *leftItem;

//右边顶栏按钮
@property (nonatomic,strong)UIBarButtonItem *rightItem;



@property(nonatomic,retain)NSMutableArray *dataArr;


//设置位置view
@property (nonatomic, strong) UIView* btnView;

@property (nonatomic,strong)UIPickerView* pickView;
@property (nonatomic,strong)UIView* downView;
@property (nonatomic,copy)NSString* time;


@end

@implementation ChooseTripViewController
@synthesize pointArr,linesArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    temppointsA = [NSMutableArray arrayWithCapacity:0];
    pointArr = [NSMutableArray arrayWithCapacity:0];
    linesArr = [NSMutableArray arrayWithCapacity:0];
    //[linesArr removeAllObjects];
    [pointArr removeAllObjects];
    [self makeView];
    
}
- (void)makeView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _rightItem = [[UIBarButtonItem alloc]initWithTitle:CustomLocalizedString(@"确定",nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = _rightItem;
    self.title = CustomLocalizedString(@"扫街路线",nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:CustomLocalizedString(@"请选择出行方式", nil)
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:CustomLocalizedString(@"步行",nil),CustomLocalizedString(@"汽车",nil) ,CustomLocalizedString(@"飞机",nil),nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self.view]) {
        [actionSheet showInView:self.view];
    } else {
        [actionSheet showInView:window];
    }
    
    //实例化数据源
    self.dataArr = [[NSMutableArray alloc]init];
    
    for(int i =0;i<2;i++)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"" forKey:@"weizhi"];
        [dict setObject:@"" forKey:@"time"];
        [dict setObject:@"" forKey:@"juli"];
        [dict setObject:@"" forKey:@"location"];
        [self.dataArr addObject:dict];
        
    }
    num = 20;
    
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _delBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //创建table
    if (!iOS7) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width , Height-44-20) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tag = 6666;
        _table.rowHeight = 90;
        [self.view addSubview:_table];
        _addBtn.frame = CGRectMake(Width-30, 100, 30, 44);
        _delBtn.frame = CGRectMake(Width-30, 150 , 30, 44);
    }else{
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, Width , Height - 64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tag = 6666;
        _table.rowHeight = 90;
        [self.view addSubview:_table];
        _addBtn.frame = CGRectMake(Width-30, 120, 30, 44);
        _delBtn.frame = CGRectMake(Width-30, 170 , 30, 44);
    }
    [_addBtn setTitle:CustomLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    
    
    
    [_delBtn setTitle:CustomLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    
    _delBtn.hidden = YES;
    
    [self.view addSubview:_delBtn];
    
    //pickview
    _arr1 = [NSMutableArray arrayWithCapacity:0];
    _arr2 = [NSMutableArray arrayWithCapacity:0];
    _arr3 = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i < 24; i ++) {
        [_arr1 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    
    for (NSInteger i = 0; i < 60; i ++) {
        [_arr2 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    for (NSInteger i = 0; i < 60; i ++) {
        [_arr3 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, Height + Height / 3, Width, Height / 3)];
    
    _backView = [[UIView alloc]init];
    _backView.frame = self.view.bounds;
    _backView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_backView addGestureRecognizer:tap];
    
    
    [self.view addSubview:_downView];
    
    _downView.backgroundColor = [UIColor lightGrayColor];
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 30)];
    [_downView addSubview:btnView];
    //取消按钮
    UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0, 0, 50, 30);
    [leftBtn setTitle:CustomLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:leftBtn];
    //确定按钮
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(Width - 50, 0, 50, 30);
    [rightBtn setTitle:CustomLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:rightBtn];
    //中间lab标示
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, Width - 100, 30)];
    lab.tag = 1000;
    lab.text = CustomLocalizedString(@"驻留时间:", nil);
    lab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:lab];
    //初始坐标
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, Width, Height / 3)];
    [_downView addSubview:self.pickView];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    }

- (void)tapClick{
    _backView.hidden = YES;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height + Height / 3, Width, Height / 3)];
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark UIPICKVIEW CUSTOM FUNTION
//pickview左边

- (void)leftBtn{
    _backView.hidden = YES;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height + Height / 3, Width, Height / 3)];
    [UIView commitAnimations];
}

//pickview右边
- (void)rightBtn:(UIButton *)sender{
 
     _backView.hidden = YES;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height + Height / 3, Width, Height / 3)];
    [UIView commitAnimations];
    NSLog(@"%ld",(long)sender.superview.superview.tag);
    NSMutableDictionary* dict = _dataArr[sender.superview.superview.tag - 2000];
    [dict setObject:_time forKey:@"time"];
    CLLocation *selectLocation  = dict[@"location"];
    if (linesArr.count >0) {
        if (firstSeconds !=0) {
            XuandianModel *model = linesArr[0];
            model.waiteSeconds = firstSeconds;
        }
        for(int i = 0;i <linesArr.count;i++)
        {
            XuandianModel *model = linesArr[i];
            if (model.index == sender.superview.superview.tag-2001 && selectLocation.coordinate.latitude == model.latitude) {
                model.waiteSeconds = seconds;
                return;
            }
        }
    }
    [_table reloadData];
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
        UIView *view0,*view1,*view2;
        NSInteger row0,row1,row2;
        row0 = [_pickView selectedRowInComponent:0];
        row1 = [_pickView selectedRowInComponent:1];
        row2 = [_pickView selectedRowInComponent:2];
    
        view0 = [_pickView viewForRow:row0 forComponent:0];
        view1 = [_pickView viewForRow:row1 forComponent:1];
        view2 = [_pickView viewForRow:row2 forComponent:2];
    
        UILabel *label1,*label2,*label0;
        label0 =(UILabel *)[view0 viewWithTag:200];
        label1 =(UILabel *)[view1 viewWithTag:200];
        label2 =(UILabel *)[view2 viewWithTag:200];
        
    _time = [NSString stringWithFormat:@"%@%@%@",label0.text,label1.text,label2.text];
    if (pickerView.superview.tag - 2000 ==0) {
        firstSeconds = [label0.text intValue]*3600 +[label1.text intValue]*60 + [label2.text intValue];
    }
    else
    {
        seconds  = [label0.text intValue]*3600 +[label1.text intValue]*60 + [label2.text intValue];
    }
}


//返回一共几列的值
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
        return 3;
}
//返回每列具体多少行
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        if(component==0)
        {
            return [_arr1 count];}
        else if(component==1)
        {
            return [_arr2 count];
            
        }
        else if(component ==2)
        {
            return [_arr3 count];
        }
    return -1;
}
//返回三列各列宽度
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
        if(component==0)
        {
            return 90.0f;}
        else if(component==1)
        {
            return 90.0f;
            
        }
        else if(component ==2)
        {
            return 90.0f;
        }
       return 0.0f;
}
//返回row高度
-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60.0f;
}
//可以理解为自定义的view内容
-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
        CGFloat width = [self pickerView:_pickView widthForComponent:component];
        CGFloat rowheight =[self pickerView:_pickView rowHeightForComponent:(component)];
        
        UIView *myView = [[UIView alloc]init];
        myView.frame =CGRectMake(0.0f, 0.0f, width, rowheight);
        UILabel *txtlabel = [[UILabel alloc] init];
        txtlabel.tag=200;
        txtlabel.frame = myView.frame;
        
        [myView addSubview:txtlabel];
        if(component== 0)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr1 objectAtIndex:row],CustomLocalizedString(@"时", nil)];
        }
        else if(component==1)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr2 objectAtIndex:row],CustomLocalizedString(@"分", nil)];
        }
        else if(component==2)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr3 objectAtIndex:row],CustomLocalizedString(@"秒", nil)];
        }
        
        return myView;
        return nil;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height + Height /3, Width, Height / 3)];
    [UIView commitAnimations];
}

//动画效果
-(void)animationCuston:(int)tag
{
    _backView.hidden = NO;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    _downView.tag=tag + 2000;
    [_downView setFrame:CGRectMake(0, Height - Height / 2, Width, Height /2 )];
    [UIView commitAnimations];
}
//返回按钮
- (void)buttonClick{
    SearchViewController* schvc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:schvc animated:YES];
}


//删除
-(void)del
{
    [self.dataArr removeLastObject];
    for(XuandianModel *model in linesArr)
    {
        if (model.index == self.dataArr.count -1) {
            [linesArr removeObject:model];
        }
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataArr.count  inSection:0];
    [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
    [_table reloadData];
    
    if (self.dataArr.count == 2) {
        self.delBtn.hidden = YES;
    }
}
//添加
-(void)addDown
{
    //可变数组，insert atindex：indexpath.row
    _delBtn.hidden = NO;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"" forKey:@"weizhi"];
    [dict setObject:@"" forKey:@"time"];
    [dict setObject:@"" forKey:@"juli"];
    [dict setObject:@"" forKey:@"location"];
    [self.dataArr addObject:dict];
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataArr.count -1 inSection:0];
    [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
    //刷新table
    [_table reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"11");
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XuandianTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XuandianTableViewCell" owner:self options:nil]lastObject];

    }
    NSMutableDictionary* dict = _dataArr[indexPath.row];
    if (dict[@"time"]) {
        cell.Lab3.text = [NSString stringWithFormat:@"%@:%@",CustomLocalizedString(@"时间", nil),dict[@"time"]];
        
    }else{
    cell.Lab3.text = [NSString stringWithFormat:@"%@: ",CustomLocalizedString(@"时间", nil)];
    }
    if (dict[@"juli"]) {
        cell.Lab4.text = [NSString stringWithFormat:@"%@:%@",CustomLocalizedString(@"距离", nil),dict[@"juli"]];
        
    }else{
    cell.Lab4.text = [NSString stringWithFormat:@"%@: ",CustomLocalizedString(@"距离", nil)];
    }
    if (dict[@"weizhi"]) {
        cell.Lab2.text = [NSString stringWithFormat:@"%@:%@",CustomLocalizedString(@"位置", nil),dict[@"weizhi"]];
    }else{
        cell.Lab2.text = [NSString stringWithFormat:@"%@:",CustomLocalizedString(@"位置", nil)];
    }
    
    UIButton* Zhuliu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Zhuliu.tag=indexPath.row;
    Zhuliu.frame = CGRectMake(22, 59, 102, 20);
    [Zhuliu setTitle:CustomLocalizedString(@"修改驻留时间", nil) forState:UIControlStateNormal];
    
    [cell addSubview:Zhuliu];
    [Zhuliu addTarget:self action:@selector(zhuliu:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//驻留时间
-(void)zhuliu:(UIButton *)btn{
    [self animationCuston: (int)btn.tag];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchViewController* schvc = [[SearchViewController alloc]init];
    schvc.index = indexPath.row;
    [self.navigationController pushViewController:schvc animated:YES];
}

#pragma mark - 出行方式
//返回
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma saveline   保存路线
//确定
- (void)rightButtonClick{
    //保存路线
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    if (linesArr.count >0) {
        [dataManager creatTabel];
        //[dataManager saveFileRecordWithModel:self.boundle withNsarry:linesArr withType:[NSString stringWithFormat:@"%ld",(long)self.index]];
    }
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
////action 的代理方法
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"%ld",(long)buttonIndex);
//    if (buttonIndex==0) {
//        //步行
//        self.index = 0;
//        self.title = @"步行扫街路线";
//    }
//    if (buttonIndex == 1) {
//        //汽车
//        self.index = 1;
//        self.title = @"汽车扫街路线";
//    }
//    if (buttonIndex == 2) {
//        //飞机
//        self.index = 2;
//        self.title = @"飞机扫街路线";
//    }
//}
//实现代理方法
-(void)chuanzhi:(XuandianModel *)model
{
    NSMutableDictionary* dict = _dataArr[model.index];
    [dict setObject:model.time forKey:@"time"];
    [dict setObject:model.juli forKey:@"juli"];
    [dict setObject:model.weizhi forKey:@"weizhi"];
    [dict setObject:model.location forKey:@"location"];
    [_table reloadData];
    
    //在这里要进行算路
    [self getLine:model];
    
}
-(void)getLine:(XuandianModel *)model
{
    [pointArr addObject:model.location];
    NSLog(@"%lu",(unsigned long)self.dataArr.count);
    if (self.dataArr.count >1&&![_dataArr[self.dataArr.count -1][@"juli"] isEqualToString:@""]) {
        NSMutableDictionary* dict = _dataArr[self.dataArr.count -1];
        switch (self.index) {
            case 0|1:
                [self requestRoutWithSoure:((CLLocation*)dict[@"location"]).coordinate Destination:model.location.coordinate];
                break;
            case 2:
               // [self PlanLine];
            default:
                break;
        }
    }
    else
    {
        return;
    }
}
//百度定位坐标转换为gps坐标
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps
{
    CLLocationCoordinate2D googleGps;
    double bd_x=baiduGps.longitude - 0.0065;
    double bd_y=baiduGps.latitude - 0.006;
    double z = sqrt(bd_x * bd_x + bd_y * bd_y) - 0.00002 * sin(bd_y * x_pi);
    double theta = atan2(bd_y, bd_x) - 0.000003 * cos(bd_x * x_pi);
    googleGps.longitude = z * cos(theta);
    googleGps.latitude = z * sin(theta);
    return googleGps;
}
//gps转换为百度坐标
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps
{
    CLLocationCoordinate2D bdGps;
    double huo_x=fireGps.longitude;
    double huo_y=fireGps.latitude;
    double z = sqrt(huo_x * huo_x + huo_y * huo_y) + 0.00002 * sin(huo_y * x_pi);
    double theta = atan2(huo_y, huo_x) + 0.000003 * cos(huo_x * x_pi);
    bdGps.longitude = z * cos(theta) + 0.0065;
    bdGps.latitude = z * sin(theta) + 0.006;
    return bdGps;
}
-(void)requestRoutWithSoure:(CLLocationCoordinate2D) start2D  Destination:(CLLocationCoordinate2D)end2D
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    //驾车 MKDirectionsTransportTypeAutomobile    步行MKDirectionsTransportTypeWalking
    directionsRequest.transportType = self.index ==0?MKDirectionsTransportTypeWalking:MKDirectionsTransportTypeAutomobile;
    //导航设置
    CLLocationCoordinate2D fromcoor=CLLocationCoordinate2DMake([self hhTrans_GCGPS:start2D].latitude, [ self hhTrans_GCGPS:end2D].longitude);
    CLLocationCoordinate2D tocoor = CLLocationCoordinate2DMake(end2D.latitude, end2D.longitude);
    directionsRequest.requestsAlternateRoutes = YES;
    MKPlacemark *startMark = [[MKPlacemark    alloc] initWithCoordinate:fromcoor addressDictionary:nil];
    MKPlacemark *endMark = [[MKPlacemark    alloc] initWithCoordinate:tocoor addressDictionary:nil];
    
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMark];
    
    [directionsRequest setSource:startItem];
    [directionsRequest setDestination:endItem];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    //接收rout
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         NSLog(@"%@",[NSThread mainThread]);
         if (error) {
             NSLog(@"directions error:%@", error);
         }
         else {
             NSLog(@"%@",response.routes);
             MKRoute *route;
             route = response.routes[0];
             int size = route.steps.count;
             for(int k=0;k<size;k++){
                 MKRouteStep *r=route.steps[k];
                 MKPolyline *p=r.polyline;
                 NSLog(@"点数%lu",(unsigned long)p.pointCount);
                 temPointsNum += p.pointCount;
             }
             for(int k=0;k<size;k++){
                 MKRouteStep *r=route.steps[k];
                 MKPolyline *p=r.polyline;
                 MKMapPoint *point=[p points];
                 NSLog(@"点数%lu",(unsigned long)p.pointCount);
                 for(int i=0;i<p.pointCount;i++){
                     //得到百度坐标
                     CLLocationCoordinate2D touchMapCoordinate =[self hhTrans_bdGPS:MKCoordinateForMapPoint(point[i])];
                     XuandianModel *model = [[XuandianModel alloc]init];
                     model.latitude = touchMapCoordinate.latitude;
                     model.longtitude = touchMapCoordinate.longitude;
                     model.indexInStep = i;
                     model.whichstep = k;
                     model.thestepTotleNum = p.pointCount ;
                     model.totleStep = size;
                     if (i == p.pointCount -1) {
                         model.isWaitPoint = 1;
                         model.waiteSeconds = 10;
                     }
                     else
                     {
                         model.isWaitPoint = 0;
                         model.waiteSeconds = 0;
                     }
                     //第几次添加的点
                     model.index = self.index;
                     model.whichbundle = self.boundle;
                     [linesArr addObject:model];
                 }
             }
             NSLog(@"%lu",(unsigned long)linesArr.count);
         }
     }];
}
-(void)chuanLines:(NSArray *)arr
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self saveLine:linesArr andPoint:pointArr];
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
