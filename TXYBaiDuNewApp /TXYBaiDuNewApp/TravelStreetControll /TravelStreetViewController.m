//
//  TravelStreetViewController.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "TravelStreetViewController.h"
#import <MapKit/MapKit.h>
#import "ChooseAPPViewController.h"
#import "SearchViewController.h"
#import "DataBaseManager.h"
#import "AppManage.h"
#import "ProgressHUD.h"
#import "TXYConfig.h"
#import "TravelStreetModel.h"
#import "SimpleOperation.h"
//#import "ChooseTypeViewController.h"
#import "MySaveDataManager.h"
#import "TXYTools.h"
#import "MyAlert.h"
#import "TotleShowLineViewController.h"
#import "MapTypeDataManager.h"
#import "ScanPointManager.h"
#define ISiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0&&[[UIDevice currentDevice].systemVersion doubleValue]<8.0)
@interface TravelStreetViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,YYdownLoadOperationDelegate,UIAlertViewDelegate>{
    UITableView *_table;
    NSMutableArray *_appsData;
    DataBaseManager *dataManager;
    MapTypeDataManager *mapManager;
    NSOperationQueue *queue;
    NSMutableArray *_dataForTab;
    UIAlertView *showAlert;
    UISwitch *c1;
    //点击的是哪个cell
    int whichIndex;
    //目前扫街扫到哪一步
    int CurrentIndex;
    //判断是否是在扫街过程中点击删除
    int isDel;
    //判断暂停的状态
    int Stop;
    //设置一个字段来控制showline界面的暂停按钮
    int ztOn;
}
@end

