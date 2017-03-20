//
//  HuiFuView.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuiFuModel.h"
#import "ipaManage.h"
#import "FakeTableViewCell.h"
#import "DeviceAbout.h"
@interface HuiFuView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UILabel     *_titleLabel;
    UIView      *_cellView;
    
    UIScrollView *_scroller;
    
    UITableView *_dataTab;
    BOOL        _isOpen;
    
    HuiFuModel      *_item;
}
@property (nonatomic, assign)   BOOL    isOpen;
@property (nonatomic, strong)   HuiFuModel  *item;
@property (nonatomic,weak)UIButton *editBtn;
@property (nonatomic,weak)UIButton *upBtn;
@property (nonatomic,assign) int whichData;
@property(nonatomic,copy)NSArray* array;
@property(nonatomic)ipaManage *ipaMgr;
@end
