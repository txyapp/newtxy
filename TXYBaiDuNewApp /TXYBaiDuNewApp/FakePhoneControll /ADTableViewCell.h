//
//  ADTableViewCell.h
//  TXYBaiDuNewApp
//
//  Created by yun on 16/6/16.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADTableViewCell : UITableViewCell
{
    UILabel *_label1,*_applyLab,*_infoLab;
    UIImageView *_headView;
}
-(void)setTitle:(NSString *)title applyText:(NSString *)apply info:(NSString *) info;
-(void)setimageV:(UIImage *)image;
-(void)setBackgroundColor1:(UIColor *)backgroundColor;
@end
