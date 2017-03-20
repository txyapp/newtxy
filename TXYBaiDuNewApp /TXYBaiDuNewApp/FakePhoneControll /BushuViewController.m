//
//  BushuCollectionViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "BushuViewController.h"

@interface BushuViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>{
    UITableView* _tableView;
}

@end

@implementation BushuViewController


- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    self.title = @"运动步数";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [self makeView];
}

- (void)makeView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    UIView* footView = [[UIView alloc]init];
    UILabel* footLab = [[UILabel alloc]init];
    footLab.text = @"1.虚拟步数和距离可以模拟您手机健康数据中的步数和距离";
    footLab.textColor = [UIColor grayColor];
    footLab.frame = CGRectMake(20, 0, Width - 40, 40);
    footLab.numberOfLines = 0;
    footLab.font = [UIFont systemFontOfSize:13];
    [footView addSubview:footLab];
    footView.frame = CGRectMake(0, 0, Width, 40);
    _tableView.tableFooterView = footView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 2;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;//section头部高度
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }else{
        /*cell.textLabel.text=nil;
         cell.detailTextLabel.text=nil;
         cell.imageView.image=nil;
         [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];*/
    }
    //[cell.contentView.subviews methodForSelector:@selector(removeFromSuperview)];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开关";
            UISwitch *switchView = [[UISwitch alloc] init];
            switchView.onTintColor = IWColor(60, 170,249);
            switchView.tintColor = [UIColor whiteColor];
            [switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            [cell addSubview:switchView];
            NSString *str = HeaithKit;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSNumber *kaiguan = [plistDict objectForKey:@"SportSwitch"];
            if (kaiguan && [kaiguan intValue] == 1) {
                switchView.on = YES;
            }else{
                switchView.on = NO;
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"虚拟步数";
            NSString *str = HeaithKit;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSString* step = [plistDict objectForKey:@"SportStep"];
            if (step) {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@步",step];
            }else{
                cell.detailTextLabel.text = @"点击输入虚拟步数";
            }
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"虚拟距离";
            NSString *str = HeaithKit;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSString* distance = [plistDict objectForKey:@"SportDistance"];
            if (distance) {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@千米",distance];
            }else{
                cell.detailTextLabel.text = @"点击输入虚拟距离";
            }
        }
    }
  
    return cell;
}

//开关按钮
- (void)switchClick:(UISwitch*)sender{
    NSString *str = HeaithKit;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSNumber *kaiguan;
    if (sender.on) {
        kaiguan  = [NSNumber numberWithInt:1];
        NSLog(@"1");
    }else{
        kaiguan  = [NSNumber numberWithInt:0];
        NSLog(@"0");
    }
    [plistDict setObject:kaiguan forKey:@"SportSwitch"];
    //同步操作
    BOOL result=[plistDict writeToFile:HeaithKit atomically:YES];
    if (result) {
        NSLog(@"存入成功");
        [_tableView reloadData];
    }else{
        NSLog(@"存入失败");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = HeaithKit;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
  
    
    if (indexPath.section == 0) {
        UITableViewCell* cell =  [_tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"手动输入" message:@"" delegate:self
                                      cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 200;
            alertView.delegate = self;
            //设置AlertView的样式
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            // 设置textfield 的键盘类型。
            tf.placeholder = @"请输入模拟步数";
            [alertView show];
        }
        if (indexPath.row == 1) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"手动输入" message:@"" delegate:self
                                      cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 201;
            alertView.delegate = self;
            //设置AlertView的样式
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            // 设置textfield 的键盘类型。
            tf.placeholder = @"请输入模拟距离(公里)";
            [alertView show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str = HeaithKit;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            // 拿到UITextField
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text) {
                [plistDict setObject:tf.text forKey:@"SportStep"];
                //同步操作
                BOOL result=[plistDict writeToFile:HeaithKit atomically:YES];
                if (result) {
                    NSLog(@"存入成功");
                }else{
                    NSLog(@"存入失败");
                }
                [_tableView reloadData];
            }else{
                [KGStatusBar showWithStatus:@"步数不能为空"];
            }
        }
    }
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            // 拿到UITextField
            // 拿到UITextField
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text) {
                [plistDict setObject:tf.text forKey:@"SportDistance"];
                //同步操作
                BOOL result=[plistDict writeToFile:HeaithKit atomically:YES];
                if (result) {
                    NSLog(@"存入成功");
                }else{
                    NSLog(@"存入失败");
                }
                [_tableView reloadData];
            }else{
                [KGStatusBar showWithStatus:@"距离不能为空"];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
