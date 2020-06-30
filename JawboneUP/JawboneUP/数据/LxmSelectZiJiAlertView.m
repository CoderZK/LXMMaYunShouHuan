//
//  LxmSelectZiJiAlertView.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmSelectZiJiAlertView.h"

@interface LxmSelectZiJiCell()

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LxmSelectZiJiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end



@interface LxmSelectZiJiAlertView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray <LxmDeviceModel *>*dataArr;//数据

@end

@implementation LxmSelectZiJiAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn =[[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bgBtn.tag = 110;
        [self addSubview:bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 300 - TableViewBottomSpace, frame.size.width, 300 + TableViewBottomSpace)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIView * accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 39.5)];
        accView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:accView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, frame.size.width - 120, 40)];
        self.titleLabel.text = @"选择子机";
        self.titleLabel.textColor = CharacterDarkColor;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [accView addSubview:self.titleLabel];
        
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenW, 0.5)];
        lineView.backgroundColor = BGGrayColor;
        [accView addSubview:lineView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.hidden = NO;
        [_contentView addSubview:self.tableView];
    }
    return self;
}

- (void)setDeviceArr:(NSArray<LxmDeviceModel *> *)deviceArr {
    _deviceArr = deviceArr;
    if (self.type.integerValue == 1) {
        self.titleLabel.text = @"选择子机";
    } else {
        self.titleLabel.text = @"选择设备";
    }
    self.dataArr = _deviceArr;
    [self.tableView reloadData];
}

- (void)show {
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGRect rect = _contentView.frame;
    rect.origin.y = self.bounds.size.height;
    _contentView.frame = rect;
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.frame.size.height;
        selfWeak.contentView.frame = rect;
        
    } completion:nil];
}

- (void)dismiss {
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = self.bounds.size.height;
        selfWeak.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSelectZiJiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectZiJiCell"];
    if (!cell) {
        cell = [[LxmSelectZiJiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectZiJiCell"];
    }
    cell.titleLabel.text = self.dataArr[indexPath.row].equNickname;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmDeviceModel *model = self.dataArr[indexPath.row];
    if (self.type.integerValue == 1) {
        if (model.type.integerValue == 1) {
            return 0.01;
        }
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectSubDeviceClick) {
        self.didSelectSubDeviceClick(self.dataArr[indexPath.row]);
    }
    [self dismiss];
}

- (void)bgBtnClick:(UIButton *)btn {
    [self dismiss];
}

@end
