//
//  CollectViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"
#import "CollectModel.h"
#import "EditViewController.h"
#import "XuandianModel.h"
#import "MySaveDataManager.h"
#import "TXYConfig.h"
#import "XuandianModel.h"
#import "ProgressHUD.h"
#import "JKAlertDialog.h"
#import "TotleScanViewController.h"
@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int single;
    NSMutableArray *arrForAlert;
}
@property UIButton* button1;
@property UIButton* button2;
@property UIButton* button3;

@property BOOL isEdit;

@property UIView* btnView;
@property UITableView* tableView;
@property NSMutableArray* dataArr;

@property UIBarButtonItem* item;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       arrForAlert = [NSMutableArray arrayWithCapacity:0];
    single = 0;
    self.title = @"收藏夹";
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    
    NSArray* array = [userPoint objectForKey:@"collect"];
    NSMutableArray* userArray = nil;
    if (array == nil){
        userArray = [NSMutableArray array];
    }else{
        userArray = [NSMutableArray arrayWithArray:array];
    }
    
    _dataArr = [NSMutableArray arrayWithArray:userArray];
    
    _isEdit = NO;
    [self makeView];
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@",((UINavigationController*)(self.tabBarController.viewControllers[0])).viewControllers);
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
    NSString* whichMap = [plistDict objectForKey:@"WhichMap"];
    [_dataArr removeAllObjects];
    if (single ==0) {
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        NSArray* array = [userPoint objectForKey:@"collect"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        //腾讯或者百度的收藏共享
        if ([whichMap isEqualToString:@"tencent"]||[whichMap isEqualToString:@"baidu"]||!whichMap) {
            for (int i = 0; i<userArray.count; i++) {
                NSMutableDictionary* dict = userArray[i];
                if ([dict[@"whichMap"] isEqualToString:@"baidu"]||(!dict[@"whichMap"])||[dict[@"whichMap"] isEqualToString:@"tencent"]) {
                    [_dataArr addObject:dict];
                }
            }
        }
        //谷歌单独收藏
        if ([whichMap isEqualToString:@"google"]) {
            for (int i = 0; i<userArray.count; i++) {
                NSMutableDictionary* dict = userArray[i];
                if ([dict[@"whichMap"] isEqualToString:@"google"]) {
                    [_dataArr addObject:dict];
                }
            }
        }
        [_tableView reloadData];
    }
    else
    {
        MySaveDataManager *manager = [MySaveDataManager shareInatance];
        [_dataArr removeAllObjects];
        _dataArr = [NSMutableArray arrayWithArray:[[manager getPotionsDate] copy]] ;
        [_tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    _isMap = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [_tableView reloadData];
}

- (void)makeView{
    
    //提示框
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, 270, 200) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.editing = NO;
    _table.tag=6666;
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnView = [[UIView alloc]init];
    _tableView = [[UITableView alloc]init];
    _tableView.tag = 7777;
    //假设是在地图选点 则有编辑按钮 假设是添加收藏夹的点 则不能编辑
    if (!_isMap) {
        //        _item = [[UIBarButtonItem alloc]initWithTitle:CustomLocalizedString(@"编辑", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editBtn)];
        _item =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"default_layers_photo_editbtn_highlighted.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editBtn)];
        self.navigationItem.rightBarButtonItem = _item;
        _item.tag = 5000;
    }
    
    _btnView.backgroundColor  = [UIColor blueColor];
    _button1.frame = CGRectMake(0, 64, Width / 2, 44);
    _button2.frame = CGRectMake(Width / 2, 64, Width / 2, 44);
    _btnView.frame = CGRectMake(0, 104, Width /2, 1);
    _tableView.frame = CGRectMake(0, 44, Width, Height - 44);
    [_button1 setTitle:@"收藏地点" forState:UIControlStateNormal];
    [_button2 setTitle:@"收藏路线" forState:UIControlStateNormal];
    
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_button1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_button2 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    [_button1 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_button2 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    _button1.selected = YES;
    
    
    _button1.backgroundColor = [UIColor whiteColor];
    _button2.backgroundColor = [UIColor whiteColor];
    
    [_button1 addTarget:self action:@selector(button1Cli) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(button2Cli) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    // _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.allowsSelectionDuringEditing = YES;
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_button1];
    [self.view addSubview:_button2];
    [self.view addSubview:_btnView];
}

//编辑按钮
- (void)editBtn{
    if (_item.tag == 5000) {
        _item.tag = 5001;
        
        _isEdit = YES;
        [_item setImage:[UIImage imageNamed:@"default_feedback_icon_clicked_hl@2x.png"]];
        [_tableView setEditing:YES animated:YES];
    }else{
        _isEdit = NO;
        _item.tag = 5000;
        [_item setImage:[UIImage imageNamed:@"default_layers_photo_editbtn_highlighted@2x.png"]];
        [_tableView setEditing:NO animated:YES];
    }
}

//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag!=6666) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (single == 0) {
                [_dataArr removeObjectAtIndex:indexPath.row];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //保存到本地
                NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
                [userPoint setObject:_dataArr forKey:@"collect"];
                [userPoint synchronize];
            }
            else
            {
                //删除数据库中的收藏路线
                MySaveDataManager *manager = [MySaveDataManager shareInatance];
                if ([manager deleteCollectionLines:_dataArr[indexPath.row]]) {
                    [ProgressHUD showSuccess:@"删除成功"];
                    [_dataArr removeObjectAtIndex:indexPath.row];
                   // _dataArr removeObjectAtIndex:<#(NSUInteger)#>
                    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
    }
}



//收藏地点
- (void)button1Cli{
    single = 0;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_btnView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_btnView setFrame:CGRectMake(0, 104, Width / 2, 1 )];
    _button1.selected = YES;
    _button2.selected = NO;
    [UIView commitAnimations];
    
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
    NSString* whichMap = [plistDict objectForKey:@"WhichMap"];
    [_dataArr removeAllObjects];
    NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userPoint objectForKey:@"collect"];
    NSMutableArray* userArray = nil;
    if (array == nil){
        userArray = [NSMutableArray array];
    }else{
        userArray = [NSMutableArray arrayWithArray:array];
    }
    //腾讯或者百度的收藏共享
    if ([whichMap isEqualToString:@"tencent"]||[whichMap isEqualToString:@"baidu"]||!whichMap) {
        for (int i = 0; i<userArray.count; i++) {
            NSMutableDictionary* dict = userArray[i];
            if ([dict[@"whichMap"] isEqualToString:@"baidu"]||(!dict[@"whichMap"])||[dict[@"whichMap"] isEqualToString:@"tencent"]) {
                [_dataArr addObject:dict];
            }
        }
    }
    //谷歌单独收藏
    if ([whichMap isEqualToString:@"google"]) {
        for (int i = 0; i<userArray.count; i++) {
            NSMutableDictionary* dict = userArray[i];
            if ([dict[@"whichMap"] isEqualToString:@"google"]) {
                [_dataArr addObject:dict];
            }
        }
    }
    _isEdit = NO;
    [_tableView reloadData];
}


