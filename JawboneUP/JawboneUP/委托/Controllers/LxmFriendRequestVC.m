//
//  LxmFriendRequestVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmFriendRequestVC.h"
#import "LxmSendLimitRequestVC.h"
#import "LxmJiaZhangModel.h"

@interface LxmFriendRequestVC ()
{
    UIButton * _sureBtn;
    UIButton * _refuseBtn;
    UIButton * _ignoreBtn;
    
    NSMutableArray * _btnArr;
  
}
@end

@implementation LxmFriendRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"好友请求";
    _btnArr = [NSMutableArray array];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:self.model.otherUserHead]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
    imgView.layer.cornerRadius = 30;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"touxiang_2"];
    [headerView addSubview:imgView];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, ScreenW-90-10, 20)];
    infoLab.text = self.model.otherUserName;
    infoLab.textColor = CharacterDarkColor;
    infoLab.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:infoLab];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 40, 60, 40)];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sureBtn setTitleColor:BlueColor forState:UIControlStateSelected];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"确认"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:BlueColor range:strRange];
    [_sureBtn setAttributedTitle:str forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_sureBtn];
    [_btnArr addObject:_sureBtn];
    
    
    _refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 40, 60, 40)];
    _refuseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _refuseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"拒绝"];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [str1 addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:strRange1];
    [_refuseBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    [_refuseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_refuseBtn];
     [_btnArr addObject:_refuseBtn];
    
    
    _ignoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 40, 60, 40)];
    _ignoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"忽略"];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    [str2 addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:strRange2];
    [_ignoreBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    [_ignoreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_ignoreBtn];
    [_btnArr addObject:_ignoreBtn];
    
}


- (void)btnClick:(UIButton *)btn
{
    if ([self.model.isEffective intValue] == 2) {
        [SVProgressHUD showErrorWithStatus:@"当前消息已经过期,不能进行操作"];
        return;
    }
    for (UIButton * btnn in _btnArr) {
        if (btnn == btn) {
            btnn.selected = YES;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:btnn.titleLabel.text];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [str addAttribute:NSForegroundColorAttributeName value:BlueColor range:strRange];
            [btnn setAttributedTitle:str forState:UIControlStateNormal];
            
            NSString * str1 = [LxmURLDefine getApplyFriendReplyURL];
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
            [dict setObject:self.model.userApplyId forKey:@"userApplyId"];
            
            if (btnn == _sureBtn) {
                [dict setObject:@"2" forKey:@"staute"];
            }else if(btnn == _refuseBtn){
                [dict setObject:@"3" forKey:@"staute"];
            }else{
                [dict setObject:@"4" forKey:@"staute"];
            }
            
            [SVProgressHUD show];
            [LxmNetworking networkingPOST:str1 parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                 [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"请求发送成功"];
                }else{
                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        }else{
            btnn.selected = NO;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:btnn.titleLabel.text];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [str addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:strRange];
            [btnn setAttributedTitle:str forState:UIControlStateNormal];
        }
    }
    
}


@end
