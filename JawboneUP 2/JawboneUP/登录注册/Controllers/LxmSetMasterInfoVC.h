//
//  LxmSetMasterInfoVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/24.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"

@interface LxmSetMasterInfoVC : BaseTableViewController

@property (nonatomic, strong) CBPeripheral *p;
@property(nonatomic,strong)LxmJiaZhangModel * model;


@end
