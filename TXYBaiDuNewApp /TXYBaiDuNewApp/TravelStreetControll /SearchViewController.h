//
//  SearchViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (nonatomic)NSInteger index;

@property(nonatomic)NSString *isChangePoint;

@property (nonatomic,copy)NSString* chengshi;

//需要传递数组表示目前已经选定哪些点
@property(nonatomic,copy)NSMutableArray *hadChoicePoints;
@end
