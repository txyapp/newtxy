//
//  LoginTextFiled.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "LoginTextFiled.h"

@implementation LoginTextFiled

-(id)initWithFrame:(CGRect)frame drawingLeft:(UIView *)icon withRight:(UIButton *)btn{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.rightView = btn;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 10;// 右偏10
    return iconRect;
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 左偏10
    return iconRect;
}
-(CGRect) textRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super textRectForBounds:bounds];
    iconRect.origin.x+=10;
    return iconRect;
}
//改变编辑时文字位置
-(CGRect) editingRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super editingRectForBounds:bounds];
    iconRect.origin.x+=10;
    return iconRect;
}
@end
