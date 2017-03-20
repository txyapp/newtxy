//
//  UpdateService.m
//  TXYUpdateModule
//
//  Created by aa on 16/9/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "UpdateService.h"
#import "UpdateProcess.h"

@interface UpdateService ()

@property (nonatomic,assign) TXYVersionType      versionType;
@property (nonatomic,strong) UpdateProcess      *updateProcesser;
@property (nonatomic,assign) UpdateTpye          updateType;

@end

@implementation UpdateService

+ (instancetype)defaultService
{
    static UpdateService *__defaultService__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultService__ = [[UpdateService alloc] init];
    });
    return __defaultService__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.updateProcesser = [[UpdateProcess alloc] init];
        self.updateProcesser.updateProcessDelegate = self;
        self.updateType = UpdateTpyeNone;
    }
    return self;
}


- (void)setCurrentVersionType:(TXYVersionType)versionType
{
    self.versionType = versionType;
}

- (void)checkUpdateRelease
{
    [self.updateProcesser checkUpdateWithIsRelease:YES];
}

- (void)checkUpdateBeta
{
    [self.updateProcesser checkUpdateWithIsRelease:NO];
}


#pragma mark - delegate
- (void)didUpdateProcessFinishedWithUpdateTpye:(UpdateTpye)type
{
    self.updateType = type;
}
@end
