//
//  LxmRegisterVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmRegisterVC.h"
//#import "LxmSureRoleVC.h"

#import "LxmRealLoginVC.h"

#import "LxmSearchDeviceVC.h"

#import "LxmRegisterCellView.h"

#import "BaseNavigationController.h"

#import "LxmLoginVC.h"


@interface LxmRegisterVC ()<UIGestureRecognizerDelegate>
{
    LxmRegisterCellView * _nameView;
    LxmRegisterCellView * _codeView;
    LxmRegisterCellView * _passwordView;
    NSTimer * _timer;
    int _time;
    UIButton * _codeBtn;
    
    UILabel * _numLab;
    NSNumber * _type;
    
}
@end

@implementation LxmRegisterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    _nameView = [[LxmRegisterCellView alloc] initWithFrame:CGRectMake(0, 5, ScreenW, 50)];
    _nameView.backgroundColor = [UIColor whiteColor];
    _nameView.imgView.image = [UIImage imageNamed:@"ico_dengzhu_2"];
    _nameView.rightTF.placeholder = @"请输入用户名";
    _nameView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    _nameView.rightTF.text = self.phone;
    [self.tableView addSubview:_nameView];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-155-5, 15, 150, 20)];
    _numLab = lab;
    lab.textAlignment = NSTextAlignmentRight;
    lab.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"更改手机只能2次" attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [attStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, 1)];
    lab.attributedText = attStr;
    [_nameView addSubview:lab];
    
    
    
    _codeView = [[LxmRegisterCellView alloc] initWithFrame:CGRectMake(0, 55.5, ScreenW, 50)];
    _codeView.backgroundColor = [UIColor whiteColor];
    _codeView.imgView.image = [UIImage imageNamed:@"ico_dengzhu_3"];
    _codeView.rightTF.placeholder = @"请输入验证码";
    [self.tableView addSubview:_codeView];
    
    _codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-105, 0, 105, 50)];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_codeBtn setTitleColor:BlueColor forState:UIControlStateNormal];
     [_codeBtn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [_codeView addSubview:_codeBtn];
    
    
    _passwordView = [[LxmRegisterCellView alloc] initWithFrame:CGRectMake(0, 106, ScreenW, 50)];
    _passwordView.backgroundColor = [UIColor whiteColor];
    _passwordView.imgView.image = [UIImage imageNamed:@"ico_dengzhu_1"];
    _passwordView.rightTF.placeholder = @"请输入密码";
    _passwordView.rightTF.secureTextEntry = YES;
    [self.tableView addSubview:_passwordView];
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0,170, ScreenW, 64)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView1];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    btn.tag = 101;
    
    [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:btn];
    
    
    
    if ([self.str isEqualToString:@"1"]) {
        //注册页
        self.navigationItem.title = @"注册";
        _nameView.rightTF.frame = CGRectMake(55, 15, ScreenW-60, 20);
        _numLab.frame = CGRectZero;
        _type = @1;
        [btn setTitle:@"完成" forState:UIControlStateNormal];

    } else if ([self.str isEqualToString:@"2"]){
        //忘记密码
        self.navigationItem.title = @"找回密码";
        _nameView.rightTF.frame = CGRectMake(55, 15, ScreenW-60, 20);
        _numLab.frame = CGRectZero;
        _type = @2;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        //更改手机
        self.navigationItem.title = @"更改手机";
        _nameView.rightTF.frame = CGRectMake(55, 15, ScreenW-60-150, 20);
        _numLab.frame = CGRectMake(ScreenW-155, 15, 150, 20);
        _type = @3;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [self.view layoutIfNeeded];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
    }
    
    
}
-(void)btnCLick:(UIButton *)btn
{
    if (btn == _codeBtn){
        //获取验证码
        if (_nameView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请先输入手机号"];
            return;
        }
        if (_nameView.rightTF.text.length!=11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:_nameView.rightTF.text forKey:@"phone"];
        [dict setObject:_type forKey:@"type"];
        if ([LxmTool ShareTool].session_token) {
            [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
        }
        [SVProgressHUD show];
        btn.userInteractionEnabled = NO;
        [LxmNetworking networkingPOST:[LxmURLDefine getCode] parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
             btn.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"key"] intValue] != 1&&[[responseObject objectForKey:@"key"] intValue] != 10002) {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            } else if ([[responseObject objectForKey:@"key"] intValue] == 10002) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号已经存在，请直接登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LxmRealLoginVC * vc = [[LxmRealLoginVC alloc] init];
                    vc.phone =_nameView.rightTF.text;
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [UIAlertController showAlertWithmessage:@"验证码发送成功，请注意查收!" atVC:self];
                [_timer invalidate];
                _timer=nil;
                _time=60;
                _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            btn.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
        
    }
    else {
        //完成注册
        if (_nameView.rightTF.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        if (_codeView.rightTF.text.length < 1){
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        if (_passwordView.rightTF.text.length < 6 || _passwordView.rightTF.text.length > 15){
            [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
            return;
        }
        if (_passwordView.rightTF.text.isContrainsKong) {
            [SVProgressHUD showErrorWithStatus:@"不能输入带有空格的密码!"];
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_nameView.rightTF.text forKey:@"phone"];
        [dict setObject:[NSString stringToMD5:_passwordView.rightTF.text] forKey:@"password"];
        [dict setObject:_codeView.rightTF.text forKey:@"verificationCode"];
        
        NSString * str = nil;
        if ([_type intValue] == 1) {
            str = [LxmURLDefine getRegisterURL];
        }else if ([_type intValue] == 2){
            str = [LxmURLDefine getpassWordURL];
        }else{
            str = [LxmURLDefine getModifyPhoneURL];
            [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
        }
        btn.userInteractionEnabled = NO;
        [SVProgressHUD show];
        [LxmNetworking networkingGET:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            btn.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"key"] intValue] != 1)
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            }else{
                if ([_type intValue] == 1) {
                    //注册
                    [LxmTool ShareTool].hasPerfect = @"1";
                    [LxmTool ShareTool].isLogin = YES;
                    [LxmTool ShareTool].session_token = [[responseObject objectForKey:@"result"] objectForKey:@"token"];
                    
                    LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                    vc.isAddSubDevice = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([_type intValue]==2){
                    //忘记密码
                    [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    //更改手机 更改成功
                    [SVProgressHUD showSuccessWithStatus:@"手机号更改成功"];
                    [LxmTool ShareTool].session_token = nil;
                    [LxmTool ShareTool].isLogin = NO;
                    
                    [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    
               
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            btn.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }];
        
    }
    
}

-(void)onTimer1
{
    _codeBtn.enabled = NO;
    [_codeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",_time--] forState:UIControlStateDisabled];
    if (_time<0)
    {
        [_timer invalidate];
        _timer=nil;
        _codeBtn.enabled=YES;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
}

//点击后退
- (void)cancelAction:(UIButton *)button {
    

    if ([self.str isEqualToString:@"3"])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return [self gestureRecognizerShouldBegin];;
    
}
- (BOOL)gestureRecognizerShouldBegin {
    
    NSLog(@"~~~~~~~~~~~%@控制器 滑动返回~~~~~~~~~~~~~~~~~~~",[self class]);
    
    return YES;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
