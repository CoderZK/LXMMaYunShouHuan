//
//  TabBarController.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/12.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "LxmHomeVC.h"
#import "LxmWeiTuoVC.h"
#import "LxmMySettingVC.h"
#import "LxmBLEManager.h"
//新出界面
#import "LxmNewHomeVC.h"
#import "LxmDataVC.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"bg_white"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    
    BOOL isTeacher = [LxmTool ShareTool].isTeacher;
    
    NSArray *imgArr=@[@"ico_shouye_2",@"ico_weituo_1",@"ico_shezhi_2"];
    NSArray *selectedImgArr=@[@"ico_shouye_1",@"ico_weituo_2",@"ico_shezhi_1"];
    
    NSArray *barTitleArr=@[@"首页",@"数据",@"设置"];
    
    
    NSArray *className=@[@"LxmNewHomeVC",@"LxmDataVC",@"LxmMySettingVC"];
    
    //        NSArray *className=@[@"LxmHomeVC",@"LxmWeiTuoVC",@"LxmMySettingVC"];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arr1 = [NSMutableArray array];
    
    for (int i = 0; i < className.count; i++) {
        NSString *str = [className objectAtIndex:i];
        BaseViewController *vc = [[NSClassFromString(str) alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        NSString *str1 = [imgArr objectAtIndex:i];
        
        //让图片保持原来的模样，未选中的图片
        vc.tabBarItem.image = [[UIImage imageNamed:str1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //图片选中时的图片
        NSString *str2 = [selectedImgArr objectAtIndex:i];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:str2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //页面的bar上面的title值
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BlueColor} forState:UIControlStateSelected];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:LineColor} forState:UIControlStateNormal];
        NSString *str3 = [barTitleArr objectAtIndex:i];
        vc.tabBarItem.title = str3;
        
        //给每个页面添加导航栏
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [arr addObject:nav];
        if (i == 0 || i == 3) {
            [arr1 addObject:nav];
        }
    }
    self.viewControllers = arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
