//
//  LxmSubOtherBabyCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSubOtherBabyCell.h"

@implementation LxmSubOtherBabyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.headerImgView.image = [UIImage imageNamed:@"touxiang_2"];
        self.headerImgView.layer.cornerRadius = 30;
        self.headerImgView.layer.masksToBounds = YES;
        [self addSubview:self.headerImgView];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 24, 24)];
        imgView.image = [UIImage imageNamed:@"ico_mingcheng"];
        [self addSubview:imgView];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 12, 80, 20)];
        self.nameLab.text = @"查妈妈";
        self.nameLab.font = [UIFont systemFontOfSize:14];
        self.nameLab.textColor = CharacterDarkColor;
        [self addSubview:self.nameLab];
        
        
        UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 46, 24, 24)];
        imgView1.image = [UIImage imageNamed:@"ico_shouji"];
        [self addSubview:imgView1];
        
        self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 48, ScreenW-130, 20)];
        self.phoneLab.font = [UIFont systemFontOfSize:14];
        self.phoneLab.text = @"15836861251";
        self.phoneLab.textColor = CharacterDarkColor;
        [self addSubview:self.phoneLab];
        
        
        
        
        self.foreverBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLab.frame)+5, 12, 69, 20)];
        [self.foreverBtn setBackgroundImage:[UIImage imageNamed:@"weituo_1"] forState:UIControlStateNormal];
        self.foreverBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.foreverBtn];
        
        
    }return self;
}

@end
