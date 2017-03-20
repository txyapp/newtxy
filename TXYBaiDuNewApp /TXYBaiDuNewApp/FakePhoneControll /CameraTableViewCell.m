//
//  CameraTableViewCell.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "CameraTableViewCell.h"

@implementation CameraTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor lightGrayColor];
        [self.layer setMasksToBounds:YES];
        self.layer.cornerRadius=15;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    return self;
}
- (void)layoutSubviews{
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    self.bounds=CGRectMake(0, 0, screenBounds.size.width*0.6, screenBounds.size.width*0.6/9*16);
}

@end
