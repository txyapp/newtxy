//
//  MyAnnotation.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/30.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyAnnotation : NSObject<BMKAnnotation>

@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * subtitle;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
