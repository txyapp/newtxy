//
//  GoogleScanViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/9/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleScanViewController.h"
#import "TXYGoogleService.h"
#import "GoogleAnnotationView.h"
#import "GoogleAnnotation.h"
#import "TXYGeocoderService.h"
#import "GoogleMapViewUtil.h"
#import "FireToGps.h"
#import "TXYConfig.h"
#import "TXYTools.h"
#import "PopoverView.h"
#import "WebViewController.h"
#import "ZCNoneiFLYTEK.h"
#import "GoogleSearchViewController.h"
#import <mach-o/dyld.h>
#import "TXYTools.h"
#import "UMSocial.h"
#import "juHua.h"
#import "DataBaseManager.h"
#import "ScanNewTableViewCell.h"
#import "MapTypeDataManager.h"
#import "MyAlert.h"
#import "SearchViewController.h"
#import "TotleScanViewController.h"
#define BColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface GoogleScanViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    int mark;
    UIButton *saveB;
    //type图片方式
    UIImageView *typeView;
    UIView *view1,*view2;
    //速度
    int speed;
    //当前速度的比率和红绿灯的比率
    float howlong,howLongRed;
    UITableView *_table;
    NSMutableArray *_dataForTab;//table的数据源
    //点击的是哪个cell  cell的位置
    NSIndexPath *_path;
    UIView *_downView,*_backView;
    UIPickerView *_pickView;
    //时间
    NSString *_time;
    //时间选择器的数据源
    NSMutableArray *_arr1,*_arr2,*_arr3,*_valueArPLan;
    //存储用户选中点后修改该点等待时间的值
    NSMutableDictionary *dicTime;
    //地点提醒
    //UISwitch *onOrOff;
    juHua *jh;
    //算路次数控制;
    int single;
    int temPointsNum;
    //存储路线的数组   用户选择的点的集合
    NSMutableArray *_linesData,*_pointsData;
    //存数临时路线value
    NSMutableArray *_valueWalkORDrive;
    //自定义停留的时间
    int customWaiteTime;
    //总距离
    int sumDistance;
    NSMutableArray *newDataForTab;
}
@end

