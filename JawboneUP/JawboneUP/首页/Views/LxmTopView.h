//
//  LxmTopView.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmTopViewDelegate;
@interface LxmTopView : UIView
@property (nonatomic,assign)id<LxmTopViewDelegate>delegate;
-(void)LxmTopViewWithTag:(NSInteger)btnTag;
-(instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr;
@end
@protocol LxmTopViewDelegate <NSObject>

-(void)LxmTopView:(LxmTopView *)view btnAtIndex:(NSInteger)index;

@end
