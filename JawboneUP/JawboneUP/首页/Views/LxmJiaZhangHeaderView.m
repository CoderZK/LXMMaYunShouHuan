//
//  LxmJiaZhangHeaderView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/2.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmJiaZhangHeaderView.h"

@implementation LxmJiaZhangHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //保证headerImg的位置  在 LxmJiaZhangHeaderView的中心
        self.headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.headerImg.layer.cornerRadius = 20;
        self.headerImg.center = self.center;
        self.headerImg.clipsToBounds = YES;
        [self addSubview:self.headerImg];
        
        self.redImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 30, 10)];
        self.redImg.image = [UIImage imageNamed:@"bg_di"];
        [self addSubview:self.redImg];
        
        self.distancelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        self.distancelab.textColor = [UIColor whiteColor];
        self.distancelab.font = [UIFont systemFontOfSize:9];
        self.distancelab.textAlignment = NSTextAlignmentCenter;
        [self.redImg addSubview:self.distancelab];
        
        self.namelab = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 40, 10)];
        self.namelab.backgroundColor = [CharacterGrayColor colorWithAlphaComponent:0.7];
        self.namelab.layer.cornerRadius = 5;
        self.namelab.clipsToBounds = YES;
        self.namelab.textAlignment = NSTextAlignmentCenter;
        self.namelab.textColor = [UIColor whiteColor];
        self.namelab.font = [UIFont systemFontOfSize:9];
        [self addSubview:self.namelab];
        
    }
    return self;
}

@end
