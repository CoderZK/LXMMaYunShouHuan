//
//  LxmSureRoleVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSureRoleVC.h"
#import "LxmRoleSelectVC.h"
#import "LxmTeacherInfoVC.h"

@interface LxmSureRoleVC ()
{
    UIButton * _teacherBtn;
    UIButton * _jiazhangBtn;
    NSMutableArray * _btnArr;
}
@end

@implementation LxmSureRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnArr = [NSMutableArray array];
    self.navigationItem.title = @"身份选择";
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenH*0.5-130, ScreenW-30, 20)];
    lab.text = @"请选择你的身份";
    lab.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:lab];
    
    _teacherBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-120, ScreenH*0.5-80, 100, 100)];
    [_teacherBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     [_teacherBtn setTitle:@"老师" forState:UIControlStateNormal];
    _teacherBtn.backgroundColor = [UIColor whiteColor];
    [_teacherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_teacherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _teacherBtn.backgroundColor = [UIColor blueColor];
    _teacherBtn.layer.cornerRadius = 50;
    _teacherBtn.clipsToBounds = YES;
    [_teacherBtn setBackgroundImage:[UIImage imageNamed:@"bg_6"] forState:UIControlStateNormal];
    [_teacherBtn setBackgroundImage:[UIImage imageNamed:@"other"] forState:UIControlStateSelected];
    [self.tableView addSubview:_teacherBtn];
    [_btnArr addObject:_teacherBtn];

    
    _jiazhangBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5+20, ScreenH*0.5-80, 100, 100)];
    [_jiazhangBtn setTitle:@"家长" forState:UIControlStateNormal];
    [_jiazhangBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_jiazhangBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_jiazhangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _jiazhangBtn.backgroundColor = [UIColor whiteColor];
    _jiazhangBtn.backgroundColor = [UIColor blueColor];
    _jiazhangBtn.layer.cornerRadius = 50;
    _jiazhangBtn.clipsToBounds = YES;
    [_jiazhangBtn setBackgroundImage:[UIImage imageNamed:@"bg_6"] forState:UIControlStateNormal];
    [_jiazhangBtn setBackgroundImage:[UIImage imageNamed:@"other"] forState:UIControlStateSelected];
    [self.tableView addSubview:_jiazhangBtn];
    [_btnArr addObject:_jiazhangBtn];

    
    
}
-(void)btnClick:(UIButton *)btn
{
    for (UIButton * btnn in _btnArr) {
        if (btn == btnn) {
            btnn.selected = YES;
            if (btnn == _jiazhangBtn) {
                //跳转到家长身份信息界面
                LxmRoleSelectVC * vc = [[LxmRoleSelectVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                [LxmTool ShareTool].isTeacher = NO;
            }
            if (btnn == _teacherBtn) {
                //跳转到老师身份信息界面
                LxmTeacherInfoVC * vc = [[LxmTeacherInfoVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                [LxmTool ShareTool].isTeacher = YES;
            }
        }
        else
        {
            btnn.selected = NO;
        }
    }
    
}

@end
