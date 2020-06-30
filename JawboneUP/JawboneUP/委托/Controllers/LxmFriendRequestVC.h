//
//  LxmFriendRequestVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"

@interface LxmFriendRequestVC : BaseTableViewController
@property (nonatomic,strong)NSString * messageID;
@property (nonatomic,strong)lxmMessageInforModel * model;
@end
