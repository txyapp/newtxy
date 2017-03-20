//
//  SetViewController.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PassDelegate.h"
@interface SetViewController : UIViewController<PayPalPaymentDelegate,UIPopoverControllerDelegate,PassDelegate>
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end
