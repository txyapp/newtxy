//
//  TXYGoogleGeoCoderUtil.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "TXYGoogleGeoCoderUtil.h"

@implementation TXYGoogleGeoCoderUtil

+ (NSString *)getFormattedStreetInfoWithResults:(NSDictionary *)results
{
    NSArray *result_infos = [results objectForKey:@"results"];
    if (result_infos.count == 0) {
        return @"无位置信息";
    }else{
        NSDictionary *info = [result_infos objectAtIndex:0];
        NSString *streetInfo = [info objectForKey:@"formatted_address"];
        if (streetInfo) {
            return [info objectForKey:@"formatted_address"];
        }else{
            return @"无位置信息";
        }
        
    }
}

+ (NSArray *)getSearchResultsWithDic:(NSDictionary *)results
{
//    NSLog(@"%@",results);
    return [results objectForKey:@"results"];
}

@end
