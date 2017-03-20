//
//  GoogleCurrentLocationAnnotationView.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleCurrentLocationAnnotationView.h"
#import "GoogleMapViewUtil.h"

@implementation GoogleCurrentLocationAnnotationView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 25, 25);
        self.annotationView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.annotationView.image = [UIImage imageNamed:@"curlocation.png"];
        [self addSubview:self.annotationView];
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    CGPoint point = [GoogleMapViewUtil getMapPointAtCurrentZoomLevelWithCoordinate:coordinate];
    CGRect curFrame = self.frame;
    self.frame = CGRectMake(point.x - curFrame.size.width/2, point.y-curFrame.size.height/2, curFrame.size.width, curFrame.size.height);
}

@end
