//
//  LxmStyleSelectView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/25.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmStyleSelectView.h"
#import "LxmStyleSelectCell.h"

@interface LxmStyleSelectView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation LxmStyleSelectView

-(instancetype)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:self.bounds];
        [btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.backgroundColor=[UIColor clearColor];
        
      
        _contentView=[[UIView alloc] init];
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = CharacterGrayColor.CGColor;
        _contentView.backgroundColor=[UIColor whiteColor];
        
        
        [self addSubview:_contentView];
        [self initTableView];
        
    }
    return self;
}
-(void)initTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-125, 44*7)];
//    _tableView.autoresizingMask  =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_contentView addSubview:_tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LxmStyleSelectCell * cell =[tableView dequeueReusableCellWithIdentifier:@"LxmStyleSelectCell"];
    if (!cell)
    {
        cell=[[LxmStyleSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmStyleSelectCell"];
    }
    
    if (indexPath.row == 0)
    {
        cell.titleLab.text = @"都不报警";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 1)
    {
        cell.titleLab.text = @"声音";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 2)
    {
        cell.titleLab.text = @"光";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 3)
    {
        cell.titleLab.text = @"震动";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 4)
    {
        cell.titleLab.text = @"声音和光";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 5)
    {
        cell.titleLab.text = @"声音和震动";
        cell.lineView.hidden = NO;
    }
    else if (indexPath.row == 6)
    {
        cell.titleLab.text = @"光和震动";
        cell.lineView.hidden = NO;
    }
    else
    {
        cell.titleLab.text = @"声音，光，震动";
        cell.lineView.hidden = YES;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmStyleSelectCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(LxmStyleSelectView:text:index:)])
    {
        [self.delegate LxmStyleSelectView:self text:cell.titleLab.text index:indexPath.row];
    }
    
}

-(void)show
{
    if ([self.str isEqualToString:@"1"]) {
        _contentView.frame = CGRectMake(110, 301+64, ScreenW-110-10, 44*7);
    }
     else if ([self.str isEqualToString:@"3"])
     {
         _contentView.frame = CGRectMake(110, 200+64, ScreenW-110-10, 44*7);
     }
     else if ([self.str isEqualToString:@"4"])
     {
         _contentView.frame = CGRectMake(110, 180+64-20, ScreenW-110-10, 44*7);
     }
    else if ([self.str isEqualToString:@"2"])
    {
        _contentView.frame = CGRectMake(110, 145+151+64, ScreenW-110-10, 44*7);
    }
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    _contentView.hidden = YES;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _contentView.hidden = NO;
        
    } completion:nil];
    
}
-(void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        _contentView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)closeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(LxmStyleSelectViewWillDismiss:)]) {
        [self.delegate LxmStyleSelectViewWillDismiss:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
