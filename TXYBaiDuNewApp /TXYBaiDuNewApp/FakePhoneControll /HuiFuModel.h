//
//  HuiFuModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuiFuModel : NSObject
{
    BOOL                _isOpen;
}

@property (nonatomic, assign)   BOOL        isOpen;
@property (nonatomic,copy)NSString *Time;
@property (nonatomic,copy)NSString *ADUUID;
@property(nonatomic,copy)NSString *UUID;

@property(nonatomic,copy)NSArray *APP;
@property(nonatomic,copy)NSString *WiFiMAC;
@property(nonatomic,copy)NSString *WiFiName;
@property(nonatomic,copy)NSString *devName;
@property(nonatomic,copy)NSString *devType;
@property(nonatomic,copy)NSString *devVer;
@property(nonatomic,copy)NSString *netState;
@property(nonatomic,copy)NSString *shuju;
@end
