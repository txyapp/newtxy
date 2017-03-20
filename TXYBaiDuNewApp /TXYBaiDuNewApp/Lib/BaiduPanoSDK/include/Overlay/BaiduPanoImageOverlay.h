//
//  BaiduPanoImageOverlay.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BaiduPanoOverlay.h"
@interface BaiduPanoImageOverlay : BaiduPanoOverlay
@property(strong, nonatomic) NSURL   *url;  // 显示的照片的url
@property(assign, nonatomic) CGSize  size;  // 照片大小
@property(strong, nonatomic) UIImage *image;// 显示的照片
@end
