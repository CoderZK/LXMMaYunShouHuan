//
//  LxmMySettingVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmMySettingVC.h"

#import "LxmConnectedVC.h"
#import "LxmRegisterVC.h"
#import "LxmSystemSettingVC.h"
#import "LxmTeacherInfoVC.h"
#import "LxmParentInfoVC.h"

#import "lxmHomeModel.h"

@interface LxmMySettingVC ()
{
    UIImageView * _imgView;
    UILabel * _nameLab;
    NSNumber * _type;
}
@end

@implementation LxmMySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 160)];
    self.tableView.tableHeaderView = bgView;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    headerView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:headerView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-40, 35, 80, 80)];
    _imgView = imgView;
    _imgView.layer.cornerRadius = 40;
    _imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"touxiang_moren"];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touxiangBtnClick)];
    [imgView addGestureRecognizer:tapGesturRecognizer];
    [headerView addSubview:imgView];
    
    UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, ScreenW-30, 20)];
    _nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = CharacterDarkColor;
    [headerView addSubview:nameLab];
    [self loadData];
    WeakObj(self);
    [LxmEventBus registerEvent:@"modifyUserInfoSuccess" block:^(id data) {
        [selfWeak loadData];
    }];
}


- (void)loadData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getSettingInfoURL] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            LxmHomeModel *model = [LxmHomeModel mj_objectWithKeyValues:responseObject[@"result"]];
            NSString * str = [Base_img_URL stringByAppendingString:model.headimg];
            NSURL * url = [NSURL URLWithString:str];
            [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
            _nameLab.text = [NSString stringWithFormat:@"%@",model.realname];
            _type = @(model.type.integerValue);
            
            NSString *push = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"is_push"]];
            switch (push.integerValue) {
                case 1:
                    [LxmTool ShareTool].isClosePush = NO;
                    break;
                case 2:
                     [LxmTool ShareTool].isClosePush = YES;
                    break;
                default:
                    break;
            }
            //323a81108895ed1f335a5b6dcdd0cf4c3ac75c1c
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)touxiangBtnClick {
    
    if ([_type intValue] == 1) {
        //老师
        LxmTeacherInfoVC * vc = [[LxmTeacherInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isModify = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //家长
        LxmParentInfoVC * vc = [[LxmParentInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isModify = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"shebei_1"];
        cell.textLabel.text = @"连接设备";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"shebei_2"];
        cell.textLabel.text = @"更改手机";
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_shezhi"];
        cell.textLabel.text = @"系统设置";
    }
    cell.clipsToBounds = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 0;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //连接设备
        LxmConnectedVC * vc = [[LxmConnectedVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = _type;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        //更改手机
        LxmRegisterVC * vc = [[LxmRegisterVC alloc] init];
        vc.str = @"3";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        //系统设置
        LxmSystemSettingVC * vc = [[LxmSystemSettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
