//
//  LxmDeviceInfoVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmDeviceInfoVC : BaseTableViewController
@property (nonatomic,strong)NSString * role;
@property (nonatomic,strong)NSString * userEquId;
@property (nonatomic,strong)NSString * tongxunID;
@property (nonatomic,strong)NSString * equHead;
@property (nonatomic,strong)NSString * distance;

@property (nonatomic, strong) LxmDeviceModel *mainModel;//主设备
@end
