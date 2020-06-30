
//
//  LxmRegisterCellView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/2.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmRegisterCellView.h"

@implementation LxmRegisterCellView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:_imgView];
        
        _rightTF = [[UITextField alloc] initWithFrame:CGRectMake(55, 15, ScreenW-60, 20)];
        [self addSubview:_rightTF];
        
    }return self;
}

@end
