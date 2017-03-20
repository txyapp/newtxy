//
//  ChooseTypeViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/12.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "ChooseTypeViewController.h"
#import "XuandianTableViewCell.h"
#import "SearchViewController.h"
#import "DataBaseManager.h"
#import "ProgressHUD.h"
#import "TXYTools.h"
#import "PopoverView.h"
#import "FireToGps.h"
#import "WGS84TOGCJ02.h"
#import "ResultModel.h"
#import "MBProgressHUD.h"
#import "juHua.h"
#import "MyAlert.h"
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface ChooseTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    UITableView *_table;
    //table的数据源
    NSMutableArray *_dataForTab;
    //时间选择器
    UIPickerView *_pickView;
    //时间选择器的数据源
    NSMutableArray *_arr1,*_arr2,*_arr3;
    UIView *_downView,*_backView;
    //时间选择器选中后的时间
    NSString *_time;
    //点击的是哪个cell  cell的位置
    NSIndexPath *_path;
    //存储路线的数组   用户选择的点的集合
    NSMutableArray *_linesData,*_pointsData;
    int temPointsNum;
    //存储用户选中点后修改该点等待时间的值
    NSMutableDictionary *dic;
    //算路次数控制;
    int single;
    //存储飞机路线的value
    NSMutableArray *_valueArPLan;
    //存数临时路线value
    NSMutableArray *_valueWalkORDrive;
    UISegmentedControl *seg,*seg2;
    UISwitch *s,*al,*stateAl;
    NSArray *_walkSpeed,*_driveSpeed,*_planSpeed,*_rateArr;
    //区别是否是选择速度  并且选择什么速度
    int typeCurrent,whitchType,linesType;
    int speed;
    juHua *jh;
    UIView *secondView;
    //红绿灯，频率，速度
    UILabel *redLab,*rateLab,*speedLab;
}
@end

