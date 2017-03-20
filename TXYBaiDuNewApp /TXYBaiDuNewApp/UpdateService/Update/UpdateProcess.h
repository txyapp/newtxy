//
//  UpdateProcess.h
//  TXYUpdateModule
//
//  Created by aa on 16/9/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateProcessProtocol.h"

@interface UpdateProcess : NSObject

@property (nonatomic,assign) float       currentVersion;

@property (nonatomic,assign) float       betaVersion;
@property (nonatomic,assign) float       releaseVersion;
@property (nonatomic,strong) NSString   *downloadURLString;

@property (nonatomic,weak) id<UpdateProcessProtocol>         updateProcessDelegate;

- (void)checkUpdateWithIsRelease:(BOOL)isRelease;

@end
