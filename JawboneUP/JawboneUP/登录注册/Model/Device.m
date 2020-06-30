//
//  Device.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/27.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "Device.h"

@implementation Device
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.baojingStyle forKey:@"baojingStyle"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.ID=[aDecoder decodeObjectForKey:@"id"];
    self.name=[aDecoder decodeObjectForKey:@"name"];
    self.distance = [aDecoder decodeObjectForKey:@"distance"];
    self.baojingStyle = [aDecoder decodeObjectForKey:@"baojingStyle"];
    return self;
}
@end