@implementation ChooseTypeViewController
@synthesize redWaitSeconds,isCycle,boundle,tripType,isAlertOn,linesType,isState;
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认频率
    self.rate= 1;
    single = 0;
    self.tripType =0;
    typeCurrent = 0;
    whitchType = 0;
    isAlertOn = 0;
    linesType = 0;
    isState = 0;
    redWaitSeconds = 0;
    speed =10;
    _dataForTab = [NSMutableArray arrayWithCapacity:0];
    _arr1 = [NSMutableArray arrayWithCapacity:0];
    _arr2 = [NSMutableArray arrayWithCapacity:0];
    _arr3 = [NSMutableArray arrayWithCapacity:0];
    _walkSpeed = [[NSArray alloc]init];
    _driveSpeed = [[NSArray alloc]init];
    _planSpeed = [[NSArray alloc]init];
    _rateArr = [[NSArray alloc]init];
    _linesData = [NSMutableArray arrayWithCapacity:0];
    _pointsData = [NSMutableArray arrayWithCapacity:0];
    dic = [NSMutableDictionary dictionaryWithCapacity:0];
    _valueArPLan = [NSMutableArray arrayWithCapacity:0];
    _valueWalkORDrive = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    jh=[[juHua alloc]init];
    [self getModelForPick];
    [self getModelFromDB];
    //NSLog(@"%@  %d  %d",_path,_path.section,_path.row);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!iOS7) {
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
        self.tabBarController.tabBar.hidden=YES;
        
        UIView *contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame=CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height+tabBar.bounds.size.height);
        
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
}
//得到某个应用的点
-(void)getModelFromDB
{
    [_dataForTab removeAllObjects];
    ((UIButton *)[self.view viewWithTag:1002]).hidden = NO;
    _dataForTab = [NSMutableArray arrayWithArray:[[DataBaseManager shareInatance] getPotionsFrom:self.boundle]];
    if (_dataForTab.count>0) {
        XuandianModel *model = _dataForTab[0];
        XuandianModel *lastModel  = _dataForTab[_dataForTab.count -1];
        al.on = lastModel.alertOn;
        isAlertOn = lastModel.alertOn;
        isState = lastModel.isState;
        //终点停留
        //stateAl.on = lastModel.isState;
        //是否循环扫街
        //s.on = model.isCycle;
        UIButton *b1 = (UIButton *)[self.view viewWithTag:8001];
        UIButton *b2 = (UIButton *)[self.view viewWithTag:8002];
        UIButton *b3 = (UIButton *)[self.view viewWithTag:8003];
        if (lastModel.isState ==1) {
            [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            b1.layer.borderColor = [UIColor blackColor].CGColor;
            [b2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            b2.layer.borderColor = [UIColor blueColor].CGColor;
            [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            b3.layer.borderColor = [UIColor blackColor].CGColor;
        }
        if (model.isCycle == 1) {
            [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            b1.layer.borderColor = [UIColor blackColor].CGColor;
            [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            b2.layer.borderColor = [UIColor blackColor].CGColor;
            [b3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            b3.layer.borderColor = [UIColor blueColor].CGColor;
        }
        isCycle = model.isCycle;
        if (model.redWaitSeconds !=0) {
            //[((UIButton *)[self.view viewWithTag:2008]) setTitle:[NSString stringWithFormat:@"红绿灯:%d秒",model.redWaitSeconds] forState:UIControlStateNormal];
            redLab.text = [NSString stringWithFormat:@"%ds",model.redWaitSeconds];
            redWaitSeconds = model.redWaitSeconds;
        }
        //[((UIButton *)[self.view viewWithTag:2009]) setTitle:[NSString stringWithFormat:@"%@:%d%@",@"速度",model.speed,@"km"] forState:UIControlStateNormal];
        speedLab.text = [NSString stringWithFormat:@"%d km",model.speed];
        speed = model.speed;
        //[((UIButton*)[self.view viewWithTag:2100]) setTitle:[NSString stringWithFormat:@"%@:%.2f",@"频率",model.ScanRate] forState:UIControlStateNormal];
        rateLab.text = [NSString stringWithFormat:@"%.f ms",model.ScanRate==1?1000:model.ScanRate];
        seg.selectedSegmentIndex = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        if (seg.selectedSegmentIndex == 1) {
            seg2.userInteractionEnabled = YES;
            seg2.tintColor = [UIColor blueColor];
        }
        else
        {
            seg2.userInteractionEnabled = NO;
            seg2.tintColor = [UIColor lightGrayColor];
        }
        seg2.selectedSegmentIndex = model.linesType;
        self.tripType = [[[DataBaseManager shareInatance]chargeWhichType:self.boundle] intValue];
        for(XuandianModel *model in _dataForTab)
        {
            MKMapPoint point;
            point.x = model.x;
            point.y = model.y;
            if (WhitchLanguagesIsChina) {
                //国内地图
                CLLocationCoordinate2D c =[self hhTrans_bdGPS:MKCoordinateForMapPoint(point)];
                model.currentLocation = c;
            }
            else
            {
                //国外地图
                CLLocationCoordinate2D c = MKCoordinateForMapPoint(point);
                model.currentLocation = c;
            }
        }
        [_table reloadData];
    }
    else
    {
        return;
    }
}
//时间选择器的数据
-(void)getModelForPick
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
    _walkSpeed = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    _driveSpeed =@[@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"110",@"120",@"130",@"140",@"150",@"160",@"170",@"180",@"190",@"200",@"210",@"220"];
    _planSpeed =@[@"450",@"500",@"550",@"600",@"650",@"700",@"750",@"800",@"850",@"900",@"950",@"1000",@"1050",@"1100",@"1150",@"1200",@"1250",@"1300",@"1350",@"1400"];
    _rateArr = @[@"1S",@"800ms",@"500ms"];
}
//时间选择器
-(void)makePickView{
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
    if (typeCurrent==1) {
        lab.text = @"速度";
    }else if(typeCurrent==0)
    {
        lab.text = @"驻留时间";
    }
    else
    {
        lab.text = @"频率";
    }
    lab.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:lab];
    //初始坐标
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, Width, Height / 3)];
    [_downView addSubview:_pickView];
    _pickView.dataSource = self;
    _pickView.delegate = self;
    if(typeCurrent ==1)
    {
         [_pickView selectRow:9 inComponent:0 animated:true];
    }
}
//码大体界面
-(void)makeUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title = @"扫街路线";
    //seg
    seg = [[UISegmentedControl alloc]initWithItems:@[@"步行",@"驾车",@"飞机"]];
    seg.frame = CGRectMake(10, iOS7?74:10, Width -20, 30);
    seg.segmentedControlStyle = UISegmentedControlStylePlain;
    seg.selectedSegmentIndex = 0;
    seg.tag = 6000;
    seg.tintColor = [UIColor blueColor];
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    seg2 = [[UISegmentedControl alloc]initWithItems:@[@"路程短",@"避拥堵",@"时间短"]];
    seg2.frame = CGRectMake(10, iOS7?125:61, Width -20, 30);
    seg2.segmentedControlStyle = UISegmentedControlStylePlain;
    seg2.selectedSegmentIndex = 0;
    seg2.tag = 6001;
    seg2.userInteractionEnabled = NO;
    seg2.tintColor = [UIColor lightGrayColor];
    [seg2 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg2];
    
    UILabel *alertL = [[UILabel alloc]initWithFrame:CGRectMake(7, seg2.frame.size.height +seg2.frame.origin.y + 5, 120, 29)];
    alertL.text = @"请设置参数:";
    [self.view addSubview:alertL];
    alertL.font = [UIFont systemFontOfSize:13];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, seg2.frame.size.height +seg2.frame.origin.y + 34 , Width-4, 0.5)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.8;
    [self.view addSubview:line2];
    
    UIButton *setB = [UIButton buttonWithType:UIButtonTypeCustom];
    setB.frame = CGRectMake(5 , seg2.frame.size.height +seg2.frame.origin.y + 35, Width - 10, 37);
    [setB addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *setI = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
    setI.image = [UIImage imageNamed:@"menu_settings"];
    [setB addSubview:setI];
    UILabel *setL = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 25)];
    setL.text = @"设置(红绿灯,速度,频率等)";
    setL.tag = 8989;
    [setB addSubview:setL];
    [self.view addSubview:setB];
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(8, setB.frame.size.height + 4 +setB.frame.origin.y , Width-16, 0.5)];
    line0.backgroundColor = [UIColor grayColor];
    line0.alpha = 0.8;
    [self.view addSubview:line0];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 30, 11, 10, 15)];
    arrow.image = [UIImage imageNamed:@"arrow_black"];
    arrow.tag = 7878;
    [setB addSubview:arrow];
    
    //此view 展示 红绿灯停留事件  还有是否需要循环
    secondView = [[UIView alloc]initWithFrame:CGRectMake(0 , setB.frame.size.height + 5 +setB.frame.origin.y , Width, 282)];
    secondView.alpha = 0;
    secondView.tag = 9999;
    
    UIButton *saveB = [UIButton buttonWithType:UIButtonTypeCustom];
    saveB.frame = CGRectMake(100, 261, Width-200, 40);
    [saveB setBackgroundColor:IWColor(60, 170, 249)];
    saveB.layer.masksToBounds = YES;
    saveB.layer.cornerRadius = 3;
    [saveB setTitle:@"保存设置" forState:UIControlStateNormal];
    [saveB addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:saveB];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 2008;
    [btn setTitle:@"红绿灯停留时间:(秒)" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(7, 0, Width, 49);
    [secondView addSubview:btn];
    redLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - 100, 8, 70, 30)];
    redLab.font = [UIFont systemFontOfSize:14];
    [btn addSubview:redLab];
    UIImageView *arrow1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 30, 11, 10, 15)];
    arrow1.image = [UIImage imageNamed:@"arrow_black"];
    [btn addSubview:arrow1];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(5, 49 , Width-10, 0.5)];
    line3.backgroundColor = [UIColor blackColor];
    line3.alpha = 0.8;
    [secondView addSubview:line3];
    
    //速度按钮
    UIButton *speed1 = [UIButton buttonWithType:UIButtonTypeCustom];
    speed1.tag = 2009;
    UIImageView *arrow2 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 30, 11, 10, 15)];
    arrow2.image = [UIImage imageNamed:@"arrow_black"];
    [speed1 addSubview:arrow2];
    [speed1 setTitle:@"扫街速度:(km)" forState:UIControlStateNormal];
    speed1.titleLabel.font = [UIFont systemFontOfSize:13];
    speed1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [speed1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [speed1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    speed1.frame = CGRectMake(7, 53, Width, 49);
    [secondView addSubview:speed1];
    speedLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - 100, 8, 70, 30)];
    speedLab.font = [UIFont systemFontOfSize:14];
    [speed1 addSubview:speedLab];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(7, 93 , Width-10, 0.5)];
    line5.backgroundColor = [UIColor blackColor];
    line5.alpha = 0.8;
    [secondView addSubview:line5];
    
    
    //频率按钮
    UIButton *tateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tateBtn.frame = CGRectMake(7, 102, Width, 49);
    tateBtn.tag = 2100;
    UIImageView *arrow3 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 30, 11, 10, 15)];
    arrow3.image = [UIImage imageNamed:@"arrow_black"];
    [tateBtn addSubview:arrow3];
    [tateBtn setTitle:@"扫街行进频率:" forState:UIControlStateNormal];
    tateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    tateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [tateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:tateBtn];
    rateLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - 100, 8, 70, 30)];
    rateLab.font = [UIFont systemFontOfSize:14];
    [tateBtn addSubview:rateLab];
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(7, 151 , Width, 0.5)];
    line6.backgroundColor = [UIColor blackColor];
    line6.alpha = 0.8;
    [secondView addSubview:line6];
    
    
    //扫街后操作
    UILabel *scanAfterL = [[UILabel alloc]initWithFrame:CGRectMake(7, 153, Width, 30)];
    scanAfterL.text =@"扫街后操作:";
    scanAfterL.font = [UIFont systemFontOfSize:14];
    [secondView addSubview:scanAfterL];
    
    
    UIButton *noB = [UIButton buttonWithType:UIButtonTypeCustom];
    noB.frame = CGRectMake(7+50/3, 185, (Width -14)/3 -50, 30);
    noB.layer.borderWidth = 1;
    [noB setTitle:@"无操作" forState:UIControlStateNormal];
    //noB.selected = YES;
    noB.tag = 8001;
    [noB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    noB.layer.borderColor = [UIColor blueColor].CGColor;
    [noB addTarget:self action:@selector(alertClickOn:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:noB];
    
    UIButton *NoChangeB = [UIButton buttonWithType:UIButtonTypeCustom];
    NoChangeB.frame = CGRectMake(7+ (Width -14)/3+50/3, 185 , (Width -14)/3 -50, 30);
    NoChangeB.layer.borderWidth = 1;
    NoChangeB.tag = 8002;
    [NoChangeB setTitle:@"终点停留" forState:UIControlStateNormal];
    [NoChangeB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[NoChangeB setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [NoChangeB addTarget:self action:@selector(alertClickOn:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:NoChangeB];
    
    UIButton *cycleB = [UIButton buttonWithType:UIButtonTypeCustom];
    cycleB.layer.borderWidth = 1;
    cycleB.tag = 8003;
    cycleB.frame = CGRectMake(7+ (Width -14)/3*2+50/3, 185 , (Width -14)/3 -50, 30);
    [cycleB setTitle:@"循环扫街" forState:UIControlStateNormal];
    [cycleB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cycleB setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [cycleB addTarget:self action:@selector(alertClickOn:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:cycleB];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, 218, Width-4, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.8;
    [secondView addSubview:line];
//    //提示是否扫街后终点不变
//    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(7, 55, 200, 30)];
//    lab2.text = @"扫街后是否停留终点:";
//    lab2.font = [UIFont systemFontOfSize:15];
//   // [secondView addSubview:lab2];
//    stateAl = [[UISwitch alloc]initWithFrame:CGRectMake(Width -75, 55, 75, 40)];
//    stateAl.on = 1;
//    stateAl.tag = 7000;
//    [stateAl addTarget:self action:@selector(alertClickOn:) forControlEvents:UIControlEventValueChanged];
//    //[secondView addSubview:stateAl];
//    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(7, 96 , Width-10, 0.5)];
//    line4.backgroundColor = [UIColor blackColor];
//    line4.alpha = 0.8;
//    //[secondView addSubview:line4];
//    
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(7, 210, 120, 40)];
//    lab.text = @"扫街路线是否循环";
//    lab.font = [UIFont systemFontOfSize:13];
//    //[secondView addSubview:lab];
//    //(Width -75, 55, 75, 40)
//    s = [[UISwitch alloc]initWithFrame:CGRectMake(Width -75, 210, 75, 40)];
//    [s addTarget:self action:@selector(sClick:) forControlEvents:UIControlEventValueChanged];
//    //[secondView addSubview:s];
    
    //是否开启地点提醒
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 222, 120, 30)];
    lab1.text = @"是否开启地点提醒:";
    lab1.font = [UIFont systemFontOfSize:13];
    [secondView addSubview:lab1];
    al = [[UISwitch alloc]initWithFrame:CGRectMake(Width -75, 222, 75, 40)];
    al.on = isAlertOn;
    [al addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventValueChanged];
    [secondView addSubview:al];
    
    [self.view addSubview:secondView];
    
    
    
    
    
    
    
    
    //tableView
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, setB.frame.size.height + 5 +setB.frame.origin.y, Width, Height - (setB.frame.size.height + 5 +setB.frame.origin.y+3))];
    _table.rowHeight = 90;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 44)];
    UIView *line9 = [[UIView alloc]initWithFrame:CGRectMake(7, 42 , Width-4, 0.5)];
    line9.backgroundColor = [UIColor lightGrayColor];
    line9.alpha = 0.8;
    [foot addSubview:line9];
    _table.tableHeaderView = foot;

    
    //添加和删除按钮  删除只允许删除最后一个点
    
    
    
    
    //添加
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(0, 0, Width, 35);
    UIImageView *arrow4 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 26, 11, 10, 15)];
    arrow4.image = [UIImage imageNamed:@"arrow_black"];
    [add addSubview:arrow4];
    add.tag = 1001;
    [add addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:add];
    UIImageView *setI1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
    setI1.image = [UIImage imageNamed:@"icon_location_button@2x"];
    [add addSubview:setI1];
    UILabel *setL1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 25)];
    setL1.text = @"添加";
    [add addSubview:setL1];
    [foot addSubview:add];
    //删除
    UIButton *del = [UIButton buttonWithType:UIButtonTypeCustom];
    del.frame = CGRectMake(Width - 120, secondView.frame.size.height +secondView.frame.origin.y + 3, 50, 30);
    [del setTitle:@"删除" forState:UIControlStateNormal];
    del.tag =  1002;
    [del setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [del addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:del];
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(3, secondView.frame.size.height +secondView.frame.origin.y + 36, Width, 0.5);
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.alpha = 0.8;
    //[self.view addSubview:line1];
    if (_dataForTab.count ==0) {
        del.hidden =YES;
    }
}
//保存设置
-(void)saveClick
{
    UIImageView *v = (UIImageView *)[self.view viewWithTag:7878];
    v.transform = CGAffineTransformMakeRotation(M_PI*(0)/180);
    UIView *m = (UIView *)[self.view viewWithTag:9090];
    m.hidden = YES;
    UILabel *l = (UILabel *)[self.view viewWithTag:8989];
    l.text = @"设置(红绿灯,速度,频率等)";
    [UIView beginAnimations:@"animation" context:(__bridge void *)(_table)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //(0, seg2.frame.size.height +seg2.frame.origin.y +2 , Width, 0)
    [_table setFrame:CGRectMake(0, seg2.frame.size.height +seg2.frame.origin.y + 77 , Width, Height - (seg2.frame.size.height +seg2.frame.origin.y + 77))];
    [UIView commitAnimations];
}
//设置按钮的点击
-(void)setClick :(UIButton *)sender
{
    UIImageView *v = (UIImageView *)[self.view viewWithTag:7878];
    UILabel *l = (UILabel *)[self.view viewWithTag:8989];
    secondView.alpha =1;
    if ([l.text isEqualToString:@"设置(红绿灯,速度,频率等)"]) {
        l.text = @"设置(红绿灯,速度,频率等)、";
        v.transform = CGAffineTransformMakeRotation(M_PI*(90)/180);
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_table)];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        //(0, seg2.frame.size.height +seg2.frame.origin.y +2 , Width, 0)
        [_table setFrame:CGRectMake(0, secondView.frame.size.height +secondView.frame.origin.y + 35 +2, Width, Height - (secondView.frame.size.height +secondView.frame.origin.y + 35 +2))];
        [UIView commitAnimations];
    }
    else
    {
        l.text = @"设置(红绿灯,速度,频率等)";
        v.transform = CGAffineTransformMakeRotation(M_PI*(0)/180);
        [UIView beginAnimations:@"animation" context:(__bridge void *)(_table)];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        //(0, seg2.frame.size.height +seg2.frame.origin.y +2 , Width, 0)
        [_table setFrame:CGRectMake(0, seg2.frame.size.height +seg2.frame.origin.y +77 , Width, Height - (seg2.frame.size.height +seg2.frame.origin.y +77))];
        [UIView commitAnimations];
    }

}
//开启最后到达提示
-(void)alertClick:(UISwitch *)c
{
    isAlertOn = c.on;
    NSLog(@"%d",isAlertOn);

}
//是否开启提示音开启
-(void)alertClickOn:(UIButton *)sender
{
    UIButton *b1 = (UIButton *)[self.view viewWithTag:8001];
    UIButton *b2 = (UIButton *)[self.view viewWithTag:8002];
    UIButton *b3 = (UIButton *)[self.view viewWithTag:8003];
    if (sender.tag == 8001) {
        //这时候 要是默认操作 终点不停留 不循环扫街  并且要把其他两个按钮的select设置为NO或者是改变他们两个的颜色为正常颜色
        isState = 0;
        isCycle = 0;
        [b1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        b1.layer.borderColor = [UIColor blueColor].CGColor;
        [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b2.layer.borderColor = [UIColor blackColor].CGColor;
        [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b3.layer.borderColor = [UIColor blackColor].CGColor;
    }
    if (sender.tag == 8002)
    {
        //这时候  扫街后终点停留   不循环扫街 并且要把其他两个按钮的select设置为NO或者是改变他们两个的颜色为正常颜色
        isState = 1;
        isCycle = 0;
        [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b1.layer.borderColor = [UIColor blackColor].CGColor;
        [b2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        b2.layer.borderColor = [UIColor blueColor].CGColor;
        [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b3.layer.borderColor = [UIColor blackColor].CGColor;
    }
    if (sender.tag == 8003)
    {
        //这时候  扫街后终点不停留   循环扫街 并且要把其他两个按钮的select设置为NO或者是改变他们两个的颜色为正常颜色
        isState = 0;
        isCycle = 1;
        [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b1.layer.borderColor = [UIColor blackColor].CGColor;
        [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b2.layer.borderColor = [UIColor blackColor].CGColor;
        [b3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        b3.layer.borderColor = [UIColor blueColor].CGColor;
    }
}
//频率修改
-(void)rateClick:(UIButton *)sender
{
    NSLog(@"%f",sender.frame.size.width);
    CGPoint point = CGPointMake(sender.frame.origin.x+sender.frame.size.width/2 , ((UIView*)[self.view viewWithTag:9999]).frame.origin.y + ((UIView*)[self.view viewWithTag:9999]).frame.size.height - 30);
    NSArray *titles = @[@"500ms",@"800ms",@"1s"];
    PopoverView *pop  = [[PopoverView alloc]initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        [((UIButton*)[self.view viewWithTag:2100]) setTitle:[NSString stringWithFormat:@"%@:%@",@"频率",titles[index]] forState:UIControlStateNormal];
        switch (index) {
            case 0:
                //频率
                self.rate = 0.5;
                break;
            case 1:
                //频率
                self.rate = 0.8;
                break;
            case 3:
                //频率
                self.rate = 1;
                break;
            default:
                break;
        }
    };
    [pop show];
}
#pragma datePick  时间选择器的点击方法
//触摸然后时间选择器消失
- (void)tapClick{
    [self datePickDissmiss];
}
- (void)leftBtn{
    
    [self datePickDissmiss];
}
//pickview右边确定按钮
- (void)rightBtn:(UIButton *)sender{
    
    [self datePickDissmiss];
    if (typeCurrent ==1) {
       // [((UIButton *)[self.view viewWithTag:2009]) setTitle:[NSString stringWithFormat:@"%@:               %d%@",@"扫街速度",speed,@"km"] forState:UIControlStateNormal];
        speedLab.text =[NSString stringWithFormat:@"%dkm",speed] ;
    }
    else if (typeCurrent ==0)
    {
        if (_path) {
            XuandianModel *model = _dataForTab[_path.row];
            model.time = _time;
            [dic setObject:[NSString stringWithFormat:@"%d",redWaitSeconds] forKey:[NSString stringWithFormat:@"%d",(int)_path.row]];
            [_table reloadData];
            _path = nil;
        }
        else
        {
           // [((UIButton *)[self.view viewWithTag:2008]) setTitle:[NSString stringWithFormat:@"%@:               %d%@",@"红绿灯停留时间",redWaitSeconds,@"秒"] forState:UIControlStateNormal];
            redLab.text = [NSString stringWithFormat:@"%ds",redWaitSeconds];
        }
    }
    else
    {
        //设置频率
       //[((UIButton*)[self.view viewWithTag:2100]) setTitle:[NSString stringWithFormat:@"%@:               %0.fms",@"扫街行进频率",self.rate] forState:UIControlStateNormal];
        rateLab.text = [NSString stringWithFormat:@"%.f ms",self.rate == 1?1000:self.rate];
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
#pragma markUser 用户操作部分
//确定操作
-(void)rightButtonClick
{
    //在此要算路 然后保存到数据库中
    if (_dataForTab.count >= 2) {
        [self caculerLine];
    }
}
//seg点击事件  需要改变算路方式
-(void)segClick:(UISegmentedControl *)seg1
{
    if (seg1.tag == 6000) {
        tripType = (int)seg1.selectedSegmentIndex;
        if (seg1.selectedSegmentIndex == 2) {
            seg2.userInteractionEnabled = NO;
            seg2.tintColor = [UIColor lightGrayColor];
            speed = 800;
            [((UIButton *)[self.view viewWithTag:2009]) setTitle:[NSString stringWithFormat:@"%@:%d%@",@"速度",speed,@"km"] forState:UIControlStateNormal];
            ((UIButton *)[self.view viewWithTag:2008]).titleLabel.textColor = [UIColor lightGrayColor];
            ((UIButton *)[self.view viewWithTag:2008]).userInteractionEnabled=NO;
        }
        else if(seg1.selectedSegmentIndex == 1)
        {
            seg2.userInteractionEnabled = YES ;
            seg2.tintColor = [UIColor blueColor];
            speed = 120;
            [((UIButton *)[self.view viewWithTag:2009]) setTitle:[NSString stringWithFormat:@"%@:%d%@",@"速度",speed,@"km"] forState:UIControlStateNormal];
            ((UIButton *)[self.view viewWithTag:2008]).titleLabel.textColor = [UIColor blackColor];
            ((UIButton *)[self.view viewWithTag:2008]).userInteractionEnabled=YES;
        }
        else
        {
            seg2.userInteractionEnabled = NO;
            seg2.tintColor = [UIColor lightGrayColor];
            speed = 10;
            [((UIButton *)[self.view viewWithTag:2009]) setTitle:[NSString stringWithFormat:@"%@:%d%@",@"速度",speed,@"km"] forState:UIControlStateNormal];
            ((UIButton *)[self.view viewWithTag:2008]).titleLabel.textColor = [UIColor blackColor];
            ((UIButton *)[self.view viewWithTag:2008]).userInteractionEnabled=YES;
        }
        NSLog(@"%d",(int)seg1.selectedSegmentIndex);
    }
    else
    {
        if (seg1.selectedSegmentIndex == 2) {
            linesType = 2;
        }
        else if(seg1.selectedSegmentIndex == 1)
        {
            linesType = 1;
        }
        else
        {
            linesType  = 0;
        }
        NSLog(@"%d",(int)seg1.selectedSegmentIndex);
    }
}
//是否循环的点击方法
-(void)sClick:(UISwitch *)s1
{
    isCycle = s1.on;
    NSLog(@"%d",s1.on);
}
//红绿灯按钮点击方法
-(void)btnClick:(UIButton *)sender
{
    //操作红绿灯
    if(sender.tag ==2009)
    {
        //表示当前选择的是速度按钮  那么pickview的值 相应的改变
        typeCurrent =1;
    }
    else if(sender.tag == 2008)
    {
        //此时只选择时间
        typeCurrent = 0 ;
    }
    else
    {
        //频率
        typeCurrent = 2 ;
    }
    [self makePickView];
    [self datePickShow];
}
//添加删除点的操作
-(void)changeNum:(UIButton *)sender
{
    if (sender.tag == 1001) {
        SearchViewController *search = [[SearchViewController alloc]init];
        search.index = (int)INT32_MAX;
        search.hadChoicePoints =_dataForTab;
        [self.navigationController pushViewController:search animated:YES];
    }
    if (sender.tag ==1002) {
        [_dataForTab removeLastObject];
        [_table reloadData];
    }
}
//实现添加点后的代理操作
-(void)chuanzhi:(XuandianModel *)model
{
    [KGStatusBar showWithStatus:@"添加成功"];
    //经纬度:116.385465, 39.785908
    NSLog(@"%lf  %lf",model.currentLocation.latitude,model.currentLocation.longitude);
    if (_dataForTab >0) {
        if (model.index < _dataForTab.count) {

            [_dataForTab replaceObjectAtIndex:model.index withObject:model];
        }
        else
        {
            [_dataForTab addObject:model];
        }
        ((UIButton *)[self.view viewWithTag:1002]).hidden = NO;
    }
    else
    {
        ((UIButton *)[self.view viewWithTag:1002]).hidden = YES;
    }
    [_table reloadData];
}
//修改点的驻留时间
-(void)zhuliu:(UIButton *)sender
{
    //此时只选择时间
    typeCurrent = 0;
    _pickView = nil;
    [self makePickView];
    [self datePickShow];
   _path = [_table indexPathForCell:(UITableViewCell *)sender.superview];
    NSLog(@"%@",_path);
    NSLog(@"%ld %ld",(long)_path.row,(long)_path.section);
}
#pragma tableDelegate
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
        [_dataForTab removeObjectAtIndex:indexPath.row];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [_table deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"11");
    return _dataForTab.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XuandianTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil)
    {   
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XuandianTableViewCell" owner:self options:nil]lastObject];
        
    }
    XuandianModel *model = _dataForTab[indexPath.row];
    if (model.time) {
        cell.Lab3.text = [NSString stringWithFormat:@"%@:%@",@"时间",model.time];
        
    }else{
        cell.Lab3.text = [NSString stringWithFormat:@"%@:",@"时间"];
    }
    if (model.juli) {
        cell.Lab4.text = [NSString stringWithFormat:@"%@:%@",@"距离",model.juli];
        
    }else{
        cell.Lab4.text = [NSString stringWithFormat:@"%@:",@"距离"];
    }
    if (model.weizhi) {
        cell.Lab2.text = [NSString stringWithFormat:@"%@:%@",@"位置",model.weizhi];
    }else{
        cell.Lab2.text = [NSString stringWithFormat:@"%@:",@"位置"];
    }
    
    UIButton* Zhuliu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Zhuliu.frame = CGRectMake(22, 59, 102, 20);
    [Zhuliu setTitle:@"修改驻留时间" forState:UIControlStateNormal];
    
    [cell addSubview:Zhuliu];
    [Zhuliu addTarget:self action:@selector(zhuliu:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchViewController *search = [[SearchViewController alloc]init];
    search.index = indexPath.row;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma markPickViewDelegate pickview的代理方法
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (typeCurrent==1) {
        UIView *view0;
        NSInteger row0;
        row0 = [_pickView selectedRowInComponent:0];
        view0 = [_pickView viewForRow:row0 forComponent:0];
        UILabel *label0;
        label0 =(UILabel *)[view0 viewWithTag:200];
        speed = [label0.text intValue];
    }
    else if (typeCurrent==0)
    {
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
        redWaitSeconds = [label0.text intValue]*3600 + [label1.text intValue]*60 +[label2.text intValue];
    }
    else
    {
        UIView *view0;
        NSInteger row0;
        row0 = [_pickView selectedRowInComponent:0];
        view0 = [_pickView viewForRow:row0 forComponent:0];
        UILabel *label0;
        label0 =(UILabel *)[view0 viewWithTag:200];
        self.rate = [label0.text intValue];
    }
}
//返回一共几列的值
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (typeCurrent==1) {
        return 1;
    }
    else if (typeCurrent==0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
    return 3;
}
//返回每列具体多少行
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (typeCurrent ==1) {
        if (tripType ==0) {
            return _walkSpeed.count;
        }
        else if (tripType ==1)
        {
            return _driveSpeed.count;
        }
        else
        {
            return _planSpeed.count;
        }
    }
    else if(typeCurrent ==0)
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
    }
    else
    {
        return [_rateArr count];
    }
    
    return -1;
}
//返回三列各列宽度
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (typeCurrent ==1) {
        return Width;
    }
    else if (typeCurrent ==0)
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
    }
    else
    {
        return Width;
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
    if (typeCurrent ==1) {
        if (tripType ==0) {
            txtlabel.text =_walkSpeed[row];
            txtlabel.textAlignment = NSTextAlignmentCenter;
        }
        else if (tripType ==1)
        {
            txtlabel.text =_driveSpeed[row];
            txtlabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            txtlabel.text =_planSpeed[row];
            txtlabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else if (typeCurrent ==0)
    {
        if(component== 0)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr1 objectAtIndex:row],@"时"];
        }
        else if(component==1)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr2 objectAtIndex:row],@"分"];
        }
        else if(component==2)
        {
            txtlabel.text =[NSString stringWithFormat:@"%@%@",[_arr3 objectAtIndex:row],@"秒"];
        }
    }
    else
    {
        txtlabel.text =_rateArr[row];
        txtlabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return myView;
    return nil;
}
//点击确定按钮的时候开始算路
-(void)caculerLine
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[红绿灯时间:秒]" options:0 error:NULL];
    NSString *string = ((UIButton *)[self.view viewWithTag:2008]).titleLabel.text;
    NSString *result = [regular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSLog(@"%@", result);
    if (_dataForTab.count>1) {
        //在此可以展示用户本条路线的基本信息
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此路线扫街方式:%@ \n 红绿灯停留:%d秒\n扫街方式:%@\n是否开启地点提醒:%@",tripType ==0 ?@"步行":(tripType == 1?@"驾车":@"飞机"),[result intValue],isCycle==1?@"循环扫街":@"不循环扫街",isAlertOn==0?@"否":@"是"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
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
//飞机算法
-(void)getLinesByPlan
{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status==AFNetworkReachabilityStatusNotReachable) {
             [MyAlert ShowAlertMessage:@"请检查网络连接" title:@"温馨提示"];
             return;
         }
         
         if (single< _dataForTab.count -1)
         {
             CLLocationCoordinate2D start2D;
             CLLocationCoordinate2D end2D;
             if (WhitchLanguagesIsChina) {
                 start2D = [self hhTrans_GCGPS:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single]).currentLocation)];
                 end2D = [self hhTrans_GCGPS:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single +1]).currentLocation)];
             }
             else
             {
                 start2D = ((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single]).currentLocation);
                 end2D= ((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single +1]).currentLocation);
             }
             NSArray *a1 =[[TXYTools sharedTools] cutWithFromCoor:start2D andToCoor:end2D andLength:200];
             [_valueArPLan addObjectsFromArray:a1];
             if(_valueArPLan.count==0)
             {
                 NSValue *start2DV =[NSValue value:&start2D withObjCType:@encode(CLLocationCoordinate2D)];
                 NSValue *end2DV = [NSValue value:&end2D withObjCType:@encode(CLLocationCoordinate2D)];
                 [_valueArPLan addObjectsFromArray:@[start2DV,end2DV]];
             }
             for(int i=0;i<_valueArPLan.count;i++){
                 CLLocationCoordinate2D c;
                 NSValue *value = _valueArPLan[i];
                 [value getValue:&c];
                 CLLocationCoordinate2D touchMapCoordinate = c;
                 // XuandianModel *model = [[XuandianModel alloc]init];
                 DBResultModel model;
                 model.latitude =[self hhTrans_bdGPS:touchMapCoordinate].latitude;
                 model.longtitude = [self hhTrans_bdGPS:touchMapCoordinate].longitude;
                 //model.indexInStep = i;
                 model.x = MKMapPointForCoordinate(c).x;
                 model.y = MKMapPointForCoordinate(c).y;
                 model.ScanRate = self.rate;
                 model.isCycle = isCycle;
                 model.waiteSeconds = 0;
                 //第几次添加的点
                 //model.index = tripType;
                 //model.whichbundle = self.boundle;
                 model.alert = 0;
                 if (i == _valueArPLan.count -1) {
                     model.alert = isAlertOn;
                 }
                 temPointsNum =(int) _linesData.count;
                 NSData *msgData = [[NSData alloc]initWithBytes:&model length:sizeof(DBResultModel)];
                 [_linesData addObject:msgData];
             }
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
                 ((XuandianModel *)_dataForTab[0]).alertOn = model.alert;
                 ((XuandianModel *)_dataForTab[0]).speed = speed;
                 ((XuandianModel *)_dataForTab[1]).x = model1.x;
                 ((XuandianModel *)_dataForTab[1]).y = model1.y;
                 ((XuandianModel *)_dataForTab[1]).isCycle = model1.isCycle;
                 ((XuandianModel *)_dataForTab[1]).redWaitSeconds =redWaitSeconds;
                 ((XuandianModel *)_dataForTab[1]).ScanRate = model1.ScanRate;
                 ((XuandianModel *)_dataForTab[1]).alertOn = model1.alert;
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
             }
             [_valueArPLan removeAllObjects];
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
             if (WhitchLanguagesIsChina) {
                 [self requestRoutWithSoure:[self hhTrans_GCGPS:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single]).currentLocation)] Destination:[self hhTrans_GCGPS:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single +1]).currentLocation)]];
             }
             else
             {
                 [self requestRoutWithSoure:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single]).currentLocation) Destination:((CLLocationCoordinate2D)((XuandianModel *)_dataForTab[single +1]).currentLocation)];
             }
         }
         else
         {
             [self saveDataToDB];
         }
     }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}
