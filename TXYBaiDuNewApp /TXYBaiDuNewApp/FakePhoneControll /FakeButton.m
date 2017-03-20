//
//  FakeButton.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/11/30.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "FakeButton.h"

@implementation FakeButton
#pragma obfuscate on
- (void)layoutSubviews{
    [super layoutSubviews];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = 15;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

@end
