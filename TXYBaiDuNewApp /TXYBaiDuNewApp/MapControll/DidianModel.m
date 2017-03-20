//
//  DidianModel.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/11.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "DidianModel.h"

@implementation DidianModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


/*
 //根据经纬度计算 运行时
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
 CGPoint dar;
 NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
 NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
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
 baiduZuo.latitude = -LA*(dir.x/40/5)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40/5)+coord.longitude;
 }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 baiduZuo.latitude = -LA*(dir.x/40)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40)+coord.longitude;
 }
 if ([jingdu isEqualToString:@"20m"]) {
 baiduZuo.latitude = -LA*(dir.x/40*4)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40*4)+coord.longitude;
 }
 if ([jingdu isEqualToString:@"1000m"]) {
 baiduZuo.latitude = -LA*(dir.x/40*20)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40*20)+coord.longitude;
 }
 NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 //先把百度坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]hhTrans_GCGPS:baiduZuo];
 //再把火星坐标转为gps坐标
 CLLocationCoordinate2D gpsZuo111 = [[FireToGps sharedIntances]gcj02Decrypt:huoxing111.latitude gjLon:huoxing111.longitude];
 [[TXYConfig sharedConfig]setFakeGPS:gpsZuo111];
 [_mapView setCenterCoordinate:baiduZuo];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = baiduZuo;
 _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
 pt1.reverseGeoPoint = baiduZuo;
 [_search reverseGeoCode:pt1];
 */


/*
 //根据经纬度计算  结束时
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
 baiduZuo.latitude = -LA*(dir.x/40/5)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40/5)+coord.longitude;
 }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 baiduZuo.latitude = -LA*(dir.x/40)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40)+coord.longitude;
 }
 if ([jingdu isEqualToString:@"20m"]) {
 baiduZuo.latitude = -LA*(dir.x/40*4)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40*4)+coord.longitude;
 }
 if ([jingdu isEqualToString:@"1000m"]) {
 baiduZuo.latitude = -LA*(dir.x/40*20)+coord.latitude;
 baiduZuo.longitude = LO*(dir.y/40*20)+coord.longitude;
 }
 NSLog(@"移动停止 精度处理后dir.x = %f ,dir.y = %f dar.la = %f,dar.lo = %f",dir.x,dir.y,baiduZuo.latitude,baiduZuo.longitude);
 //先把百度坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]hhTrans_GCGPS:baiduZuo];
 //再把火星坐标转为gps坐标
 CLLocationCoordinate2D gpsZuo111 = [[FireToGps sharedIntances]gcj02Decrypt:huoxing111.latitude gjLon:huoxing111.longitude];
 [[TXYConfig sharedConfig]setFakeGPS:gpsZuo111];
 [_mapView setCenterCoordinate:baiduZuo];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = baiduZuo;
 _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
 pt1.reverseGeoPoint = baiduZuo;
 [_search reverseGeoCode:pt1];
 */
//根据距离计算
/*
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
 dir = CGPointMake(dx,dy);
 }
 NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
 NSString* jingdu = [userPoint objectForKey:@"xuanfujingdu"];
 CGPoint newDir;
 CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
 if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
 coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
 }
 CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为
 CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
 NSLog(@"darCoordZuo.la = %f,darCoordZuo.lo = %f",darCoord.latitude,darCoord.longitude);
 // CGPoint dar = [_mapView convertCoordinate:baiduZuo toPointToView:_mapView];
 CGPoint dar = _mapView.center;
 NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f newDir.x = %f,newDir.y = %f,_mapView.center.x = %f,_mapView.center.y = %f",dir.x,dir.y,newDir.x,newDir.y,_mapView.center.x,_mapView.center.y);
 if ([jingdu isEqualToString:@"1m"]) {
 newDir.x = dir.x/5+dar.x;
 newDir.y = dir.y/5+dar.y;
 }
 if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 newDir.x = dir.x+dar.x;
 newDir.y = dir.y+dar.y;
 }
 if ([jingdu isEqualToString:@"20m"]) {
 newDir.x = dir.x*4+dar.x;
 newDir.y = dir.y*4+dar.y;    }
 if ([jingdu isEqualToString:@"1000m"]) {
 newDir.x = dir.x*20+dar.x;
 newDir.y = dir.y*20+dar.y;
 }
 NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f newDir.x = %f,newDir.y = %f,_mapView.center.x = %f,_mapView.center.y = %f",dir.x,dir.y,newDir.x,newDir.y,_mapView.center.x,_mapView.center.y);
 CLLocationCoordinate2D newCoord = [_mapView convertPoint:newDir toCoordinateFromView:_mapView];
 //先把百度坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]hhTrans_GCGPS:newCoord];
 //再把火星坐标转为gps坐标
 CLLocationCoordinate2D gpsZuo111 = [[FireToGps sharedIntances]gcj02Decrypt:huoxing111.latitude gjLon:huoxing111.longitude];
 NSLog(@"gpsZuo111.la = %f,gpsZuo111.lo = %f",gpsZuo111.latitude,gpsZuo111.longitude);
 
 [[TXYConfig sharedConfig]setFakeGPS:gpsZuo111];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = newCoord;
 // _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 */


