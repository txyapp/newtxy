//
//  BaiduPanoLabelOverlay.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduPanoOverlay.h"
#import <UIKit/UIKit.h>

@interface BaiduPanoLabelOverlay : BaiduPanoOverlay
@property(copy, nonatomic) NSString       *text;            // 显示的文字
@property(strong, nonatomic) UIColor      *textColor;       // 文字颜色
@property(strong, nonatomic) UIColor      *backgroundColor; // 文字背景颜色
@property(assign, nonatomic) NSInteger    fontSize;         // 文字大小
@property(assign, nonatomic) UIEdgeInsets edgeInsets;       // 文字边距
@end

