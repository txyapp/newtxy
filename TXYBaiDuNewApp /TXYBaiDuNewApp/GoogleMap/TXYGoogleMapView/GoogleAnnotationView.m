//
//  GoogleAnnotationView.m
//  TXYGoogleTest
//
//  Created by aa on 16/7/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleAnnotationView.h"

#define kAddButtonSize CGSizeMake(30,30)
#define kInfoBGViewHeight 34
#define kAnnotationSize CGSizeMake(35,35)
#define kTriangleSize CGSizeMake(21,15)

@implementation GoogleAnnotationView

- (instancetype)initWithAddButton:(UIView *)btn
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
//        self.infoBGView.userInteractionEnabled = NO;
//        self.addBtn.userInteractionEnabled = YES;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, 0, screenSize.width, kAnnotationSize.height+kInfoBGViewHeight+10);
        self.annotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_icon.png"]];
        self.annotationView.frame = CGRectMake((self.frame.size.width-kAnnotationSize.width)/2, self.frame.size.height-kAnnotationSize.height, kAnnotationSize.width, kAnnotationSize.height);
        [self addSubview:self.annotationView];
        
        
        
        self.triangleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle.png"]];
        self.triangleView.frame = CGRectMake(self.annotationView.frame.origin.x+8, self.annotationView.frame.origin.y - 12, kTriangleSize.width, kTriangleSize.height);
        
        
        self.infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, kInfoBGViewHeight)];
        self.infoBGView.layer.shadowColor = [[UIColor blackColor] CGColor];;
        self.infoBGView.layer.shadowOffset = CGSizeMake(0, 0);
        self.infoBGView.layer.shadowOpacity = 0.3;
        self.infoBGView.layer.shadowRadius = 3;
        self.infoBGView.layer.borderWidth = 0.7;
        self.infoBGView.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4] CGColor];
        self.infoBGView.backgroundColor = [UIColor colorWithRed:252.0 green:254.0 blue:235.0 alpha:1.0];
        
        
        self.addBtn = btn;
        self.addBtn.frame = CGRectMake(0, 0, kAddButtonSize.width, kAddButtonSize.height);
        
        self.streetInfoLabel = [[UILabel alloc] init];
        self.streetInfoLabel.frame = CGRectMake(0, -25, 60, 20);
        self.streetInfoLabel.textAlignment = NSTextAlignmentCenter;
        self.streetInfoLabel.backgroundColor = [UIColor clearColor];
        self.streetInfoLabel.font = [UIFont systemFontOfSize:13];
//        self.streetInfoLabel.text = @"hehe";
        
        [self addSubview:self.infoBGView];
        [self.infoBGView addSubview:self.streetInfoLabel];
        [self.infoBGView addSubview:self.addBtn];
        [self addSubview:self.triangleView];
    }
    return self;
}

- (void)setStreetLabelInfo:(NSString *)streetInfo
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (streetInfo == nil) {
        self.infoBGView.frame = CGRectMake(0, 0, 0, 0);
        self.triangleView.frame = CGRectMake(0, 0, 0, 0);
    }else{
    
        CGSize size = [streetInfo sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(screenSize.width - kAddButtonSize.width, 20) lineBreakMode:NSLineBreakByWordWrapping];

        self.streetInfoLabel.frame = CGRectMake(5, (kInfoBGViewHeight - size.height)/2, size.width, size.height);
        
        CGSize infoBGViewSize = CGSizeMake(self.streetInfoLabel.frame.size.width+self.addBtn.frame.size.width + 15, kInfoBGViewHeight);
        self.infoBGView.frame = CGRectMake((screenSize.width - infoBGViewSize.width)/2, 0, infoBGViewSize.width, kInfoBGViewHeight);
        
        self.addBtn.frame = CGRectMake(self.streetInfoLabel.frame.origin.x + self.streetInfoLabel.frame.size.width + 5, (kInfoBGViewHeight - kAddButtonSize.height)/2, kAddButtonSize.width, kAddButtonSize.height);
        
        self.streetInfoLabel.text = streetInfo;
    }
}

- (void)setAnnotationImage:(NSString *)imageName
{
    self.annotationView.image = [UIImage imageNamed:imageName];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect btnRect = self.addBtn.frame;
    CGRect bgRect = self.infoBGView.frame;
    if (point.x > bgRect.origin.x + btnRect.origin.x - 5 && point.x < bgRect.origin.x + btnRect.origin.x + btnRect.size.width + 5 && point.y > bgRect.origin.y + btnRect.origin.y - 5 && point.y < bgRect.origin.y + btnRect.origin.y + btnRect.size.height + 5) {
        return YES;
    }else{
        return NO;
    }
    
}

@end
