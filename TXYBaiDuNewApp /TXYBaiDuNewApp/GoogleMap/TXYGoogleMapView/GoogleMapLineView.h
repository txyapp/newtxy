//
//  GoogleMapLineView.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMapLineModel.h"

@interface GoogleMapLineView : UIView

@property (nonatomic,weak) GoogleMapLineModel   *mapLineModel;

@property (nonatomic,strong) NSMutableArray     *pointsArray;

- (void)addMapLine:(GoogleMapLineModel *)mapLine;

- (void)stopDraw;

@end
