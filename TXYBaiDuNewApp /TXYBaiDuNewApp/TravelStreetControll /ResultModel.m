//
//  ResultModel.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/11/18.
//  Copyright © 2015年 yunlian. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel
@synthesize weizhi = _weizhi,time=_time,latitude = _latitude,longtitude =_longtitude,whichbundle=_whichbundle,isWaitPoint=_isWaitPoint,waiteSeconds = _waiteSeconds,isCycle = _isCycle,x=_x,y=_y,ScanRate=_ScanRate,redWaitSeconds = _redWaitSeconds;
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_weizhi forKey:@"weizhi"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_ScanRate]  forKey:@"ScanRate"];
    [aCoder encodeObject:[NSNumber numberWithInt:_redWaitSeconds]  forKey:@"redWaitSeconds"];
    //第几次添加的
    [aCoder encodeObject:[NSNumber numberWithDouble:_latitude] forKey:@"latitude"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_longtitude] forKey:@"longtitude"];
    [aCoder encodeObject:_whichbundle forKey:@"whichbundle"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isWaitPoint] forKey:@"isWaitPoint"];
    [aCoder encodeObject:[NSNumber numberWithInt:_waiteSeconds] forKey:@"waiteSeconds"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isCycle] forKey:@"isCycle"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_y] forKey:@"y"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self != nil){
        _weizhi = [aDecoder decodeObjectForKey:@"weizhi"];
        _time = [aDecoder decodeObjectForKey:@"time"];
        _latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
        _longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] doubleValue];
        _whichbundle = [aDecoder decodeObjectForKey:@"whichbundle"];
        _isWaitPoint = [[aDecoder decodeObjectForKey:@"isWaitPoint"] intValue];
        _waiteSeconds = [[aDecoder decodeObjectForKey:@"waiteSeconds"] intValue];
        _isCycle = [[aDecoder decodeObjectForKey:@"isCycle"] intValue];
        _x = [[aDecoder decodeObjectForKey:@"x"] doubleValue];
        _y = [[aDecoder decodeObjectForKey:@"y"] doubleValue];
        _ScanRate = [[aDecoder decodeObjectForKey:@"ScanRate"] doubleValue];
        _redWaitSeconds = [[aDecoder decodeObjectForKey:@"redWaitSeconds"] intValue];
    }
    return self;
}
@end
