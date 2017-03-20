//
//  HuiFuView.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/4/8.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "HuiFuView.h"
#import "AppManage.h"
#define IMRowHeight     44
#define IMRowSubHeight  300
#define Color [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1]
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation HuiFuView
@synthesize isOpen = _isOpen;
@synthesize item = _item;
@synthesize whichData,array,editBtn = _editBtn,upBtn = _upBtn;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, frame.size.height)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Width - 100, frame.size.height)];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_cellView];
        [_cellView addSubview:_titleLabel];
        whichData = 0;
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        _editBtn .frame = CGRectMake(Width - 95, 0, 30, frame.size.height);
        [_cellView addSubview:_editBtn];
        
        _upBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _upBtn .frame = CGRectMake(Width - 55, 0, 30, frame.size.height);
        [_cellView addSubview:_upBtn];
    }
    
    return self;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    NSLog(@"%@",self.item.APP);
    int apps = self.item.APP.count;
    if (_isOpen) {
        if (_scroller == nil) {
            _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IMRowHeight, Width, Width/6.5)];
            _scroller.backgroundColor = [UIColor whiteColor];
            _scroller.showsHorizontalScrollIndicator = NO;
            _scroller.contentSize = CGSizeMake(apps*(Width/6.5 +Width/13)+10, Width/6.5);
            for (int i = 0; i < apps;  i++) {
                UIImageView *appimg = nil;
//                if (i==0) {
//                    appimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0 , Width/6.5, Width/6.5)];
//                }else{
//                    
//                }
                appimg = [[UIImageView alloc]initWithFrame:CGRectMake((0.5+1.5*i)*Width/6.5 -10, 0 , Width/6.5, Width/6.5)];
                appimg.layer.borderWidth = 1;
                appimg.layer.borderColor = Color.CGColor;
                appimg.layer.masksToBounds = YES;
                appimg.layer.cornerRadius = 5;
                appimg.image=[[AppManage sharedAppManage] getIconForBundleId:self.item.APP[i]];
                [_scroller addSubview:appimg];
            }
            
            
            [self loadData];
            //data展示
            _dataTab  =  [[UITableView alloc]initWithFrame:CGRectMake(0, Width/6.5 + IMRowHeight + 5, Width, IMRowSubHeight-(Width/6.5 + IMRowHeight + 5) ) style:UITableViewStylePlain];
            _dataTab.delegate = self;
            _dataTab.dataSource = self;
            //_dataTab.scrollEnabled = NO;
            _dataTab.backgroundColor = [UIColor clearColor];
            
            
        }
        _titleLabel.frame = CGRectMake(20, 0, Width - 100, IMRowHeight);
        _editBtn .frame = CGRectMake(Width - 95, 0, 30, IMRowHeight);
        _upBtn .frame = CGRectMake(Width - 55, 0, 30, IMRowHeight);
        NSLog(@"%@",_scroller.superview);
        [self addSubview:_scroller];
        [self addSubview:_dataTab];
    }
    else {
        _titleLabel.frame = CGRectMake(20, 0, Width - 100, IMRowHeight);
        _editBtn .frame = CGRectMake(Width - 95, 0, 30, IMRowHeight);
        _upBtn .frame = CGRectMake(Width - 55, 0, 30, IMRowHeight);
        if (_scroller.superview) {
            [_scroller removeFromSuperview];
            [_dataTab removeFromSuperview];
            _scroller = nil;
            _dataTab = nil;
        }
    }
}

-(void)loadData
{
    NSString *str = GaijiPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSLog(@"plistdit = %@",plistDict);
    array = [plistDict objectForKey:@"Gaiji"];
    NSLog(@"array = %@",array);
}

- (void)setItem:(HuiFuModel *)item {
    _item = item;
    self.isOpen = item.isOpen;
    _titleLabel.text = item.Time;
    NSLog(@"shuju = %@",item.shuju);
    if ([item.shuju isEqualToString:@"yes"]) {
        _titleLabel.textColor = IWColor(60, 170, 249);
    }
    NSLog(@"%@",item.APP);
}

