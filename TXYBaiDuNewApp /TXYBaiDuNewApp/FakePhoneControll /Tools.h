//
//  Tools.h
//  TxyFakePhone
//
//  Created by root1 on 16/3/22.
//  Copyright (c) 2016年 yunlian. All rights reserved.
//

typedef enum DevTpye {
    cancel,
    iPhone,
    iPad,
} DevTpye;

typedef enum DevVersion {
    cancel2,
    fiOS7,
    fiOS8,
    fiOS9,
} DevVersion;

#import <UIKit/UIKit.h>

@interface Tools : NSObject

+(instancetype)sharedTools;

/**
 *  清理Safari
 */
-(void)cleanSafari;

/**
 *  获取改机信息
 *
 */
-(NSMutableDictionary *)getInfoDict;

/**
 *  清理剪切版
 */
-(void)cleanClipboard;

/**
 *  针对bundleId清理KeyChain
 */
-(void)cleanKeyChainWithBundleId:(NSArray *)bundleIdArr;

/**
 *  针对bundleId备份app数据
 */
typedef void (^backupBlockOver)(NSDictionary *dict);
-(void)BackupAppDataWithBundleId:(NSArray *)bundleIdArr withKey:(NSString *)key :(backupBlockOver)block;

/**
 *  删除备份数据
 *
 */
-(void)deleteForBackUpWithBundleId:(NSString *)bundleId Key:(NSString *)key;

/**
 *  针对bundleId清理app数据
 */
-(void)cleanAppDataWithBundleId:(NSArray *)bundleIdArr;

/**
 *  恢复app备份
 *
 */
-(void)recoverAppWhitBundleId:(NSArray *)bundleIdArr WithKey:(NSString *)key;

/**
 *  针对bundleId 设置模拟3G网络
 */
-(void)set3G:(BOOL)is3G WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置设备类型
 */
-(void)setDevType:(DevTpye)type WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置设备版本
 */
-(void)setDevVersion:(DevVersion)version WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置设备名称
 */
-(void)setDevName:(NSString *)devName WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置序列号
 */
-(void)setSeral:(NSString *)devSeral WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置UUID
 */
-(void)setUUID:(NSString *)UUID WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置广告标识符
 */
-(void)setADUUID:(NSString *)ADUUID WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置路由器wifi名称
 */
-(void)setWiFiName:(NSString *)WIFIName WithBundleId:(NSString *)bundleId;

/**
 *  针对bundleId 设置路由器wifi地址
 */
-(void)setWiFiMAC:(NSString *)WIFIMac WithBundleId:(NSString *)bundleId;

/**
 *  撤销app修改
 */
-(void)cancelChangeWithBundleId:(NSString *)bundleId;

/**
 *  获取设备剩余空间
 *
 */
-(float)deviceFreeSpace;

typedef void (^folderSizeBlock)(float size);
/**
 *  获取一个文件夹的大小
 *
 */
- (void)folderSizeAtPath:(NSArray*)folderPath WithBlock:(folderSizeBlock)block;

/**
 *  关闭一个app
 */
-(void)killAppForBundleId:(NSString *)bundleId;

@end





