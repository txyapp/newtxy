//
//  TravelStreetViewController.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
@interface TravelStreetViewController : UIViewController<PassDelegate>
@property(nonatomic,weak)id<PassDelegate>delegate;
@end
