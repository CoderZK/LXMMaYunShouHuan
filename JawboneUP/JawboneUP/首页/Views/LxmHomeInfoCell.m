//
//  LxmHomeInfoCell.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/26.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmHomeInfoCell.h"

@implementation LxmHomeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 15 - 160, 20)];
        _nameLab.text = @"主机李老师";
        [self addSubview:_nameLab];
        
        UIImageView * dianliangView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 130 - 25, 15, 20, 20)];
        dianliangView.contentMode = UIViewContentModeScaleAspectFit;
        dianliangView.image = [UIImage imageNamed:@"ico_dianliang"];
        [self addSubview:dianliangView];
        
        _dianliangLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 130 , 15, 50, 20)];
        _dianliangLab.text = @"0%";
        [self addSubview:_dianliangLab];
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-50-25, 15, 20, 20)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        iconImgView.image = [UIImage imageNamed:@"ico_juli"];
        [self addSubview:iconImgView];
        
        _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 50, 15, 50, 20)];
        _locationLab.text = @"0";
        [self addSubview:_locationLab];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:view];
    }
    return self;
}

- (void)setDataModel:(LxmDeviceModel *)dataModel {
//    _dataModel = dataModel;
//    _nameLab.text = _dataModel.equNickname;
//    _dianliangLab.text = [NSString stringWithFormat:@"%ld%@",(long)_dataModel.power,@"%"];
//    _locationLab.text = [NSString stringWithFormat:@"%@",@(_dataModel.distance)];
//    if (_dataModel.isConnect) {
//        UIColor *color=[UIColor blackColor];
//        _nameLab.textColor = color;
//        _dianliangLab.textColor = color;
//        _locationLab.textColor = color;
//    } else {
//        UIColor *color=[UIColor lightGrayColor];
//        _nameLab.textColor = color;
//        _dianliangLab.textColor = color;
//        _locationLab.textColor = color;
//    }
}

@end
