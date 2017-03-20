//
//  SimpleOperation.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/18.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DataBaseManager.h"
#import <UIKit/UIKit.h>
#import "TravelStreetModel.h"
#import "XuandianModel.h"
@class SimpleOperation;
@protocol YYdownLoadOperationDelegate <NSObject>
@optional
//-(void)downLoadOperation:(SimpleOperation*)operation withTextName:(NSString *)textName andIsOn:(BOOL)isOn andWithRow:(int)row withLocation:(CLLocation *)location andCurrentIndex:(int)currentIndex;
-(void)refreshWithRow:(NSString *)bundle;
-(void)cancleAll;
@end
@interface SimpleOperation : NSOperation{
   id givenObject;
    int indexRow;
    NSMutableArray *dataArr;
    NSString *Boundle;
    BOOL finished;
    BOOL executing;
    double jdc;
}
@property(nonatomic,copy)NSString *jiaodu;
@property(nonatomic,copy)NSString *whichSingle;
@property (nonatomic,assign) SEL methodTest;
@property(nonatomic)int IsDel;
@property(nonatomic)int AllCancle;
//定义一个字段来暂停次线程
@property(nonatomic)int isStop,isShowLineStop;
// 定义初始化方法
- (id) initWithObject:(NSObject *)paramObject withIndexRow:(int)row withArr:(NSMutableArray *)arr withWhichBoundle:(NSString *)boundle;
@property(nonatomic,strong)id <YYdownLoadOperationDelegate> delegate;
@end
