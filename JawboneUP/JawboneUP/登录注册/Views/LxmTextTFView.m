//
//  LxmTextTFView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/25.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTextTFView.h"

@implementation LxmTextTFView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        [self addSubview:_leftLab];
        _rightTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 15, ScreenW-115-10, 20)];
        [self addSubview:_rightTF];
    }
    return self;
}

@end
