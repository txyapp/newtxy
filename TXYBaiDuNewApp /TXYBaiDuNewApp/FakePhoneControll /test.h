//
//  test.h
//  1111111
//
//  Created by yunlian on 16/3/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Passdelegate.h"
typedef enum
{
    DrawerViewStateUp = 0,
    DrawerViewStateDown
}DrawerViewState;
@interface test : UIView<UIGestureRecognizerDelegate>
{
    UIImageView *arrow;         //向上拖拽时显示的图片
    
    
    UIView *parentView;         //抽屉所在的view
    UIView *contentView;        //抽屉里面显示的内容
    
    DrawerViewState drawState;  //当前抽屉状态
}

- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handleTap;
- (void)transformArrow:(DrawerViewState) state;

@property (nonatomic)CGPoint left;//抽屉拉出时的中心点
@property (nonatomic)CGPoint right;//抽屉收缩时的中心点
@property (nonatomic,retain) UIView *parentView;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,retain) UIImageView *arrow;
@property (nonatomic) DrawerViewState drawState;

@property(nonatomic,strong)id<PassDelegate>delegate;

@end
