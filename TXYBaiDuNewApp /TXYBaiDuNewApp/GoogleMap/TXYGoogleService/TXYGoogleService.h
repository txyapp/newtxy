//
//  TXYGoogleService.h
//  Pods
//
//  Created by aa on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import "GoogleMapConfig.h"
#import "GoogleMapManager.h"
#import "GoogleMapLocationManager.h"

@interface TXYGoogleService : NSObject

+ (instancetype)defaultService;

+ (GoogleMapConfig *)mapConfig;

+ (GoogleMapManager *)mapManager;

+ (GoogleMapLocationManager *)locationManager;

@end
