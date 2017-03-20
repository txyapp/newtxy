//
//  AppInfo.m
//  FakePhoneApp
//
//  Created by root1 on 15/9/10.
//  Copyright (c) 2015年 root1. All rights reserved.
//

#import "AppInfo.h"
#import "ipaManage.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>

extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);
extern NSString * SBSCopyIconImagePathForDisplayIdentifier(NSString *identifier);
extern NSArray * SBSCopyApplicationDisplayIdentifiers(BOOL activeOnly, BOOL unknown);

static BOOL isFirmware3x = NO;
static NSData * (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier) = NULL;

@interface AppInfo()

@property(nonatomic,strong)ipaManage *ipaMgr;
@property(nonatomic,strong)NSArray *appArr;
@property(nonatomic,strong)NSDictionary *allAppInfo;
@property(nonatomic,assign)BOOL isAllModel;

@end

@implementation AppInfo

- (instancetype)init{
    self=[super init];
    if(self){
        isFirmware3x = [[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"];
        if (!isFirmware3x) {
            // Firmware >= 4.0
            SBSCopyIconImagePNGDataForDisplayIdentifier = (NSData*(*)(NSString*))dlsym(RTLD_DEFAULT, "SBSCopyIconImagePNGDataForDisplayIdentifier");
        }
        self.appArr=[SBSCopyApplicationDisplayIdentifiers(NO, NO) mutableCopy];
        self.ipaMgr=[[ipaManage alloc]init];
        if (self.appArr==nil) {
            NSLog(@"ipaMgr获取");
            self.isAllModel=NO;
            self.allAppInfo=[self.ipaMgr installedApps];
            self.appArr=[[self.ipaMgr installedApps] allKeys];
        }else{
            NSLog(@"api获取");
            self.allAppInfo=[self.ipaMgr installedApps];
            self.appArr=[[self.ipaMgr installedApps] allKeys];
            self.isAllModel=YES;
        }
    }
    return self;
}

- (NSArray *)allAppBundleId{
    return self.appArr;
}

- (NSString *)appNameForBundelId:(NSString *)bundleId{
    NSString *appName=nil;
    if (self.isAllModel) {
        appName=SBSCopyLocalizedApplicationNameForDisplayIdentifier(bundleId);
    }else{
        appName=[self.ipaMgr displayNameForAppID:bundleId];
        if(appName==nil){
            NSDictionary *appInfo=[self.allAppInfo objectForKey:bundleId];
            appName=[appInfo objectForKey:@"appName"];
        }
    }
    return appName;
}

- (NSString *)appDataPathForBundleId:(NSString *)bundleId{
    NSString *dataPath=nil;
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0){
        NSDictionary *appDict=[self.allAppInfo objectForKey:bundleId];
        dataPath=[appDict objectForKey:@"boundDataContainerURL"];
    }else{
        dataPath=[self.ipaMgr bundlePathForAppID:bundleId];
    }
    //系统app
    if (dataPath==nil) {
        NSLog(@"系统app");
        //dataPath=@"/var/mobile";
    }
    return dataPath;
}

- (UIImage *)appIconForBundleId:(NSString *)bundleId{
    UIImage *appIcon=nil;
    if (self.isAllModel) {
        appIcon=[self getIcon:bundleId];
    }else{
        NSData *appIconData=[self.ipaMgr bundleIconForAppID:bundleId];
        appIcon=[UIImage imageWithData:appIconData];
    }
    return appIcon;
}


-(UIImage *)getIcon:(NSString *)bundleID{
    UIImage *icon = nil;
    if (isFirmware3x) {
        // Firmware < 4.0
        NSString *iconPath = SBSCopyIconImagePathForDisplayIdentifier(bundleID);
        if (iconPath != nil) {
            icon = [UIImage imageWithContentsOfFile:iconPath];
        }
    } else {
        // Firmware >= 4.0
        if (SBSCopyIconImagePNGDataForDisplayIdentifier != NULL) {
            NSData *data = (*SBSCopyIconImagePNGDataForDisplayIdentifier)(bundleID);
            if (data != nil) {
                icon = [UIImage imageWithData:data];
            }
        }
    }
    return icon;
}
@end

