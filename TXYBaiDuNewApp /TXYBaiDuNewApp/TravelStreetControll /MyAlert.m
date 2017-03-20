//
//  MyAlert.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MyAlert.h"

@implementation MyAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)ShowAlertMessage:(NSString *)aMessage title:(NSString *)aTitle
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    NSLog(@"%f    %f",alert.frame.origin.x,alert.frame.origin.y);
    [alert show];
}
+(void)ShowAlertBtnNum
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"选择数量" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    UITextField * txt = [[UITextField alloc] init];
    txt.backgroundColor = [UIColor whiteColor];
    txt.frame = CGRectMake(alert.center.x+65,alert.center.y+48, 150,23);
    [alert addSubview:txt];
    [alert show];
}
@end
