//
//  GoogleMapScrollViewDelegate.h
//  TXYGoogleTest
//
//  Created by aa on 16/7/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    MapTileShowTypeZoom = 1,
    MapTileShowTypeScroll,
    MapTileShowTypeDecelerate
}MapTileShowType;


@interface GoogleMapScrollViewDelegate : NSObject<UIScrollViewDelegate>

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@end
