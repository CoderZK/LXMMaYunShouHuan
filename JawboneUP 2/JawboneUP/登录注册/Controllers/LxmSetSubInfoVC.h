//
//  LxmSetSubInfoVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/19.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface LxmSetSubInfoVC : BaseTableViewController

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic,assign)BOOL issetting;

@property (nonatomic, strong) NSString *parentId;//母机设备id

@end
