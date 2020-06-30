//
//  LxmMessageVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum{
    LxmMessageVC_type_message,
    LxmMessageVC_type_notify
} LxmMessageVC_type;

@interface LxmMessageVC : BaseTableViewController
@property(nonatomic,weak)UIViewController * preVC;
-(instancetype)initWithType:(LxmMessageVC_type)type;
@property(nonatomic,assign)LxmMessageVC_type type;

@property(nonatomic,assign)BOOL isDoubleVC;

@end
