//
//  LxmRegisterVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmRegisterVC : BaseTableViewController
/*
 判断是注册还是登录密码 注册 1 ，忘记密码 2；
 */
@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSString * phone;
@end
