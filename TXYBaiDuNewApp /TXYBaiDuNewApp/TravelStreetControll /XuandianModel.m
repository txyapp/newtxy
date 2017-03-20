//
//  XuandianModel.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/24.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "XuandianModel.h"

@implementation XuandianModel
@synthesize location = _location, weizhi = _weizhi,time=_time,juli=_juli,index=_index,latitude = _latitude,longtitude =_longtitude,indexInStep=_indexInStep,whichbundle=_whichbundle,whichstep=_whichstep,thestepTotleNum= _thestepTotleNum,totleStep=_totleStep,isWaitPoint=_isWaitPoint,waiteSeconds = _waiteSeconds,isCycle = _isCycle,x=_x,y=_y,ScanRate=_ScanRate,redWaitSeconds = _redWaitSeconds,speed =_speed,alertOn = _alertOn,linesType = _linesType,isState = _isState,isCollec = _isCollec,waitTime = _waitTime,longitudeNum = _longitudeNum,latitudeNum = _latitudeNum;
//,currentLocation = _currentLocation
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:_isCollec] forKey:@"isCollec"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isState] forKey:@"isState"];
    [aCoder encodeObject:[NSNumber numberWithInt:_linesType] forKey:@"linesType"];
    [aCoder encodeObject:[NSNumber numberWithInt:_speed] forKey:@"speed"];
    [aCoder encodeObject:[NSNumber numberWithInt:_alertOn] forKey:@"alertOn"];
    [aCoder encodeObject:_weizhi forKey:@"weizhi"];
    //[aCoder encodeObject: [NSValue valueWithBytes:&_currentLocation objCType:@encode(CLLocationCoordinate2D)] forKey:@"currentLocation"];
    [aCoder encodeObject:_waitTime forKey:@"waitTime"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_juli forKey:@"juli"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_ScanRate]  forKey:@"ScanRate"];
    [aCoder encodeObject:_longitudeNum  forKey:@"longitudeNum"];
    [aCoder encodeObject:_latitudeNum  forKey:@"latitudeNum"];
    [aCoder encodeObject:[NSNumber numberWithInt:_redWaitSeconds]  forKey:@"redWaitSeconds"];
    //第几次添加的
    [aCoder encodeObject:[NSNumber numberWithInt:_index]  forKey:@"index"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_latitude] forKey:@"latitude"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_longtitude] forKey:@"longtitude"];
    [aCoder encodeObject:[NSNumber numberWithInt:_indexInStep] forKey:@"indexInStep"];
    [aCoder encodeObject:_whichbundle forKey:@"whichbundle"];
    [aCoder encodeObject:[NSNumber numberWithInt:_whichstep] forKey:@"whichstep"];
    [aCoder encodeObject:[NSNumber numberWithInt:_thestepTotleNum] forKey:@"thestepTotleNum"];
    [aCoder encodeObject:[NSNumber numberWithInt:_totleStep] forKey:@"totleStep"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isWaitPoint] forKey:@"isWaitPoint"];
    [aCoder encodeObject:[NSNumber numberWithInt:_waiteSeconds] forKey:@"waiteSeconds"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isCycle] forKey:@"isCycle"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_y] forKey:@"y"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self != nil){
        _isCollec =[[aDecoder decodeObjectForKey:@"isCollec"] intValue];
        _isState =[[aDecoder decodeObjectForKey:@"isState"] intValue];
        _linesType =[[aDecoder decodeObjectForKey:@"linesType"] intValue];
        _speed =[[aDecoder decodeObjectForKey:@"speed"] intValue];
        _alertOn = [[aDecoder decodeObjectForKey:@"alertOn"] intValue];
        _weizhi = [aDecoder decodeObjectForKey:@"weizhi"];
        _waitTime = [aDecoder decodeObjectForKey:@"waitTime"];
        _time = [aDecoder decodeObjectForKey:@"time"];
        _juli =[aDecoder decodeObjectForKey:@"juli"];
        _index = [[aDecoder decodeObjectForKey:@"index"] intValue];
        _latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
        _longtitude = [[aDecoder decodeObjectForKey:@"longtitude"] doubleValue];
        _indexInStep = [[aDecoder decodeObjectForKey:@"indexInStep"] intValue];
        _whichbundle = [aDecoder decodeObjectForKey:@"whichbundle"];
        _whichstep = [[aDecoder decodeObjectForKey:@"whichstep"] intValue];
        _thestepTotleNum = [[aDecoder decodeObjectForKey:@"thestepTotleNum"] intValue];
        _totleStep = [[aDecoder decodeObjectForKey:@"totleStep"] intValue];
        _isWaitPoint = [[aDecoder decodeObjectForKey:@"isWaitPoint"] intValue];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _waiteSeconds = [[aDecoder decodeObjectForKey:@"waiteSeconds"] intValue];
        _isCycle = [[aDecoder decodeObjectForKey:@"isCycle"] intValue];
        _x = [[aDecoder decodeObjectForKey:@"x"] doubleValue];
        _y = [[aDecoder decodeObjectForKey:@"y"] doubleValue];
        _ScanRate = [[aDecoder decodeObjectForKey:@"ScanRate"] doubleValue];
        _redWaitSeconds = [[aDecoder decodeObjectForKey:@"redWaitSeconds"] intValue];
        // [[aDecoder decodeObjectForKey:@"currentLocation"] getValue:&_currentLocation];
        _longitudeNum = [aDecoder decodeObjectForKey:@"longitudeNum"];
        _latitudeNum = [aDecoder decodeObjectForKey:@"latitudeNum"];
    }
    return self;
}
@end
