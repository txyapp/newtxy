#import <Foundation/Foundation.h>
#import "NSDictionary+noNIL.h"


#define IPAManagerNotificationInstallCallback     @"installCallback"
#define IPAManagerNotificationUninstallCallback   @"uninstallCallback"
#define IPAManagerNotificationarchiveCallback     @"archiveCallback"


@interface ipaManage : NSObject {
    void * _module;
    void * _springBooardModule;
    void * _uiKitModule;
}

//安装
- (NSInteger) install:(NSString*)ipaPath callback:(void *)aInstallCallback userData:(id)userData;
//IOS8用安装
/*
 status={
 PercentComplete = 50;
 Status = CreatingContainer;
 }
 */
- (BOOL) installApp:(NSString*)ipaPath usingBlock:(void (^)(NSDictionary *status))statusBlock;

//卸载
- (NSInteger) uninstall:(NSString*)Identifier callback:(void *)aUninstallCallback userData:(id)userData;

//IOS8卸载
- (NSInteger) uninstallApp:(NSString*)Identifier;

//归档
- (NSInteger) archive:(NSString*)Identifier callBack:(void *)aArchiveCallback;
//删除归档
- (NSInteger) removeArchive:(NSString *)Identifier callBack:(void *)aRemoveArchiveCallback;
//枚举
- (NSMutableArray *) browseInstalledAppList;
//枚举2
- (NSDictionary *)lookUpAppList;

//根据APPID取得路径
- (NSString*) bundlePathForAppID:(NSString*)identifier;
//获取指定appid的数据
- (NSData*) bundleIconForAppID:(NSString*)identifier;
//获取appid的显示名字
- (NSString*)displayNameForAppID:(NSString*)identifier;
//正在运行的app的bundle id列表
-(NSArray *)allRunningAppids;
//得到iphone 前台运行的app的bundle id
-(NSString*)frontMostAppID;

//获取应用的列表(适合IOS8)
-(NSDictionary*)installedApps;
@end
