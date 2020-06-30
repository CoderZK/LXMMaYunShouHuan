//
//  LxmMessageCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmMessageCell.h"

@implementation LxmMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _iconImgView.image = [UIImage imageNamed:@"touxiang_moren"];
        _iconImgView.layer.cornerRadius = 30;
        _iconImgView.layer.masksToBounds = YES;
        [self addSubview:_iconImgView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 13, 100, 20)];
        _titleLab.text = @"电量提醒";
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = CharacterDarkColor;
        [self addSubview:_titleLab];
        
        
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 36, ScreenW-100, 40)];
        _detailLab.text = @"子机查baby的电量是20%，请尽快充电";
        _detailLab.textColor = CharacterGrayColor;
        _detailLab.numberOfLines = 0;
        _detailLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_detailLab];
        
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(235, 13, ScreenW-250, 20)];
        _timeLab.text = @"今天16：00";
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.textColor = [CharacterGrayColor colorWithAlphaComponent:0.5];
        _timeLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_timeLab];
        
        
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
