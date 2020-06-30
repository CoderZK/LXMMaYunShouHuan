//
//  LxmSubDeviceListVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/3.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSubDeviceListVC.h"
#import "LxmSubMybabyCell.h"
#import "LxmSubOtherBabyCell.h"
#import "LxmlimitDelegateVC.h"
#import "LxmJiaZhangModel.h"
#import "LxmFindFriendVC.h"
#import "LxmWeiTuoDetailVC.h"


@interface LxmSubDeviceListVC ()<LxmSubMybabyCellDelegate>
{
    NSInteger _page;
    NSMutableArray * _meDataArr;
    NSMutableArray * _otherDataArr;
    /*是否有数据*/
    UILabel * _isNoDataLB;
}
@end

@implementation LxmSubDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _meDataArr = [NSMutableArray array];
    _otherDataArr = [NSMutableArray array];
    
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

- (void)loadData
{
    
    [SVProgressHUD show];
    NSString * str = [LxmURLDefine getuserFindChildEquListURL];
    NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,@"pageNum":@(_page)};
    
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {

            if (_page == 1) {
                [_meDataArr removeAllObjects];
                [_otherDataArr removeAllObjects];
            }
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            
            for (NSDictionary * dict in arr) {
                LxmWeiTuoModel  * deviceModel = [LxmWeiTuoModel mj_objectWithKeyValues:dict];
                if ([deviceModel.type intValue] == 1) {
                    //本人的孩子
                    [_meDataArr addObject:deviceModel];
                }else{
                    //别人委托给我的孩子
                    [_otherDataArr addObject:deviceModel];
                }
                
            }
            _page++;
            if(_meDataArr.count == 0&&_otherDataArr.count == 0) {
                _isNoDataLB.hidden = NO;
            }else {
                _isNoDataLB.hidden = YES;
            }
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _meDataArr.count;
    }
    return _otherDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LxmSubMybabyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubMybabyCell"];
        if (!cell)
        {
            cell = [[LxmSubMybabyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubMybabyCell"];
        }
        cell.delegate = self;
        LxmWeiTuoModel * model = [_meDataArr objectAtIndex:indexPath.row];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:model.headimg]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
        cell.nameLab.text = model.nickname;
        cell.phoneLab.text = model.tel;
        return cell;
    }else
    {
        LxmSubOtherBabyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubOtherBabyCell"];
        if (!cell)
        {
            cell = [[LxmSubOtherBabyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubOtherBabyCell"];
        }
        LxmWeiTuoModel * model = [_otherDataArr objectAtIndex:indexPath.row];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:model.headimg]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
        cell.nameLab.text = model.nickname;
        cell.phoneLab.text = model.tel;
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_meDataArr.count == 0) {
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        if (indexPath.section == 0) {
            LxmWeiTuoModel * model = [_meDataArr objectAtIndex:indexPath.row];
            LxmWeiTuoDetailVC * vc = [[LxmWeiTuoDetailVC alloc] init];
            vc.equId = model.equId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
}


#pragma index 110 限时委托 111 永久委托
- (void)LxmSubMybabyCell:(LxmSubMybabyCell *)cell btnAtIndex:(NSInteger)index
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        LxmWeiTuoModel * model = [_meDataArr objectAtIndex:indexPath.row];
        if (index == 110) {
            LxmlimitDelegateVC * vc = [[LxmlimitDelegateVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.equId = model.equId;
            vc.childName = model.nickname;
            [self.preVC.navigationController pushViewController:vc animated:YES];
        }else{
            LxmFindFriendVC * vc = [[LxmFindFriendVC alloc] init];
            vc.equId = model.equId;
            vc.childName = model.nickname;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
        LxmWeiTuoModel * model = [_otherDataArr objectAtIndex:indexPath.row];
        LxmFindFriendVC * vc = [[LxmFindFriendVC alloc] init];
        vc.equId = model.equId;
        vc.hidesBottomBarWhenPushed = YES;
        vc.childName = model.nickname;
        [self.navigationController pushViewController:vc animated:YES];
    }

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
    if (_meDataArr.count == 0) {
        return 0.1;
    }else{
        if (section == 0) {
            return 10;
        }
        return 0.1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
