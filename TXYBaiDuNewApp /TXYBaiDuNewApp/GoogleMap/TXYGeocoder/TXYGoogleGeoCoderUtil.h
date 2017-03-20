//
//  TXYGoogleGeoCoderUtil.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXYGoogleGeoCoderUtil : NSObject

+ (NSString *)getFormattedStreetInfoWithResults:(NSDictionary *)results;
+ (NSArray *)getSearchResultsWithDic:(NSDictionary *)results;

@end
