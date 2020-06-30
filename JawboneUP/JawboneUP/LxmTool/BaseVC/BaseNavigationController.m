//
//  BaseNavigationController.m
//  Lxm_learnSny海食汇
//
//  Created by sny on 15/10/13.
//  Copyright © 2015年 cznuowang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTableViewController.h"

@implementation BaseNavigationController

-(void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图,把导航栏黑线去掉
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Lxm_navi"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    self.navigationBar.translucent = NO;
     [[UINavigationBar appearance] setTranslucent:NO];
   
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    //设置bar的title颜色
    self.navigationBar.titleTextAttributes = @{
                                    NSForegroundColorAttributeName:UIColor.whiteColor,
                                         NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                             };
    //设置bar的左右按钮颜色
    [self.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}




@end
