//
//  LxmSubMybabyCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSubMybabyCell.h"

@implementation LxmSubMybabyCell

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
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 12, ScreenW-115-95, 20)];
        self.nameLab.text = @"查妈妈查妈妈们妈妈妈妈们妈妈妈妈";
        self.nameLab.font = [UIFont systemFontOfSize:14];
        self.nameLab.textColor = CharacterDarkColor;
        [self addSubview:self.nameLab];
        
        
        UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 46, 24, 24)];
        imgView1.image = [UIImage imageNamed:@"ico_shouji"];
        [self addSubview:imgView1];
        
        self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 48, ScreenW-115-95, 20)];
        self.phoneLab.font = [UIFont systemFontOfSize:14];
        self.phoneLab.text = @"15836861251";
        self.phoneLab.textColor = CharacterDarkColor;
        [self addSubview:self.phoneLab];
        
        UIButton * limitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-95, 10, 80, 26)];
        [limitBtn setBackgroundImage:[UIImage imageNamed:@"weituo_3"] forState:UIControlStateNormal];
        [limitBtn setTitle:@"限时委托" forState:UIControlStateNormal];
        limitBtn.tag = 110;
        [limitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        limitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [limitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:limitBtn];
        
        UIButton * foreverBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-95, 44, 80, 26)];
        [foreverBtn setBackgroundImage:[UIImage imageNamed:@"weituo_3"] forState:UIControlStateNormal];
        [foreverBtn setTitle:@"永久委托" forState:UIControlStateNormal];
        foreverBtn.tag = 111;
        [foreverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        foreverBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [foreverBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foreverBtn];
        
        
    }return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(LxmSubMybabyCell:btnAtIndex:)]) {
        [self.delegate LxmSubMybabyCell:self btnAtIndex:btn.tag];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
