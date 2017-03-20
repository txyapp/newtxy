//
//  MyAlert.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlert : UIAlertView
+(void)ShowAlertMessage:(NSString *)aMessage title:(NSString *)aTitle;
+(void)ShowAlertBtnNum;
@end
