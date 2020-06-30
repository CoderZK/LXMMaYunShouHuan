//
//  LxmAboutUsVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/2.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmAboutUsVC.h"

@interface LxmAboutUsVC ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *versionLabel;//版本号

@property (nonatomic, strong) UILabel *companyLabel;

@end

@implementation LxmAboutUsVC

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.text = @"公司简介：心颜物联网是一家以用心改善生活为理念，以科技创新为根基，以市场为导向的科技型公司。公司旨在通过先进的技术将儿童定位在安全距离范围内的方法，来解决父母带娃外出心情比较紧张，不能放松的状态。从而提高儿童安全系数，并把家长从紧张状态中解放出来。";
    }
    return _textLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.layer.cornerRadius = 5;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.image = [UIImage imageNamed:@"1024.jpg"];
    }
    return _iconImgView;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.textColor = CharacterGrayColor;
        _versionLabel.font = [UIFont systemFontOfSize:16];
        NSString *app_version = [[NSBundle.mainBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _versionLabel.text = [NSString stringWithFormat:@"V%@", app_version];
    }
    return _versionLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.textColor = CharacterDarkColor;
        _companyLabel.font = [UIFont systemFontOfSize:16];
        _companyLabel.text = @"常州新颜物联网科技有限公司";
    }
    return _companyLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenW, self.tableView.bounds.size.height - NavigationSpace)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    

    [headerView addSubview:self.textLabel];
    [headerView addSubview:self.iconImgView];
    [headerView addSubview:self.versionLabel];
    [headerView addSubview:self.companyLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(headerView).offset(15);
        make.trailing.equalTo(headerView).offset(-15);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(150);
        make.centerX.equalTo(headerView);
        make.width.height.equalTo(@80);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
        make.centerX.equalTo(headerView);
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView).offset(-20);
        make.centerX.equalTo(headerView);
    }];
}

@end