//存储数据到数据库
-(void)saveDataToDB
{
    //在这里得到数据 _linesData
    jh.label.text=@"正在存储";
    DataBaseManager *dataManager = [DataBaseManager shareInatance];
    if ([dataManager isExistRecordWithID:self.boundle]) {
        [dataManager deleteCurrentLines:self.boundle];
    }
    BOOL result = NO;
    if (_linesData.count >0) {
      result = [dataManager saveFileRecordWithBoundle:self.boundle withNsarry:_linesData withType:[NSString stringWithFormat:@"%d",self.tripType] withIsCycle:[NSString stringWithFormat:@"%d",isCycle]withPotions:_dataForTab];
        if (result == NO) {
            [jh hide];
            [MyAlert ShowAlertMessage:@"线路存储失败" title:@"温馨提示"];
            return;
        }
    }
    else
    {
        [jh hide];
        [MyAlert ShowAlertMessage:@"请检查网络连接" title:@"温馨提示"];
        return;
    }
    [jh hide];
    self.tabBarController.selectedIndex = 2;
    [self.delegate refrush];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//百度坐标转换为火星坐标
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps
{
    CLLocationCoordinate2D googleGps;
    //0.065
    long double bd_x=baiduGps.longitude - 0.0065;
    long double bd_y=baiduGps.latitude - 0.006;
    long double z =(long double)sqrt(bd_x * bd_x + bd_y * bd_y) -(long double)0.00002 * sin(bd_y * x_pi);
    long double theta = (long double)atan2(bd_y, bd_x) - (long double)0.000003 * cos(bd_x * x_pi);
    googleGps.longitude = (long double)z * cos(theta);
    googleGps.latitude = (long double)z * sin(theta);
    return googleGps;
}
//火星转换为百度坐标
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
//百度 google公用一种方法   仅限于计算步行 和驾车
-(void)requestRoutWithSoure:(CLLocationCoordinate2D) start2D  Destination:(CLLocationCoordinate2D)end2D
{
   NSLog(@"初始点经纬度:%f %f   末点经纬度: %f  %f",start2D.latitude,start2D.longitude,end2D.latitude,end2D.longitude);
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    directionsRequest.transportType = tripType ==0?MKDirectionsTransportTypeWalking:MKDirectionsTransportTypeAutomobile;
    directionsRequest.requestsAlternateRoutes = YES;
    MKPlacemark *startMark = [[MKPlacemark    alloc] initWithCoordinate:start2D addressDictionary:nil];
    MKPlacemark *endMark = [[MKPlacemark    alloc] initWithCoordinate:end2D addressDictionary:nil];
    
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMark];
    
    [directionsRequest setSource:startItem];
    [directionsRequest setDestination:endItem];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    //接收rout
    jh.label.text=@"正在请求中...";
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         NSLog(@"%@",[NSThread mainThread]);
         if (error) {
             [MyAlert ShowAlertMessage:@"线路规划失败" title:@"温馨提示"];
             NSLog(@"directions error:%@", error);
         }
         else
         {
             if(response.routes.count > 0)
             {
                 NSLog(@"总共有%d路线",response.routes.count);
                 MKRoute *route;
                 
                 if (response.routes.count >= linesType) {
                     route = response.routes[linesType];
                 }
                 else
                 {
                     route = response.routes[0];
                 }
                 int size = (int)route.steps.count;
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
                     for(int i=0;i<p.pointCount-1;i++){
                         
                         CLLocation *start= [[CLLocation alloc]initWithLatitude:MKCoordinateForMapPoint(point[i]).latitude longitude:MKCoordinateForMapPoint(point[i]).longitude];
                         CLLocation *end= [[CLLocation alloc]initWithLatitude:MKCoordinateForMapPoint(point[i+1]).latitude longitude:MKCoordinateForMapPoint(point[i+1]).longitude];
                         [_valueWalkORDrive removeAllObjects];
                         [self chargeDasticencewithstarCLL:start withEndCLL:end];
                         for(int m=0;m<_valueWalkORDrive.count;m++){
                             CLLocationCoordinate2D c;
                             NSValue *value = _valueWalkORDrive[m];
                             [value getValue:&c];
                             if (c.latitude!=0&&c.longitude!=0) {
                                 DBResultModel model;
                                 model.latitude =[self hhTrans_bdGPS:c].latitude;
                                 model.longtitude = [self hhTrans_bdGPS:c].longitude;
                                 model.x = MKMapPointForCoordinate(c).x;
                                 model.y = MKMapPointForCoordinate(c).y;
                                 model.ScanRate = self.rate;
                                 model.isState = isState;
                                 model.isCycle = isCycle;
                                 //MKMapPoint pointC = MKMapPointForCoordinate(c);
                                 NSLog(@"%d   %d",p.pointCount,i);
                                 if (i == p.pointCount - 2 && m ==_valueWalkORDrive.count -1) {
                                     model.isWaitPoint = 1;
                                     model.waiteSeconds = redWaitSeconds;
                                     model.alert = 0;
                                 }
                                 else
                                 {
                                     model.alert = 0;
                                     if (m==0) {
                                         //判断起始点是否修改过等待时间  并确定是第几个点
                                         if (dic) {
                                             if ([[dic allKeys]containsObject:[NSString stringWithFormat:@"%d",k]]) {
                                                 model.isWaitPoint = 1;
                                                 model.waiteSeconds = [dic[[NSString stringWithFormat:@"%d",k]]intValue];
                                             }else
                                             {
                                                 model.isWaitPoint = 1;
                                                 model.waiteSeconds  = 0;
                                             }
                                         }
                                     }
                                     else
                                     {
                                         model.isWaitPoint = 0;
                                         model.waiteSeconds = 0;
                                     }
                                 }
                                 if (k ==size -1 &&m ==_valueWalkORDrive.count -1&&i == p.pointCount - 2) {
                                     model.alert = isAlertOn;
                                 }
                                 model.whichbundle = (char*)[self.boundle UTF8String];
                                 model.redWaitSeconds = redWaitSeconds;
                                 //                             NSValue *value=[NSValue valueWithBytes:&model objCType:@encode(DBResultModel)];
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
                 [MyAlert ShowAlertMessage:@"线路规划失败" title:@"温馨提示"];
             }
         }
         single++;
         [self getLines];
     }];
    
}
-(void)chargeDasticencewithstarCLL:(CLLocation *)start withEndCLL:(CLLocation *)end
{
    NSArray *a1 =[[[TXYTools sharedTools] cutWithFromCoor:start.coordinate andToCoor:end.coordinate andLength:speed/3.6*self.rate] copy];
    int num = (int)a1.count;
    for (int m = 0; m<num; m++) {
        if (single == 0||single == _dataForTab.count -2) {
            [_valueWalkORDrive addObject:a1[m]];
        }
        else
        {
            if (0<m<num) {
                [_valueWalkORDrive addObject:a1[m]];
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)chuanLines:(NSArray *)arr
{
    [_dataForTab removeAllObjects];
    for(XuandianModel *model in arr)
    {
        MKMapPoint point;
        point.x = model.x;
        point.y = model.y;
        if (WhitchLanguagesIsChina) {
            //国内地图
            CLLocationCoordinate2D c =[self hhTrans_bdGPS:MKCoordinateForMapPoint(point)];
            model.currentLocation = c;
        }
        else
        {
            //国外地图
            CLLocationCoordinate2D c = MKCoordinateForMapPoint(point);
            model.currentLocation = c;
        }
        [_dataForTab addObject:model];
    }
    [_table reloadData];
}
-(void)chuanzhiGPS:(XuandianModel *)model
{
    model.currentLocation =[self hhTrans_bdGPS:[[FireToGps sharedIntances]gcj02Encrypt:[model.latitudeNum doubleValue] bdLon:[model.longitudeNum doubleValue]]] ;
   // model.currentLocation = CLLocationCoordinate2DMake([model.latitudeNum doubleValue], [model.longitudeNum doubleValue]);
   // model.currentLocation = cu;
    NSLog(@"%lf  %lf",model.currentLocation.latitude,model.currentLocation.longitude);
    if (_dataForTab.count >0) {
        if (model.index < _dataForTab.count) {
            XuandianModel *model1 = [_dataForTab lastObject];
            MKMapPoint po1 = MKMapPointForCoordinate(model1.currentLocation);
            MKMapPoint po2 = MKMapPointForCoordinate(model.currentLocation);
            int dis = MKMetersBetweenMapPoints(po1,po2);
            if (dis >1000) {
                model.juli = [NSString stringWithFormat:@"%dkm",dis];
            }
            else
            {
                model.juli = [NSString stringWithFormat:@"%dm",dis];
            }
            [_dataForTab replaceObjectAtIndex:model.index withObject:model];
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
        ((UIButton *)[self.view viewWithTag:1002]).hidden = NO;
    }
    else
    {
        model.juli = @"0 km";
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        model.time = locationString;
        ((UIButton *)[self.view viewWithTag:1002]).hidden = YES;
        [_dataForTab addObject:model];
    }
    [_table reloadData];
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
