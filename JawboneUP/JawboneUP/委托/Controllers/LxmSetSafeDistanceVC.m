//
//  LxmSetSafeDistanceVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/15.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSetSafeDistanceVC.h"
#import "LxmBLEManager.h"
#import "LxmWeiTuoVC.h"

@interface LxmSetSafeDistanceVC ()
{
    UITextField * _tf;
    //api485@163.com Aa11223344
}
@end

@implementation LxmSetSafeDistanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置安全距离";
    
    UIView * headeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    headeView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:headeView];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW-30, 50)];
    titleLab.text = self.zhanshiStr;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = CharacterDarkColor;
    titleLab.numberOfLines = 0;
    [headeView addSubview:titleLab];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 0.5)];
    lineView.backgroundColor = LineColor;
    [headeView addSubview:lineView];
    
    
    UILabel* leftlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 50.5, 80, 49.5)];
    leftlab.text = @"安全距离";
    leftlab.textColor = CharacterDarkColor;
    leftlab.font = [UIFont systemFontOfSize:15];
    [headeView addSubview:leftlab];
    
    
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(95, 50.5, ScreenW-110, 49.5)];
    _tf.placeholder = @"请输入和主机的安全距离(1-300m)";
    _tf.font = [UIFont systemFontOfSize:15];
    _tf.textColor = CharacterDarkColor;
    [headeView addSubview:_tf];
    
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0,130, ScreenW, 64)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView1];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    btn.tag = 101;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:btn];
    
}

- (void)btnCLick
{
    if (_tf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入和主机的安全距离"];
        return;
    }
   
    [[LxmBLEManager shareManager] setDistance:self.p distance:[_tf.text intValue] completed:^(BOOL success, NSString *tips) {
        if (success) {
            
            NSString * str = [LxmURLDefine getApplyEntrustReplyURL];
            NSDictionary * dict = @{@"token":[LxmTool ShareTool].session_token,
                                    @"userApplyId":self.userApplyId,
                                    @"staute":@2,
                                    @"safeDistance":@([_tf.text intValue])};
             [SVProgressHUD show];
            [LxmNetworking networkingPOST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"您已经接受了委托"];
                    for (UIViewController * vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LxmWeiTuoVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }else{
                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 [SVProgressHUD dismiss];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"安全距离设置失败"];
        }
    }];
}

@end
