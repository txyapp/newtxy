//
//  CollectModel.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
    }
    return self;
}


@end
