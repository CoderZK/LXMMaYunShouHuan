//
//  LxmConnectedVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmConnectedVC.h"
#import "LxmConnectedCell.h"
#import "LxmSubConnectedCell.h"
#import "LxmDeviceInfoVC.h"
#import "LxmSearchDeviceVC.h"
#import "LxmJiaZhangModel.h"

#import "LxmBLEManager.h"


@interface LxmConnectedVC ()<UIGestureRecognizerDelegate>
{
    NSInteger _page;
    NSMutableArray * _dataArr;
    LxmDeviceModel * _mainDeviceModel;
    
     NSMutableArray * _tempDataArr;
}
@end

@implementation LxmConnectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已绑定设备";
    _page = 1;
    _dataArr = [NSMutableArray array];
    
    _tempDataArr = [NSMutableArray array];
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [rightbtn addTarget:self action:@selector(rightbarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn setTitle:@"添加设备" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",LxmBLEManager.shareManager.deviceList);
    [super viewWillAppear:animated];
    _page = 1;
    [self loadData];
}

- (void)loadData
{
    NSString * str = [LxmURLDefine getBandDeviceListURL];
    NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,@"pageNum":@(_page)};
     [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            
            if (_page == 1) {
                [_dataArr removeAllObjects];
                [_tempDataArr removeAllObjects];
            }
            
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            
            
            
            for (NSDictionary * dict in arr) {
                LxmDeviceModel * deviceModel = [LxmDeviceModel mj_objectWithKeyValues:dict];
                [_tempDataArr addObject:deviceModel];
                if ([deviceModel.type intValue] == 1) {
                    _mainDeviceModel = deviceModel;
                }else
                {
                     [_dataArr addObject:deviceModel];
                }
            }
          
            _page++;
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

-(void)rightbarBtnClick
{
    LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] init];
    vc.yibingdangArr = _tempDataArr;
    vc.isAddSubDevice = YES;
    vc.parentId = _mainDeviceModel.equId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LxmConnectedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmConnectedCell"];
        if (!cell)
        {
            cell = [[LxmConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmConnectedCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_img_URL,_mainDeviceModel.equHead]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
        cell.titleLab.text = _mainDeviceModel.equNickname;
        cell.phoneLab.text = _mainDeviceModel.tel;
        return cell;
    }
 
   LxmSubConnectedCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"LxmSubConnectedCell"];
   if (!cell1) {
       cell1 = [[LxmSubConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubConnectedCell"];
    }
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    LxmDeviceModel * model = [_dataArr objectAtIndex:indexPath.row];
     [cell1.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_img_URL,model.equHead]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
    cell1.subLab.text = model.equNickname;
   return cell1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
    }
    view.contentView.backgroundColor = self.tableView.backgroundColor;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //主机
        LxmDeviceInfoVC * vc = [[LxmDeviceInfoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.role = @"主机";
        vc.userEquId = _mainDeviceModel.userEquId;
        vc.tongxunID = _mainDeviceModel.communication;
        vc.equHead = _mainDeviceModel.equHead;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        LxmDeviceModel * model = [_dataArr objectAtIndex:indexPath.row];
        LxmDeviceInfoVC * vc = [[LxmDeviceInfoVC alloc] initWithTableViewStyle:UITableViewStylePlain];
        vc.role = @"子机";
        vc.mainModel = _mainDeviceModel;
        vc.userEquId = model.userEquId;
        vc.tongxunID = model.communication;
        vc.equHead = model.equHead;
        vc.distance = model.safeDistance;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return [self gestureRecognizerShouldBegin];;
    
}
- (BOOL)gestureRecognizerShouldBegin {
    
    NSLog(@"~~~~~~~~~~~%@控制器 滑动返回~~~~~~~~~~~~~~~~~~~",[self class]);
    
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