//收藏路线
- (void)button2Cli{
    single = 1;
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_btnView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_btnView setFrame:CGRectMake(Width / 2, 104, Width / 2, 1 )];
    _button1.selected = NO;
    _button2.selected =YES;
    [UIView commitAnimations];
    
    MySaveDataManager *manager = [MySaveDataManager shareInatance];
    [_dataArr removeAllObjects];
    _dataArr = [NSMutableArray arrayWithArray:[[manager getPotionsDate] copy]] ;
    [_tableView reloadData];
}


//动画效果
-(void)animationCuston
{
    [UIView beginAnimations:@"btnAnimation" context:(__bridge void *)(_btnView)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [_btnView setFrame:CGRectMake(Width / 2, 104, Width / 2, 1 )];
    [UIView commitAnimations];
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag!=6666) {
        if (single !=0) {
            return 85;
        }
    }
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag!=6666) {
        return _dataArr.count;
    }
    else
    {
        return arrForAlert.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag !=6666) {
        if (single ==0) {
            // 定义唯一标识
            static NSString *CellIdentifier = @"Cell";
            // 通过唯一标识创建cell实例
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            //点
            NSMutableDictionary* dict = nil;
            if (_dataArr.count) {
                dict = [NSMutableDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"地点:%@  添加时间:%@",dict[@"name"],dict[@"time"]];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.imageView.image = [UIImage imageNamed:@"default_busline_icon_stopsign@2x"];
            return cell;
        }
        //路线
        else
        {
            // 定义唯一标识
            static NSString *CellIdentifier = @"Cell";
            // 通过唯一标识创建cell实例
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            NSString *name = _dataArr[indexPath.row];
            MySaveDataManager *manager = [MySaveDataManager shareInatance];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[manager getPotionsWith:name]];
            NSMutableString *str = [NSMutableString stringWithCapacity:0];
            for (XuandianModel *model in arr) {
                NSString *name = model.weizhi;
                [str appendString:[NSString stringWithFormat:@"%@",name]];
            }
            [arrForAlert removeAllObjects];
            NSMutableArray *currArr = [NSMutableArray arrayWithArray:[[MySaveDataManager shareInatance] getPotionsWith:_dataArr[indexPath.row]]];
            int l=0;
            for (XuandianModel *model in currArr) {
                if (l==0) {
                    model.weizhi = [NSString stringWithFormat:@"%@",model.weizhi];
                }
                if (l== currArr.count -1) {
                    model.weizhi = [NSString stringWithFormat:@"%@",model.weizhi];
                }
                [arrForAlert addObject:model.weizhi];
                l++;
            }
            if (arrForAlert.count > 1) {
                UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 25, 25)];
                icon.image = [UIImage imageNamed:@"default_carReport_raoxing@2x"];
                [cell.contentView addSubview:icon];
                UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(55, 5 + 78/3 +3.5, Width - 130, 78/3)];
                nameL.font = [UIFont systemFontOfSize:14];
                nameL.text = name;
                //(55, 5, Width - 130, 78/3)
                //(Width - 50, 5 + 78/3 + 3.5, 22, 27)
                [cell.contentView addSubview:nameL];
                UILabel *stratL = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, Width - 130, 78/3)];
                stratL.text = arrForAlert[0];
                stratL.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:stratL];
                UIImageView *startI=[[UIImageView alloc]initWithFrame:CGRectMake(Width - 50, 5, 20, 25)];
                startI.image = [UIImage imageNamed:@"start"];
                [cell.contentView addSubview:startI];
                UILabel *endL = [[UILabel alloc]initWithFrame:CGRectMake(55, 5 + 78/3*2 + 3.5, Width - 130, 78/3)];
                endL.text = [arrForAlert lastObject];
                endL.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:endL];
                UIImageView *endI=[[UIImageView alloc]initWithFrame:CGRectMake(Width - 50, 5 + 78/3*2 + 3.5, 20, 25)];
                endI.image = [UIImage imageNamed:@"end"];
                [cell.contentView addSubview:endI];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
                cell.imageView.image = [UIImage imageNamed:@"default_carReport_raoxing@2x"];
            }
            return cell;
        }
    }
    else
    {
        // 定义唯一标识
        static NSString *CellIdentifier = @"Cell";
        // 通过唯一标识创建cell实例
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text =arrForAlert[indexPath.row];
        return cell;
    }
    return nil;
}

