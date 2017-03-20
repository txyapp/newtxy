//
//  PassDelegate.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/8.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XuandianModel.h"
@protocol PassDelegate <NSObject>
@optional
-(void)chuanzhi:(XuandianModel *)model;
-(void)chuanLines:(NSArray *)arr;
-(void)chuanzhiGPS:(XuandianModel *)model;
- (void)chuancan:(NSMutableArray*)array;
-(void)DelCellAtIndex:(NSString *)bundle;
-(void)refrush;
-(void)refrushWith:(NSString *)bundle;
//恢复后的回调
-(void)changeAfter:(int)which;
//选择app后返回设置界面的代理方法
-(void)chooseApp;
@end
