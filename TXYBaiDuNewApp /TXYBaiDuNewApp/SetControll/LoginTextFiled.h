//
//  LoginTextFiled.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextFiled : UITextField
@property(nonatomic,strong)UIImage *lImage,*rImage;
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIView*)icon withRight:(UIButton *)btn;
@end
