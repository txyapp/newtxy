//
//  ResultModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/11/18.
//  Copyright © 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface ResultModel : NSObject<NSCoding>
@property(nonatomic)double x;
@property(nonatomic)double y;
//扫街频率
@property(nonatomic)double ScanRate;
//红绿灯选择的时间
@property(nonatomic)int redWaitSeconds;
//维度
@property(nonatomic)double latitude;
//经度
@property(nonatomic)double longtitude;
//该app扫街是否循环
@property(nonatomic)int isCycle;
//是否是拐点(红绿灯的地方)
@property(nonatomic)int isWaitPoint;
//他的位置信息
@property (nonatomic,copy)NSString* weizhi;
//时间
@property (nonatomic,copy)NSString*  time;
//此点的等待时间 seconds
@property(nonatomic)int  waiteSeconds;
//哪个应用
@property(nonatomic,copy)NSString *whichbundle;
@end
