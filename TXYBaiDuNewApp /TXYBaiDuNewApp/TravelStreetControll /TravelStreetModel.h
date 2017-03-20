//
//  TravelStreetModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/15.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TravelStreetModel : NSObject
@property(nonatomic,copy)NSString *textName;
@property(nonatomic)UIImage *image;
@property(nonatomic,copy)NSString *type;
@property(nonatomic)int on;
//哪个地图引擎下的
@property(nonatomic,copy)NSString *whichMap;
@end
