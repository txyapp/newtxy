//
//  UpdateService.h
//  TXYUpdateModule
//
//  Created by aa on 16/9/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateProcessProtocol.h"


typedef enum{
    TXYVersionTypeRelease,
    TXYVersionTypeBeta
}TXYVersionType;

@interface UpdateService : NSObject<UpdateProcessProtocol>

+ (instancetype)defaultService;

- (void)setCurrentVersionType:(TXYVersionType)versionType;

- (void)checkUpdateRelease;

- (void)checkUpdateBeta;


@end
