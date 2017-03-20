//
//  YundongTableViewCell.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "YundongTableViewCell.h"
@implementation YundongTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      //  self.backgroundColor=[UIColor lightGrayColor];
        [self.layer setMasksToBounds:YES];
        self.layer.cornerRadius=15;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _label1 = [[UILabel alloc]init];
        _label1.textColor = [UIColor whiteColor];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:22];
        [self.contentView addSubview:_label1];
        
//        _applyLab = [[UILabel alloc]init];
//        _applyLab.textColor = [UIColor whiteColor];
//        _applyLab.textAlignment = NSTextAlignmentLeft;
//        _applyLab.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_applyLab];
//        
//        _infoLab = [[UILabel alloc]init];
//        _infoLab.textColor = [UIColor whiteColor];
//        _infoLab.textAlignment = NSTextAlignmentLeft;
//        _infoLab.font = [UIFont systemFontOfSize:15];
//        _infoLab.numberOfLines = 0;
//        [self.contentView addSubview:_infoLab];
        
        _headView = [[UIImageView alloc]init];
        _headView.layer.borderWidth = 1;
        _headView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_headView.layer setMasksToBounds:YES];
        _headView.backgroundColor = [UIColor yellowColor];
        _headView.layer.cornerRadius=15;
        
        [self.contentView addSubview:_headView];
    }
    return self;
}

- (void)layoutSubviews{
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    self.bounds=CGRectMake(0, 0, screenBounds.size.width*0.9, self.bounds.size.height);
    
    _headView.frame = CGRectMake(5, 5, 50, 50);
    _label1.frame = CGRectMake(60, 10 , screenBounds.size.width*0.9 - 200 , 40 );
//    _applyLab.frame = CGRectMake(45, 40, screenBounds.size.width*0.9 , 20);
//    _infoLab.frame = CGRectMake(45, 60, screenBounds.size.width*0.9 - 90, 60);
    
}
-(void)setTitle:(NSString *)title applyText:(NSString *)apply info:(NSString *)info
{
    _label1.text = title;
//    _applyLab.text = apply;
//    _infoLab.text = info;
}

-(void)setimageV:(UIImage *)image
{
    _headView.image = image;
}
-(void)setBackgroundColor1:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
}


@end
