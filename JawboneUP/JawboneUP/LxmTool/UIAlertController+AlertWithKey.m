//
//  UIAlertController+AlertWithKey.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "UIAlertController+AlertWithKey.h"
#import "UIViewController+TopVC.h"

@implementation UIAlertController (AlertWithKey)
+(void)showAlertWithKey:(NSNumber *)num  message:(NSString *)message atVC:(UIViewController *)vc
{
    int n = [num intValue];
    NSString * msg = nil;
    switch (n)
    {
        case 2:
            msg=@"服务器异常";
            break;
        case 3:
            msg=@"没有相关数据";
            break;
        case 4:
            msg=@"必要参数为空";
            break;
        case 5:
            msg=@"验签失败";
            break;
        case 6:
            msg=message;
            break;
        case 7:
            msg=@"用户未登录";
            break;
        case 10001:
            msg=@"账号不存在";
            break;
        case 10002:
            msg=@"账号已经存在";
            break;
        case 10003:
            msg=@"账号已退出";
            break;
        case 10004:
            msg=@"验证码不合法";
            break;
        case 10005:
            msg=@"手机号码不合法";
            break;
        case 10006:
            msg=@"账号或密码错误";
            break;
        case 10007:
            msg=@"更改手机号次数已满";
            break;
        case 20001:
            msg=@"号码当天发送短信超过限制";
            break;
        case 20002:
            msg=@"号码一分钟内发送次数超过限制";
            break;
        case 20003:
            msg=@"同一ip地址发送短信超过限制";
            break;
        case 30001 :
            msg=@"已绑定子机，该母机不可解绑";
            break;
        case 40001 :
            msg=@"姓名长度超出限制";
            break;
        case 40002:
            msg=@"地址长度超出限制";
            break;
        case 40003:
            msg=@"幼儿园长度超出限制";
            break;
        case 40004:
            msg=@"昵称长度超出限制";
            break;
        case 40005 :
            msg=@"内容长度超出限制";
            break;
        default:
            msg=message;
            break;
    }
    
    if (msg) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        if (vc) {
            if (vc == UIViewController.topViewController) {
                [UIViewController.topViewController presentViewController:alertController animated:YES completion:nil];
            }
        } else {
            [UIViewController.topViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

+ (void)showAlertWithmessage:(NSString *)message atVC:(UIViewController *)vc {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    if (vc) {
        if (vc == UIViewController.topViewController) {
            [UIViewController.topViewController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        [UIViewController.topViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
