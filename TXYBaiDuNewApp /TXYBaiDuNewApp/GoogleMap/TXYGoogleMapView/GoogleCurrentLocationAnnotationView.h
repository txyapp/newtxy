//
//  GoogleCurrentLocationAnnotationView.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/5.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>

@interface GoogleCurrentLocationAnnotationView : UIView

@property (nonatomic,strong) UIImageView                *annotationView;
@property (nonatomic,assign) CLLocationCoordinate2D      coordinate;

@end
