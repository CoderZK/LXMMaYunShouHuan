//
//  LxmWeiTuoManageVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoManageVC.h"
#import "LxmBLEManager.h"
#import "LxmSetSafeDistanceVC.h"
#import "LxmWeiTuoVC.h"
#import "LxmMessageVC.h"
#import "CBPeripheral+MAC.h"

@interface LxmWeiTuoManageVC ()

@end

@implementation LxmWeiTuoManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"委托管理";
    
    UIView * infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 50)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    UILabel * titlelab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenW-30, 20)];
    titlelab.numberOfLines = 0;
    titlelab.textColor = CharacterDarkColor;
    titlelab.font = [UIFont systemFontOfSize:15];
    [infoView addSubview:titlelab];
    
    NSString * str = [NSString stringWithFormat:@"%@已经将%@%@给您",self.model.otherUserName,self.model.nickname,[self.model.authorizeType intValue]==1?@"限时委托":@"永久委托"];
    CGFloat f = [str getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:15].height;
    infoView.frame = CGRectMake(0, 10, ScreenW, f+30);
    titlelab.frame = CGRectMake(15, 15, ScreenW-30, f);
    titlelab.text = str;
    
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+10, ScreenW, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-140, 7, 120, 36)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_bujies"] forState:UIControlStateNormal];
    leftBtn.tag = 11;
    [leftBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"不接受" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5+20, 7, 120, 36)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 12;
    [rightBtn setTitle:@"接受" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:rightBtn];
}

- (void)rightBtn:(UIButton *)btn
{
    if ([self.model.isEffective intValue] == 2) {
        [SVProgressHUD showErrorWithStatus:@"当前消息已经过期,不能进行操作"];
        return;
    }
    if (btn.tag == 11) {
        //不接受
        NSString * str = [LxmURLDefine getApplyEntrustReplyURL];
        NSDictionary * dict = @{@"token":[LxmTool ShareTool].session_token,
                                @"userApplyId":self.model.userApplyId,
                                @"staute":@3,
                                };
        [LxmNetworking networkingPOST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"您已经拒绝了委托"];
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LxmWeiTuoVC class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass:[LxmMessageVC class]]) {
                         [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        
    }else{
        //接受
//        self.model.identifier = @"39AA6282-776C-45C9-B65F-84F97F864CBB";
        CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:self.model.communication];
        CBPeripheral *master = LxmBLEManager.shareManager.master;
        if (master && p) {
            [LxmBLEManager.shareManager connectPeripheral:master completed:^(BOOL success, CBPeripheral *per) {
                if (success) {
                    [LxmBLEManager.shareManager connectPeripheral:p completed:^(BOOL success, CBPeripheral *per) {
                        if (success) {
                            [LxmBLEManager.shareManager addDevice:p deviceName:@"子1" toDevice:master completed:^(BOOL success, NSString *tips) {
                                if (success) {
                                    [LxmBLEManager.shareManager addDevice:master deviceName:@"母机" toDevice:p completed:^(BOOL success, NSString *tips) {
                                        if (success) {
                                            LxmSetSafeDistanceVC * vc = [[LxmSetSafeDistanceVC alloc] init];
                                            vc.zhanshiStr = [NSString stringWithFormat:@"%@已经将%@%@给您,请设置安全距离",self.model.otherUserName,self.model.nickname,[self.model.authorizeType intValue]==1?@"限时委托":@"永久委托"];
                                            vc.p = p;
                                            vc.tongXinID = self.model.communication;
                                            vc.userApplyId = self.model.userApplyId;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        } else {
                                            [SVProgressHUD showErrorWithStatus:@"添加失败"];
                                        }
                                    }];
                                } else {
                                    [SVProgressHUD showErrorWithStatus:@"添加失败"];
                                }
                            }];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"设备连接失败"];
                        }
                    }];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"设备连接失败"];
                }
            }];
        }
    }
}
@end
