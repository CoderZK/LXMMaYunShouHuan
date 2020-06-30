//
//  LxmFriendVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmFriendVC.h"
#import "LxmSubOtherBabyCell.h"
#import "LxmJiaZhangModel.h"

@interface LxmFriendVC ()
{
    NSInteger _page;
    NSMutableArray * _dataArr;
    /*是否有数据*/
    UILabel * _isNoDataLB;
}
@end

@implementation LxmFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    _dataArr = [NSMutableArray array];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    _isNoDataLB =[[UILabel alloc] initWithFrame:CGRectMake(0, ScreenH / 2.0-64 , ScreenW, 20)];
    _isNoDataLB.text = @"没有数据!";
    _isNoDataLB.font = [UIFont systemFontOfSize:16];
    _isNoDataLB.textAlignment = NSTextAlignmentCenter;
    _isNoDataLB.textColor = [UIColor blackColor];
    _isNoDataLB.hidden = YES;
    [self.tableView addSubview:_isNoDataLB];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _page = 1;
    [self loadData];
}

-(void)loadData
{
    NSString * str = [LxmURLDefine getFindFriendListURL];
    NSDictionary *dic = @{@"token":[LxmTool ShareTool].session_token,
                           @"pageNum":@(_page)
                           };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            
            for (NSDictionary * dict in arr) {
                lxmFriendModel  * deviceModel = [lxmFriendModel mj_objectWithKeyValues:dict];
                [_dataArr addObject:deviceModel];
    
            }
            _page++;
            if(_dataArr.count == 0) {
                _isNoDataLB.hidden = NO;
            }else {
                _isNoDataLB.hidden = YES;
            }
            [self.tableView reloadData];
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LxmSubOtherBabyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubOtherBabyCell"];
    if (!cell)
    {
        cell = [[LxmSubOtherBabyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubOtherBabyCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lxmFriendModel * model = [_dataArr objectAtIndex:indexPath.section];
    [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:model.headimg]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
    cell.nameLab.text = model.realname;
    cell.phoneLab.text = model.tel;
    cell.foreverBtn.hidden = YES;
    cell.nameLab.frame = CGRectMake(115, 12, ScreenW-130, 20);
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"123"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"123"];
        }return headerView;
    }return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
