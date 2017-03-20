//
//  UpdateProcess.m
//  TXYUpdateModule
//
//  Created by aa on 16/9/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "UpdateProcess.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#include <notify.h>

#import "MBProgressHUD.h"
#import "UMOnlineConfig.h"

@interface UpdateProcess()<UIAlertViewDelegate>

@property (nonatomic,assign) BOOL        isFource;

@end

@implementation UpdateProcess

- (instancetype)init
{
    if (self = [super init]) {
        NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        float currentVersion = [versionString floatValue];
        self.currentVersion = currentVersion;
    }
    return self;
}

- (void)checkUpdateWithIsRelease:(BOOL)isRelease
{
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSString *url=@"http://dl.txyapp.com/up99.txt";
    //http://dl.txyapp.com/up.txt   http://dl.txyapp.com/newupdate.txt

    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:responseObject
      		                            options:NSJSONReadingMutableContainers
                                  error:nil];
    
        NSLog(@"%@",responseObject);
        NSLog(@"%@",jsonObject);
        NSDictionary *releaseDic = [jsonObject objectForKey:@"release"];
        NSLog(@"%@",releaseDic);
        NSDictionary *betaDic = [jsonObject objectForKey:@"beta"];
        self.downloadURLString = [jsonObject objectForKey:@"downloadURLString"];
        if (isRelease) {
            NSString *isFource = [jsonObject objectForKey:@"isFource"];
            if ([isFource intValue] == 1) {
                self.isFource = YES;
            }else{
                self.isFource = NO;
            }
        }else{
            self.isFource = NO;
        }
        
        
        self.releaseVersion = [[releaseDic objectForKey:@"version"] floatValue];
        NSLog(@"%f",self.releaseVersion);
        self.betaVersion = [[betaDic objectForKey:@"version"] floatValue];
        if (isRelease) {
            [self processReleaseUpdate:releaseDic];
        }else{
            [self processBetaUpdate:betaDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)processReleaseUpdate:(NSDictionary *)releaseDic
{
    NSLog(@"%f 和  %f",self.currentVersion,self.releaseVersion);
//    [self showUpdateAlertWithTitle:[releaseDic objectForKey:@"title"] andContent:[releaseDic objectForKey:@"content"]];
    if ([self isShouldUpdateWithCurrentVersion:self.currentVersion andNewestVersion:self.releaseVersion]) {
        [self showUpdateAlertWithTitle:[releaseDic objectForKey:@"title"] andContent:[releaseDic objectForKey:@"content"]];
    }else{
        
    }
}

- (void)processBetaUpdate:(NSDictionary *)betaDic
{
    if ([self isShouldUpdateWithCurrentVersion:self.currentVersion andNewestVersion:self.betaVersion]) {
        [self showUpdateAlertWithTitle:[betaDic objectForKey:@"title"] andContent:[betaDic objectForKey:@"content"]];
    }else{
        [self dontUpdate];
    }
}

- (void)showUpdateAlertWithTitle:(NSString *)title andContent:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"方式一: cydia更新",@"方式二: 下载更新", nil];
    [alert show];
}

- (void)dontUpdate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


//设置版本更新显示信息
- (void)setShowUpdateVersionString
{
    
}

#pragma mark - alert delegate func
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self updateByCydia];
    }
    if (buttonIndex == 2) {
        [self updateByDownload];
    }
    if (buttonIndex == 0) {
        if (self.isFource) {
            exit(0);
        }
    }
}

#pragma mark - update func
- (void)updateByCydia
{
    [self writeCydiaHtml];
    [self switchToCydia];
}

- (void)updateByDownload
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:appDelegate.window.rootViewController.view];
    [appDelegate.window.rootViewController.view addSubview:hud];
    hud.mode=MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
//    NSString *url=[UMOnlineConfig getConfigParams:@"url"];
    NSString *url = self.downloadURLString;
    
    //下载准备
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *requestOper=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    // 下载
    // 指定文件保存路径，将文件保存在沙盒中
   
    NSString *filePath=@"/var/mobile/Library/Preferences/txy.deb";
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
        system("killall -9 Cydia");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            notify_post("com.txyupdata.start");
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    [requestOper start];
}

- (void)writeCydiaHtml
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
    //    [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES];
    [log_text writeToFile:[NSString stringWithFormat:@"%@/cydia.html",docDir] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)switchToCydia
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"cydia://url/%@/cydia.html", docDir]]];
    exit(0);
}

#pragma mark - util func
- (BOOL)isShouldUpdateWithCurrentVersion:(float)currentVersion andNewestVersion:(float)newestVersion
{
    if (currentVersion < newestVersion) {
        return YES;
    }else{
        return NO;
    }
}

@end
