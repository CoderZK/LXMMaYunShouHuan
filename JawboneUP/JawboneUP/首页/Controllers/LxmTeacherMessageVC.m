//
//  LxmTeacherMessageVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTeacherMessageVC.h"
#import "LxmMessageVC.h"
#import "LxmTopView.h"

@interface LxmTeacherMessageVC ()<LxmTopViewDelegate>
{
    LxmTopView *_topView;
    UIScrollView *_scrollView;
    LxmMessageVC * _notifyVC;
    LxmMessageVC * _lxmMessageVC;
}
@end

@implementation LxmTeacherMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    _topView = [[LxmTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) withTitleArr:@[@"通知",@"消息"]];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, self.view.bounds.size.width, self.view.bounds.size.height-41)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*2.0, 0);
    [self.view addSubview:_scrollView];
    
    
    _notifyVC = [[LxmMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    _notifyVC.type = LxmMessageVC_type_notify;
    _notifyVC.view.frame = _scrollView.bounds;
    _notifyVC.isDoubleVC = YES;
    _notifyVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_scrollView addSubview:_notifyVC.view];
    _notifyVC.preVC = self;
    [_scrollView addSubview:_notifyVC.view];
    [self addChildViewController:_notifyVC];
    
    
    _lxmMessageVC = [[LxmMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    _lxmMessageVC.view.frame = CGRectMake(_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    _lxmMessageVC.type = LxmMessageVC_type_message;
    _lxmMessageVC.isDoubleVC = YES;
    _lxmMessageVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _lxmMessageVC.preVC = self;
    [_scrollView addSubview:_lxmMessageVC.view];
    [self addChildViewController:_lxmMessageVC];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [_topView LxmTopViewWithTag:toN];
    }
}
-(void)LxmTopView:(LxmTopView *)view btnAtIndex:(NSInteger)index
{
     [_scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
