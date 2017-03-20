//
//  GoogleAnnotationView.h
//  TXYGoogleTest
//
//  Created by aa on 16/7/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleAnnotationView : UIView

@property (nonatomic,strong) UIImageView        *annotationView;
@property (nonatomic,strong) UILabel            *streetInfoLabel;
@property (nonatomic,strong) UIImageView        *triangleView;
@property (nonatomic,strong) UIView             *addBtn;
@property (nonatomic,strong) UIView             *infoBGView;

- (instancetype)initWithAddButton:(UIView *)btn;

- (void)setStreetLabelInfo:(NSString *)streetInfo;
- (void)setAnnotationImage:(NSString *)imageName;

@end
