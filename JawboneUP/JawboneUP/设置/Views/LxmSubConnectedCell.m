//
//  LxmSubConnectedCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSubConnectedCell.h"

@implementation LxmSubConnectedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _imgView.layer.cornerRadius = 30;
        _imgView.clipsToBounds = YES;
        _imgView.image =[UIImage imageNamed:@"pic_1"];
        [self addSubview:_imgView];
        
        UILabel * sub = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 40, 20)];
        sub.text = @"子机";
        sub.textColor = BlueColor;
        [self addSubview:sub];
        
        _subLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 30, ScreenW-125-15-20, 20)];
        _subLab.textColor = CharacterDarkColor;
        _subLab.text = @"1234566";
        [self addSubview:_subLab];
        
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
