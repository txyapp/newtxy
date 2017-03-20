//
//  CLGeocoderManager.h
//  TXYGoogleTest
//
//  Created by aa on 16/8/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXYGeocoderProtocol.h"

@interface CLGeocoderManager : NSObject<TXYGeocoderServiceInterface>

+ (instancetype)sharedManager;

@property (nonatomic,weak)  id<TXYReverseGeocoderProtocol>       reverseGeocoderDelegate;
@property (nonatomic,weak)  id<TXYGeocoderProtocol>              geocoderSearchDelegate;

@end