/*
 //根据距离计算  停止时
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
 CGPoint newDir;
 CLLocationCoordinate2D coord = [[TXYConfig sharedConfig]getFakeGPS];
 if (!(((int)[[TXYConfig sharedConfig]getRealGPS].latitude == 0)&&((int)[[TXYConfig sharedConfig]getRealGPS].longitude == 0))) {
 coord = CLLocationCoordinate2DMake([[TXYConfig sharedConfig]getRealGPS].latitude, [[TXYConfig sharedConfig]getRealGPS].longitude);
 }
 CLLocationCoordinate2D darCoord = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
 //将工具类中的gps坐标转为火星坐标
 CLLocationCoordinate2D huoxing = [[FireToGps sharedIntances]gcj02Encrypt:darCoord.latitude bdLon:darCoord.longitude];
 //将火星转为百度
 CLLocationCoordinate2D baiduZuo = [[FireToGps sharedIntances]hhTrans_bdGPS:huoxing];
 //CGPoint dar = [_mapView convertCoordinate:baiduZuo toPointToView:_mapView];
 CGPoint dar = _mapView.center;
 NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f newDir.x = %f,newDir.y = %f",dir.x,dir.y,newDir.x,newDir.y);
 if ([jingdu isEqualToString:@"1m"]) {
 newDir.x = dir.x/5+dar.x;
 newDir.y = dir.y/5+dar.y;
 }    if ([jingdu isEqualToString:@"5m"]||!jingdu) {
 newDir.x = dir.x+dar.x;
 newDir.y = dir.y+dar.y;    }
 if ([jingdu isEqualToString:@"20m"]) {
 newDir.x = dir.x*4+dar.x;
 newDir.y = dir.y*4+dar.y;    }
 if ([jingdu isEqualToString:@"1000m"]) {
 newDir.x = dir.x*20+dar.x;
 newDir.y = dir.y*20+dar.y;
 }
 NSLog(@"移动时 精度处理后dir.x = %f ,dir.y = %f newDir.x = %f,newDir.y = %f",dir.x,dir.y,newDir.x,newDir.y);
 CLLocationCoordinate2D newCoord = [_mapView convertPoint:newDir toCoordinateFromView:_mapView];
 //先把百度坐标转为火星坐标
 CLLocationCoordinate2D huoxing111 = [[FireToGps sharedIntances]hhTrans_GCGPS:newCoord];
 //再把火星坐标转为gps坐标
 CLLocationCoordinate2D gpsZuo111 = [[FireToGps sharedIntances]gcj02Decrypt:huoxing111.latitude gjLon:huoxing111.longitude];
 [[TXYConfig sharedConfig]setFakeGPS:gpsZuo111];
 [_mapView setCenterCoordinate:newCoord];
 [_mapView removeAnnotation:_annotation];
 _annotation.coordinate = newCoord;
 _annotation.title = @"解析中";
 [_mapView addAnnotation:_annotation];
 BMKReverseGeoCodeOption* pt1 = [[BMKReverseGeoCodeOption alloc]init];
 pt1.reverseGeoPoint = newCoord;
 [_search reverseGeoCode:pt1];

 */





@end
