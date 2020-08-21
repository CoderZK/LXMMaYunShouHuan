//
//  LxmCalendarView.m
//  SuoPaiMIS
//
//  Created by 李晓满 on 2017/4/5.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmCalendarView.h"
#import "XMCalendarView.h"
#import "XMCalendarCell.h"
#import "XMCalendarDataSource.h"
#import "XMCalendarManager.h"

@interface LxmCalendarView ()<XMCalendarViewDelegate>
@property (nonatomic, strong) UIButton * btn;
@property(nonatomic,strong)XMCalendarView * calenderView;
@property(nonatomic,strong)UIView * bgView;
@end

@implementation LxmCalendarView

-(instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        
        _btn = [[UIButton alloc] initWithFrame:self.bounds];
        [_btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+50, ScreenW, ScreenH-64-50)];
        [self addSubview:_bgView];
        
        _calenderView = [[XMCalendarView alloc] initWithFrame:CGRectMake(0, 64+50, ScreenW , 400)];
        _calenderView.delegate = self;
        _calenderView.backgroundColor = [UIColor redColor];
        [self addSubview:_calenderView];
    }
    return self;
}
- (void)xmCalendarSelectDate:(NSDate *)date
{
    if ([self.delegate respondsToSelector:@selector(LxmCalendarView:data:)])
    {
        [self.delegate LxmCalendarView:self data:date];
    }
}
-(void)show
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.hidden = YES;
    _bgView.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.hidden = NO;
         _bgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:nil];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.hidden = YES;
        _bgView.backgroundColor=[UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)closeBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(LxmCalendarView:)])
    {
        [self.delegate LxmCalendarView:self];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(LxmCalendarView:)])
    {
        [self.delegate LxmCalendarView:self];
    }
}


@end