#pragma tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict5 = [array[whichData] allValues][0];
    NSLog(@"array = %@",array);
    NSLog(@"array[whichdata] = %@",array[whichData]);
    NSLog(@"dict5 = %@",dict5);
    NSString *str = GaijiPlist;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:GaijiPlist];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSLog(@"plistdit = %@",plistDict);
    NSArray* shezhi = [plistDict objectForKey:@"Shezhi"];
    NSString* uuid = [shezhi[0] objectForKey:@"uuid"];
    NSString* aduuid = [shezhi[0] objectForKey:@"aduuid"];
    FakeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[FakeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }else{
        cell.textLabel.text=nil;
        cell.detailTextLabel.text=nil;
        cell.imageView.image=nil;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel* lab1 = [[UILabel alloc]init];
    
    lab1.adjustsFontSizeToFitWidth = YES;
    //   lab1.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:lab1];
    UILabel* lab2 = [[UILabel alloc]init];
    lab2.adjustsFontSizeToFitWidth = YES;
    lab2.textColor = [UIColor blackColor];
    //  lab2.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:lab2];
    
    if (indexPath.row==7) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        //   cell.backgroundColor = Color;
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5,70, 30);
        nameLab.font = [UIFont systemFontOfSize:13];
        nameLab.text = @"aduuid:";
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(110, 5, Width - 120, 30);
        lab1.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:15];
        lab1.text = [[DeviceAbout sharedDevice]getADUUID];
        if ([aduuid isEqualToString:@"yes"]) {
            lab1.text = [dict5 objectForKey:@"ADUUID"];
            imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h"];
            lab1.textColor = IWColor(60, 170, 249);
            NSLog(@"lab2.text = %@",lab2.text);
            NSLog(@"dict5 = %@",dict5);
        }
    }
    if (indexPath.row==6) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5, 70, 30);
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.text = @"uuid:";
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(110, 5,Width - 120, 30);
        lab1.text = [[DeviceAbout sharedDevice]getUUID];
        lab1.textAlignment = NSTextAlignmentLeft;
        if ([uuid isEqualToString:@"yes"]) {
            lab1.text = [dict5 objectForKey:@"UUID"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==5) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5,80, 30);
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.text = @"wifi地址:";
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(120, 5, Width-120, 30);
        lab1.textAlignment = NSTextAlignmentLeft;
        NSDictionary* dict = [[DeviceAbout sharedDevice]fetchSSIDInfo];
        NSLog(@"dcit = %@",dict);
        if (dict) {
            lab1.text = [dict objectForKey:@"BSSID"];
        }
        if (![[dict5 objectForKey:@"WiFiMAC"]isEqualToString:[dict objectForKey:@"BSSID"]]) {
            lab1.text = [dict5 objectForKey:@"WiFiMAC"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==4) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5, 80, 30);
        nameLab.text = @"wifi名字:";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(120, 5, Width-120, 30);
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.text = [[DeviceAbout sharedDevice]getUUID];
        NSDictionary* dict = [[DeviceAbout sharedDevice]fetchSSIDInfo];
        NSLog(@"dcit = %@",dict);
        if (dict) {
            lab1.text = [dict objectForKey:@"SSID"];
        }
        if (![[dict5 objectForKey:@"WiFiName"]isEqualToString:[dict objectForKey:@"SSID"]]) {
            lab1.text = [dict5 objectForKey:@"WiFiName"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==0) {
        //cell.textLabel.text=@"设备名称:";
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5, 80, 30);
        nameLab.text = @"设备名字:";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.text = [[DeviceAbout sharedDevice]getDeviceName];
        lab1.frame = CGRectMake(120, 5, Width - 120, 30);
        lab1.textAlignment = NSTextAlignmentLeft;
        if (![[dict5 objectForKey:@"devName"]isEqualToString:[[DeviceAbout sharedDevice]getDeviceName]]) {
            lab1.text = [dict5 objectForKey:@"devName"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==1) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5,80, 30);
        nameLab.text = @"设备类型:";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(120, 5, Width-120, 30);
        lab1.textAlignment = NSTextAlignmentLeft;
        if ([[DeviceAbout sharedDevice]getDeviceType] == iPhone) {
            lab1.text = @"iPhone";
        }
        if ([[DeviceAbout sharedDevice]getDeviceType] == iPad) {
            lab1.text = @"iPad";
        }
        if (![[dict5 objectForKey:@"devType"]isEqualToString:lab1.text]) {
            lab1.text = [dict5 objectForKey:@"devType"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==2) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5, 80, 30);
        nameLab.text = @"设备版本:";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(120, 5, Width -120, 30);
        lab1.text = [[DeviceAbout sharedDevice]getDeviceIOS];
        lab1.textAlignment = NSTextAlignmentLeft;
        if (![[dict5 objectForKey:@"devVer"]isEqualToString: lab1.text]) {
            lab1.text = [dict5 objectForKey:@"devVer"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    if (indexPath.row==3) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(10, 10, 20, 20);
        imageView.image = [UIImage imageNamed:@"qinglijiasu_icon_wancheng_h@2x"];
        [cell.contentView addSubview:imageView];
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(40, 5, 80, 30);
        nameLab.text = @"手机网络:";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLab];
        lab1.frame = CGRectMake(120, 5, Width-100, 30);
        lab1.text = [[DeviceAbout sharedDevice]getNetWorkStates];
        lab1.textAlignment = NSTextAlignmentLeft;
        if (![[dict5 objectForKey:@"netState"]isEqualToString:[[DeviceAbout sharedDevice]getNetWorkStates]]) {
            lab1.text = [dict5 objectForKey:@"netState"];
            lab1.textColor = IWColor(60, 170, 249);
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
