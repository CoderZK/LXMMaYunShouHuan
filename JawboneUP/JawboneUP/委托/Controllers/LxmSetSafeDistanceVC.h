//
//  LxmSetSafeDistanceVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/15.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmBLEManager.h"

@interface LxmSetSafeDistanceVC : BaseTableViewController
@property (nonatomic,strong)NSString * tongXinID;
@property (nonatomic,strong)NSNumber * userApplyId;
@property (nonatomic,strong)NSString * zhanshiStr;
@property (nonatomic,strong)CBPeripheral * p;
@end
