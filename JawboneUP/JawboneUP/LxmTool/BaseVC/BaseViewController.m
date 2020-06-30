//
//  BaseViewController.m
//  Lxm
//
//  Created by Lxm on 15/10/13.
//  Copyright © 2015年 Lxm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end
@implementation BaseViewController

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGGrayColor;
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
        leftItem.tintColor = UIColor.whiteColor;
        //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
}


- (void)baseLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] > 1) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        } else {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (BOOL)isConnectWork {
    NSString *netWorkState = [[AFNetworkReachabilityManager sharedManager] localizedNetworkReachabilityStatusString];
    if([netWorkState isEqualToString:@"Unknow"] || [netWorkState isEqualToString:@"Not Reachable"]) {// 未知 或 无网络
        return NO;
    } else {
        return YES;
    }
}

@end
