//
//  LxmDataNavView.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDataNavView.h"
#import "LxmBLEManager.h"

@implementation LxmDataNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.backButton];
    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightButton];
    [self.topView addSubview:self.juliButton];
    [self.topView addSubview:self.jibuButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-7);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-7);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.juliButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.topView);
        make.width.equalTo(@60);
    }];
    [self.jibuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.topView);
        make.width.equalTo(@60);
    }];
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImage imageNamed:@"lxm_nav_left"] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 16);
    }
    return _backButton;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.layer.borderColor = UIColor.whiteColor.CGColor;
        _topView.layer.borderWidth = 0.5;
        _topView.layer.cornerRadius = 5;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (UIButton *)juliButton {
    if (!_juliButton) {
        _juliButton = [UIButton new];
        [_juliButton setTitle:@"距离" forState:UIControlStateNormal];
        [_juliButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_juliButton setTitleColor:BlueColor forState:UIControlStateSelected];
        [_juliButton setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateSelected];
        [_juliButton setBackgroundImage:[UIImage imageNamed:@"touming"] forState:UIControlStateNormal];
        _juliButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _juliButton.selected = YES;
        [_juliButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _juliButton;
}

- (UIButton *)jibuButton {
    if (!_jibuButton) {
        _jibuButton = [UIButton new];
        [_jibuButton setTitle:@"计步" forState:UIControlStateNormal];
        [_jibuButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_jibuButton setTitleColor:BlueColor forState:UIControlStateSelected];
        [_jibuButton setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateSelected];
        [_jibuButton setBackgroundImage:[UIImage imageNamed:@"touming"] forState:UIControlStateNormal];
        _jibuButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_jibuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jibuButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setTitle:@"同步" forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightButton;
}


- (void)btnClick:(UIButton *)btn {
    if (LxmBLEManager.shareManager.isTongbuDistance || LxmBLEManager.shareManager.isTongbuStep) {
        [SVProgressHUD showErrorWithStatus:@"数据正在同步,请稍后.."];
        return;
    } else {
        if (self.didSelectButton) {
            self.didSelectButton(btn == _juliButton);
        }
    }
}

@end


/**
 选择子机view
 */
@interface LxmDataSelectView ()

@property (nonatomic, strong) UIImageView *iconImgView;//三角

@property (nonatomic, strong) UIView *lineView;//线条

@end
@implementation LxmDataSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImgView];
    [self addSubview:self.lineView];
}
/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"down"];
    }
    return _iconImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end
