//
//  DidianModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DidianModel.h"

@interface DidianModel : NSObject



//关键字
@property (nonatomic,copy)NSString* key;
//城市
@property (nonatomic,copy)NSString* city;
//地区
@property (nonatomic,copy)NSString* district;
//poi ID
@property (nonatomic,copy)NSString* poiId;
//封装成NSValue的CLLocationCoordinate2D
@property (nonatomic,strong)NSValue* coordValue;
//邮编
@property (nonatomic,strong)NSString* postcode;
//电话
@property (nonatomic,strong)NSString* phone;
//距离
@property (nonatomic,copy)NSString* juli;

//地点model
@property (nonatomic,strong)DidianModel* model;

//latitude
@property (nonatomic,copy)NSNumber* latitude;

//long
@property (nonatomic,copy)NSNumber* longitude;

@end
/*
 
 //按移动距离计算
 void notificationCallback (CFNotificationCenterRef center,
 void * observer,
 CFStringRef name,
 const void * object,
 CFDictionaryRef userInfo) {
 
 
 NSString *str = XuanFuGPSPlist;
 NSMutableDictionary *plistDict;
 if (str) {
 plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuGPSPlist];
 if (plistDict==nil) {
 plistDict=[NSMutableDictionary dictionary];
 }
 }else{
 plistDict=[NSMutableDictionary dictionary];
 }
 NSDictionary* xuanfuDic = [plistDict objectForKey:@"xuanfugps"];
 NSMutableDictionary* xuanfuMdic = nil;
 if (xuanfuDic == nil){
 xuanfuMdic = [NSMutableDictionary dictionary];
 }else{
 xuanfuMdic = [NSMutableDictionary dictionaryWithDictionary:xuanfuDic];
 }
 NSNumber *vx = [xuanfuDic objectForKey:@"dirx"];
 NSNumber *vy = [xuanfuDic objectForKey:@"diry"];
 CGPoint dir;
 if (vx && vy) {
 double dx = [vx doubleValue];
 double dy = [vy doubleValue];
 dir = CGPointMake(dx, dy);
 }
 NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
 NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
 CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
 if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
 coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
 }
 CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为百度
 CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
 CGPoint dar = [_mapView convertCoordinate:baiduZuo toPointToView:_mapView];
 CGPoint dararar;
 NSLog(@"移动停止 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 if ([jingdu isEqualToString:@"1m"]) {
 darCoord.latitude = -ee*(dir.x/40/5)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40/5)+darCoord.longitude;
 }
 if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 //        darCoord.latitude = -ee*(dir.x/40)+darCoord.latitude;
 //        darCoord.longitude = ee*(dir.y/40)+darCoord.longitude;
 dararar.x = dar.x + dir.x/40;
 dararar.y = dar.y + dir.y/40;
 }
 if ([jingdu isEqualToString:@"20m"]) {
 darCoord.latitude = -ee*(dir.x/40*4)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40*4)+darCoord.longitude;
 }
 if ([jingdu isEqualToString:@"1000m"]) {
 darCoord.latitude = -ee*(dir.x/40*20)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40*20)+darCoord.longitude;
 }
 NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为百度
 CLLocationCoordinate2D baiduZuo111 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing111];
 [[TXYConfig sharedConfig]setFakeGPS:darCoord];
 [_mapView setCenterCoordinate:baiduZuo111];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = baiduZuo111;
 _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
 pt1.reverseGeoPoint = baiduZuo111;
 [_search reverseGeoCode:pt1];
 }
 //滑动停止时的反应
 void notificationCallbackEnd (CFNotificationCenterRef center,
 void * observer,
 CFStringRef name,
 const void * object,
 CFDictionaryRef userInfo) {
 NSString *str = XuanFuEndGPSPlist;
 NSMutableDictionary *plistDict;
 if (str) {
 plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:XuanFuEndGPSPlist];
 if (plistDict==nil) {
 plistDict=[NSMutableDictionary dictionary];
 }
 }else{
 plistDict=[NSMutableDictionary dictionary];
 }
 NSDictionary* xuanfuDic = [plistDict objectForKey:@"xuanfugps"];
 NSMutableDictionary* xuanfuMdic = nil;
 if (xuanfuDic == nil){
 xuanfuMdic = [NSMutableDictionary dictionary];
 }else{
 xuanfuMdic = [NSMutableDictionary dictionaryWithDictionary:xuanfuDic];
 }
 NSNumber *vx = [xuanfuDic objectForKey:@"dirx"];
 NSNumber *vy = [xuanfuDic objectForKey:@"diry"];
 CGPoint dir;
 if (vx && vy) {
 double dx = [vx doubleValue];
 double dy = [vy doubleValue];
 dir = CGPointMake(dx, dy);
 }
 NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
 NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
 CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
 if (!(((int)[[TXYConfig sharedConfig]getFakeGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getFakeGPS].longitude == 0))) {
 coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
 }
 CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为百度
 CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
 NSLog(@"移动停止 精度处理前dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 if ([jingdu isEqualToString:@"1m"]) {
 darCoord.latitude = -ee*(dir.x/40/5)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40/5)+darCoord.longitude;
 }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 darCoord.latitude = -ee*(dir.x/40)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40)+darCoord.longitude;
 }
 if ([jingdu isEqualToString:@"20m"]) {
 darCoord.latitude = -ee*(dir.x/40*4)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40*4)+darCoord.longitude;
 }
 if ([jingdu isEqualToString:@"1000m"]) {
 darCoord.latitude = -ee*(dir.x/40*20)+darCoord.latitude;
 darCoord.longitude = ee*(dir.y/40*20)+darCoord.longitude;
 }
 NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为百度
 CLLocationCoordinate2D baiduZuo111 = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing111];
 [[TXYConfig sharedConfig]setFakeGPS:darCoord];
 [_mapView setCenterCoordinate:baiduZuo111];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = baiduZuo111;
 _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
 pt1.reverseGeoPoint = baiduZuo111;
 [_search reverseGeoCode:pt1];
 
 }

 
 */