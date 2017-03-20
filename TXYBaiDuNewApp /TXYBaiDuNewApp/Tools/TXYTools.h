//
//  TXYTools.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class UIImage;

@interface TXYTools : NSObject

/**
 *  获取一个工具类的单例
 *
 *  @return TXYTools的实例
 */
+ (instancetype)sharedTools;

/**
 *  获取机器码
 *
 *  @return 机器码
 */
- (NSString *)machineCode;

 /**
 *  当前机器是否可以打开地图开关
 *
 *  @return 是否可以开启的布尔类型
 */
- (BOOL)isCanOpen;

/**
 *  根据路径加载一个字典Plist
 *
 *  @param path 字典文件路径
 *
 *  @return 可变字典
 */
- (NSMutableDictionary *)loadSetDictForPath:(NSString *)path;

/**
 *  把一个字典写入指定路径
 *
 *  @param dict 字典
 *  @param path 需要写入的路径
 *
 *  @return 返回是否写入成功dict
 */
- (BOOL)writeDict:(NSMutableDictionary *)dict toPath:(NSString *)path;

/**
 *  分割gps坐标
 *
 *  @param fromCoor 出发点
 *  @param toCoor   总点
 *  @param length   分割距离单位：米
 *
 *  @return 分割结果数组
 */
-(NSArray *)cutWithFromCoor:(CLLocationCoordinate2D)fromCoor andToCoor:(CLLocationCoordinate2D)toCoor andLength:(double)length;
/**
 *  求方位角
 *
 *  @param fromCoor 出发点
 *  @param toCoor   总点
 *
 *  @return 角度
 */
-(double)getWithFromCoor:(CLLocationCoordinate2D)fromCoor andToCoor:(CLLocationCoordinate2D)toCoor;
//void GetPoint(long double Aj,long double Aw,long double L,long double Angle,long double &Bj,long double &Bw);

/*
 *  上传位置信息
 */
- (void)getOldInfoWithCoor:(CLLocationCoordinate2D)coor andAdress:(NSString *)address;
/*
 *  判断是否在国外，需要上传位置信息
 */
- (void)setOldCoordinate:(CLLocationCoordinate2D)coor;



@end
