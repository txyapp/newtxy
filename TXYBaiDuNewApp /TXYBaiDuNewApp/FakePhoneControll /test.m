//
//  test.m
//  1111111
//
//  Created by yunlian on 16/3/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "test.h"
#import "Passdelegate.h"
#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
@implementation test
@synthesize contentView,parentView,drawState,left,right;
@synthesize arrow;
- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
{
    self = [super initWithFrame:CGRectMake(parentview.frame.size.width - 28, 0, 400, parentview.frame.size.height)];
    //self.backgroundColor  = [UIColor redColor];
    if (self) {
        contentView = contentview;
        parentView = parentview;
        
//        UIImage *drawer_arrow = [UIImage imageNamed:@"drawer_arrow.png"];
//        arrow = [[UIImageView alloc]initWithImage:drawer_arrow];
//        [arrow setFrame:CGRectMake(0,(self.frame.size.height-56)/2,28,28)];
//        [self addSubview:arrow];
        
        //嵌入内容的UIView
        [contentView setFrame:CGRectMake(28,0,Width/2 - 28 , self.frame.size.height)];
        [self addSubview:contentview];
        
        //移动的手势
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRcognize.delegate=self;
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        
        [self addGestureRecognizer:panRcognize];
        
        //单击的手势
//        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
//        tapRecognize.numberOfTapsRequired = 1;
//        tapRecognize.delegate = self;
//        [tapRecognize setEnabled :YES];
//        [tapRecognize delaysTouchesBegan];
//        [tapRecognize cancelsTouchesInView];
//        
//        [self addGestureRecognizer:tapRecognize];
        
        //设置两个位置的坐标
        right = CGPointMake(parentview.frame.size.width-14  + contentview.frame.size.width/2, parentview.frame.size.height/2);
        //NSLog(@"%d",self.frame.size.width);
        left = CGPointMake(parentview.frame.size.width - contentview.frame.size.width/2, parentview.frame.size.height/2);
        self.center =  right;
        
        //设置起始状态
        drawState = DrawerViewStateDown;
    }
    return self;
}
#pragma UIGestureRecognizer Handles
/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    CGPoint translation = [recognizer translationInView:parentView];
//    NSLog(@"%f",translation.x);
//    if (self.center.x + translation.x < left.x) {
//        self.center = left;
//    }else if(self.center.x + translation.x > right.x)
//    {
//        self.center = right;
//    }else{
//        self.center = CGPointMake(self.center.x + translation.x,self.center.y);
//    }
//  
//    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];
   // NSLog(@"%d",self.center.x);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (translation.x < 0) {
                self.center = left;
                //[self transformArrow:DrawerViewStateUp];
              //  [self.delegate mengcengUp];
            }else
            {
                self.center = right;
               // [self.delegate mengcengDown];
                //[self transformArrow:DrawerViewStateDown];
            }
            
        } completion:^(BOOL finish){
            if (drawState == DrawerViewStateDown) {
                drawState = DrawerViewStateUp;
            }else{
                drawState = DrawerViewStateDown;
                
            }
        }];
        
    }
}

/*
 *  handleTap 触摸函数
 *  @recognizer  UITapGestureRecognizer 触摸识别器
 */
-(void) handleTap
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        if (drawState == DrawerViewStateDown) {
            self.center = left;
            //[self transformArrow:DrawerViewStateUp];
          //  [self.delegate mengcengUp];
        }else
        {
            self.center = right;
            //[self transformArrow:DrawerViewStateDown];
         //   [self.delegate mengcengDown];
        }
    } completion:^(BOOL finish)
     {
         if (drawState == DrawerViewStateDown) {
             drawState = DrawerViewStateUp;
         }else{
             drawState = DrawerViewStateDown;
             
         }
     }];
    
}

/*
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态
 */
-(void)transformArrow:(DrawerViewState) state
{
    //NSLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (state == DrawerViewStateUp){
            arrow.transform = CGAffineTransformMakeRotation(M_PI);
           // drawState = DrawerViewStateDown;
        }else
        {
            arrow.transform = CGAffineTransformMakeRotation(0);
            //drawState = DrawerViewStateUp;
            
        }
    } completion:^(BOOL finish){
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
