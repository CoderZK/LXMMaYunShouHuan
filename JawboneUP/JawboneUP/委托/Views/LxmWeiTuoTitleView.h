//
//  LxmWeiTuoTitleView.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmWeiTuoTitleViewDelegate;
@interface LxmWeiTuoTitleView : UIView

@property (nonatomic,assign)id<LxmWeiTuoTitleViewDelegate>delegate;
- (void)LxmLxmWeiTuoTitleViewWithTag:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame;
@end

@protocol LxmWeiTuoTitleViewDelegate <NSObject>

- (void)LxmWeiTuoTitleView:(LxmWeiTuoTitleView *)titleView btnAtIndex:(NSInteger)index;

@end
