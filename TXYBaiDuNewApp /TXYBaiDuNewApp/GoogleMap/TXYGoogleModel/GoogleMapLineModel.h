//
//  GoogleMapLineModel.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapLineModel : NSObject

@property (nonatomic,strong) NSMutableArray     *mapLinePointCoordinateInfoArray;


- (void)addMapLinePointValue:(NSValue *)pointValue;
- (void)removeAllMapLinePoints;

@end
