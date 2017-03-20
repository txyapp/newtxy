//
//  Tools.m
//  TxyFakePhone
//
//  Created by root1 on 16/3/22.
//  Copyright (c) 2016年 yunlian. All rights reserved.
//

#import "Tools.h"
#include <notify.h>
#include <dlfcn.h>
#import <sys/sysctl.h>
#include <mach-o/dyld.h>

#define PlistPath @"/var/mobile/Library/Preferences/txyfakephone.plist"
#define PlistPathDM @"/var/mobile/Library/Preferences/txyfakephonedm.plist"

#define folderSize @"/var/mobile/Library/Preferences/folderSize.plist"
#define folderResult @"/var/mobile/Library/Preferences/folderResult.plist"

#define BackUpResult @"/var/mobile/Library/Preferences/BackUpResult.plist"

#define deleteFilePath @"/var/mobile/Library/Preferences/deleteFile.plist"

static Tools *tool=nil;
@implementation Tools

+ (instancetype)sharedTools{
    @synchronized (self){
        if (tool==nil) {
            tool=[[Tools alloc]init];
        }
    }
    return tool;
}

-(NSMutableDictionary *)getInfoDict{
    return [self loadsetDict];
}

-(NSMutableDictionary *)loadsetDict{
    NSMutableDictionary *dcit=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPath];
    if(dcit==nil){
        dcit=[NSMutableDictionary dictionary];
    }
    return dcit;
}

-(BOOL)wrSetDict:(NSDictionary *)dict{
    BOOL b=[dict writeToFile:PlistPath atomically:YES];
    return b;
}

-(void)cleanSafari{
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    [deleteDict setObject:@(YES) forKey:@"safari"];
    [deleteDict writeToFile:PlistPathDM atomically:YES];
    notify_post("com.txy.start");
}

/**
 *  针对bundleId清理KeyChain
 */
-(void)cleanKeyChainWithBundleId:(NSArray *)bundleIdArr{
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    [deleteDict setObject:bundleIdArr forKey:@"CleanKeyChain"];
    [deleteDict writeToFile:PlistPathDM atomically:YES];
    //notify_post("com.txy.start");
}


-(void)BackupAppDataWithBundleId:(NSArray *)bundleIdArr withKey:(NSString *)key :(backupBlockOver)block{
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    [deleteDict setObject:bundleIdArr forKey:@"BackupApp"];
    [deleteDict setObject:key forKey:@"AppBackupKey"];
    [deleteDict writeToFile:PlistPathDM atomically:YES];
    
    __block int count=0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            while (YES) {
                NSString *resultStr=[[NSString alloc]initWithContentsOfFile:BackUpResult encoding:NSUTF8StringEncoding error:nil];
                if (resultStr.length>0) {
                    block(@{});
                    [[NSFileManager defaultManager] removeItemAtPath:BackUpResult error:nil];
                    break;
                }
                sleep(1);
                count++;
                if (count>120) {
                    block(@{});
                    [[NSFileManager defaultManager] removeItemAtPath:BackUpResult error:nil];
                    break;
                }
            }
        });
    });
    
}

-(void)deleteForBackUpWithBundleId:(NSString *)bundleId Key:(NSString *)key{
    NSArray *deleteArr=@[bundleId,key];
    [deleteArr writeToFile:deleteFilePath atomically:YES];
    notify_post("com.txy.deleteBackUp");
}

-(void)cleanAppDataWithBundleId:(NSArray *)bundleIdArr{
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    [deleteDict setObject:bundleIdArr forKey:@"CleanApp"];
    [deleteDict writeToFile:PlistPathDM atomically:YES];
    //notify_post("com.txy.start");
}

/**
 *  恢复app
 *
 */
-(void)recoverAppWhitBundleId:(NSArray *)bundleIdArr WithKey:(NSString *)key{
    NSMutableDictionary *deleteDict=[[NSMutableDictionary alloc]initWithContentsOfFile:PlistPathDM];
    if(deleteDict==nil){
        deleteDict =[NSMutableDictionary dictionary];
    }
    [deleteDict setObject:bundleIdArr forKey:@"RecoverApp"];
    [deleteDict setObject:key forKey:@"RecoverAppKey"];
    [deleteDict writeToFile:PlistPathDM atomically:YES];

}

/**
 *  清理剪切版
 */
-(void)cleanClipboard{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
}

/**
 *  针对bundleId 设置模拟3G网络
 */
-(void)set3G:(BOOL)is3G WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:@"3G" forKey:@"netState"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置设备类型
 */
