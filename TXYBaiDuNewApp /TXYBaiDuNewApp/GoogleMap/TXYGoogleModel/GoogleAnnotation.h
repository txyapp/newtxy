//
//  GoogleAnnotation.h
//  TXYGoogleTest
//
//  Created by aa on 16/7/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleAnnotationView.h"
#import <CoreLocation/CLLocation.h>

@class UIButton;

@interface GoogleAnnotation : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D          coordinate;
@property (nonatomic,strong) NSString                       *annotationTitle;
@property (nonatomic,strong) NSString                       *annotationImageName;
@property (nonatomic,strong) GoogleAnnotationView           *annotationView;

- (instancetype)initWithAddButton:(UIButton *)btn;

@end
