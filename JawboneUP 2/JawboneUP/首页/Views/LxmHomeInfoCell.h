//
//  LxmHomeInfoCell.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/26.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxmJiaZhangModel.h"

@interface LxmHomeInfoCell : UITableViewCell
@property (nonatomic,strong)UILabel * nameLab;
@property (nonatomic,strong)UILabel * dianliangLab;
@property (nonatomic,strong)UILabel * locationLab;


@property (nonatomic, strong) LxmDeviceModel *dataModel;

@end
