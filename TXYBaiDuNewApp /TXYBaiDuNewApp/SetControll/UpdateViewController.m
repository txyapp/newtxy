//
//  UpdateViewController.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/11/16.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "UpdateViewController.h"
#import "MobClick.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#include <notify.h>
#import "UMOnlineConfig.h"

#define SystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

@interface UpdateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"版本更新";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, W, H-44-20) style:UITableViewStylePlain];
    if(SystemVersion<7.0){
        self.tableView.frame=CGRectMake(0, 0, W, H-44);
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=60;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }else{
        cell.textLabel.text=nil;
        cell.detailTextLabel.text=nil;
        cell.imageView.image=nil;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if(indexPath.row==0){
        cell.textLabel.text=@"检查更新";
    }
    if(indexPath.row==1){
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.textLabel.text=[NSString stringWithFormat:@"当前版本:%@",version];;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        NSLog(@"检查更新");
        [MobClick startWithAppkey:UmengKeyT reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        [MobClick checkUpdateWithDelegate:self selector:@selector(updata:)];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)updata:(NSDictionary *)appInfo{
    NSLog(@"%@",appInfo);
    NSString *update_log=[appInfo objectForKey:@"update_log"];
    NSString *newVersion=[appInfo objectForKey:@"version"];
    BOOL isupdata=[[appInfo objectForKey:@"update"] boolValue];
    if (isupdata) {
        NSString *title=[NSString stringWithFormat:@"发现新版本 v%@",newVersion];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:update_log delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (void)rewriteAppCydiaHtml
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cydia" ofType:@"html"];
    NSString *CydiaLogo = [[NSBundle mainBundle] pathForResource:@"Cydia_logo" ofType:@"png"];
    NSString *CydiaBtn = [[NSBundle mainBundle] pathForResource:@"Cydia_btn" ofType:@"png"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSString *log_text = [[NSString alloc] initWithData:
                          [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########LOGO" withString:CydiaLogo];
    log_text = [log_text stringByReplacingOccurrencesOfString:@"###########BTN" withString:CydiaBtn];
    [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //BOOL bRet = [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    //    NSLog(@"write result %d", bRet);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"更新");
        
        [self rewriteAppCydiaHtml];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"cydia://url/%@/cydia.html", docDir]]];
        NSLog(@"%@",docDir);
        exit(0);
    }
    
        /*MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode=MBProgressHUDModeIndeterminate;
        [hud show:YES];
        
        NSString *url=[UMOnlineConfig getConfigParams:@"url"];
        NSLog(@"%@",url);
        
        //下载准备
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFHTTPRequestOperation *requestOper=[[AFHTTPRequestOperation alloc]initWithRequest:request];
        // 下载
        // 指定文件保存路径，将文件保存在沙盒中
        NSString *cachePath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];;
        NSString *filePath=[cachePath stringByAppendingPathComponent:@"txy.deb"];
        NSLog(@"%@",filePath);
        requestOper.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        //监听下载进度
        [requestOper setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
            hud.progress=precent;
            hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(precent*100)];
        }];
        //下载结果
        [requestOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"下载成功");
            hud.labelText = @"正在安装";
            notify_post("com.txyupdata.start");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"下载失败");
            [hud removeFromSuperview];
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        
        [requestOper start];
 
    }else{
        NSLog(@"取消");
        
    }*/
}


@end
