//
//  LxmSearchDeviceVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"

@interface LxmSearchDeviceVC : BaseTableViewController

@property(nonatomic,assign)BOOL isAddSubDevice;
@property(nonatomic,strong)LxmJiaZhangModel * model;


@property (nonatomic, strong) NSMutableArray *yibingdangArr;//已绑定设备列表

@property (nonatomic, strong) NSString *parentId;//母机设备id

@end


