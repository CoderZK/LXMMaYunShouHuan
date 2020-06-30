//
//  LxmRealLoginVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/12.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmRealLoginVC.h"
#import "LxmRegisterVC.h"
#import "LxmImgTFView.h"
#import "TabBarController.h"
//#import "LxmSureRoleVC.h"
#import "LxmSearchDeviceVC.h"
#import "LxmHomeVC.h"

#import "LxmBLEManager.h"


@interface LxmRealLoginVC ()<UITextFieldDelegate>
{
    UITableView * _tableView;
    LxmImgTFView * _userNameView;
    LxmImgTFView * _passwordView;
}
@end

@implementation LxmRealLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenW, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _userNameView = [[LxmImgTFView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 49.75)];
    _userNameView.imageView.image = [UIImage imageNamed:@"ico_dengzhu_2"];
    _userNameView.TF.placeholder = @"请输入用户名";
    _userNameView.TF.keyboardType = UIKeyboardTypeNumberPad;
    _userNameView.TF.text = self.phone;
    [bgView addSubview:_userNameView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 49.75, ScreenW-8, 0.5)];
    lineView.backgroundColor = LineColor;
    [bgView addSubview:lineView];
    
    _passwordView = [[LxmImgTFView alloc] initWithFrame:CGRectMake(0, 50.25, ScreenW, 50)];
    _passwordView.imageView.image = [UIImage imageNamed:@"ico_dengzhu_1"];
    _passwordView.TF.placeholder = @"请输入密码";
    _passwordView.TF.secureTextEntry = YES;
    [bgView addSubview:_passwordView];
    
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, ScreenW, 64)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:btn];

    
    UIButton *fogetBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-110, 200, 100, 20)];
    [fogetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    fogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    fogetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [fogetBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    [fogetBtn addTarget:self action:@selector(fogetBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fogetBtn];
    
}
- (void)fogetBtnClcik{
    //找回密码
    LxmRegisterVC * vc = [[LxmRegisterVC alloc] init];
    vc.str = @"2";
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)btnClcik:(UIButton *)btn {
    //登录成功
    if (_userNameView.TF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (_passwordView.TF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (_passwordView.TF.text.isContrainsKong) {
        [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的密码!"];
        return;
    }
    if (_passwordView.TF.text.length<6||_passwordView.TF.text.length>15) {
        [SVProgressHUD showErrorWithStatus:@"密码长度必须在6~15之间"];
        return;
    }
    
    NSString * signature = [NSString stringToMD5:_passwordView.TF.text];
    NSDictionary * dict = @{@"phone":_userNameView.TF.text,@"password":signature};

    NSString * loginStr = [LxmURLDefine getLoginURL];
    [SVProgressHUD show];
    btn.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:loginStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        btn.userInteractionEnabled = YES;
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"token"]];
            [LxmTool ShareTool].hasPerfect = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"hasPerfect"]];
//            //测试

            [[LxmTool ShareTool] uploadDeviceToken];
            if ([[LxmTool ShareTool].hasPerfect intValue] == 1) {
                //资料完整 跳转首页
                TabBarController *BarVC=[[TabBarController alloc] init];
                [UIApplication sharedApplication].delegate.window.rootViewController = BarVC;
            } else {
                //扫描设备列表 
                LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:vc animated:YES];
            }
      
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10001) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您还没有注册，请先注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LxmRegisterVC * vc = [[LxmRegisterVC alloc] init];
                vc.str = @"1";
                vc.phone = _userNameView.TF.text;
                [self.navigationController pushViewController:vc animated:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10006) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:responseObject[@"message"] atVC:self];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        btn.userInteractionEnabled = YES;
    }];
}

//点击后退
- (void)cancelAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 11) {
        return NO;
    }
    return YES;
}

@end
