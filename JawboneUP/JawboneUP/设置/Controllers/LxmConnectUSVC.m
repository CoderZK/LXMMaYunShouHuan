//
//  LxmConnectUSVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmConnectUSVC.h"

@interface LxmConnectUSVC ()

@end

@implementation LxmConnectUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    
    UIView * QQview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    QQview.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:QQview];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
    lab.text = @"客服QQ";
    lab.textColor = CharacterDarkColor;
    lab.font = [UIFont systemFontOfSize:15];
    [QQview addSubview:lab];
    
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, ScreenW-110, 20)];
    lab1.text = @"847189574";
    lab1.textColor = CharacterDarkColor;
    lab1.textAlignment = NSTextAlignmentRight;
    lab1.font = [UIFont systemFontOfSize:15];
    [QQview addSubview:lab1];
    
    UIButton * phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50.5, ScreenW, 50)];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:phoneBtn];
    
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
    lab2.text = @"热线电话";
    lab2.textColor = CharacterDarkColor;
    lab2.font = [UIFont systemFontOfSize:15];
    [phoneBtn addSubview:lab2];
    
    UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, ScreenW-110, 20)];
    lab3.text = @"400-009-5647";
    lab3.textColor = CharacterDarkColor;
    lab3.textAlignment = NSTextAlignmentRight;
    lab3.font = [UIFont systemFontOfSize:15];
    [phoneBtn addSubview:lab3];
    
}
- (void)btnClick
{
    
    UIAlertController  * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否拨打%@",@"400-009-5647"] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"400-009-5647"]]];
        
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];

}

@end
