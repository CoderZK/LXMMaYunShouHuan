//
//  LxmTextBtnImgView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/25.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTextBtnImgView.h"

@implementation LxmTextBtnImgView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        [self addSubview:_leftLab];
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, 0, ScreenW-115, 50)];
        [self addSubview:_rightBtn];
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, ScreenW-115-35, 20)];
        [self addSubview:_rightLab];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-35, 15, 20, 20)];
        imgView.image = [UIImage imageNamed:@"LYYou_xia"];
        [self addSubview:imgView];
    }
    return self;
}

@end
