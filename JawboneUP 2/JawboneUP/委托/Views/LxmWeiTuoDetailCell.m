//
//  LxmWeiTuoDetailCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoDetailCell.h"

@interface LxmWeiTuoDetailCell()
{
    UILabel *_nameLab;
    UIButton *_weituotypeBtn;
    UILabel *_phoneLab;
}
@end

@implementation LxmWeiTuoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        headerImgView.image = [UIImage imageNamed:@"touxiang_2"];
        headerImgView.layer.cornerRadius = 30;
        headerImgView.layer.masksToBounds = YES;
        [self addSubview:headerImgView];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 24, 24)];
        imgView.image = [UIImage imageNamed:@"ico_mingcheng"];
        [self addSubview:imgView];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 12, 80, 20)];
        _nameLab.text = @"查妈妈";
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = CharacterDarkColor;
        [self addSubview:_nameLab];
        
        _weituotypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLab.frame)+5, 12, 69, 20)];
        [_weituotypeBtn setBackgroundImage:[UIImage imageNamed:@"weituo_3"] forState:UIControlStateNormal];
        [self addSubview:_weituotypeBtn];
        
        
        UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 46, 24, 24)];
        imgView1.image = [UIImage imageNamed:@"ico_shouji"];
        [self addSubview:imgView1];
        
        UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 48, ScreenW-130-69, 20)];
        phoneLab.font = [UIFont systemFontOfSize:14];
        phoneLab.text = @"15836861251";
        phoneLab.textColor = CharacterDarkColor;
        [self addSubview:phoneLab];

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-15-69, 30, 69, 20)];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"weituo_3"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setTitle:@"取消委托" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        
        
    }return self;
}
- (void)cancleBtnClick{
    if ([self.delegate respondsToSelector:@selector(LxmWeiTuoDetailCell:)]) {
        [self.delegate LxmWeiTuoDetailCell:self];
    }
}
- (void)setModel:(LxmWeiTuoModel *)model{
    
    _nameLab.text = model.realname;
    CGFloat f = [_nameLab.text getSizeWithMaxSize:CGSizeMake(ScreenW-115-69-5-69-15, 20) withFontSize:14].width;
    _nameLab.frame = CGRectMake(115, 12, f, 20);
    _weituotypeBtn.frame = CGRectMake(CGRectGetMaxX(_nameLab.frame)+5, 12, 69, 20);
    _phoneLab.text = model.tel;
    
    [_weituotypeBtn setBackgroundImage:[UIImage imageNamed:[model.authorizeType integerValue] == 1?@"weituo_2":@"weituo_1"] forState:UIControlStateNormal];
}

@end
