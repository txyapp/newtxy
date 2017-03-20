//
//  juHua.m
//  sss
//
//  Created by root1 on 15/11/20.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "juHua.h"

@interface juHua()

@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)BOOL isShow;

@end

@implementation juHua

- (instancetype)init{
    self=[super init];
    if (self) {
        self.view=[[UIView alloc]init];
    }
    return self;
}

-(void)showAllScreen:(BOOL)isAllSc Image:(UIImage *)img{
    UIApplication *app=[UIApplication sharedApplication];
    UIWindow *win=app.windows[0];
    UIView *rootView=win.rootViewController.view;
    rootView.userInteractionEnabled=!isAllSc;
    
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
    self.view.bounds=CGRectMake(0,
                           0,
                           img.size.width,
                           img.size.height);
    self.view.center=CGPointMake(rootView.frame.size.width*0.5,rootView.frame.size.height*0.5);
    [self.view addSubview:imgView];
    self.label=[[UILabel alloc]init];
    self.label.textAlignment = NSTextAlignmentCenter; 
    self.label.bounds=CGRectMake(0, 0, 200, 30);
    self.label.center=CGPointMake(CGRectGetMaxX(imgView.frame)-img.size.width*0.5, CGRectGetMaxY(imgView.frame)+15);
    self.label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.label];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INTMAX_MAX;
    
    [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    if (self.isShow==NO) {
        [rootView addSubview:self.view];
        self.isShow=YES;
    }
    
}

-(void)hide{
    UIApplication *app=[UIApplication sharedApplication];
    UIWindow *win=app.windows[0];
    UIView *rootView=win.rootViewController.view;
    rootView.userInteractionEnabled=YES;
    [self.view removeFromSuperview];
    self.isShow=NO;
}


@end
