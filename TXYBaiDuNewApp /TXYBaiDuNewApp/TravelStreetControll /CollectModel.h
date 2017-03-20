//
//  CollectModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CollectModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* time;



@property (nonatomic)NSNumber* longitude;

@property (nonatomic)NSNumber* latitude;

@end
