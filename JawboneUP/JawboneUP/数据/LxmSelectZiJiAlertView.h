//
//  LxmSelectZiJiAlertView.h
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmSelectZiJiCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface LxmSelectZiJiAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^didSelectSubDeviceClick)(LxmDeviceModel *device);

@property (nonatomic, strong) NSArray<LxmDeviceModel *> *deviceArr;

@property (nonatomic, strong) NSNumber *type;//1距离 2计步

@end


