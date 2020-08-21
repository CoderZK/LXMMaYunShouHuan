//
//  LxmModifyDeviceInforVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"

@interface LxmModifyDeviceInforVC : BaseTableViewController

@property(nonatomic,strong)LxmEquModel * model;

@property (nonatomic, strong) LxmDeviceModel *mainModel;

@property (nonatomic,strong)NSString * userEquId;
@property (nonatomic,strong)NSString * role;

@end
