
//
//  LoginTableViewCell.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/30.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.layer setMasksToBounds:YES];
        self.layer.cornerRadius=25;
        self.backgroundColor = IWColor(47, 129, 188);;
        [self.layer setBorderWidth:1.0]; //边框宽度
        [self.layer setBorderColor:IWColor(47, 129, 188).CGColor];

    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat W=[UIScreen mainScreen].bounds.size.width;
    self.frame=CGRectMake(10, self.frame.origin.y, W-20, self.frame.size.height);
}

@end
