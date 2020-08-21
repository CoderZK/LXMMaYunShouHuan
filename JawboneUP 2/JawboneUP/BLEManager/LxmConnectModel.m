//
//  LxmConnectModel.m
//  JawboneUP
//
//  Created by 宋乃银 on 2017/11/4.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmConnectModel.h"

@implementation LxmConnectModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uuidStr forKey:@"uuidStr"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.tongxinId forKey:@"tongxinId"];
    [aCoder encodeBool:self.isMaster forKey:@"isMaster"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uuidStr=[aDecoder decodeObjectForKey:@"uuidStr"];
        self.nickName=[aDecoder decodeObjectForKey:@"nickName"];
        self.tongxinId = [aDecoder decodeObjectForKey:@"tongxinId"];
        self.isMaster = [aDecoder decodeBoolForKey:@"isMaster"];
    }
    return self;
}

@end
