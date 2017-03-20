//
//  GoogleAnnotation.m
//  TXYGoogleTest
//
//  Created by aa on 16/7/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleAnnotation.h"
#import "GoogleMapViewUtil.h"

@implementation GoogleAnnotation

- (instancetype)initWithAddButton:(UIButton *)btn
{
    if (self = [super init]) {
        self.annotationView = [[GoogleAnnotationView alloc] initWithAddButton:btn];
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [GoogleMapViewUtil getMapPointAtCurrentZoomLevelWithCoordinate:coordinate];
    CGRect viewFrame = self.annotationView.frame;
    self.annotationView.frame = CGRectMake(point.x - viewFrame.size.width/2, point.y - viewFrame.size.height, viewFrame.size.width, viewFrame.size.height);
    _coordinate = coordinate;
}

- (void)setAnnotationTitle:(NSString *)annotationTitle
{
    _annotationTitle = annotationTitle;
    [self.annotationView setStreetLabelInfo:annotationTitle];
}

- (void)setAnnotationImageName:(NSString *)annotationImageName
{
    _annotationImageName = annotationImageName;
    [self.annotationView setAnnotationImage:annotationImageName];
}

@end
