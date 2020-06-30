//
//  LxmConnectedCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmConnectedCell.h"

@implementation LxmConnectedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _headerImgView.image = [UIImage imageNamed:@"pic_1"];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
        [self addSubview:_headerImgView];
        
        UILabel * roleLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 40, 20)];
        roleLab.textColor = [UIColor redColor];
        roleLab.text = @"主机";
        [self addSubview:roleLab];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 15, ScreenW-125-15-20, 20)];
        _titleLab.text = @"老师";
        [self addSubview:_titleLab];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 45, 20, 20)];
        imgView.image = [UIImage imageNamed:@"ico_shouji"];
        [self addSubview:imgView];
        
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 45, ScreenW-125-15-20, 20)];
        _phoneLab.text  = @"15836861521";
        [self addSubview:_phoneLab];
        
        UIImageView * AImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 20, 20, 20)];
        AImgView.image = [UIImage imageNamed:@"LYYou"];
        [self addSubview:AImgView];
        
    }return self;
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
