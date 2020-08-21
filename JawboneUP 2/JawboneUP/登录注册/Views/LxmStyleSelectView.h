//
//  LxmStyleSelectView.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/25.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmStyleSelectView;
@interface LxmStyleSelectView : UIView
@property(nonatomic ,strong) UIView * contentView;
@property(nonatomic,assign)id<LxmStyleSelectView>delegate;

@property(nonatomic,strong)NSString * str;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)show;
-(void)dismiss;
@end
@protocol LxmStyleSelectView <NSObject>

-(void)LxmStyleSelectView:(LxmStyleSelectView *)view text:(NSString *)text index:(NSInteger)index;
-(void)LxmStyleSelectViewWillDismiss:(LxmStyleSelectView *)view;

@end
