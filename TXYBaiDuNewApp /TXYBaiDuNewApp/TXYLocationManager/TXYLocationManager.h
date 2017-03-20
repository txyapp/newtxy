//
//  TXYLocationManager.h
//  TXYBaiDuNewApp
//
//  Created by aa on 16/8/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TXYLocationManager : NSObject

+ (instancetype)sharedManager;

- (void)startSearchRealLocation;

@end
