//
//  LxmMyLocationView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmMyLocationView.h"

@implementation LxmMyLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 40, 40)];
        self.headerImg.layer.cornerRadius = 20;
        self.headerImg.clipsToBounds = YES;
        [self addSubview:self.headerImg];

        
        UILabel * me = [[UILabel alloc] initWithFrame:CGRectMake(10, 51, 40, 9)];
        me.textAlignment = NSTextAlignmentCenter;
        me.text = @"我";
        me.textColor = [UIColor whiteColor];
        me.font = [UIFont systemFontOfSize:9];
        [self addSubview:me];
        
    }
    return self;
}

@end
