//
//  LxmDateModel.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/10/12.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDateModel.h"

@implementation LxmDateModel

@end

@implementation LxmDateDistanceModel

- (NSString *)distanceDouble {
    if (!_distanceDouble) {
        _distanceDouble = @"";
    }
    return _distanceDouble;
}

- (NSString *)timeStr {
    if (_timeStr) {
        if ([_timeStr isEqualToString:@"23:59:59"]) {
            return @"23";
        } else {
            _timeStr = [_timeStr substringWithRange:NSMakeRange(0, 2)];
            return [NSString stringWithFormat:@"%d",_timeStr.intValue - 1];
        }
    }
    return @"";
}

@end

@implementation LxmDateJibuModel

- (NSString *)time {
    if (_time) {
        NSArray *aa = [_time componentsSeparatedByString:@" "];
        NSString *tt = aa.lastObject;
        if ([tt isEqualToString:@"23:59:59"]) {
            return @"23";
        } else {
            tt = [tt substringWithRange:NSMakeRange(0, 2)];
           return [NSString stringWithFormat:@"%d",tt.intValue - 1];
        }
    }
    return @"";
}

@end
