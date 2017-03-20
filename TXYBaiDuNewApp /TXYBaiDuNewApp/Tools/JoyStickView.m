//
//  VisualStickView.m
//  SampleGame
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Myst. All rights reserved.
//

#import "JoyStickView.h"

#define STICK_CENTER_TARGET_POS_LEN 20.0f

@implementation JoyStickView

-(void) initStick
{
    
    stickViewBase = [[UIImageView alloc]init];
    stickViewBase.frame = CGRectMake(0, 0, 60, 60);
    stickView = [[UIImageView alloc]init];
    stickView.frame = CGRectMake(15, 15, 30, 30);
    stickView.backgroundColor = [UIColor redColor];
    stickViewBase.backgroundColor = [UIColor grayColor];
    stickViewBase.layer.masksToBounds = YES;
    stickViewBase.layer.cornerRadius = 30;
    stickViewBase.layer.borderWidth = 1;
    stickView.layer.masksToBounds = YES;
    stickView.layer.cornerRadius = 15;
    stickView.layer.borderWidth = 1;
    _mCenter = stickViewBase.center;
    [self addSubview:stickViewBase];
    [self addSubview:stickView];
    self.frame = CGRectMake(50, Height/4*3, 60, 60);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStick];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
        // Initialization code
        [self initStick];
    }
	
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)notifyDir:(CGPoint)dir
{
    
    NSValue *vdir = [NSValue valueWithCGPoint:dir];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              vdir, @"dir", nil];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"StickChanged" object:nil userInfo:userInfo];
   
}

- (void)GPSMoveTo:(CGPoint)dir
{
    
    NSValue *vdir = [NSValue valueWithCGPoint:dir];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              vdir, @"dir", nil];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"GPSMoveTo" object:nil userInfo:userInfo];
    
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    CGRect fr = stickView.frame;
    fr.origin.x = deltaToCenter.x+15;
    fr.origin.y = deltaToCenter.y+15;
    stickView.frame = fr;
}

- (void)touchEvent:(NSSet *)touches
{

    if([touches count] != 1)
        return ;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
    CGPoint touchPoint = [touch locationInView:stickViewBase];
   // NSLog(@"touchpoint.x = %f,touchpoint.y = %f,view.wid = %f,view.hei = %f,center.x = %f,center.y = %f",touchPoint.x,touchPoint.y,view.frame.size.width,view.frame.size.height,_mCenter.x,_mCenter.y);
    CGPoint dtarget, dir,dar;
    dir.x = touchPoint.x - _mCenter.x;
    dir.y = touchPoint.y - _mCenter.y;
   // NSLog(@"dir.x = %f,dir.y = %f",dir.x,dir.y);
    dar.x = dir.x;
    dar.y = dir.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);
    NSLog(@"len = %f",len);
    if(len < 10.0 && len > -10.0)
    {
        // center pos
        dtarget.x = 0.0;
        dtarget.y = 0.0;
        dir.x = 0;
        dir.y = 0;
    }
    else
    {
        double len_inv = (1.0 / len);
        
        dir.x *= len_inv;
        dir.y *= len_inv;
        dtarget.x = dir.x * 40;
        dtarget.y = dir.y * 40;
    }
    [self stickMoveTo:dtarget];
    
    [self notifyDir:dar];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    CGPoint dtarget, dir;
    dtarget.x = 0.0;
    dtarget.y = 0.0;
    //手指离开屏幕后小圆点回归原地
    [self stickMoveTo:dtarget];
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
    CGPoint touchPoint = [touch locationInView:stickViewBase];
    NSLog(@"touchpoint.x = %f,touchpoint.y = %f,view.wid = %f,view.hei = %f,center.x = %f,center.y = %f",touchPoint.x,touchPoint.y,view.frame.size.width,view.frame.size.height,_mCenter.x,_mCenter.y);
    dir.x = touchPoint.x - _mCenter.x;
    dir.y = touchPoint.y - _mCenter.y;
    CGPoint dar;
    dar.x = dir.x;
    dar.y = dir.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);
    NSLog(@"len = %f",len);
    if(len < 10.0 && len > -10.0)
    {
        dir.x = 0;
        dir.y = 0;
    }
    else
    {
        double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;
    }
    [self GPSMoveTo:dar];
}

@end
