//
//  LxmMessageVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmMessageVC.h"
#import "LxmMessageCell.h"
#import "LxmJiaZhangModel.h"
#import "LxmFriendRequestVC.h"
#import "LxmWeiTuoManageVC.h"
#import "LxmWeiTuoJieshouVC.h"
#import "LxmLocalDataManager.h"

@interface LxmMessageVC ()
{
    NSInteger _page;
    NSMutableArray * _msgDataArr;
}
@end

@implementation LxmMessageVC

-(instancetype)initWithType:(LxmMessageVC_type)type
{
    if (self=[super init])
    {
        _type = type;
    }
    return self;
}

- (void)haveNewMsg {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNewMsg) name:LxmLocalDataManagerNewMsgNotication object:nil];
    if (!self.isDoubleVC) {
        self.navigationItem.title = @"消息";
    }
    if (self.type == LxmMessageVC_type_notify) {
        _msgDataArr = [NSMutableArray array];
        _page = 1;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self loadData];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData];
        }];
        [self loadData];
    } else {

    }
}

- (void)loadData
{
    NSString * str = [LxmURLDefine getMsgListURL];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:@{@"token":[LxmTool ShareTool].session_token,@"pageNum":@(_page)} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            
            if (_page == 1) {
                [_msgDataArr removeAllObjects];
            }
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            for (NSDictionary * dict in arr) {
                
                lxmMessageModel * model = [lxmMessageModel mj_objectWithKeyValues:dict];
                [_msgDataArr addObject:model];
            }
            _page++;
            [self.tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == LxmMessageVC_type_notify)
    {
        return _msgDataArr.count;
    }else{
        return [LxmLocalDataManager shareManager].localMsgs.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LxmMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMessageCell"];
    if (!cell)
    {
        cell = [[LxmMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMessageCell"];
    }
    lxmMessageModel * model = nil;
    if (self.type == LxmMessageVC_type_notify) {
       model = [_msgDataArr objectAtIndex:indexPath.row];
        if ([model.type intValue] == 1||[model.type intValue] == 2||[model.type intValue] == 3||[model.type intValue] == 4) {
            cell.iconImgView.image = [UIImage imageNamed:@"xiaoxi_3"];
        }else{
            cell.iconImgView.image = [UIImage imageNamed:@"xiaoxi_4"];
        }
    }else if(self.type == LxmMessageVC_type_message){
        model = [[LxmLocalDataManager shareManager].localMsgs objectAtIndex:indexPath.row];
        if ([model.type intValue]== 1) {
            //电量提醒
            cell.iconImgView.image = [UIImage imageNamed:@"xiaoxi_1"];
        }else{
            //距离提醒
            cell.iconImgView.image = [UIImage imageNamed:@"xiaoxi_2"];
        }
    }
    CGFloat f = [model.title getSizeWithMaxSize:CGSizeMake(100, 999) withFontSize:16].width;
    cell.titleLab.frame = CGRectMake(85, 13, f, 20);
    cell.timeLab.frame = CGRectMake(90+f, 13, ScreenW-90-f-15, 20);
    cell.titleLab.text = model.title;
    cell.detailLab.text = model.content;
    cell.timeLab.text = model.createTime;
    if ([model.isRead intValue] == 1) {
        //已读
        cell.backgroundColor = [LineColor colorWithAlphaComponent:0.1];
    }else{
        //未读
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.type == LxmMessageVC_type_notify){
        //通知
       lxmMessageModel * model = [_msgDataArr objectAtIndex:indexPath.row];
        if ([model.type intValue] == 2||[model.type intValue] == 3||[model.type intValue] == 4||[model.type intValue] == 8) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            
            [self loadMsgInfoDataWithMsgID:@([model.msgId intValue])];
            [self setMessageReadWithMsgID:@([model.msgId intValue])index:indexPath.row withModel:model];
        }
        
    }else if(self.type == LxmMessageVC_type_message){
        //消息
        lxmMessageModel * model = [[LxmLocalDataManager shareManager].localMsgs objectAtIndex:indexPath.row];
        [[LxmLocalDataManager shareManager] readMsg:model];
        [self.tableView reloadData];
    }
}
- (void)setMessageReadWithMsgID:(NSNumber *)msgID index:(NSInteger)index withModel:(lxmMessageModel *)model{
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine setMsgReadURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"msgId":msgID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
            model.isRead = @1;
            [_msgDataArr replaceObjectAtIndex:index withObject:model];
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    if (self.type == LxmMessageVC_type_notify){
        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"您确定要删除这条消息吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertcontroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertcontroller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            lxmMessageModel * model = [_msgDataArr objectAtIndex:indexPath.row];
            [SVProgressHUD show];
            [LxmNetworking networkingPOST:[LxmURLDefine getDeleteMsgURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"msgId":@([model.msgId intValue])} success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [_msgDataArr removeObject:model];
                    [self.tableView reloadData];
                }else{
                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }]];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }else{
        lxmMessageModel * model = [[LxmLocalDataManager shareManager].localMsgs objectAtIndex:indexPath.row];
        [[LxmLocalDataManager shareManager] removeMsg:model];
        [self.tableView reloadData];
    }
   
}
- (void)loadMsgInfoDataWithMsgID:(NSNumber *)msgID{
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getMessageDetailURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"msgId":msgID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
            
            lxmMessageInforModel * model = [lxmMessageInforModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            if ([model.isEffective intValue] == 1) {
                switch ([model.type intValue]) {
                        case 1:
                        //好友申请
                    {
                        LxmFriendRequestVC * vc = [[LxmFriendRequestVC alloc] init];
                        vc.model = model;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        case 2:
                        //好友申请同意
                    {
                        
                    }
                        break;
                        case 3:
                        //好友申请拒绝
                    {
                        
                    }
                        break;
                        case 4:
                        //好友申请忽略
                    {
                        
                    }
                        break;
                        case 5:
                        //委托申请
                    {
                        LxmWeiTuoManageVC * vc = [[LxmWeiTuoManageVC alloc] init];
                        vc.model = model;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        case 6:
                        //委托申请接受
                    {
                        LxmWeiTuoJieshouVC * vc = [[LxmWeiTuoJieshouVC alloc] init];
                        vc.model = model;
                        vc.type = LxmWeiTuoJieshouVC_type_jieshou;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                        break;
                        case 7:
                        //委托申请拒绝
                    {
                        LxmWeiTuoJieshouVC * vc = [[LxmWeiTuoJieshouVC alloc] init];
                        vc.model = model;
                        vc.type = LxmWeiTuoJieshouVC_type_bujieshou;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        case 8:
                        //解除委托
                        break;
                    default:
                        break;
                }
            }
            else{
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此条消息已经过期" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"111");
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"12"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"12"];
    }return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"123"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"123"];
    }return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
