//
//  ScanNewTableViewCell.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/1/26.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanNewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NumLab;
@property (weak, nonatomic) IBOutlet UILabel *NamLab;
@property (weak, nonatomic) IBOutlet UILabel *destanceLab;
@property (weak, nonatomic) IBOutlet UILabel *waiteTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *ChangeBtn;

@end
