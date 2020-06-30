//
//  UIControl+AfterTimeAble.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/11/29.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "UIControl+AfterTimeAble.h"


@implementation UIControl (AfterTimeAble)

- (void)enabledAfter:(CGFloat)time {
    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
}

@end
