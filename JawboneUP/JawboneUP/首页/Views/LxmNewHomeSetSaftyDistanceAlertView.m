//
//  LxmNewHomeSetSaftyDistanceAlertView.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmNewHomeSetSaftyDistanceAlertView.h"

@interface LxmNewHomeSetSaftyDistanceAlertView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    void (^_setBlock)(NSInteger);
}
@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *calcelButton;//取消

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *sureButton;//确定

@end

@implementation LxmNewHomeSetSaftyDistanceAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 300 - TableViewBottomSpace, frame.size.width, 300 + TableViewBottomSpace)];
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIView * accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 39.5)];
        accView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:accView];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, frame.size.width, 0.5)];
        line.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
        [accView addSubview:line];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, frame.size.width - 120, 40)];
        self.titleLabel.text = @"设定安全距离";
        self.titleLabel.textColor = CharacterDarkColor;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [accView addSubview:self.titleLabel];
        
        UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 60, 0, 60, 39.5)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [accView addSubview:rightBtn];
        
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [_contentView addSubview:self.pickerView];

    }
    return self;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 51;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view){
        view = [[UIView alloc] init];
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (row == 0) {
        titleLabel.text = @"静音";
    } else {
        titleLabel.text = [NSString stringWithFormat:@"%ld 米",(long)row];
    }
    
    [view addSubview:titleLabel];
    return view;
}

//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenW;
}

//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld 米",(long)row]];
    [att addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:CharacterDarkColor} range:NSMakeRange(0, att.length)];
    return att;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld",(long)row);
}

- (void)showWithNumber:(NSInteger)num setBlock:(void (^)(NSInteger))block {
    if (num > 50) {
        num = 50;
    }
    _setBlock = block;
    [self.pickerView selectRow:num inComponent:0 animated:NO];
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

-(void)dismiss {
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

/**
 完成
 */
- (void)finishClick {
    [self dismiss];
    if (_setBlock) {
        _setBlock([_pickerView selectedRowInComponent:0]);
    }
}

@end

