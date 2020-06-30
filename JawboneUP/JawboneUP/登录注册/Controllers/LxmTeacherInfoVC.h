//
//  LxmTeacherInfoVCViewController.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmMySettingVC.h"

@interface LxmTeacherInfoVC : BaseTableViewController
@property (nonatomic,assign)BOOL isModify;
@property (nonatomic,strong)LxmMySettingVC * preVC;
@end
