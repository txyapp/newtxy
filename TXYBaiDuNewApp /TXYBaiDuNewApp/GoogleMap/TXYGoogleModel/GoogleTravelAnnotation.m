//
//  GoogleTravelAnnotation.m
//  TXYGoogleTest
//
//  Created by aa on 16/9/22.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleTravelAnnotation.h"

@implementation GoogleTravelAnnotation

- (instancetype)init
{
    if (self = [super init]) {
        self.annotationView = [[GoogleAnnotationView alloc] initWithAddButton:nil];

    }
    return self;
}
- (instancetype)initWithTravelView
{
    if (self = [super init]) {
        self.annotationView = [[GoogleAnnotationView alloc] init];
        self.annotationView.frame = CGRectMake(-100, -100, 40, 40);
    }
    return self;
}
@end
