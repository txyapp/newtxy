/*
 ============================================================================
 Name           : QAppKeyCheck.h
 Author         : 腾讯SOSO地图API
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QAppKeyCheck,QAppKeyCheckDelegate declaration
 ============================================================================
 */

/**    @file QAppKeyCheck.h     */

#import <Foundation/Foundation.h>
#import "QTypes.h"

/*!
 *  @brief  协议类。用于通知APPKey验证的结果的回调
 */
@protocol QAppKeyCheckDelegate <NSObject>

/*!
 *  @brief  通知APPKey验证的结果
 *
 *  @param errCode 错误码
 */
- (void)notifyAppKeyCheckResult:(QErrorCode)errCode;

@end

/*!
 *  @brief  APPKey验证的类
 */
@interface QAppKeyCheck : NSObject

/*!
 *  @brief 用户传入的唯一识别ID
 */
@property(nonatomic,retain) NSString* suid;

/*!
 *  @brief SDK 生成的唯一id
 */
@property(nonatomic,readonly)NSString* mapGenerateId;

/*!
 *  @brief 版本号
 */
@property(nonatomic,readonly)NSString* version;

/*!
 *  @brief  启动APPKey验证
 *
 *  @param key 申请的有效key
 *  @param delegate 代理
 *
 *  @return 是否成功
 */
-(BOOL)start:(NSString*)key withDelegate:(id<QAppKeyCheckDelegate>)delegate;

/*!
 *  @brief  停止或取消APPKey验证
 */
-(void)stop;

@end
