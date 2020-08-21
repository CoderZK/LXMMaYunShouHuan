//
//  LxmTopView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTopView.h"

@interface LxmTopView()
{
    UIView *_lineView;
    NSMutableArray * _btnArr;
    NSArray * _array;
}
@end

@implementation LxmTopView
-(instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr
{
    if (self=[super initWithFrame:frame])
    {
        
        _array = titleArr;
        
        _btnArr = [NSMutableArray array];
        for (int i=0; i<titleArr.count; i++)
        {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/titleArr.count*i, 0, frame.size.width/titleArr.count,frame.size.height)];
            [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            btn.tag=i;
            [btn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
            [btn setTitleColor:BlueColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            [self addSubview:btn];
            [_btnArr addObject:btn];
            
            if (btn.tag==0)
            {
                btn.selected = YES;
                _lineView=[[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width*0.5-20, frame.size.height-1.5, 40, 2)];
                _lineView.backgroundColor=BlueColor;
                [self addSubview:_lineView];
            }
        }
    }
    return self;
}
-(void)LxmTopViewWithTag:(NSInteger)btnTag
{
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
        if (btn1.tag == btnTag)
        {
            btn1.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect=_lineView.frame;
                rect.origin.x= btn1.tag*btn1.frame.size.width+(btn1.frame.size.width*0.5-20);
                _lineView.frame=rect;
            }];
            
        }
        else
        {
            btn1.selected = NO;
        }
    }
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(LxmTopView:btnAtIndex:)])
    {
        [self.delegate LxmTopView:self btnAtIndex:btn.tag];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=_lineView.frame;
        rect.origin.x= btn.tag*btn.frame.size.width+(btn.frame.size.width*0.5-20);
        _lineView.frame=rect;
    }];
    
    
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
        if (btn1==btn)
        {
            btn1.selected = YES;
        }
        else
        {
            btn1.selected = NO;
        }
    }
    
    
}

@end
