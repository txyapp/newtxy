//
//  HuiFuViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/7.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "HuiFuViewController.h"
#import "HuiFuView.h"
#import "KGStatusBar.h"
#import "HuiFuModel.h"
#import "MBProgressHUD.h"
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define IMRowHeight     44
#define IMRowSubHeight  300
@interface HuiFuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *_opendIndexPath;
    NSMutableArray *arr;
}
@property(nonatomic,assign)BOOL isOpen;
@end

@implementation HuiFuViewController
@synthesize AppTable,isOpen;
- (void)viewDidLoad {
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [super viewDidLoad];
    self.title = @"恢复";
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    //self.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    arr = [NSMutableArray arrayWithCapacity:0];
    _opendIndexPath = nil;
    [self InitView];
    [self loadData];
    isOpen = NO;
    // Do any additional setup after loading the view.
}
- (void)fanhui{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
   // self.tabBarController.tabBar.hidden = NO;
}

/**
 *  准备数据
 */
-(void)loadData{
    NSString *str = GaijiPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSLog(@"plistdit = %@",plistDict);
    NSArray* shezhi = [plistDict objectForKey:@"Shezhi"];
    NSArray* array = [plistDict objectForKey:@"Gaiji"];
    NSLog(@"shezhi = %@",shezhi);
    NSLog(@"array的元素的有  %d 个",array.count);
    for (int i = 0; i < array.count; i ++) {
        HuiFuModel *item  = [[HuiFuModel alloc]init];
        NSDictionary *dic = array[i];
        NSDictionary *dic1 = shezhi[i];
        NSLog(@"dict1 = %@",dic1);
        if (dic) {
            NSString *Dkey = [dic allKeys][0] ;
            NSLog(@"当前key值为:%@",Dkey);
            item.Time = Dkey;
            item.ADUUID = dic[Dkey][@"ADUUID"];
            item.APP = [NSArray arrayWithArray:dic[Dkey][@"APP"]];
            item.UUID = dic[Dkey][@"UUID"];
            item.WiFiMAC = dic[Dkey][@"WIFIMAC"];
            item.WiFiName  =  dic[Dkey] [@"WiFiName"];
            item.devName = dic[Dkey][@"devName"];
            item.devType = dic [Dkey][@"devType"];
            item.devVer = dic[Dkey][@"devVer"];
            item.netState = dic[Dkey][@"netState"];
            item.shuju = dic1[@"shuju"];
            NSLog(@"shuju = %@",item.shuju);
            [arr addObject:item];
            NSLog(@"itemAPP :%@ dicAPP :%@",item.APP,dic[Dkey][@"APP"]);
        }
    }
    [AppTable reloadData];
}
/**
 *  创建界面
 */
-(void)InitView{
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor=IWColor(60, 170, 249);
    AppTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    AppTable.delegate = self;
    AppTable.dataSource = self;
    AppTable.sectionFooterHeight = 1;
    AppTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:AppTable];
}

