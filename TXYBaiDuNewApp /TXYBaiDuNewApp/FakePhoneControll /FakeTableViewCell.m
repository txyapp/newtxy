//
//  FakeTableViewCell.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/11/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "FakeTableViewCell.h"

@implementation FakeTableViewCell
#pragma obfuscate on
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat W=[UIScreen mainScreen].bounds.size.width;
    self.frame=CGRectMake(10, self.frame.origin.y, W-20, self.frame.size.height);
}

@end