-(void)setDevType:(DevTpye)type WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    NSString *typeStr=nil;
    if (type==iPhone) {
        typeStr=@"iPhone";
    }
    if (type==iPad) {
        typeStr=@"iPad";
    }
    if (type==cancel) {
        typeStr=@"";
    }
    [infoDict setObject:typeStr forKey:@"devType"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置设备版本
 */
-(void)setDevVersion:(DevVersion)version WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    NSString *versionStr=nil;
    if (version==fiOS7) {
        versionStr=@"7.1.2";
    }
    if (version==fiOS8) {
        versionStr=@"8.4";
    }
    if (version==fiOS9) {
        versionStr=@"9.2.1";
    }
    if (version==cancel2) {
        versionStr=@"";
    }
    [infoDict setObject:versionStr forKey:@"devVer"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置设备名称
 */
-(void)setDevName:(NSString *)devName WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:devName forKey:@"devName"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置序列号
 */
-(void)setSeral:(NSString *)devSeral WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:devSeral forKey:@"seral"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置UUID
 */
-(void)setUUID:(NSString *)UUID WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:UUID forKey:@"UUID"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置广告标识符
 */
-(void)setADUUID:(NSString *)ADUUID WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:ADUUID forKey:@"ADUUID"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置路由器wifi名称
 */
-(void)setWiFiName:(NSString *)WIFIName WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:WIFIName forKey:@"WiFiName"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

/**
 *  针对bundleId 设置路由器wifi地址
 */
-(void)setWiFiMAC:(NSString *)WIFIMac WithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    NSMutableDictionary *infoDict=[setDict objectForKey:bundleId];
    if (infoDict==nil) {
        infoDict=[NSMutableDictionary dictionary];
    }
    [infoDict setObject:WIFIMac forKey:@"WiFiMAC"];
    [setDict setObject:infoDict forKey:bundleId];
    [self wrSetDict:setDict];
}

-(void)cancelChangeWithBundleId:(NSString *)bundleId{
    NSMutableDictionary *setDict=[self loadsetDict];
    [setDict removeObjectForKey:bundleId];
    [self wrSetDict:setDict];
    /*NSMutableArray *selectAppArr=[setDict objectForKey:@"selectApp"];
    [selectAppArr removeObject:bundleId];
    [setDict setObject:selectAppArr forKey:@"selectApp"];
    [setDict removeObjectForKey:bundleId];
    [self wrSetDict:setDict];*/
}

-(float)deviceFreeSpace{
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
    NSString *diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return [diskFreeSize floatValue]/1024/1024/1024;
}

- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)folderSizeAtPath:(NSArray*)folderPath WithBlock:(folderSizeBlock)block{
    [folderPath writeToFile:folderSize atomically:YES];
    notify_post("com.txy.folderSize");
    __block int count=0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            while (YES) {
                NSString *resultStr=[[NSString alloc]initWithContentsOfFile:folderResult encoding:NSUTF8StringEncoding error:nil];
                if (resultStr.length>0) {
                    block([resultStr floatValue]);
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:folderResult error:&error];
                    [[NSFileManager defaultManager] removeItemAtPath:folderSize error:&error];
                    if (error) {
                        NSLog(@"%@",error);
                    }
                    break;
                }
                sleep(1);
                count++;
                if (count>10) {
                    block(-1);
                    [[NSFileManager defaultManager] removeItemAtPath:folderResult error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:folderSize error:nil];
                    break;
                }
            }
        });
    });
}
//@"com.tencent.xin"
-(void)killAppForBundleId:(NSString *)bundleId{
    /*pid_t pid=[self getPIDByIdentifier:bundleId];
    if (pid > 0) {
        kill(pid, SIGKILL);
    }*/
    notify_post([bundleId UTF8String]);
}


- (NSUInteger)getPIDByIdentifier:(NSString *)displayIdentifier
{
    unsigned pathSize = MAXPATHLEN + 1;
    char path[pathSize];
    _NSGetExecutablePath(path, &pathSize);
    path[pathSize] = '\0';
    
    void *sbserv = dlopen(path, RTLD_LAZY);
    
    BOOL (*SBSProcessIDForDisplayIdentifier)(CFStringRef identifier, pid_t *pid) = dlsym(sbserv, "SBSProcessIDForDisplayIdentifier");
    
    pid_t pid = 0;
    
    
    if (!SBSProcessIDForDisplayIdentifier((__bridge CFStringRef)displayIdentifier, &pid)) {
        return 0;
    }else{
        return pid;
    }
}

@end
