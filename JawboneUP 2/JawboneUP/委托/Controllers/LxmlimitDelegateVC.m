//
//  LxmlimitDelegateVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmlimitDelegateVC.h"
#import "PGDatePicker.h"
#import "LxmFindFriendVC.h"

@interface LxmlimitDelegateVC ()<PGDatePickerDelegate>
{
    UILabel * _leftLab;
    UILabel * _leftLab1;
    UILabel * _rightLab;
    UILabel * _rightLab1;
    PGDatePicker * _picker;
    PGDatePicker * _picker1;
}
@end

@implementation LxmlimitDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"限时委托";
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightbtn addTarget:self action:@selector(rightbarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLab.text = @"委托时间";
    titleLab.textColor = CharacterDarkColor;
    titleLab.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLab];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.75, ScreenW, 0.5)];
    lineView.backgroundColor = LineColor;
    [headerView addSubview:lineView];
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.25, ScreenW*0.5-5, 49.75)];
    leftBtn.tag = 210;
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:leftBtn];
    
    UILabel * leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
    _leftLab = leftLab;
    leftLab.backgroundColor = self.tableView.backgroundColor;
    leftLab.layer.cornerRadius = 10;
    leftLab.clipsToBounds = YES;
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.font = [UIFont systemFontOfSize:14];
    leftLab.textColor = CharacterGrayColor;
    leftLab.text = @"0000-00-00";
    [leftBtn addSubview:leftLab];
    
    UILabel * leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 60, 30)];
    _leftLab1 = leftLab1;
    leftLab1.backgroundColor = self.tableView.backgroundColor;
    leftLab1.layer.cornerRadius = 10;
    leftLab1.clipsToBounds = YES;
    leftLab1.textAlignment = NSTextAlignmentCenter;
    leftLab1.font = [UIFont systemFontOfSize:14];
    leftLab1.textColor = CharacterGrayColor;
    leftLab1.text = @"0:00";
    [leftBtn addSubview:leftLab1];
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(ScreenW*0.5-5, 74.75, 10, 0.5)];
    line.backgroundColor = CharacterDarkColor;
    [headerView addSubview:line];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5+5, 50.25, ScreenW*0.5-5, 49.75)];
    rightBtn.tag = 211;
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:rightBtn];
    
    UILabel * rightLab = [[UILabel alloc] initWithFrame:CGRectMake(rightBtn.bounds.size.width-15-60-5-100, 10, 100, 30)];
    _rightLab = rightLab;
    rightLab.backgroundColor = self.tableView.backgroundColor;
    rightLab.layer.cornerRadius = 10;
    rightLab.clipsToBounds = YES;
    rightLab.textAlignment = NSTextAlignmentCenter;
    rightLab.font = [UIFont systemFontOfSize:14];
    rightLab.textColor = CharacterGrayColor;
    rightLab.text = @"0000-00-00";
    [rightBtn addSubview:rightLab];
    
    UILabel * rightLab1 = [[UILabel alloc] initWithFrame:CGRectMake(rightBtn.bounds.size.width-15-60, 10, 60, 30)];
    _rightLab1 = rightLab1;
    rightLab1.backgroundColor = self.tableView.backgroundColor;
    rightLab1.layer.cornerRadius = 10;
    rightLab1.clipsToBounds = YES;
    rightLab1.textAlignment = NSTextAlignmentCenter;
    rightLab1.font = [UIFont systemFontOfSize:14];
    rightLab1.textColor = CharacterGrayColor;
    rightLab1.text = @"0:00";
    [rightBtn addSubview:rightLab1];
    
    
}
#pragma 导航栏右侧确定按钮

- (void) rightbarBtnClick
{
    if ([_leftLab.text isEqualToString:@"0000-00-00"]) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择委托的开始时间"];
        return;
    }
    if ([_rightLab.text isEqualToString:@"0000-00-00"]) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择委托的截止时间"];
        return;
    }
    [self.tableView endEditing:YES];
    LxmFindFriendVC * vc = [[LxmFindFriendVC alloc] init];
    vc.starStr = [NSString stringWithFormat:@"%@ %@",_leftLab.text,_leftLab1.text];
    vc.endTimeStr = [NSString stringWithFormat:@"%@ %@",_rightLab.text,_rightLab1.text];
    vc.equId = self.equId;
    vc.childName = self.childName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 委托时间选择
- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 210) {
        //开始时间
        _picker = [[PGDatePicker alloc] init];
        _picker.delegate = self;
        _picker.datePickerMode = PGDatePickerModeDateHourMinute;
        [_picker show];
    }else{
        //截止时间
        _picker1 = [[PGDatePicker alloc] init];
        _picker1.delegate = self;
        _picker1.datePickerMode = PGDatePickerModeDateHourMinute;
        [_picker1 show];
    }
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    if (datePicker == _picker) {
            _leftLab.text = [NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day];
        _leftLab1.text = [NSString stringWithFormat:@"%ld:%ld",dateComponents.hour,dateComponents.minute];
    }else{
          _rightLab.text = [NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day];
        _rightLab1.text = [NSString stringWithFormat:@"%ld:%ld",dateComponents.hour,dateComponents.minute];
    }

}


@end
