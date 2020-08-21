//
//  LxmHomeModel.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHomeModel.h"

@implementation LxmHomeModel
@synthesize headimg = _headimg;
- (NSString *)headimg {
    if (!_headimg) {
        _headimg = @"";
    }
    return _headimg;
}

- (NSString *)realname {
    if (!_realname) {
        _realname = @"";
    }
    return _realname;
}

- (NSString *)type {
    if (!_type) {
        _type = @"";
    }
    return _type;
}

@end