@implementation GoogleScanViewController
@synthesize redWaitSeconds,rate,isCycle,linesType,tripType,isState;
- (void)viewDidLoad {
    [super viewDidLoad];
    tripType = 0;
    sumDistance = 0;
    howlong = 0;
    mark = 0;
    single = 0;
    howLongRed =0;
    linesType = 0;
    isState = 1;
    temPointsNum = 0;
    rate = 1;
    speed = 10;
    isCycle = 0;
    redWaitSeconds = 0;
    _dataForTab = [NSMutableArray arrayWithCapacity:0];
    newDataForTab = [NSMutableArray arrayWithCapacity:0];
    _arr1 = [NSMutableArray arrayWithCapacity:0];
    _arr2 = [NSMutableArray arrayWithCapacity:0];
    _arr3 = [NSMutableArray arrayWithCapacity:0];
    dicTime = [NSMutableDictionary dictionaryWithCapacity:0];
    _valueArPLan = [NSMutableArray arrayWithCapacity:0];
    _linesData = [NSMutableArray arrayWithCapacity:0];
    _pointsData = [NSMutableArray arrayWithCapacity:0];
    _valueWalkORDrive = [NSMutableArray arrayWithCapacity:0];
    //布局
    [self makeUI];
    [self getDateForPick];
    jh=[[juHua alloc]init];
    [self getModelFromDB];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
//得到某个应用的点
-(void)getModelFromDB
{
    [_dataForTab removeAllObjects];
    ((UIButton *)[self.view viewWithTag:1002]).hidden = NO;
    NSLog(@"boundle is :%@",self.boundle);
    _dataForTab = [NSMutableArray arrayWithArray:[[DataBaseManager shareInatance] getPotionsFrom:self.boundle]];

    if (_dataForTab.count>0) {
        XuandianModel *model = _dataForTab[0];
        XuandianModel *lastModel  = _dataForTab[_dataForTab.count -1];
        isState = lastModel.isState;
        if (lastModel.isState ==1) {
            ((UISegmentedControl*)[self.view viewWithTag:2003]).selectedSegmentIndex = 0;
        }
        if (model.isCycle == 1) {
            ((UISegmentedControl*)[self.view viewWithTag:2003]).selectedSegmentIndex = 1;
        }
        if (lastModel.isState ==0 && model.isCycle==0) {
            ((UISegmentedControl*)[self.view viewWithTag:2003]).selectedSegmentIndex = 2;
        }
        isCycle = model.isCycle;
        if (model.redWaitSeconds !=0) {
            ((UILabel *)[self.view viewWithTag:4001]).text = [NSString stringWithFormat:@"%ds",model.redWaitSeconds];
            ((UISlider*)[self.view viewWithTag:3001]).value =model.redWaitSeconds;
            redWaitSeconds = model.redWaitSeconds;
            NSLog(@"%d",model.redWaitSeconds);
        }
        ((UILabel *)[self.view viewWithTag:4000]).text = [NSString stringWithFormat:@"%d km",lastModel.speed];
        speed = model.speed;
        
        int whitch = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        if (whitch ==0) {
            //（步行,驾车,飞机）
            ((UISlider*)[self.view viewWithTag:3000]).maximumValue = 20;((UISlider*)[self.view viewWithTag:3000]).minimumValue = 1;
            typeView.image = [UIImage imageNamed:@"buxing"];
        }
        if (whitch==1) {
            //红绿灯
            ((UISlider*)[self.view viewWithTag:3000]).maximumValue = 260;((UISlider*)[self.view viewWithTag:3000]).minimumValue = 30;
            typeView.image = [UIImage imageNamed:@"qiche"];
        }
        if (whitch==2){
            ((UISlider*)[self.view viewWithTag:3000]).maximumValue = 1400;((UISlider*)[self.view viewWithTag:3000]).minimumValue = 1;
            typeView.image = [UIImage imageNamed:@"plane"];
        }
        ((UISlider*)[self.view viewWithTag:3000]).value =lastModel.speed;
        NSLog(@"%@",[NSString stringWithFormat:@"%0.1f",model.ScanRate]);
        if ([[NSString stringWithFormat:@"%0.1f",model.ScanRate]  isEqualToString:@"0.3"]) {
            ((UISegmentedControl*)[self.view viewWithTag:2002]).selectedSegmentIndex = 0;
        }
        if ([[NSString stringWithFormat:@"%0.1f",model.ScanRate]  isEqualToString:@"0.6"]) {
            ((UISegmentedControl*)[self.view viewWithTag:2002]).selectedSegmentIndex = 1;
        }
        if ([[NSString stringWithFormat:@"%0.1f",model.ScanRate]  isEqualToString:@"1.0"]) {
            ((UISegmentedControl*)[self.view viewWithTag:2002]).selectedSegmentIndex = 2;
        }
        //int whitch = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        ((UISegmentedControl*)[self.view viewWithTag:1001]).selectedSegmentIndex = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        ((UISegmentedControl*)[self.view viewWithTag:2004]).selectedSegmentIndex = lastModel.linesType;
        if (whitch !=1) {
            ((UISegmentedControl*)[self.view viewWithTag:2004]).hidden = YES;
        }
        else
        {
            ((UISegmentedControl*)[self.view viewWithTag:2004]).hidden = NO;
        }
        tripType = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        if (tripType != 1) {
            [view1 setFrame:CGRectMake(0, -50, Width, 230)];
            [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
        }
        else
        {
            [view1 setFrame:CGRectMake(0, -50, Width, 270)];
            [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
        }
        for(XuandianModel *model in _dataForTab)
        {
            MKMapPoint point;
            point.x = model.x;
            point.y = model.y;
            
            CLLocationCoordinate2D c = [[FireToGps sharedIntances]gcj02Decrypt:MKCoordinateForMapPoint(point).latitude gjLon:MKCoordinateForMapPoint(point).longitude];;
            model.currentLocation = c;
        }
        [_table reloadData];
    }
    else
    {
        return;
    }
}
-(void)makeUI
{
    //隐藏nav
    self.view.backgroundColor = BColor(241, 241, 241);
    //table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0,165 + 64,Width,Height -(165 + 64))];
    _table.rowHeight = 134;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle =UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    //在这里写具体设置参数的Ui
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, -50, Width, 230)];
    view1.backgroundColor = IWColor(60, 170, 249);
    [self.view addSubview:view1];
    
    NSArray *titleArr = @[@"扫街速度:",@"等红绿灯:",@"扫街频率:",@"扫街完成:",@"规划方式:"];
    for(int i=0;i<titleArr.count;i++){
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + (30 + 10) *i, 62, 30)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.tag = 5000+i;
        lab.text = titleArr[i];
        [view1 addSubview:lab];
        if (i<2) {
            UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(82, 10 + (30 + 10) *i, 65, 30)];
            value.text = @"()";
            value.tag = 4000+i;
            if (i==0) {
                value.text = @"10km/h";
            }
            value.textColor = [UIColor whiteColor];
            value.font = [UIFont systemFontOfSize:13];
            [view1 addSubview:value];
            
            UISlider *sl = [[UISlider alloc]initWithFrame:CGRectMake(150, 10 + (30 + 10) *i + 7.5, Width - 155, 20)];
            sl.tag = 3000+i;
            [view1 addSubview:sl];
            
            if (i ==0) {
                //（步行,驾车,飞机）
                sl.maximumValue = 120;sl.minimumValue = 1;
            }
            if (i==1) {
                //红绿灯
                sl.maximumValue = 90;sl.minimumValue = 0;
            }
            if (i==2){
                sl.maximumValue = 1000;sl.minimumValue = 0;
            }
            if (i==3) {
                sl.maximumValue = 3;sl.minimumValue = 0;
            }
            [sl addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        }
        if (i<=4&&i>1) {
            NSArray *items = @[@[@"300ms",@"600ms",@"1000ms"],@[@"终点停留",@"循环",@"返回模拟"],@[@"短路程",@"避拥堵",@"短时间"]];
            UISegmentedControl *typeSeg = [[UISegmentedControl alloc]initWithItems:items[i-2]];
            typeSeg.frame = CGRectMake(100,(30 + 10) *i+9, Width-105, 30);
            typeSeg.selectedSegmentIndex = 0;
            typeSeg.tag = 2000+i;
            if (i==2) {
                typeSeg.selectedSegmentIndex = 2;
            }
            [typeSeg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:15],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
            [typeSeg setTitleTextAttributes:dic forState:UIControlStateNormal];
            typeSeg.tintColor = [UIColor whiteColor];
            [view1 addSubview:typeSeg];
        }
    }
    
    //保存设置按钮
    saveB = [UIButton buttonWithType:UIButtonTypeCustom];
    saveB.frame = CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30);
    [saveB setBackgroundColor:[UIColor whiteColor]];
    saveB.layer.masksToBounds = YES;
    saveB.layer.cornerRadius = 3;
    [saveB setTitle:@"保 存 设 置" forState:UIControlStateNormal];
    saveB.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveB addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:saveB];
    //UI
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 165 + 64)];
    view2.backgroundColor = IWColor(60, 170, 249);
    [self.view addSubview:view2];
    
    //
    //自定义stateView
    UIView *stateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    stateView.backgroundColor = IWColor(60, 170, 249);
    [view2 addSubview:stateView];
    //title
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-30, 25, 60, 30)];
    lab.text = @"扫街";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor whiteColor];
    [stateView addSubview:lab];
    //返回按钮
    UIButton *backB = [UIButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(5, 25, 40, 35);
    [backB setImage:[UIImage imageNamed:@"default_common_navibar_prev_normal@2x"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [stateView addSubview:backB];
    //确定算路按钮
    UIButton *sureB = [UIButton buttonWithType:UIButtonTypeCustom];
    sureB.frame = CGRectMake(Width - 50, 25, 40, 35);
    [sureB setTitle:@"确定" forState:UIControlStateNormal];
    [sureB addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [stateView addSubview:sureB];
    
    //
    //设置不同方式对应的图片(步行,驾车,飞机)
    typeView = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-37.5, 64+5, 65, 65)];
    //typeView.backgroundColor = [UIColor whiteColor];
    typeView.layer.masksToBounds = YES;
    typeView.layer.cornerRadius = 32.5;
    typeView.image = [UIImage imageNamed:@"buxing"];
    [view2 addSubview:typeView];
    
    //选择不同的算路方案
    NSArray *items = @[@"步 行",@"驾 车",@"飞 机"];
    UISegmentedControl *typeSeg = [[UISegmentedControl alloc]initWithItems:items];
    typeSeg.frame = CGRectMake(15, 64+85, Width-30, 32);
    typeSeg.selectedSegmentIndex = 0;
    typeSeg.tag = 1001;
    [typeSeg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    typeSeg.layer.borderColor = [UIColor whiteColor].CGColor;
    typeSeg.layer.borderWidth = 1;
    typeSeg.tintColor = [UIColor whiteColor];
    typeSeg.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:15],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [typeSeg setTitleTextAttributes:dic forState:UIControlStateNormal];
    typeSeg.layer.cornerRadius = 15;
    typeSeg.layer.masksToBounds = YES;
    [view2 addSubview:typeSeg];
    //扫街参数 路线添加
    NSArray *items1 = @[@"扫 街 参 数",@"路 线 添 加"];
    UISegmentedControl *Seg = [[UISegmentedControl alloc]initWithItems:items1];
    Seg.frame = CGRectMake(15, 64+125, Width-30, 32);
    Seg.tag = 1002;
    [Seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    Seg.layer.borderColor = [UIColor whiteColor].CGColor;
    Seg.layer.borderWidth = 1;
    Seg.tintColor = [UIColor whiteColor];
    Seg.backgroundColor = [UIColor clearColor];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:15],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [Seg setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    Seg.layer.cornerRadius = 15;
    Seg.layer.masksToBounds = YES;
    [view2 addSubview:Seg];
}
#pragma tableDlegate
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row!=0 && indexPath.row !=_dataForTab.count-1) {
            XuandianModel *one = _dataForTab[indexPath.row-1];
            XuandianModel *two = _dataForTab[indexPath.row+1];
            MKMapPoint po1 = MKMapPointForCoordinate(one.currentLocation);
            MKMapPoint po2 = MKMapPointForCoordinate(two.currentLocation);
            int dis = MKMetersBetweenMapPoints(po1,po2);
            if (dis >1000) {
                dis = dis/1000;
                two.juli = [NSString stringWithFormat:@"%dkm",dis];
            }
            else
            {
                two.juli = [NSString stringWithFormat:@"%dm",dis];
            }
        }
        [_dataForTab removeObjectAtIndex:indexPath.row];
        [_table reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"11");
    return _dataForTab.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ScanNewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ScanNewTableViewCell" owner:self options:nil]lastObject];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    XuandianModel *model = _dataForTab[indexPath.row];
    cell.NumLab.text = [NSString stringWithFormat:@"%d",indexPath.row +1];
    cell.NumLab.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model.juli) {
        cell.destanceLab.text = [NSString stringWithFormat:@"%@",model.juli];
        
    }else{
        cell.destanceLab.text = @"0km";
    }
    if (model.weizhi) {
        cell.NamLab.text = model.weizhi;
    }else{
        cell.NamLab.text = @" ";
    }
    if (model.waitTime) {
        cell.waiteTimeLab.text = model.waitTime;
        NSArray *array = [model.waitTime componentsSeparatedByString:@":"];
        int time = 0;
        if (array.count == 3) {
            time = [array[0] intValue]*3600+[array[1] intValue]*60 + [array[2] intValue];
        }
        [dicTime setObject:[NSString stringWithFormat:@"%d",time] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    else
    {
        cell.waiteTimeLab.text = @"";
    }
    if (indexPath.row == _dataForTab.count -1) {
        UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 134 , Width, 0.5)];
        line0.backgroundColor = [UIColor grayColor];
        line0.alpha = 0.8;
        line0.tag = 9000+indexPath.row;
        [cell.contentView addSubview:line0];
    }
    else
    {
        for (UIView *l in cell.contentView.subviews) {
            if(l.tag == 9000+indexPath.row)
            {
                [l removeFromSuperview];
            }
        }
    }
    [cell.ChangeBtn addTarget:self action:@selector(changWaitTime:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchViewController *search = [[SearchViewController alloc]init];
    search.index = indexPath.row;
    NSMutableArray *mustArr = [NSMutableArray arrayWithCapacity:0];
    if (indexPath.row -1 >= 0) {
        [mustArr addObject:_dataForTab[indexPath.row -1]];
    }
    search.hadChoicePoints = mustArr;
    [self.navigationController pushViewController:search animated:YES];
}
//返回上一个页面
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
//确定开始算路
-(void)sure
{
    int sumDis = 0;
    for(XuandianModel *model in _dataForTab)
    {
        sumDis += [model.juli intValue];
    }
    NSLog(@"开始算路");
    //在此要算路 然后保存到数据库中
    if (_dataForTab.count >= 2) {
        [self caculerLine];
    }
}

//不同的选项seg点击事件
-(void)segClick:(UISegmentedControl *)seg
{
    UILabel *lab = (UILabel *)[self.view viewWithTag:5004];
    UISegmentedControl *sg1 = (UISegmentedControl *)[self.view viewWithTag:2004];
    UILabel *lab1 = (UILabel *)[self.view viewWithTag:4000];
    UISlider *csl = (UISlider *)[self.view viewWithTag:3000];
    UISlider *csl1 = (UISlider *)[self.view viewWithTag:3001];
    if (seg.tag ==1001) {
        //扫街方式（步行0,驾车1,飞机2）
        NSLog(@"%d",seg.selectedSegmentIndex);
        if (seg.selectedSegmentIndex == 0 ) {
            //步行方式  最上面的img的图片要相应的改变
            typeView.image = [UIImage imageNamed:@"buxing"];
            tripType = 0;
            lab1.text = @"10km/h";
            //也就是界面没有下拉
            if (mark ==0) {
                [view1 setFrame:CGRectMake(0, -50, Width, 230)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
            }
            else
            {
                //界面下拉了
                [view1 setFrame:CGRectMake(0, -50, Width, 230)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
                [self pushView];
            }
        }
        if (seg.selectedSegmentIndex == 1 )
        {
            //驾车方式
            typeView.image = [UIImage imageNamed:@"qiche"];
            tripType = 1;
            lab1.text = @"60km/h";
            //也就是界面没有下拉
            if (mark ==0) {
                [view1 setFrame:CGRectMake(0, -50, Width, 270)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
            }
            else
            {
                //界面下拉了
                [view1 setFrame:CGRectMake(0, -50, Width, 270)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
                [self pushView];
            }
        }
        if (seg.selectedSegmentIndex == 2 )
        {
            //飞机方式
            typeView.image = [UIImage imageNamed:@"plane"];
            tripType = 2;
            lab1.text = @"800km/h";
            //也就是界面没有下拉
            if (mark ==0) {
                [view1 setFrame:CGRectMake(0, -50, Width, 230)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
            }
            else
            {
                //界面下拉了
                [view1 setFrame:CGRectMake(0, -50, Width, 230)];
                [saveB setFrame:CGRectMake(120, view1.frame.size.height - 40, Width - 240, 30)];
                [self pushView];
            }
        }
        if (tripType !=1) {
            lab.hidden = YES;
            sg1.hidden = YES;
        }
        else
        {
            lab.hidden = NO;
            sg1.hidden = NO;
        }
        UILabel *labs = (UILabel *)[self.view viewWithTag:4001];
        if(tripType == 0)
        {
            //步行
            csl.minimumValue = 1;
            csl.maximumValue = 20;
            speed = 10;
            csl1.userInteractionEnabled = YES;
            [csl setValue:10 animated:YES];
            [csl1 setValue:0 animated:YES];
            labs.text = [NSString stringWithFormat:@"%ds",0];
        }
        if (tripType == 1) {
            //汽车
            csl.minimumValue = 30;
            csl.maximumValue = 260;
            speed = 60;
            csl1.userInteractionEnabled = YES;
            [csl setValue:60 animated:YES];
            [csl1 setValue:0 animated:YES];
            labs.text = [NSString stringWithFormat:@"%ds",0];
        }
        if (tripType == 2) {
            //飞机
            csl.minimumValue = 1;
            csl.maximumValue = 1400;
            speed = 800;
            [csl setValue:800 animated:YES];
            csl1.userInteractionEnabled = NO;
            [csl1 setValue:0 animated:YES];
            labs.text = @"不可用";
        }
    }
    if (seg.tag ==1002)
    {
        if (tripType !=1) {
            lab.hidden = YES;
            sg1.hidden = YES;
        }
        else
        {
            lab.hidden = NO;
            sg1.hidden = NO;
        }
        NSLog(@"%d",seg.selectedSegmentIndex);
        //（扫街参数0,路线添加1）
        if (seg.selectedSegmentIndex == 0) {
            [self pushView];
        }
        else
        {
            //界面跳转  开始添加点
            SearchViewController *search = [[SearchViewController alloc]init];
            search.index = (int)INT32_MAX;
            search.hadChoicePoints =_dataForTab;
            [self.navigationController pushViewController:search animated:YES];
        }
        seg.selectedSegmentIndex = -1;
    }
    if (seg.tag ==2004) {
        //路线类型
        linesType = seg.selectedSegmentIndex;
    }
    if (seg.tag == 2002) {
        //扫街频率
        if (seg.selectedSegmentIndex == 0) {
            rate = 0.3;
        }
        if (seg.selectedSegmentIndex == 1) {
            rate = 0.6;
        }
        if (seg.selectedSegmentIndex == 2) {
            rate = 1;
        }
    }
    if (seg.tag == 2003) {
        if (seg.selectedSegmentIndex == 0) {
            //默认为终点停留
            isState = 1;
            isCycle = 0;
        }
        if (seg.selectedSegmentIndex == 1) {
            //循环扫街
            isState = 0;
            isCycle = 1;
        }
        if (seg.selectedSegmentIndex == 2) {
            //返回模拟位置
            isState = 0;
            isCycle = 0;
        }
    }
}
//下拉动画
-(void)pushView
{
    mark = 1;
    //扫街参数界面设置弹出
    [UIView beginAnimations:@"animation" context:(__bridge void *)(view1)];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    //(0, seg2.frame.size.height +seg2.frame.origin.y +2 , Width, 0)
    if (tripType != 1) {
        [view1 setFrame:CGRectMake(0, view2.frame.size.height +view2.frame.origin.y, Width, 230)];
    }
    else
    {
        [view1 setFrame:CGRectMake(0, view2.frame.size.height +view2.frame.origin.y, Width, 270)];
    }
    [UIView commitAnimations];
}
//保存设置
-(void)saveClick
{
    mark = 0;
    [UIView beginAnimations:@"animation" context:(__bridge void *)(view1)];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [view1 setFrame:CGRectMake(0, -216, Width, 240)];
    [UIView commitAnimations];
}
//不同滑块的滑动事件
-(void)sliderChange:(UISlider *)sl
{
    UILabel *lab = (UILabel *)[self.view viewWithTag:sl.tag+1000];
    if (sl.tag == 3000) {
        //(步行,汽车,飞机)
        lab.text = [NSString stringWithFormat:@"%.fKm/h",sl.value];
        speed = sl.value;
        howlong = sl.value/sl.maximumValue;
    }
    if (sl.tag == 3001) {
        //(红绿灯)
        lab.text = [NSString stringWithFormat:@"%.fs",sl.value];
        redWaitSeconds = sl.value;
        howLongRed = sl.value/sl.maximumValue;
    }
    if (sl.tag == 3002) {
        //扫街频率
        lab.text = [NSString stringWithFormat:@"%.fms/次",sl.value];
        rate = sl.value/1000;
    }
    if (sl.tag == 3003) {
        //扫街完成
        int a =  (int)sl.value+0.5;
        if (a == 0) {
            lab.text = @"无操作";
            isState = 0;
            isCycle = 0;
        }
        if (a == 1) {
            lab.text = @"循环";
            isState = 0;
            isCycle = 1;
        }
        if (a == 2) {
            lab.text = @"终点停留";
            isState = 1;
            isCycle = 0;
        }
    }
}
//修改点的停留时间
-(void)changWaitTime:(UIButton *)sender
{
    [self makePickView];
    [self datePickShow];
    if ([[sender.superview.superview class]isSubclassOfClass:[UITableViewCell class]]) {
        _path = [_table indexPathForCell:(UITableViewCell *)sender.superview.superview];
    }
    else
    {
        _path = [_table indexPathForCell:(UITableViewCell *)sender.superview.superview.superview];
    }
    NSLog(@"%@",_path);
    NSLog(@"%ld %ld",(long)_path.row,(long)_path.section);
}
-(void)makePickView
{
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
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:leftBtn];
    //确定按钮
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(Width - 50, 0, 50, 30);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:rightBtn];
    //中间lab标示
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, Width - 100, 30)];
    lab.tag = 1000;
    lab.text = @"驻留时间";
    lab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:lab];
    //初始坐标
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, Width, Height / 3)];
    [_downView addSubview:_pickView];
    _pickView.dataSource = self;
    _pickView.delegate = self;
}
- (void)tapClick{
    [self datePickDissmiss];
}
- (void)leftBtn{
    
    [self datePickDissmiss];
}
- (void)rightBtn:(UIButton *)sender
{
    [self datePickDissmiss];
    if (_path) {
        XuandianModel *model = _dataForTab[_path.row];
        model.waitTime = _time;
        [dicTime setObject:[NSString stringWithFormat:@"%d",customWaiteTime] forKey:[NSString stringWithFormat:@"%d",(int)_path.row]];
        [_table reloadData];
        _path = nil;
    }
}
//时间选择器消失
-(void)datePickDissmiss
{
    _backView.hidden = YES;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height + Height / 3, Width, Height / 3)];
    [UIView commitAnimations];
}
-(void)datePickShow
{
    _backView.hidden = NO;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_downView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_downView setFrame:CGRectMake(0, Height - Height / 2, Width, Height /2 )];
    [UIView commitAnimations];
}
-(void)getDateForPick
{
    for (NSInteger i = 0; i < 24; i ++) {
        [_arr1 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    
    for (NSInteger i = 0; i < 60; i ++) {
        [_arr2 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    for (NSInteger i = 0; i < 60; i ++) {
        [_arr3 addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
}
#pragma pickViewDelegate
#pragma markPickViewDelegate pickview的代理方法
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    UIView *view0,*view6,*view7;
    NSInteger row0,row1,row2;
    row0 = [_pickView selectedRowInComponent:0];
    row1 = [_pickView selectedRowInComponent:1];
    row2 = [_pickView selectedRowInComponent:2];
    
    view0 = [_pickView viewForRow:row0 forComponent:0];
    view6 = [_pickView viewForRow:row1 forComponent:1];
    view7 = [_pickView viewForRow:row2 forComponent:2];
    
    UILabel *label0,*label6,*label7;
    label0 =(UILabel *)[view0 viewWithTag:200];
    label6 =(UILabel *)[view6 viewWithTag:200];
    label7 =(UILabel *)[view7 viewWithTag:200];
    
    NSString *hh= [label0.text stringByReplacingOccurrencesOfString:@"时" withString:@""];
    NSString *mm = [label6.text stringByReplacingOccurrencesOfString:@"分" withString:@""];
    NSString *ss = [label7.text stringByReplacingOccurrencesOfString:@"秒" withString:@""];
    _time = [NSString stringWithFormat:@"%@:%@:%@",hh,mm,ss];
    customWaiteTime = [label0.text intValue]*3600 + [label6.text intValue]*60 +[label7.text intValue];
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
        txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr1 objectAtIndex:row],@":"];
    }
    else if(component==1)
    {
        txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr2 objectAtIndex:row],@":"];
    }
    else if(component==2)
    {
        txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr3 objectAtIndex:row],@":"];
    }
    
    return myView;
    return nil;
}
//算路
-(void)caculerLine
{
    if (_dataForTab.count>1) {
        //在此可以展示用户本条路线的基本信息
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此路线扫街方式:%@ \n 红绿灯停留:%d秒\n扫街方式:%@\n",tripType ==0 ?@"步行":(tripType == 1?@"驾车":@"飞机"),redWaitSeconds,isCycle==1?@"循环扫街":@"不循环扫街"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 6006) {
        if (buttonIndex ==1) {
            [jh showAllScreen:YES Image:[UIImage imageNamed:@"zhuan"]];
            switch (tripType) {
                case 1:
                    //步行算法
                    [self getLines];
                    break;
                case 0:
                    //驾车算法
                    [self getLines];
                    break;
                case 2:
                    //飞机算法
                    [self getLinesByPlan];
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        NSLog(@"%d",(int)buttonIndex);
        if(buttonIndex ==1)
        {
            [self caculerLine];
        }
    }
}
//飞机算法
-(void)getLinesByPlan
{
    //NSLog(@"%lf",((XuandianModel *)_dataForTab[0]).currentLocation.latitude);
    [self getCutPlaneDataWhith:_dataForTab];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status==AFNetworkReachabilityStatusNotReachable) {
             [MyAlert ShowAlertMessage:@"请检查网络连接" title:@"温馨提示"];
             return;
         }
         
         if (single <= newDataForTab.count -1)
         {
             DBResultModel model;
             CLLocationCoordinate2D currentCll;
             currentCll.latitude = ((XuandianModel *)newDataForTab[single]).latitude;
             currentCll.longitude = ((XuandianModel *)newDataForTab[single]).longtitude;
             model.latitude =currentCll.latitude;
             model.longtitude = currentCll.longitude;
             CLLocationCoordinate2D hx = [[FireToGps sharedIntances]gcj02Encrypt:currentCll.latitude bdLon:currentCll.longitude];
             model.x = MKMapPointForCoordinate(hx).x;
             model.y = MKMapPointForCoordinate(hx).y;
             model.ScanRate = rate;
             model.isState = isState;
             model.isCycle = isCycle;
             model.len = speed/3.6*rate;
             model.alert = 0;
             model.isWaitPoint = 0;
             model.alert = 0;
             if (single == newDataForTab.count -1) {
                 model.alert = 1;
             }
             model.whichbundle = (char*)[self.boundle UTF8String];
             temPointsNum =(int) _linesData.count;
             NSData *msgData = [[NSData alloc]initWithBytes:&model length:sizeof(DBResultModel)];
             [_linesData addObject:msgData];
             
             
             
             DBResultModel model2;//声明test2，为了得到test1的值
             NSData *newData = _linesData[single];
             [newData getBytes:&model2 length:sizeof(DBResultModel)];
             ((XuandianModel *)newDataForTab[single]).x = model2.x;
             ((XuandianModel *)newDataForTab[single]).y = model2.y;
             ((XuandianModel *)newDataForTab[single]).isCycle = model2.isCycle;
             ((XuandianModel *)newDataForTab[single]).redWaitSeconds = redWaitSeconds;
             ((XuandianModel *)newDataForTab[single]).ScanRate = model2.ScanRate;
             ((XuandianModel *)newDataForTab[single]).alertOn = model2.alert;
             ((XuandianModel *)newDataForTab[single]).speed = speed;
             single ++;
             [self getLinesByPlan];
         }
         else
         {
             [self saveDataToDB];
         }
         
     }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
}
//  取到距离的真实值
- (int)getInstance:(NSString *)juli
{
    if ([juli hasSuffix:@"km"]) {
        return [[juli substringToIndex:[juli rangeOfString:@"km"].location] integerValue];
    }else
    {
        return [[juli substringToIndex:[juli rangeOfString:@"m"].location] integerValue]/1000;
    }
}
//在这里吧飞机的坐标细分
-(NSMutableArray *)getCutPlaneDataWhith:(NSMutableArray *)startData
{
    [newDataForTab removeAllObjects];
    //飞机以10KM为单位切 仅在百度地图坐标系下
    for (int a = 0; a <startData.count -1; a++) {
        int m =  [self getInstance:((XuandianModel *)startData[a+1]).juli ]/10;
        if (m == 0) {
            m=1;
        }
        if(m>0)
        {
            for (int i = 0; i< m + 1; i ++) {
                XuandianModel *newModel = [[XuandianModel alloc]init];
//                NSLog(@"%lf",((XuandianModel *)_dataForTab[a]).currentLocation.latitude);
                newModel.x = ((float)i/m)*MKMapPointForCoordinate(((XuandianModel *)startData[a+1]).currentLocation).x +(1-((float)i/m))*MKMapPointForCoordinate(((XuandianModel *)startData[a]).currentLocation).x;
                newModel.y = ((float)i/m)*MKMapPointForCoordinate(((XuandianModel *)startData[a+1]).currentLocation).y+(1-((float)i/m))*MKMapPointForCoordinate(((XuandianModel *)startData[a]).currentLocation).y;
                // NSLog(@"%f , %f",newModel.x,newModel.y);
                MKMapPoint newPoint;
                newPoint.x = newModel.x;
                newPoint.y = newModel.y;
                // NSLog(@"%f",newPoint.x);
                newModel.latitude =   MKCoordinateForMapPoint(newPoint).latitude;
                newModel.longtitude = MKCoordinateForMapPoint(newPoint).longitude;
                // NSLog(@"%f , %f",newModel.latitude,newModel.longtitude);
                newModel.currentLocation = ((XuandianModel *)startData[a]).currentLocation;
                [newDataForTab addObject:newModel];
            }
        }
        else
        {
            newDataForTab  = [NSMutableArray arrayWithArray:startData];
        }
    }
    //    NSLog(@"%d",newDataForTab.count);
    return newDataForTab;
}
//算路
-(void)getLines
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status==AFNetworkReachabilityStatusNotReachable) {
             [MyAlert ShowAlertMessage:@"请检查网络连接" title:@"温馨提示"];
             return;
         }
         if (single< _dataForTab.count -1) {
             //百度坐标的方法
             [self requestRoutWithSoure:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single]).currentLocation) Destination:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single +1]).currentLocation)];
         }
         else
         {
             [self saveDataToDB];
         }
     }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}
