//
//  LxmStyleSelectCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/27.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmStyleSelectCell.h"

@implementation LxmStyleSelectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.0, ScreenW-115, 0.5)];
        _lineView.backgroundColor = LineColor;
        [self addSubview:_lineView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW-115-15, 43.5)];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLab];
        
    }
    return self;
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
