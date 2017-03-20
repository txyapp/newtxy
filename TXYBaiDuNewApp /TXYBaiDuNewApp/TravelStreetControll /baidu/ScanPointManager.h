//
//  ScanPointManager.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanPointManager : NSObject
@property(nonatomic,strong) NSMutableDictionary *dic;
+(ScanPointManager*)defaultManager;
@end
