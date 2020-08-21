//
//  LxmHeaderView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/2.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmHeaderView.h"

@implementation LxmHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.headerImg.layer.cornerRadius = 20;
        self.headerImg.clipsToBounds = YES;
        self.headerImg.userInteractionEnabled = YES;
        self.headerImg.center = self.center;
        [self addSubview:self.headerImg];
        
        self.distancelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 60, 15)];
        self.distancelab.textColor = BlueColor;
        self.distancelab.font = [UIFont systemFontOfSize:13];
        self.distancelab.textAlignment = NSTextAlignmentCenter;
        self.distancelab.userInteractionEnabled = YES;
        [self addSubview:self.distancelab];
        
        self.namelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 60, 15)];
        self.namelab.textAlignment = NSTextAlignmentCenter;
        self.namelab.textColor = CharacterDarkColor;
        self.namelab.font = [UIFont systemFontOfSize:13];
        self.namelab.userInteractionEnabled = YES;
        [self addSubview:self.namelab];
        
    }
    return self;
}

@end
