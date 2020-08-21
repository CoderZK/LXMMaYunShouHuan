//
//  ZFGenericChart.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericChart.h"
#import "ZFColor.h"

@implementation ZFGenericChart

/**
 *  初始化变量
 */
- (void)commonInit{
    _isAnimated = YES;
    _isShadowForValueLabel = YES;
    _opacity = 1.f;
    _valueOnChartFont = [UIFont systemFontOfSize:10.f];
    _xLineNameLabelToXAxisLinePadding = 0.f;
    _valueLabelPattern = kPopoverLabelPatternPopover;
    
    _isShowAxisLineValue = YES;
    _isShowAxisArrows = YES;
    _numberOfDecimal = 1;
    _separateLineStyle = kLineStyleRealLine;
    _separateLineDashPhase = 0.f;
    _separateLineDashPattern = @[@(2), @(2)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    //标题Label
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, TOPIC_HEIGHT)];
    self.topicLabel.numberOfLines = 2;
    self.topicLabel.textColor = CharacterDarkColor;
    self.topicLabel.font = [UIFont systemFontOfSize:14.f];
    self.topicLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.topicLabel];
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.topicLabel.frame = CGRectMake(CGRectGetMinX(self.topicLabel.frame) + 15, CGRectGetMinY(self.topicLabel.frame), self.frame.size.width - 30, CGRectGetHeight(self.topicLabel.frame));
}

@end
