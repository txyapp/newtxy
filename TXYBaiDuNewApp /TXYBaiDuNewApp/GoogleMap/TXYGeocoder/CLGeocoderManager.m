//
//  CLGeocoderManager.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "CLGeocoderManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TXYGoogleGeoCoderUtil.h"


#define kReverseGeocoderURLString(lat,lon) [NSString stringWithFormat:@"https://maps.google.cn/maps/api/geocode/json?latlng=%f,%f&language=zh-CN",lat,lon];

#define kGeocoderRootURLString [NSString stringWithFormat:@"https://maps.google.cn/maps/api/geocode/json"];

@interface CLGeocoderManager()

@end

@implementation CLGeocoderManager

+ (instancetype)sharedManager
{
    static CLGeocoderManager *__sharedManager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager__ = [[CLGeocoderManager alloc] init];
    });
    return __sharedManager__;
}

#pragma mark - interface imp
- (void)startReverseGeocoderWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = kReverseGeocoderURLString(coordinate.latitude,coordinate.longitude);
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *streetInfo = [TXYGoogleGeoCoderUtil getFormattedStreetInfoWithResults:responseObject];
        [self.reverseGeocoderDelegate didReverseGeocodeSuccessWithStreetInfo:streetInfo andCoordinate:coordinate];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.reverseGeocoderDelegate didReverseGeocodeFailedWithInfo:@"解析失败，请稍后再试"];
    }];
}

- (void)startGeocoderSearchText:(NSString *)searchText
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = kGeocoderRootURLString;
    NSDictionary *params = @{@"address":searchText};
    [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *result = [TXYGoogleGeoCoderUtil getSearchResultsWithDic:responseObject];
        NSLog(@"res = %@",responseObject);
        [self.geocoderSearchDelegate didGeocoderSuccessWithResults:result];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.geocoderSearchDelegate didGeocoderFailedWithInfo:@"搜索失败，请稍后再试"];
    }];
}

@end
