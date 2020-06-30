//
//  LxmSelectCardView.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmSelectCardView;
@interface LxmSelectCardView : UIView

@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,assign)id<LxmSelectCardView>delegate;
- (instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr;
-(void)show;
-(void)dismiss;

@end
@protocol LxmSelectCardView <NSObject>
-(void)LxmSelectCardView:(LxmSelectCardView *)view text:(NSString *)text index:(NSInteger)index;
-(void)LxmSelectCardViewWillDismiss:(LxmSelectCardView *)view;
@end
