//
//  CleanAppViewController.h
//  FakePhoneApp
//
//  Created by root1 on 15/9/8.
//  Copyright (c) 2015年 root1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassDelegate.h"
@interface CleanAppViewController : UIViewController<PassDelegate>

@property(copy,nonatomic)void(^selectAppArrayBlock)(NSMutableArray *);

@property(nonatomic,weak)id<PassDelegate> delegate;
@end
