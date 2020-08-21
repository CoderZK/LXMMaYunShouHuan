//
//  LxmWeiTuoDetailCell.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxmJiaZhangModel.h"
@protocol LxmWeiTuoDetailCellDelegate;
@interface LxmWeiTuoDetailCell : UITableViewCell
@property (nonatomic,strong)LxmWeiTuoModel *model;
@property (nonatomic,assign)id <LxmWeiTuoDetailCellDelegate>delegate;
@end

@protocol LxmWeiTuoDetailCellDelegate <NSObject>
- (void)LxmWeiTuoDetailCell:(LxmWeiTuoDetailCell *)cell;
@end
