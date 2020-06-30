//
//  LxmDataNavView.h
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmDataNavView : UIView

@property (nonatomic, strong) UIButton *backButton;//返回按钮

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *juliButton;

@property (nonatomic, strong) UIButton *jibuButton;

@property (nonatomic, strong) UIButton *rightButton;//导航栏右侧按钮

@property (nonatomic, copy) void(^didSelectButton)(BOOL isDistance);

@end


/**
 选择子机view
 */
@interface LxmDataSelectView : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

@end
