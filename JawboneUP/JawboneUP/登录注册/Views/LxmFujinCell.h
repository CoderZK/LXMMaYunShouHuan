//
//  LxmFujinCell.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmFujinCellDelegate;
@interface LxmFujinCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel * uuidLabel;
@property(nonatomic,weak)id<LxmFujinCellDelegate>delegate;
@end

@protocol LxmFujinCellDelegate <NSObject>

-(void)LxmFujinCell:(LxmFujinCell *)cell btnAtIndex:(NSInteger)index;

@end
