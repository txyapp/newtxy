//
//  ApplicationViewController.h
//  TXYBaiDuNewApp
//
//  Created by Macmini1 on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"

@interface ApplicationViewController : UIViewController<PassDelegate>

@property (nonatomic,strong)id<PassDelegate>delegate;

@end
