//
//  EditTableViewController.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController


@property (nonatomic,copy)NSString* name;

@property (nonatomic)int index;

@property (nonatomic,strong)UITextField* field;
//判断是修改路线还是修改单个点的名称
@property(nonatomic)int single;
//需要修改的路线的名称
@property(nonatomic,copy)NSString *LinesName;
@end
