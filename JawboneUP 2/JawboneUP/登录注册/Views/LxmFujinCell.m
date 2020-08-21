//
//  LxmFujinCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmFujinCell.h"

@implementation LxmFujinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.uuidLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenW-130, 64)];
        _uuidLabel.numberOfLines = 2;
        [self addSubview:self.uuidLabel];
        
        UIButton * bandingBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-115, 19, 100, 36)];
        [bandingBtn setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
        [bandingBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [bandingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bandingBtn];
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(LxmFujinCell:btnAtIndex:)]) {
        [self.delegate LxmFujinCell:self btnAtIndex:self.index];
    }
    
}

@end
