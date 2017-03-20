//
//  YundongTableViewCell.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/1.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YundongTableViewCell : UITableViewCell{
    UILabel *_label1,*_applyLab,*_infoLab;
    UIImageView *_headView;
}
-(void)setTitle:(NSString *)title applyText:(NSString *)apply info:(NSString *) info;
-(void)setimageV:(UIImage *)image;
-(void)setBackgroundColor1:(UIColor *)backgroundColor;

@end
