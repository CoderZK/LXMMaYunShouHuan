//
//  LxmImgTFView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmImgTFView.h"

@implementation LxmImgTFView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:_imageView];
        
        _TF = [[UITextField alloc] initWithFrame:CGRectMake(55, 10, ScreenW-65, 40)];
        _TF.textColor = CharacterDarkColor;
        [self addSubview:_TF];
    }
    return self;
}

@end
