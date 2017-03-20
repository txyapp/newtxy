//
//  AppDelegate.h
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BNCoreServices.h"
#import "WXApi.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    BMKMapManager* _mapManager;
    
}
@property (strong, nonatomic) UIWindow *window;



//当前模拟位置所在的城市
@property (nonatomic,copy)NSString* city;

@end

