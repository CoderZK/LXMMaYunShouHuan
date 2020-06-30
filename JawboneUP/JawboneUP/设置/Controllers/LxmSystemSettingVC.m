//
//  LxmSystemSettingVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/2.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSystemSettingVC.h"
#import "LxmAdviceVC.h"
#import "LxmAboutUsVC.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"
#import "LxmLoginVC.h"
#import "BaseNavigationController.h"
#import "LxmConnectUSVC.h"

#import "LxmBLEManager.h"
#import "CBPeripheral+MAC.h"

@interface LxmSystemSettingVC ()<UIGestureRecognizerDelegate>
{
     CGFloat _cacheSize;
}
@end

@implementation LxmSystemSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统设置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0,270, ScreenW, 64)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView1];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    btn.tag = 101;
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exitCLick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:btn];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    _cacheSize = [NSFileManager getFileSizeForDir:path];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell2"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell2"];
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-116, 15, 100, 20)];
            lab.textAlignment = NSTextAlignmentRight;
            lab.textColor = CharacterDarkColor;
            lab.font = [UIFont systemFontOfSize:15];
            lab.tag = 107;
            [cell addSubview:lab];
        }
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.text = @"清理缓存";
        UILabel * lab1 = (UILabel *)[cell viewWithTag:107];
        lab1.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
        return cell;
        
    }else if (indexPath.row == 3){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell3"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell3"];
            UISwitch * switchbtn = [[UISwitch alloc] initWithFrame:CGRectMake(cell.bounds.size.width-61, cell.bounds.size.height*0.5-15, 61, 31)];
            switchbtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            switchbtn.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [switchbtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [switchbtn setOn:YES];
            switchbtn.tag = 1024;
            switchbtn.onTintColor = BlueColor;
            [cell addSubview:switchbtn];
        }
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.text = @"推送消息";
        UISwitch * swith = [cell viewWithTag:1024];
        swith.on = ![LxmTool ShareTool].isClosePush;
        return cell;
        
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
            UIImageView * aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 13, 24, 24)];
            aImgView.image = [UIImage imageNamed:@"ico_9"];
            aImgView.tag = 111;
            [cell addSubview:aImgView];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW, 0.5)];
            lineView.backgroundColor = self.tableView.backgroundColor;
            [cell addSubview:lineView];
            
        }
        UIImageView * icon = (UIImageView *)[cell viewWithTag:111];
        
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"联系我们";
                break;
            case 1:
                cell.textLabel.text = @"意见反馈";
                break;
            case 4:
                cell.textLabel.text = @"关于我们";
                break;
                
            default:
                break;
        }
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //联系我们
        LxmConnectUSVC * vc = [[LxmConnectUSVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row == 1){
        //意见反馈
        LxmAdviceVC * vc = [[LxmAdviceVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2) {
        if (_cacheSize>0)
        {
            NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            _cacheSize=0;
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"暂无缓存"];
        }
    }else if (indexPath.row == 3){
        //推送消息
    }else{
        //关于我们
        LxmAboutUsVC * vc = [[LxmAboutUsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)switchAction:(UISwitch *)switchBtn
{
    if (switchBtn.on)
    {
        NSLog(@"%@",@"接收推送 开");
        [LxmTool ShareTool].isClosePush = NO;
        
        NSData * deviceToken = [(AppDelegate *)[UIApplication sharedApplication].delegate pushToken];
        [UMessage registerDeviceToken:deviceToken];
       // 2.获取到deviceToken
        NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
       //3. 将deviceToken给后台
        NSLog(@"send_token:%@",token);
        [LxmTool ShareTool].deviceToken = token;
        [[LxmTool ShareTool] uploadDeviceToken];
    }
    else
    {
        NSLog(@"%@",@"关闭推送 关");
        [LxmTool ShareTool].isClosePush = YES;
        [UMessage registerDeviceToken:nil];
        [LxmTool ShareTool].deviceToken = @"";
        [[LxmTool ShareTool] uploadDeviceToken];
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)exitCLick
{
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //退出登录
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine getExitLoginURL] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"key"] intValue] == 10003) {
                
                for (CBPeripheral *p in LxmBLEManager.shareManager.deviceList) {
                    if (p.state == CBPeripheralStateConnected) {
                         [LxmBLEManager.shareManager disConnectPeripheral:p];
                    }
                }
            
                //跳转登录页
                [LxmTool ShareTool].session_token = nil;
                [LxmTool ShareTool].isLogin = NO;
                
                [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"meaasge"] atVC:self];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return [self gestureRecognizerShouldBegin];;
    
}
- (BOOL)gestureRecognizerShouldBegin {
    
    NSLog(@"~~~~~~~~~~~%@控制器 滑动返回~~~~~~~~~~~~~~~~~~~",[self class]);
    
    return YES;
    
}

@end