@implementation TravelStreetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    whichIndex = 0;
    CurrentIndex = 0;
    isDel = 0;
    ztOn = 0;
    _appsData = [NSMutableArray arrayWithCapacity:0];
    _dataForTab = [NSMutableArray arrayWithCapacity:0];
    queue = [[NSOperationQueue alloc]init];
    [self makeView];
    [self getModel];
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(getMessageFormShowLine:) name:@"stop" object:nil];
}
//获取数据
-(void)getModel
{
    [_dataForTab removeAllObjects];
    dataManager = [DataBaseManager shareInatance];
    mapManager = [MapTypeDataManager shareInatance];
    if (![dataManager chargeListInDB])
    {
        [dataManager creatTabel];
    }
    [[AppManage sharedAppManage]getAllAppArray];
    _appsData =[NSMutableArray arrayWithArray:[[dataManager getAppsFromDB] copy]];
    NSLog(@"%@",_appsData);
    for (int i =0; i < _appsData.count; i++) {
        TravelStreetModel *model1 = [[TravelStreetModel alloc]init];
        NSString *whichMap = [mapManager  getWhichMapWith:_appsData[i]];
        NSLog(@"whichMap is %@",whichMap);
        if (whichMap) {
            if ([whichMap isEqualToString:@"baidu"]) {
                model1.whichMap = @"百度";
            }
            if ([whichMap isEqualToString:@"tencent"]) {
                model1.whichMap = @"腾讯";
            }
            if ([whichMap isEqualToString:@"google"]) {
                model1.whichMap = @"谷歌";
            }
        }
        else
        {
            model1.whichMap = @"百度";
        }
        model1.type =  [[dataManager chargeWhichType:_appsData[i]] intValue]==0?@"步行":([[dataManager chargeWhichType:_appsData[i]] intValue]==1?@"驾车":@"飞机");
        model1.textName = [NSString stringWithFormat:@"%@%@%@:%@%@%@:%@",[[AppManage sharedAppManage] getAppNameForBundleId:_appsData[i]],@"\n",@"出行方式",model1.type,@"\n",@"地图类型",model1.whichMap];
        model1.image = [[AppManage sharedAppManage] getIconForBundleId:_appsData[i]];
        model1.on = 0;
       
        if (![[AppManage sharedAppManage] getAppNameForBundleId:_appsData[i]]) {
            [dataManager deleteCurrentLines:_appsData[i]];
        }
        else
        {
            [_dataForTab addObject:model1];
        }
       
    }
    [_table reloadData];
}
//码UI
- (void)makeView{
    self.title = @"扫街";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bus_addSelec.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tsButtonClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    _table = [[UITableView alloc]init];
    
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    _table.frame=CGRectMake(0, 0, W, H + self.tabBarController.tabBar.frame.size.height - 10);
    if (!iOS7) {
        CGFloat H=self.view.frame.size.height-44;
        _table.frame=CGRectMake(0, 0, W, H);
    }
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _table.delegate = self;
    _table.dataSource = self;
    _table.rowHeight = 60;
    [self.view addSubview:_table];
    
    showAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看详情",@"修改配置",@"收藏路线" ,nil];
}
#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"array = %@",_appsData);
    return _dataForTab.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; 
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //[cell.contentView respondsToSelector:@selector(removeFromSuperview)];
    
    TravelStreetModel *model = _dataForTab[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = model.textName;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines=0;
    CGSize itemSize = CGSizeMake(45, 45);
    
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [model.image drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSLog(@"%f  %f",cell.frame.size.height,cell.frame.size.width);
    c1 = [[UISwitch alloc]initWithFrame:CGRectMake(Width - 55, 15, 51, 31)];
    c1.tag = 2000+indexPath.row;
    c1.on = model.on;
    [c1 addTarget:self action:@selector(cClick:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:c1];
    return cell;
}
/**
 *  判断switch  把任务添加到queue中
 *
 *  @param c switch
 */
-(void)cClick:(UISwitch *)c{
    if ([[TXYConfig sharedConfig] getToggle]&&[[TXYTools sharedTools] isCanOpen]) {
        UITableViewCell *cell=nil;
        if (ISiOS7) {
            cell  = (UITableViewCell*)c.superview.superview.superview;
        }else
        {
            cell  = (UITableViewCell*)c.superview.superview;
        }
        NSIndexPath *path = [_table indexPathForCell:cell];
        TravelStreetModel *model = _dataForTab[path.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@:%@\n地图类型:%@",[[AppManage sharedAppManage] getAppNameForBundleId:_appsData[path.row]],@"\n",@"扫街状态",c.on ==1?@"开":@"关",model.whichMap];
        [queue setMaxConcurrentOperationCount:1000];
        NSLog(@"%ld",(long)c.tag);
        if (c.on == YES) {
            ztOn = 1;
            DataBaseManager *dataManager1 = [DataBaseManager shareInatance];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            arr =  [NSMutableArray arrayWithArray:[dataManager1 getLinesFrom:_appsData[path.row]]];
            if(arr.count>0)
            {
                SimpleOperation *operation = [[SimpleOperation alloc]initWithObject:c withIndexRow:(int)path.row withArr:arr withWhichBoundle:_appsData[path.row]];
                NSLog(@"%d",operation.isReady);
                operation.delegate = self;
                [queue addOperation:operation];
            }
        }
        else
        {
            ztOn = 0;
            UITableViewCell  *cell;
            if (iOS8) {
                cell  = (UITableViewCell*)c.superview.superview;
            }else{
                cell = (UITableViewCell*)c.superview.superview.superview;
            }
            
            NSLog(@"%@",c.superview.superview.class);
            NSIndexPath *path = [_table indexPathForCell:cell];
            for(SimpleOperation *op in queue.operations)
            {
                NSLog(@"%@",op.whichSingle);
                if ([_appsData indexOfObject:op.whichSingle] == path.row) {
                    ScanPointManager *mangager = [ScanPointManager defaultManager];
                    [mangager.dic removeObjectForKey:[_appsData[path.row] stringByReplacingOccurrencesOfString:@"." withString:@""]];
                    [op cancel];
                    NSLog(@"%@",queue.operations);
                }
            }
        }
    }
    else if([[TXYConfig sharedConfig] getToggle]==0)
    {
        c.on=!c.on;
        [KGStatusBar showWithStatus:@"请打开地图界面开关"];
        return;
    }
    
}
/**
 *  刷新数据
 *  在取消操作的时候 需要改变cell的样式
 *  @param row 通过row来修改数据
 */
-(void)refreshWithRow:(NSString *)bundle{
    TravelStreetModel *model =   _dataForTab[[_appsData indexOfObject:bundle]];
    model.textName = [NSString stringWithFormat:@"%@%@%@:%@\n地图类型:%@",[[AppManage sharedAppManage] getAppNameForBundleId:_appsData[[_appsData indexOfObject:bundle]]],@"\n",@"扫街状态",c1.on ==1?@"开":@"关",model.whichMap];
    model.on = NO;
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_appsData indexOfObject:bundle] inSection:0];
    UITableViewCell  *cell  = [_table cellForRowAtIndexPath:path];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@:%@\n地图类型:%@",[[AppManage sharedAppManage] getAppNameForBundleId:_appsData[[_appsData indexOfObject:bundle]]],@"\n",@"扫街状态",@"关",model.whichMap];
    for (UIView *w in cell.contentView.subviews) {
        if ([w isKindOfClass:[UISwitch class]]) {
            UISwitch *current = (UISwitch *)w;
            current.on = NO;
        }
    }
}
//接受到来自showline页面的通知 需要暂停或者恢复
-(void)getMessageFormShowLine:(NSNotification *)sender
{
    //NSLog(@"收到通知");
    NSDictionary *dic = (NSDictionary *)sender.object;
    //判断是开始开始还是暂停
    int isStop = [dic[@"isStop"] integerValue];
    //在这里执行暂停操作
    NSString *whichOp = dic[@"bundle"];
    if (isStop == 1) {
        for(SimpleOperation *op in queue.operations)
        {
            NSLog(@"%@",op.whichSingle);
            if ([op.whichSingle isEqualToString:whichOp]) {
                op.isStop = 1;
                Stop = 1;
            }
        }
    }
    //在这里执行恢复操作
    if (isStop == 0) {
        for(SimpleOperation *op in queue.operations)
        {
            NSLog(@"%@",op.whichSingle);
            if ([op.whichSingle isEqualToString:whichOp]) {
                op.isStop = 0;
                Stop = 0;
            }
        }
    }
}
-(void)cancleAll
{
    NSLog(@"%@",queue.operations);
    for(SimpleOperation *op in queue.operations)
    {
        NSLog(@"%@",queue.operations);
        if (op) {
            op.AllCancle = 1;
            [op cancel];
        }
    }
    [_table reloadData];
}
/**
 *  获取监听刷新ui
 *
 *  @param notification 监听
 */
//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    whichIndex = (int)indexPath.row;
    //默认中文
    [ProgressHUD show:@"正在加载中....."];
    TotleShowLineViewController *showBD = [[TotleShowLineViewController alloc]init];
    showBD.bundle = _appsData[whichIndex];
    showBD.appName= [[AppManage sharedAppManage] getAppNameForBundleId:_appsData[whichIndex]];
    showBD.CurrentIndex = CurrentIndex;
    showBD.queue =queue;
    showBD.Stop = Stop;
    showBD.ztOnShowLine = ztOn;
    showBD.typeShowLine  = [dataManager chargeWhichType:_appsData[whichIndex]];
    dataManager = [DataBaseManager shareInatance];
    showBD.isCycle = [dataManager chargeIsCycle:_appsData[whichIndex]];
    showBD.index = whichIndex;
    showBD.delegate = self;
    showBD.whichMap = [mapManager getWhichMapWith:_appsData[whichIndex]];
    [self.navigationController pushViewController:showBD animated:YES];
    [ProgressHUD showSuccess:@"加载完成"];
}
//跳转扫街
- (void)tsButtonClick{
    NSString *str = WhichMap;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:WhichMap];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
