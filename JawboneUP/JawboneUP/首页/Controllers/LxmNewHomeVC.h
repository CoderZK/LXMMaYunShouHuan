//
//  LxmNewHomeVC.h
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
@interface LxmNewHomeVC : BaseTableViewController

@end

/**
 安全距离计步信息
 */
@interface LxmNewHomeView : UIView

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong)  UILabel *numLabel;//值

@property (nonatomic, strong) UIButton *setButton;//设定

@end

/**
 电量主机信息
 */
@interface LxmNewHomeCellTopView : UIView
@property (nonatomic, strong) LxmDeviceModel *deviceModel;//设备model
@end

/**
 安全距离计步信息
 */
@interface LxmNewHomeCellBottomView : UIView

@property (nonatomic, strong) LxmDeviceModel *mainModel;//主机设备model

@property (nonatomic, strong) LxmDeviceModel *deviceModel;//设备model
@end

/**
 主机
 */
@interface LxmNewHomeMineCell : UITableViewCell

@property (nonatomic, strong) LxmDeviceModel *deviceModel;//设备model

@end

/**
 子机
 */
@interface LxmNewHomeZiJiCell : UITableViewCell

@property (nonatomic, copy) void(^setSaftyDistanceBlock)(LxmDeviceModel *model);

@property (nonatomic, copy) void(^setRealOpenBlock)(LxmDeviceModel *model);

@property (nonatomic, strong) LxmDeviceModel *mainModel;//主机设备model

@property (nonatomic, strong) LxmDeviceModel *deviceModel;//设备model

@end
