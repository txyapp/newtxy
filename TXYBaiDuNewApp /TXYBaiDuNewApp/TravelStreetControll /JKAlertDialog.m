//
//  JKAlertDialog.m
//  JKAlertDialog
//
//  Created by Jakey on 15/3/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
#define AlertPadding 5
#define MenuHeight 44

#define AlertHeight 130
#define AlertWidth 270

#import "JKAlertDialog.h"
@implementation JKAlertDialogItem
@end

@implementation JKAlertDialog
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _title  = title;
        _message = message;
        
        [self buildViews];
    }
    return self;
}
-(void)buildViews{
    self.frame = [UIScreen mainScreen].bounds;
     _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;

    [self addSubview:_coverView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AlertWidth, AlertHeight)];
    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
  
    if(_title){
    //title
    CGFloat labelHeigh = [self heightWithString:_title fontSize:17 width:AlertWidth-2*AlertPadding];
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding, AlertPadding, AlertWidth-2*AlertPadding, labelHeigh)];
    _labelTitle.font = [UIFont boldSystemFontOfSize:17];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.numberOfLines = 0;
    _labelTitle.text = _title;
    _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [_alertView addSubview:_labelTitle];
    }
    //message
    if (_message) {
        CGFloat messageHeigh = [self heightWithString:_message fontSize:14 width:AlertWidth-2*AlertPadding];
        
        _labelmessage =  [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding, _labelTitle.frame.origin.y+_labelTitle.frame.size.height, AlertWidth-2*AlertPadding, messageHeigh+2*AlertPadding)];
        _labelmessage.font = [UIFont systemFontOfSize:14];
        _labelmessage.textColor = [UIColor blackColor];
        _labelmessage.textAlignment = NSTextAlignmentCenter;
        _labelmessage.text = _message;
        _labelmessage.numberOfLines = 0;
        _labelmessage.lineBreakMode = NSLineBreakByCharWrapping;
        [_alertView addSubview:_labelmessage];
    }
    
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [_alertView addSubview:_contentScrollView];


}
-(void)layoutSubviews{
    _buttonScrollView.frame = CGRectMake(0, _alertView.frame.size.height-MenuHeight,_alertView.frame.size.width, MenuHeight);
    _contentScrollView.frame = CGRectMake(0, _labelTitle.frame.origin.y+_labelTitle.frame.size.height, _alertView.frame.size.width, _alertView.frame.size.height-MenuHeight);
    self.contentView.frame = CGRectMake(0,5,self.contentView.frame.size.width, self.contentView.frame.size.height);
    _contentScrollView.contentSize = self.contentView.frame.size;

}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self addButtonItem];
    [_contentScrollView addSubview:self.contentView];
    CGFloat plus;
    if (self.contentView) {
        plus = self.contentView.frame.size.height-(_alertView.frame.size.height-MenuHeight);
    }else{
        plus = _labelmessage.frame.origin.y+_labelmessage.frame.size.height -(_alertView.frame.size.height-MenuHeight);
    }
   if (plus<0) {
        plus = 0;
    }
    CGFloat height =  MIN([UIScreen mainScreen].bounds.size.height-MenuHeight,_alertView.frame.size.height+plus);
    
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, AlertWidth, height);
    _alertView.center = self.center;
    [self setNeedsDisplay];
    [self setNeedsLayout];

}
- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
   // NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    //return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:string];
    return  [attriString  boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}
#pragma mark - add item

- (NSInteger)addButtonWithTitle:(NSString *)title{
    JKAlertDialogItem *item = [[JKAlertDialogItem alloc] init];
    item.title = title;
    item.action = nil;
    item.type = Button_OK;
    [_items addObject:item];
    return [_items indexOfObject:title];
}
- (void)addButton:(ButtonType)type withTitle:(NSString *)title handler:(JKAlertDialogHandler)handler{
    JKAlertDialogItem *item = [[JKAlertDialogItem alloc] init];
    item.title = title;
    item.action = handler;
    item.type = type;
    [_items addObject:item];
    item.tag = [_items indexOfObject:item];
}
- (void)addButtonItem {
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _alertView.frame.size.height- MenuHeight,AlertWidth, MenuHeight)];
    _buttonScrollView.bounces = NO;
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    _buttonScrollView.showsVerticalScrollIndicator =  NO;
    CGFloat  width;
    if(self.buttonWidth){
        width = self.buttonWidth;
        _buttonScrollView.contentSize = CGSizeMake(width*[_items count], MenuHeight);
    }else
    {
       width = _alertView.frame.size.width/[_items count];
    }
    [_items enumerateObjectsUsingBlock:^(JKAlertDialogItem *item, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.frame = CGRectMake(idx*width, 1, width, MenuHeight);
        //seperator
        button.backgroundColor = [UIColor whiteColor];
        button.layer.shadowColor = [[UIColor grayColor] CGColor];
        button.layer.shadowRadius = 0.5;
        button.layer.shadowOpacity = 1;
        button.layer.shadowOffset = CGSizeZero;
        button.layer.masksToBounds = NO;
        button.tag = 90000+ idx;
        // title
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
        
        // action
        [button addTarget:self
                    action:@selector(buttonTouched:)
          forControlEvents:UIControlEventTouchUpInside];

        [_buttonScrollView addSubview:button];
    }];
    [_alertView addSubview:_buttonScrollView];
    
}

- (void)buttonTouched:(UIButton*)button{
    JKAlertDialogItem *item = _items[button.tag-90000];
    if (item.action) {
        item.action(item);
    }
    [self dismiss];
}
#pragma mark - show and dismiss
-(void)showArea:(UIWindow *)window
{
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
    }];
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.subviews[0];
    //    UIView *topView2 = window.subviews[2];
    NSLog(@"%@",window.subviews);
    [topView addSubview:self];
    [topView bringSubviewToFront:self];
    [self showAnimation];
}
- (void)show:(UIWindow *)window {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;

    } completion:^(BOOL finished) {
        
    }];
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.subviews[0];
//    UIView *topView2 = window.subviews[2];
    NSLog(@"%@",window.subviews);
    [topView addSubview:self];
    [topView bringSubviewToFront:self];
    [self showAnimation];
}
-(void)show2
{
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
    }];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.subviews[0];
    NSLog(@"%@",[topView class]);
    [topView addSubview:self];
    [topView bringSubviewToFront:self];
    [self showAnimation];
}
- (void)dismiss {
    [self hideAnimation];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self removeFromSuperview];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];

    
}

@end