/**
 *  tableView Delegate
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(15, 0, Width  - 15, 1);
    view.backgroundColor = Color;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedCellID = @"reusedCellID";
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
    HuiFuView *rowView = nil;
    HuiFuModel *item = [arr objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    rowView = [[HuiFuView alloc] initWithFrame:CGRectMake(0, 0, Width, item.isOpen?IMRowHeight+IMRowSubHeight:IMRowHeight)];
    rowView.tag = 2012;
    rowView.whichData = indexPath.row;
    [cell.contentView addSubview:rowView];
    
    
    rowView = (HuiFuView*)[cell.contentView viewWithTag:2012];
    rowView.frame = CGRectMake(0, 0, Width, item.isOpen?IMRowHeight+IMRowSubHeight:IMRowHeight);
    rowView.item = item;
    
    [rowView.editBtn addTarget:self action:@selector(edite:) forControlEvents:UIControlEventTouchUpInside];
    [rowView.upBtn addTarget:self action:@selector(upClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = GaijiPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSMutableArray* array = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Gaiji"]];
    int which = indexPath.row;
    NSMutableDictionary *changDic =[NSMutableDictionary dictionaryWithDictionary:array[which]] ;
    NSString* zhuangtai = [changDic allKeys][0];
    NSMutableAttributedString *yanseStr = [[NSMutableAttributedString alloc]initWithString:zhuangtai];
    NSLog(@"yanse = %@",yanseStr);
    [yanseStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    NSString *anotherString=[yanseStr string];
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您确定要恢复到 “%@” 状态吗?",zhuangtai] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    dialog.tag = 7000 + indexPath.row;
    [dialog show];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    HuiFuModel * item = [arr objectAtIndex:indexPath.row];
    
    if (item.isOpen == YES) {
        return NO;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HuiFuModel *item = [arr objectAtIndex:indexPath.row];
    return item.isOpen?IMRowHeight+IMRowSubHeight:IMRowHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [AppTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *str = GaijiPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray* array = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Gaiji"]];
        NSMutableArray* array2 = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Shezhi"]];
        NSString* keyzhi = [array2[indexPath.row] objectForKey:@"keyzhi"];
        if (![keyzhi isEqualToString:@"no"]) {
            NSMutableArray* bundleArr = [NSMutableArray arrayWithArray:[[array[indexPath.row] allValues][0] objectForKey:@"APP"]];
            //删除app备份内容
            for (int i = 0; i<bundleArr.count; i++) {
                NSString* bundle = bundleArr[i];
                [[Tools  sharedTools]deleteForBackUpWithBundleId:bundle Key:keyzhi];
            }
        }
        [array removeObjectAtIndex:indexPath.row];
        [array2 removeObjectAtIndex:indexPath.row];
       // NSDictionary *dic = @{@"Gaiji":array};
        [plistDict setObject:array forKey:@"Gaiji"];
        [plistDict setObject:array2 forKey:@"Shezhi"];
        if ([plistDict writeToFile:GaijiPlist atomically:YES]) {
            [KGStatusBar showSuccessWithStatus:@"删除成功"];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


//修改记录名称
-(void)edite:(UIButton *)sender
{
    UITableViewCell *cell = nil;
    NSIndexPath *indexPath = nil;
    if (iOS7) {
        cell = (UITableViewCell *)sender.superview.superview.superview.superview.superview;
    }
    else
    {
        cell = (UITableViewCell *)sender.superview.superview.superview.superview;
    }
    if (cell) {
        indexPath = [AppTable indexPathForCell:cell];
    }
    
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入分组名称" message:@"修改分组名称" delegate:self cancelButtonTitle:@"修改" otherButtonTitles:@"取消",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    dialog.tag = 6000 + indexPath.row;
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    [dialog show];
}


#pragma alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag >= 7000) {
        if (buttonIndex == 0) {
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate changeAfter:alertView.tag - 7000];
            
            
            //[self.delegate changeAfter:alertView.tag - 7000];
            //[self dismissViewControllerAnimated:YES completion:^{
               
//            }];
            
        }
    }
    else
    {
        if (buttonIndex == 0) {
            NSString *answer = [alertView textFieldAtIndex:0].text;
            NSLog(@"%@",answer);
            NSString *str = GaijiPlist;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSLog(@"plist1 = %@",plistDict);
            NSMutableArray* array = [NSMutableArray arrayWithArray:[plistDict objectForKey:@"Gaiji"]];
            int which = alertView.tag  - 6000;
            NSMutableDictionary *changDic =[NSMutableDictionary dictionaryWithDictionary:array[which]] ;
            
            NSDictionary *aa =[changDic allValues][0];
            NSLog(@"aa = %@",aa);
            NSLog(@"changDic = %@",changDic);
            if (answer.length <1) {
                [KGStatusBar showSuccessWithStatus:@"名字不能为空"];
                return;
            }else{
            [changDic removeAllObjects];
            [changDic setObject:aa forKey:answer];
            }
            NSLog(@"array = %@   changdic == %@",array,changDic);
         //   [array replaceObjectAtIndex:which withObject:changDic];
            [array removeObjectAtIndex:which];
            NSLog(@"array = %@",array);
            [array insertObject:changDic atIndex:which];
            
            NSLog(@"array = %@",array);
            //问题出在这里
          //  NSDictionary *dic = @{@"Gaiji":array};
            [plistDict setObject:array forKey:@"Gaiji"];
            if ([plistDict writeToFile:GaijiPlist atomically:YES]) {
                [KGStatusBar showSuccessWithStatus:@"名字修改成功"];
            }
            NSLog(@"plist2 = %@",plistDict);
            HuiFuModel *model = nil;
            model = arr[which];
            model.Time = answer;
            [AppTable reloadData];
        }
    }
}
//点击详情
-(void)upClick :(UIButton *)sender
{
    // NSLog(@"%@",sender.superview.superview.superview.superview);
    UITableViewCell *cell = nil;
    NSIndexPath *indexPath = nil;
    if (iOS7) {
        cell = (UITableViewCell *)sender.superview.superview.superview.superview.superview;
    }
    else
    {
        cell = (UITableViewCell *)sender.superview.superview.superview.superview;
    }
    if (cell) {
        indexPath = [AppTable indexPathForCell:cell];
    }
    //NSLog(@"目前是第%d行 目前的cell是:%@",indexPath.row,cell);
    HuiFuModel *item = nil;
    //选中单元格的表现
    if (_opendIndexPath) {
        if (_opendIndexPath.row == indexPath.row) {
            item = [arr objectAtIndex:_opendIndexPath.row];
            item.isOpen  = NO;
            [AppTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_opendIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            _opendIndexPath = nil;
        }
        else {
            item = [arr objectAtIndex:_opendIndexPath.row];
            item.isOpen = NO;
            item = [arr objectAtIndex:indexPath.row];
            item.isOpen = YES;
            [AppTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_opendIndexPath, indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            _opendIndexPath = indexPath;
        }
    }
    else {
        item = [arr objectAtIndex:indexPath.row];
        item.isOpen = YES;
        [AppTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        _opendIndexPath = indexPath;
    }
    [AppTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
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
