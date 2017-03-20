//
//  XuandianModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/24.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface XuandianModel : NSObject<NSCoding>

//他的位置信息
@property (nonatomic,copy)NSString* weizhi;
//时间
@property (nonatomic,copy)NSString*  time;
//距离
@property (nonatomic,copy)NSString*  juli;
//位置对象
@property(nonatomic,copy)CLLocation *location;
//你选的是第几个点
@property (nonatomic)int  index;
//维度
@property(nonatomic)double latitude;
//经度
@property(nonatomic)double longtitude;
//在stept中的位置
@property(nonatomic)int indexInStep;
//哪个应用
@property(nonatomic,copy)NSString *whichbundle;
//哪一个step
@property(nonatomic)int whichstep;
//所在step的点的总数
@property(nonatomic)int thestepTotleNum;
//所在路线总共有多少个step
@property(nonatomic)int totleStep;
//是否是拐点(红绿灯的地方)
@property(nonatomic)int isWaitPoint;
//此点的等待时间 seconds
@property(nonatomic)int  waiteSeconds;
//该app扫街是否循环
@property(nonatomic)int isCycle;
//
@property(nonatomic)CLLocationCoordinate2D currentLocation;
//存储gps坐标相对地图的点
@property(nonatomic)double x;
@property(nonatomic)double y;
//扫街频率
@property(nonatomic)double ScanRate;

@property (nonatomic,copy)NSString* latitudeStr;

@property (nonatomic,copy)NSString* longitudeStr;

@property (nonatomic,strong)NSNumber* latitudeNum;
@property (nonatomic,strong)NSNumber* longitudeNum;
//红绿灯选择的时间
@property(nonatomic)int redWaitSeconds;
//速度
@property(nonatomic)int speed;
//记录点是否需要提醒
@property(nonatomic)int alertOn;
//记录路线的类型
@property(nonatomic)int linesType;
//是否终点停留
@property(nonatomic)int isState;
//是否是收藏夹选点
@property(nonatomic)int isCollec;
//该店驻留的时间
@property(nonatomic,copy)NSString *waitTime;
@end
