//
//  LxmSelectCardView.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSelectCardView.h"
#import "LxmRoleModel.h"

@interface LxmSelectCardView()<UITableViewDelegate,UITableViewDataSource>
{
//    UIView * _contentView;
     NSArray *_dataArr;
     UITableView *_tableView;
}
@end

@implementation LxmSelectCardView

- (instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:self.bounds];
        [btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.backgroundColor=[UIColor clearColor];
        
        _dataArr = arr;
    
        _contentView =[[UIView alloc] initWithFrame:CGRectMake(15, 154, ScreenW-30, 44*_dataArr.count)];
        _contentView.layer.borderColor = LineColor.CGColor;
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.cornerRadius = 3;
        _contentView.clipsToBounds = YES;
//        _contentView.center=self.center;
//        _contentView.center=CGPointMake(ScreenW*0.5, ScreenH*0.5);
//        _contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _contentView.backgroundColor=[UIColor whiteColor];
        _contentView.layer.masksToBounds=YES;
        [self addSubview:_contentView];
        [self initTableView];
    }
    return self;
}
-(void)initTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, 44*_dataArr.count)];
    _tableView.autoresizingMask  =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_contentView addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _contentView.bounds.size.width, 0.5)];
        lineView.backgroundColor = LineColor;
        lineView.tag = 111;
        [cell addSubview:lineView];
    }
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    LxmRoleModel * model = [_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    UIView * lineView = [cell viewWithTag:111];
    lineView.hidden = indexPath.row == _dataArr.count-1;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(LxmSelectCardView:text:index:)])
    {
        [self.delegate LxmSelectCardView:self text:cell.textLabel.text index:indexPath.row];
    }
    
}
-(void)show
{
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
    if ([self.delegate respondsToSelector:@selector(LxmSelectCardViewWillDismiss:)]) {
        [self.delegate LxmSelectCardViewWillDismiss:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}




@end
