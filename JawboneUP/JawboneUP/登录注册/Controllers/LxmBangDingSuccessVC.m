//
//  LxmBangDingSuccessVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/26.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmBangDingSuccessVC.h"
#import "TabBarController.h"
#import "LxmSearchDeviceVC.h"

@interface LxmBangDingSuccessVC ()

@end

@implementation LxmBangDingSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定安心圈手环";
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-50, ScreenH*0.5-200, 100, 100)];
    imgView.image = [UIImage imageNamed:@"bg_10"];
    [self.view addSubview:imgView];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW*0.5-150, CGRectGetMaxY(imgView.frame)+20, 300, 20)];
    lab.text = @"设备绑定成功";
    lab.textAlignment = 1;
    [self.view addSubview:lab];
    
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame)+10, ScreenW-30, 20)];
    lab1.text = @"开启您的智能手环之旅吧！";
    lab1.textAlignment = 1;
    [self.view addSubview:lab1];
    
    
    if ([self.deviceType isEqualToString:@"子机"]) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-150, CGRectGetMaxY(lab1.frame)+20, 300, 44)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100;
        [self.view addSubview:button];
    }else{
        UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5-170, CGRectGetMaxY(lab1.frame)+30, 150, 44)];
        [button1 setTitle:@"完成" forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
        button1.layer.cornerRadius = 10;
        button1.layer.masksToBounds = YES;
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 101;
        [self.view addSubview:button1];
        
        UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5+20, CGRectGetMaxY(lab1.frame)+30, 150, 44)];
        [button2 setBackgroundImage:[UIImage imageNamed:@"btn_jieshou"] forState:UIControlStateNormal];
        button2.layer.cornerRadius = 10;
        button2.layer.masksToBounds = YES;
        [button2 setTitle:@"添加子机" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 102;
        [self.view addSubview:button2];
    }
    
    
    
}

- (void)buttonClick:(UIButton *)btn {
    if (btn.tag == 100) {
        //子机

         TabBarController * bar = [[TabBarController alloc] init];
           self.view.window.rootViewController = bar;
    }
    
    else
    {
        //母机
        if (btn.tag == 101) {
                TabBarController * bar = [[TabBarController alloc] init];
                self.view.window.rootViewController = bar;
        }
        else
        {
            //添加子机
            //跳转添加扫描列表
            LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] init];
            vc.isAddSubDevice = YES;
            vc.parentId = self.parentId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

@end
