//
//  VisualStickView.h
//  SampleGame
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Myst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoyStickView : UIView
{
    UIImageView *stickViewBase;
    UIImageView *stickView;
    UIImage *imgStickNormal;
    UIImage *imgStickHold;
}

@property (nonatomic)CGPoint mCenter;
@end
