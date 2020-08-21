//
//  LxmSendLimitRequestVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmJiaZhangModel.h"
@interface LxmSendLimitRequestVC : BaseTableViewController
@property(nonatomic,strong)NSString * starStr;
@property(nonatomic,strong)NSString * endTimeStr;
@property (nonatomic,strong)NSString * equId;
@property (nonatomic,strong)NSString * childName;
@property (nonatomic,strong)NSString * friendName;
@property (nonatomic,strong)lxmFriendModel * model;
@property (nonatomic,strong)NSNumber * authorizeType;
@end
