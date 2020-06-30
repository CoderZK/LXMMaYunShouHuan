//
//  LxmWeiTuoDetailVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/16.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoDetailVC.h"
#import "LxmWeiTuoDetailCell.h"
#import "LxmJiaZhangModel.h"
#import "LxmBLEManager.h"

@interface LxmWeiTuoDetailVC ()<LxmWeiTuoDetailCellDelegate>
{
    NSInteger _page;
    NSMutableArray * _motherDataArr;
    /*是否有数据*/
    UILabel * _isNoDataLB;
}
@end

@implementation LxmWeiTuoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"子机授权的母机列表";
    _page = 1;
    _motherDataArr = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self loadData];
    
    _isNoDataLB =[[UILabel alloc] initWithFrame:CGRectMake(0, ScreenH / 2.0-64 , ScreenW, 20)];
    _isNoDataLB.text = @"没有数据!";
    _isNoDataLB.font = [UIFont systemFontOfSize:16];
    _isNoDataLB.textAlignment = NSTextAlignmentCenter;
    _isNoDataLB.textColor = [UIColor blackColor];
    _isNoDataLB.hidden = YES;
    [self.tableView addSubview:_isNoDataLB];
}
- (void)loadData
{
    
    NSString * str = [LxmURLDefine getFindMotherEqulistURL];
    NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,@"pageNum":@(_page),@"equId":@([self.equId intValue])};
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (_page == 1) {
            [_motherDataArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            
            for (NSDictionary * dict in arr) {
                LxmWeiTuoModel  * deviceModel = [LxmWeiTuoModel mj_objectWithKeyValues:dict];
                [_motherDataArr addObject:deviceModel];
            }
            _page++;
            if(_motherDataArr.count == 0) {
                _isNoDataLB.hidden = NO;
            }else {
                _isNoDataLB.hidden = YES;
            }
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _motherDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LxmWeiTuoDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmWeiTuoDetailCell"];
    if (!cell)
    {
        cell = [[LxmWeiTuoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmWeiTuoDetailCell"];
    }
    LxmWeiTuoModel  * deviceModel = [_motherDataArr objectAtIndex:indexPath.row];
    cell.model = deviceModel;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)LxmWeiTuoDetailCell:(LxmWeiTuoDetailCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    LxmWeiTuoModel  * deviceModel = [_motherDataArr objectAtIndex:indexPath.row];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getClearEntrustURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"userEquId":deviceModel.userEquId} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"取消委托成功"];
            [_motherDataArr removeObject:deviceModel];
            if (_motherDataArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            }
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];

    
    
}

@end