//   NSString * which = [plistDict objectForKey:@"WhichMap"];
//    if (![which isEqualToString:@"google"]) {
//        
//    }
//    else
//    {
//        [MyAlert ShowAlertMessage:@"该地图不支持扫街" title:@"温馨提示"];
//    }
    if ([[TXYConfig sharedConfig]getToggle]) {
        ChooseAPPViewController* chavc = [[ChooseAPPViewController alloc]init];
        [self.navigationController pushViewController:chavc animated:YES];
    }
    else if ([[TXYConfig sharedConfig]getToggle]==0){
        [KGStatusBar showWithStatus:@"请打开地图界面开关"];
        return;
    }
//    ChooseAPPViewController* chavc = [[ChooseAPPViewController alloc]init];
//    [self.navigationController pushViewController:chavc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//删除某一行数据
-(void)DelCellAtIndex:(NSString *)bundle
{
    [KGStatusBar showWithStatus:@"删除成功"];
    [_dataForTab removeObjectAtIndex:[_appsData indexOfObject:bundle]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_appsData indexOfObject:bundle] inSection:0];
    [_table deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
    isDel = 1;
    [_appsData removeObject:bundle];
}
//新添加路线的时候的回调
-(void)refrush{
    NSMutableArray *newArr =[NSMutableArray arrayWithArray:[[dataManager getAppsFromDB] copy]];
    NSLog(@"%@",_appsData);
    [newArr removeObjectsInArray:_appsData];
    TravelStreetModel *model1 = [[TravelStreetModel alloc]init];
    if([newArr lastObject])
    {
       [_appsData addObject:[newArr lastObject]];
        NSString *whichMap = [mapManager  getWhichMapWith:[newArr lastObject]];
        NSLog(@"whichMap is %@",whichMap);
        if (whichMap) {
            if ([whichMap isEqualToString:@"baidu"]) {
                model1.whichMap = @"百度";
            }
            if ([whichMap isEqualToString:@"tencent"]) {
                model1.whichMap = @"腾讯";
            }
            if ([whichMap isEqualToString:@"google"]) {
                model1.whichMap = @"谷歌";
            }
        }
        else
        {
            model1.whichMap = @"百度";
        }
        model1.type =  [[dataManager chargeWhichType:[newArr lastObject]] intValue]==0?@"步行":([[dataManager chargeWhichType:[newArr lastObject]] intValue]==1?@"驾车":@"飞机");
        model1.textName = [NSString stringWithFormat:@"%@%@%@:%@%@%@:%@",[[AppManage sharedAppManage] getAppNameForBundleId:[newArr lastObject]],@"\n",@"出行方式",model1.type,@"\n",@"地图类型",model1.whichMap];
        model1.image = [[AppManage sharedAppManage] getIconForBundleId:[newArr lastObject]];
        model1.on = 0;
        [_dataForTab addObject:model1];
        NSIndexPath *path = [NSIndexPath indexPathForRow:_dataForTab.count-1 inSection:0];
        [_table insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"算路失败,请检查网络" title:@"温馨提示"];
    }
    
}
-(void)refrushWith:(NSString *)bundle
{
    int index =   [_appsData indexOfObject:bundle];
    TravelStreetModel *model2 = _dataForTab[index];
    //NSLog(@"%@",[model2 class]);
    TravelStreetModel *model1 = [[TravelStreetModel alloc]init];
    if(bundle)
    {
        NSString *whichMap = [mapManager  getWhichMapWith:bundle];
        NSLog(@"whichMap is %@",whichMap);
        if (whichMap) {
            if ([whichMap isEqualToString:@"baidu"]){
                model1.whichMap = @"百度";
                model2.whichMap = @"百度";
            }
            if ([whichMap isEqualToString:@"tencent"]){
                model1.whichMap = @"腾讯";
                model2.whichMap = @"腾讯";
            }
            if ([whichMap isEqualToString:@"google"]) {
                model1.whichMap = @"谷歌";
                model2.whichMap = @"谷歌";
            }
        }
        else
        {
            model1.whichMap = @"百度";
            model2.whichMap = @"百度";
        }
//        model2.whichMap  = whichMap;
        model1.type =  [[dataManager chargeWhichType:bundle] intValue]==0?@"步行":([[dataManager chargeWhichType:bundle] intValue]==1?@"驾车":@"飞机");
        model1.textName = [NSString stringWithFormat:@"%@%@%@:%@%@%@:%@",[[AppManage sharedAppManage] getAppNameForBundleId:bundle],@"\n",@"出行方式",model1.type,@"\n",@"地图类型",model1.whichMap];
        model1.image = [[AppManage sharedAppManage] getIconForBundleId:bundle];
        model1.on = 0;
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell  *cell  = [_table cellForRowAtIndexPath:path];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@:%@%@%@:%@",[[AppManage sharedAppManage] getAppNameForBundleId:bundle],@"\n",@"出行方式",model1.type,@"\n",@"地图类型",model1.whichMap];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"算路失败,请检查网络" title:@"温馨提示"];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    _table.hidden=NO;
    self.view.backgroundColor = [UIColor whiteColor];
   // [self getModel];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString *str = WhichMap;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:WhichMap];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
/*    NSString * which = [plistDict objectForKey:@"WhichMap"];
    if ([which isEqualToString:@"google"]) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"谷歌地图暂不支持扫街" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlert show];
    }*/
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.tabBarController.selectedIndex = 0;
}
- (void)viewWillDisappear:(BOOL)animated{
    _table.hidden = YES;
}
@end
