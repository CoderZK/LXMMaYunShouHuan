//
//  LxmSubMybabyCell.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmSubMybabyCellDelegate;
@interface LxmSubMybabyCell : UITableViewCell
@property (nonatomic,strong)UIImageView * headerImgView;
@property (nonatomic,weak)id<LxmSubMybabyCellDelegate>delegate;
@property (nonatomic,strong)UILabel * nameLab;
@property (nonatomic,strong)UILabel * phoneLab;

@end

@protocol LxmSubMybabyCellDelegate <NSObject>
- (void)LxmSubMybabyCell:(LxmSubMybabyCell *)cell btnAtIndex:(NSInteger)index;
@end
