//
//  SearchModel.h
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/10.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DidianModel.h"

@interface SearchModel : NSObject


@property (nonatomic) int totalPoiNum;		///<本次POI搜索的总结果数
@property (nonatomic) int currPoiNum;			///<当前页的POI结果数
@property (nonatomic) int pageNum;			///<本次POI搜索的总页数
@property (nonatomic) int pageIndex;			///<当前页的索引
//多少个地点
@property (nonatomic,strong)NSArray* dianArray;  //成员为didianmodel

//多少个城市
@property (nonatomic,strong)NSArray* cityArray; //成员为城市
@end
