//
//  LxmWeiTuoTitleView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoTitleView.h"

@interface LxmWeiTuoTitleView ()
{
    UIView *_leftLinView;
    UIView *_rightLinView;
    NSMutableArray * _btnArr;
    UIButton * _leftBtn;
    UIButton * _rightBtn;
}
@end


@implementation LxmWeiTuoTitleView 

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _btnArr = [NSMutableArray array];
        
        UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW*0.5, 40)];
        _leftBtn = leftBtn;
        leftBtn.tag = 0;
        leftBtn.selected = YES;
        [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:BlueColor forState:UIControlStateSelected];
        [leftBtn setTitle:@"子机列表" forState:UIControlStateNormal];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:leftBtn];
        [_btnArr addObject:leftBtn];
        
        CGFloat f = [@"子机列表" getSizeWithMaxSize:CGSizeMake(ScreenW*0.5, 20) withFontSize:16].width;
        UIView * leftLinView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW*0.5*0.5-f*0.5, 35, f, 2)];
        _leftLinView = leftLinView;
        _leftLinView.hidden = NO;
        leftLinView.backgroundColor = BlueColor;
        [leftBtn addSubview:leftLinView];
        
        
        
        UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW*0.5, 0, ScreenW*0.5, 40)];
        [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = rightBtn;
        rightBtn.tag = 1;
        [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:BlueColor forState:UIControlStateSelected];
        [rightBtn setTitle:@"好友" forState:UIControlStateNormal];
        rightBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:rightBtn];
        [_btnArr addObject:rightBtn];
        
        CGFloat f1 = [@"好友" getSizeWithMaxSize:CGSizeMake(ScreenW*0.5, 20) withFontSize:16].width;
        UIView * rightLinView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW*0.5*0.5-f1*0.5, 35, f1, 2)];
        _rightLinView = rightLinView;
        _rightLinView.hidden = YES;
        rightLinView.backgroundColor = BlueColor;
        [rightBtn addSubview:rightLinView];
        
    }return self;
}


- (void)LxmLxmWeiTuoTitleViewWithTag:(NSInteger)index
{
    
    if ([self.delegate respondsToSelector:@selector(LxmWeiTuoTitleView:btnAtIndex:)])
    {
        [self.delegate LxmWeiTuoTitleView:self btnAtIndex:index];
    }
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
        if (btn1.tag == index)
        {
            btn1.selected = YES;
            if (btn1 == _leftBtn) {
                _leftLinView.hidden = NO;
                _rightLinView.hidden = YES;
            }
            else
            {
                _leftLinView.hidden = YES;
                _rightLinView.hidden = NO;
            }
            
        }
        else
        {
            btn1.selected = NO;
            if (btn1 == _leftBtn) {
                _leftLinView.hidden = YES;
                _rightLinView.hidden = NO;
            }
            else
            {
                _leftLinView.hidden = NO;
                _rightLinView.hidden = YES;
            }
        }
    }
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(LxmWeiTuoTitleView:btnAtIndex:)])
    {
        [self.delegate LxmWeiTuoTitleView:self btnAtIndex:btn.tag];
    }

    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
        if (btn1==btn)
        {
            btn1.selected = YES;
            if (btn1 == _leftBtn) {
                _leftLinView.hidden = NO;
                _rightLinView.hidden = YES;
            }
            else
            {
                _leftLinView.hidden = YES;
                _rightLinView.hidden = NO;
            }
        }
        else
        {
            btn1.selected = NO;
            if (btn1 == _leftBtn) {
                _leftLinView.hidden = YES;
                _rightLinView.hidden = NO;
            }
            else
            {
                _leftLinView.hidden = NO;
                _rightLinView.hidden = YES;
            }
        }
    }
    
    
}


@end
