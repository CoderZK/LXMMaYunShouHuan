//
//  LxmParentInfoVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmMySettingVC.h"

@interface LxmParentInfoVC : BaseTableViewController
@property (nonatomic,strong)NSString * identityId;
@property (nonatomic,assign)BOOL isModify;
@property (nonatomic,strong)LxmMySettingVC * preVC;
@end
