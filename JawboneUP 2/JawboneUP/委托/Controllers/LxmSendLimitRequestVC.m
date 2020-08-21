//
//  LxmSendLimitRequestVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSendLimitRequestVC.h"
#import "LxmWeiTuoManageVC.h"
#import "LxmBLEManager.h"
#import "LxmSetSafeDistanceVC.h"

@interface LxmSendLimitRequestVC ()
{
    UIButton * _cancelBtn;
    UIButton * _sureBtn;
    UILabel * _infoLab;
}
@end

@implementation LxmSendLimitRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发送请求";
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 220)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-30, 20, 60, 60)];
    imgView.layer.cornerRadius = 30;
    imgView.layer.masksToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:self.model.headimg]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
    [headerView addSubview:imgView];
  
    _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, ScreenW-120, 40)];
    _infoLab.numberOfLines = 0;
    NSString * str = [NSString stringWithFormat:@"您已添加%@为好友，您是否要将子机%@%@给%@？",self.model.realname,self.childName,[self.authorizeType intValue]==1?@"限时委托":@"永久委托",self.model.realname];
    NSString * str1 = [NSString stringWithFormat:@"您已添加%@为好友，您是否要将子机",self.model.realname];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor}];
    [attStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(str1.length, self.childName.length)];
    _infoLab.attributedText = attStr;
    _infoLab.textColor = CharacterDarkColor;
    _infoLab.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:_infoLab];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-80, 160, 80, 40)];
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *strr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
    NSRange strRange = {0,[strr length]};
    [strr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [strr addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:strRange];
    [_cancelBtn setAttributedTitle:strr forState:UIControlStateNormal];
    [headerView addSubview:_cancelBtn];
    
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5, 160, 80, 40)];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sureBtn setTitleColor:BlueColor forState:UIControlStateSelected];
    NSMutableAttributedString *strr1 = [[NSMutableAttributedString alloc] initWithString:@"确认"];
    NSRange strRange1 = {0,[strr1 length]};
    [strr1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [strr1 addAttribute:NSForegroundColorAttributeName value:BlueColor range:strRange1];
    [_sureBtn setAttributedTitle:strr1 forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_sureBtn];
    
    
}

- (void)btnClick:(UIButton *)btn {
    if (btn==_cancelBtn) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        NSString * str = [LxmURLDefine getApplyEntrustURL];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        if (self.starStr&&self.endTimeStr) {
            [dict setObject:self.starStr forKey:@"startTime"];
            [dict setObject:self.endTimeStr forKey:@"endTime"];
        }
        
        [dict setObject:self.authorizeType forKey:@"authorizeType"];
        [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
        [dict setObject:self.model.userId forKey:@"otherUserId"];
        [dict setObject:@([self.equId integerValue]) forKey:@"equId"];
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"委托申请发送成功"];
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
        
  
        
    }
//    LxmWeiTuoManageVC * vc = [[LxmWeiTuoManageVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
