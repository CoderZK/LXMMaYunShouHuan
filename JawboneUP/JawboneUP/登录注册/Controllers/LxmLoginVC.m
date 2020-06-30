//
//  LxmLoginVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/12.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmLoginVC.h"
#import "LxmRealLoginVC.h"
#import "BaseNavigationController.h"
#import "LxmRegisterVC.h"
#import "TabBarController.h"

@interface LxmLoginVC ()

@end

@implementation LxmLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"bg_3"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgView];
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-120, self.view.bounds.size.width*0.5, 120)];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"登录" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.tag = 100;
    [self.view addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height-120, self.view.bounds.size.width*0.5, 120)];
    [rightBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.tag = 101;
    [self.view addSubview:rightBtn];
    
    UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5-1, self.view.bounds.size.height-120+50, 1, 20)];
    imgView1.image = [UIImage imageNamed:@"bg_2"];
    [self.view addSubview:imgView1];
}

- (void)leftBtnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {
        //跳转登录页
        LxmRealLoginVC * vc = [[LxmRealLoginVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        //跳转注册页面
        LxmRegisterVC * vc = [[LxmRegisterVC alloc] init];
        vc.str = @"1";
        [self.navigationController pushViewController:vc animated:YES];
//        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
    }
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