//选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag !=6666) {
        NSLog(@"%d",(int)tableView.tag);
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableDictionary* dict1 = nil;
        if (single==0) {
            if (_dataArr.count) {
                dict1 = [NSMutableDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
            }
        }
        if (_isEdit) {
            if (single ==0) {
                NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
                NSArray* array = [userPoint objectForKey:@"collect"];
                NSMutableArray* userArray = nil;
                if (array == nil){
                    userArray = [NSMutableArray array];
                }else{
                    userArray = [NSMutableArray arrayWithArray:array];
                }
                
                EditViewController* edvc = [[EditViewController alloc]init];
                edvc.single = single;
                NSMutableDictionary* dict = nil;
                if (_dataArr.count) {
                    dict = [NSMutableDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
                }
                NSInteger dex = [array indexOfObject:dict];
                edvc.index = dex;
                edvc.name = dict[@"name"];
                [self.navigationController pushViewController:edvc animated:YES];
            }
            else
            {
                EditViewController* edvc = [[EditViewController alloc]init];
                edvc.single = single;
                edvc.LinesName = _dataArr[indexPath.row];
                [self.navigationController pushViewController:edvc animated:YES];
            }
            
        }else{
            if (!_isMap) {
                if (single ==0) {
                    [[TXYConfig sharedConfig]setFakeGPS:CLLocationCoordinate2DMake([dict1[@"latitudeNum"] doubleValue], [dict1[@"longitudeNum"] doubleValue])];
                    NSLog(@"la = %f  lo = %f",[[TXYConfig sharedConfig]getFakeGPS].latitude,[[TXYConfig sharedConfig]getFakeGPS].longitude);
                    self.tabBarController.selectedIndex = 0;
                }
                else
                {
                    [arrForAlert removeAllObjects];
                    MySaveDataManager *manager = [MySaveDataManager shareInatance];
                    NSMutableArray *currArr = [NSMutableArray arrayWithArray:[manager getPotionsWith:_dataArr[indexPath.row]]];
                    int l=0;
                    for (XuandianModel *model in currArr) {
                        if (l==0) {
                            model.weizhi = [NSString stringWithFormat:@"%@    (起)",model.weizhi];
                        }
                        if (l== currArr.count -1) {
                            model.weizhi = [NSString stringWithFormat:@"%@    (终)",model.weizhi];
                        }
                        [arrForAlert addObject:model.weizhi];
                        l++;
                    }
                    JKAlertDialog  *alert = [[JKAlertDialog alloc]initWithTitle:@"当前路线" message:@"请选择"];
                    alert.contentView =  _table;
                    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
                    }];
                    [alert addButton:Button_OTHER withTitle:@"确定" handler:^(JKAlertDialogItem *item) {
                        NSLog(@"click %@",item.title);
                    }];
                    [alert show:self.view.window];
                }
            }else{
                if (single ==0) {
                    NSMutableDictionary* dict = nil;
                    if (_dataArr.count) {
                        dict = [NSMutableDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
                    }
                    XuandianModel* model = [[XuandianModel alloc]init];
                    model.index =(int)self.index;
                    model.time = dict[@"time"];
                    model.weizhi = dict[@"name"];
                    model.juli = dict[@"juli"];
                    model.latitudeNum =dict[@"latitudeNum"] ;
                    model.longitudeNum = dict[@"longitudeNum"];
                    model.isCollec = 1;
                    [self.delegate chuanzhiGPS:model];
                    for(UIViewController *controller in self.navigationController.viewControllers)
                    {
                        if ([controller isKindOfClass:[TotleScanViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                else
                {
                    [arrForAlert removeAllObjects];
                    MySaveDataManager *manager = [MySaveDataManager shareInatance];
                    NSMutableArray *currArr = [NSMutableArray arrayWithArray:[manager getPotionsWith:_dataArr[indexPath.row]]] ;
                    for (XuandianModel *model in currArr) {
                        [arrForAlert addObject:model.weizhi];
                    }
                    JKAlertDialog  *alert = [[JKAlertDialog alloc]initWithTitle:@"当前路线" message:@"请选择"];
                    alert.contentView =  _table;
                    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
                    }];
                    [alert addButton:Button_OTHER withTitle:@"确定" handler:^(JKAlertDialogItem *item) {
                        //传路线
                        [self.delegate chuanLines:[manager getPotionsWith:_dataArr[indexPath.row]]];
                        NSLog(@"%@",self.navigationController.viewControllers);
                        for(UIViewController *controller in self.navigationController.viewControllers)
                        {
                            if ([controller isKindOfClass:[TotleScanViewController class]]) {
                                [self.navigationController popToViewController:controller animated:YES];
                            }
                        }
                        NSLog(@"click %@",item.title);
                    }];
                    
                    [alert show:self.view.window];
                }
            }
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag!=6666) {
        return YES;
    }
    return NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