//百度 google公用一种方法   仅限于计算步行 和驾车
-(void)requestRoutWithSoure:(CLLocationCoordinate2D) start2D  Destination:(CLLocationCoordinate2D)end2D
{
    NSLog(@"初始点经纬度:%f %f   末点经纬度: %f  %f",start2D.latitude,start2D.longitude,end2D.latitude,end2D.longitude);
    //初始点坐标
    NSString *origin =[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithDouble:start2D.latitude],[NSNumber numberWithDouble:start2D.longitude]];
    //终点坐标
    NSString *destination =[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithDouble:end2D.latitude],[NSNumber numberWithDouble:end2D.longitude]];
    //写进参数
    NSDictionary *scandic = @{@"origin":origin,@"destination":destination,@"sensor":@"false",@"mode":tripType ==0?@"walking":@"driving",@"alternatives":@"true"};
    jh.label.text = @"正在请求中...";
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    [mgr GET:@"https://maps.google.cn/maps/api/directions/json" parameters:scandic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resDict = responseObject;
        NSLog(@"%@",resDict);
        NSLog(@"%@",resDict[@"routes"][0][@"legs"][0][@"steps"][0][@"polyline"][@"points"]);
        if (resDict) {
            NSArray *routesArr = resDict[@"routes"];
            int routeCount = routesArr.count;
            
            if (routeCount > linesType&&tripType == 1) {
                
            }
            else
            {
                linesType = 0;
            }
            if (routeCount >0) {
                {
                    NSArray *legsArr = routesArr[linesType][@"legs"];
                    int legsCount = legsArr.count;
                    for (int j = 0; j<legsCount; j++) {
                        NSArray *stepsArr = legsArr[j][@"steps"];
                        int stepsCount = stepsArr.count;
                        for (int z = 0; z <stepsCount; z ++) {
                            NSString  *pointsStr =stepsArr[z][@"polyline"][@"points"];
                            NSMutableArray *pointsArr = [[self decodePoly:pointsStr] copy];
                            int pointsCount = pointsArr.count;
                            temPointsNum =routeCount*legsCount*stepsCount*pointsCount;
                            //现在最小的部分
                            for(int n=0;n<pointsCount - 1;n++){
                                
                                CLLocationCoordinate2D c;
                                NSValue *value = pointsArr[n];
                                [value getValue:&c];
                                
                                DBResultModel model;
                                model.latitude =c.latitude;
                                model.longtitude = c.longitude;
                                CLLocationCoordinate2D hx = [[FireToGps sharedIntances]gcj02Encrypt:c.latitude bdLon:c.longitude];
                                model.x = MKMapPointForCoordinate(hx).x;
                                model.y = MKMapPointForCoordinate(hx).y;
                                model.ScanRate = rate;
                                model.isState = isState;
                                model.isCycle = isCycle;
                                model.len = speed/3.6*rate;
                                model.alert = 0;
                                model.waitePoint = 0;
                                model.isWaitPoint = 0;
                                if (n==0) {
                                    model.isWaitPoint = 1;
                                }
                                model.redWaitSeconds = redWaitSeconds;
                                NSMutableArray *existPoints =[NSMutableArray arrayWithArray:[dicTime allKeys]] ;
                                for (NSString *which in existPoints) {
                                    if (dicTime[[NSString stringWithFormat:@"%@",which]]) {
                                        if(single == [which intValue]|| single+1 == [which intValue])
                                        {
                                            if (single == 0 && [which intValue]==0) {
                                                //说明是在第一个位置 刚开始就暂停了第一个选中的点
                                                if (j==0&&z==0&&n==0) {
                                                    model.waiteSeconds = redWaitSeconds + [dicTime[[NSString stringWithFormat:@"%@",which]]intValue];
                                                    model.waitePoint = 1;
                                                }
                                                
                                            }
                                            //判断是最后一个点
                                            else if(single == _dataForTab.count -2 && [which intValue]==_dataForTab.count -1)
                                            {
                                                if (j==legsCount -1 && z==stepsCount -1 && n == pointsCount -1 ) {
                                                    model.waiteSeconds = redWaitSeconds + [dicTime[[NSString stringWithFormat:@"%@",which]]intValue];
                                                    model.waitePoint = 1;
                                                }
                                            }
                                            //判断其他情况
                                            else
                                            {
                                                if (single +1 == [which intValue]) {
                                                    if (j==legsCount -1 && z==stepsCount -1 && n == pointsCount -1) {
                                                        model.waiteSeconds = redWaitSeconds + [dicTime[[NSString stringWithFormat:@"%@",which]]intValue];
                                                        model.waitePoint = 1;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (z == stepsCount -1 && n == pointsCount - 1) {
                                    model.alert = 1;
                                }
                                model.whichbundle = (char*)[self.boundle UTF8String];
                                //_linesData;
                                NSData *msgData = [[NSData alloc]initWithBytes:&model length:sizeof(DBResultModel)];
                                [_linesData addObject:msgData];
                            }
                        }
                    }
                }
                if (temPointsNum>2) {
                    if (single == 0) {
                        DBResultModel model;//声明test2，为了得到test1的值
                        NSData *newData = _linesData[0];
                        [newData getBytes:&model length:sizeof(DBResultModel)];
                        DBResultModel model1;
                        NSData *lastData = [_linesData lastObject];
                        [lastData getBytes:&model1 length:sizeof(DBResultModel)];
                        ((XuandianModel *)_dataForTab[0]).x = model.x;
                        ((XuandianModel *)_dataForTab[0]).y = model.y;
                        ((XuandianModel *)_dataForTab[0]).isCycle = model.isCycle;
                        ((XuandianModel *)_dataForTab[0]).redWaitSeconds = redWaitSeconds;
                        ((XuandianModel *)_dataForTab[0]).ScanRate = model.ScanRate;
                        ((XuandianModel *)_dataForTab[0]).speed = speed;
                        ((XuandianModel *)_dataForTab[0]).alertOn = model.alert;
                        ((XuandianModel *)_dataForTab[0]).linesType = linesType;
                        ((XuandianModel *)_dataForTab[0]).isState = isState;
                        ((XuandianModel *)_dataForTab[1]).x = model1.x;
                        ((XuandianModel *)_dataForTab[1]).y = model1.y;
                        ((XuandianModel *)_dataForTab[1]).isCycle = model1.isCycle;
                        ((XuandianModel *)_dataForTab[1]).redWaitSeconds = redWaitSeconds;
                        ((XuandianModel *)_dataForTab[1]).ScanRate = model1.ScanRate;
                        ((XuandianModel *)_dataForTab[1]).alertOn = model1.alert;
                        ((XuandianModel *)_dataForTab[1]).linesType = linesType;
                        ((XuandianModel *)_dataForTab[1]).isState = isState;
                    }
                    else
                    {
                        DBResultModel model;//声明test2，为了得到test1的值
                        NSData *newData = [_linesData lastObject];
                        [newData getBytes:&model length:sizeof(DBResultModel)];
                        ((XuandianModel *)_dataForTab[single+1]).x = model.x;
                        ((XuandianModel *)_dataForTab[single+1]).y = model.y;
                        ((XuandianModel *)_dataForTab[single+1]).isCycle = model.isCycle;
                        ((XuandianModel *)_dataForTab[single+1]).redWaitSeconds = redWaitSeconds;
                        ((XuandianModel *)_dataForTab[single+1]).ScanRate = model.ScanRate;
                        ((XuandianModel *)_dataForTab[single+1]).alertOn = model.alert;
                        ((XuandianModel *)_dataForTab[single+1]).linesType = linesType;
                        ((XuandianModel *)_dataForTab[single+1]).isState = isState;
                    }
                }
            }
            else
            {
                //规划线路失败
                [MyAlert ShowAlertMessage:@"线路规划失败" title:@"温馨提示"];
            }
        }
        single++;
        [self getLines];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSMutableArray *)decodePoly:(NSString *)encoded
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    int index = 0, len = encoded.length;
    long double lat = 0, lng = 0;
    while (index < len) {
        int b, shift = 0, result = 0;
        do {
            b = [encoded characterAtIndex:index] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
            index ++;
        } while (b >= 0x20);
        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
            index++;
        } while (b >= 0x20);
        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        CLLocationCoordinate2D p;
        p.latitude =(((long double) lat / 1E5));
        p.longitude = (((long double) lng / 1E5));
        NSValue *valuep = [NSValue value:&p withObjCType:@encode(CLLocationCoordinate2D)];
        [arr addObject:valuep];
        
    }
    return arr;
}
-(void)saveDataToDB
{
    //在这里得到数据 _linesData
    jh.label.text=@"正在存储";
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    if ([dataManager isExistRecordWithID:self.boundle]) {
        [dataManager deleteCurrentLines:self.boundle];
    }
    MapTypeDataManager *maptypeManager= [MapTypeDataManager shareInatance];
    if (![maptypeManager chargeListInDB])
    {
        [maptypeManager creatTabel];
    }
    if ([maptypeManager isExistRecordWithBundle:self.boundle]) {
        [maptypeManager deleteMapTypeWithBundle:self.boundle];
    }
    BOOL result = NO;
    if (_linesData.count >0) {
        if (self.tripType !=2) {
            
        }
        else
        {
            for (int i = 0; i<_dataForTab.count; i++) {
                CLLocationCoordinate2D a ;
                a =((XuandianModel *)_dataForTab[i]).currentLocation;
                NSLog(@"%lf",a.latitude);
                CLLocationCoordinate2D hx = [[FireToGps sharedIntances]gcj02Encrypt:a.latitude bdLon:a.longitude];
                ((XuandianModel *)_dataForTab[i]).x = MKMapPointForCoordinate(hx).x;
                ((XuandianModel *)_dataForTab[i]).y = MKMapPointForCoordinate(hx).y;
                ((XuandianModel *)_dataForTab[i]).isCycle = isCycle;
                ((XuandianModel *)_dataForTab[i]).redWaitSeconds = redWaitSeconds;
                ((XuandianModel *)_dataForTab[i]).ScanRate = rate;
                ((XuandianModel *)_dataForTab[i]).alertOn = 0;
                ((XuandianModel *)_dataForTab[i]).linesType = linesType;
                ((XuandianModel *)_dataForTab[i]).isState = isState;
                ((XuandianModel *)_dataForTab[i]).speed = speed;
            }
        }
        
        result = [dataManager saveFileRecordWithBoundle:self.boundle withNsarry:_linesData withType:[NSString stringWithFormat:@"%d",self.tripType] withIsCycle:[NSString stringWithFormat:@"%d",isCycle]withPotions:_dataForTab];
        if (result == NO) {
            [jh hide];
            [MyAlert ShowAlertMessage:@"线路存储失败" title:@"温馨提示"];
            return;
        }
        else
        {
            [maptypeManager saveFileRecordwithWhichApp:self.boundle withWhichMap:@"google"];
        }
    }
    else
    {
        [jh hide];
        [MyAlert ShowAlertMessage:@"请检查网络连接" title:@"温馨提示"];
        return;
    }
    [jh hide];
    if (self.isShowLine == 1) {
        [((TotleScanViewController *)self.parentViewController) backTravelStreetWith:self.boundle];
    }
    else
    {
        [((TotleScanViewController *)self.parentViewController) backTravelStreet];
    }
}
#pragma passDelegate
-(void)chuanLines:(NSArray *)arr
{
    [_dataForTab removeAllObjects];
    for(XuandianModel *model in arr)
    {
        MKMapPoint point;
        point.x = model.x;
        point.y = model.y;
        CLLocationCoordinate2D c =MKCoordinateForMapPoint(point);
        model.currentLocation = c;
        [_dataForTab addObject:model];
    }
    [_table reloadData];
}
-(void)chuanzhiGPS:(XuandianModel *)model
{
    CLLocationCoordinate2D c;
    c.latitude = [model.latitudeNum doubleValue];
    c.longitude = [model.longitudeNum doubleValue];
    model.currentLocation = c;
    // model.currentLocation = cu;
    NSLog(@"%@",_dataForTab);
    NSLog(@"%d",model.index);
    NSLog(@"%lf  %lf",model.currentLocation.latitude,model.currentLocation.longitude);
    if (_dataForTab.count >0 && model.index !=0) {
        if (model.index < _dataForTab.count) {
            if (model.index <_dataForTab.count -1) {
                XuandianModel *model1 = _dataForTab [model.index+1];
                MKMapPoint po1 = MKMapPointForCoordinate(model1.currentLocation);
                NSLog(@"%lf  %lf",model1.currentLocation.latitude,model1.currentLocation.longitude);
                MKMapPoint po2 = MKMapPointForCoordinate(model.currentLocation);
                int dis = MKMetersBetweenMapPoints(po1,po2);
                if (dis >1000) {
                    model.juli = [NSString stringWithFormat:@"%dkm",dis/1000];
                }
                else
                {
                    model.juli = [NSString stringWithFormat:@"%dm",dis];
                }
                [_dataForTab replaceObjectAtIndex:model.index withObject:model];
            }
            else
            {
                XuandianModel *model1 = _dataForTab [model.index-1];
                MKMapPoint po1 = MKMapPointForCoordinate(model1.currentLocation);
                MKMapPoint po2 = MKMapPointForCoordinate(model.currentLocation);
                int dis = MKMetersBetweenMapPoints(po1,po2);
                if (dis >1000) {
                    model.juli = [NSString stringWithFormat:@"%dkm",dis/1000];
                }
                else
                {
                    model.juli = [NSString stringWithFormat:@"%dm",dis];
                }
                [_dataForTab replaceObjectAtIndex:model.index withObject:model];
            }
        }
        else
        {
            XuandianModel *model1 = [_dataForTab lastObject];
            MKMapPoint po1 = MKMapPointForCoordinate(model1.currentLocation);
            MKMapPoint po2 = MKMapPointForCoordinate(model.currentLocation);
            int dis = MKMetersBetweenMapPoints(po1,po2);
            if (dis >1000) {
                dis = dis/1000;
                model.juli = [NSString stringWithFormat:@"%dkm",dis];
            }
            else
            {
                model.juli = [NSString stringWithFormat:@"%dm",dis];
            }
            [_dataForTab addObject:model];
        }
    }
    else
    {
        if (_dataForTab.count >0 && model.index ==0) {
            model.juli = @"0 km";
            [_dataForTab replaceObjectAtIndex:0 withObject:model];
        }
        else{
            model.juli = @"0 km";
            [_dataForTab addObject:model];
        }
    }
    [_table reloadData];
}
//实现添加点后的代理操作
-(void)chuanzhi:(XuandianModel *)model
{
    NSLog(@"%@",_dataForTab);
    [KGStatusBar showWithStatus:@"添加成功"];
    //经纬度:116.385465, 39.785908
    NSLog(@"%lf  %lf",model.currentLocation.latitude,model.currentLocation.longitude);
    if (model.index < _dataForTab.count) {
        if (model.index < _dataForTab.count-1) {
            [_dataForTab replaceObjectAtIndex:model.index withObject:model];
            XuandianModel *model1 = _dataForTab [model.index+1];
            MKMapPoint po1 = MKMapPointForCoordinate(model1.currentLocation);
            NSLog(@"%lf  %lf",model1.currentLocation.latitude,model1.currentLocation.longitude);
            MKMapPoint po2 = MKMapPointForCoordinate(model.currentLocation);
            int dis = MKMetersBetweenMapPoints(po2,po1);
            NSLog(@"%d",dis);
            if (dis >1000) {
                model1.juli = [NSString stringWithFormat:@"%dkm",dis/1000];
            }
            else
            {
                model1.juli = [NSString stringWithFormat:@"%dm",dis];
            }
            [_dataForTab replaceObjectAtIndex:model.index+1 withObject:model1];
        }
        else
        {
            [_dataForTab replaceObjectAtIndex:model.index withObject:model];
        }
    }
    else
    {
        [_dataForTab addObject:model];
    }
    [_table reloadData];
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
