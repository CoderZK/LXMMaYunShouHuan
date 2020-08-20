//
//  LxmSearchDeviceVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSearchDeviceVC.h"
#import "LxmFujinCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "TabBarController.h"
#import "LxmBLEManager.h"
#import "LxmSetMasterInfoVC.h"
#import "LxmSetSubInfoVC.h"
#import "CBPeripheral+MAC.h"
#import "LxmShengJiSheBeiVC.h"
@interface LxmSearchDeviceVC ()<LxmFujinCellDelegate>
{
    NSMutableArray<CBPeripheral *> *_mainPeripheralsArr;
    NSMutableArray<CBPeripheral *> *_subPeripheralsArr;
}
@end

@implementation LxmSearchDeviceVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索设备";
    
    _mainPeripheralsArr = [NSMutableArray array];
    _subPeripheralsArr = [NSMutableArray array];
    
    [self updateArr:[LxmBLEManager shareManager].deviceList];
    [self.tableView reloadData];
    __weak typeof(self) weak_self = self;
    [LxmEventBus registerEvent:@"deviceListChanged" block:^(id data) {
         [weak_self updateArr:[LxmBLEManager shareManager].deviceList];
    }];
    
    //扫描到需要升级的设备, 停止扫描并进行升级处理
    WeakObj(self);
    [LxmEventBus registerEvent:@"shengji" block:^(NSDictionary * dict) {
        [[LxmBLEManager shareManager] stopScan];
        LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dataDict = dict;
        [selfWeak.navigationController pushViewController:vc animated:YES];
        
    }];
    //升级成功之后,重新启动扫描
    [LxmEventBus registerEvent:@"sjcg" block:^(id data) {
        [[LxmBLEManager shareManager] startScan];
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//   [[LxmBLEManager shareManager] startScan];
    // 取消不必要的连接
    [LxmBLEManager.shareManager disConnectTempDeviceIfNeed];
    
}

- (void)updateArr:(NSArray *)arr {
    NSMutableArray *mainArr = [NSMutableArray array];
    NSMutableArray *subArr = [NSMutableArray array];
    [_mainPeripheralsArr removeAllObjects];
    [_subPeripheralsArr removeAllObjects];
    for (CBPeripheral *p in arr) {
        if (p.isMaster) {
            [mainArr addObject:p];
        } else {
            if (_yibingdangArr.count == 0) {
                 [subArr addObject:p];
            } else {
                BOOL isHave = NO;
                for (LxmDeviceModel *model in _yibingdangArr) {
                    if ([model.communication isEqualToString:p.tongxinId]) {
                        isHave = YES;
                        break;
                    }
                }
                if (!isHave) {
                    [subArr addObject:p];
                }
            }
           
        }
    }
    _mainPeripheralsArr = mainArr;
    _subPeripheralsArr = subArr;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isAddSubDevice ?  _subPeripheralsArr.count : _mainPeripheralsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmFujinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFujinCell"];
    if (!cell)
    {
        cell = [[LxmFujinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFujinCell"];
    }
    CBPeripheral *p = self.isAddSubDevice ? _subPeripheralsArr[indexPath.row] : _mainPeripheralsArr[indexPath.row];
    cell.uuidLabel.text = [NSString stringWithFormat:@"%@",p.name];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)LxmFujinCell:(LxmFujinCell *)cell btnAtIndex:(NSInteger)index {
    CBPeripheral *p = self.isAddSubDevice ? _subPeripheralsArr[index] : _mainPeripheralsArr[index];
    NSLog(@"%@",p);
    if (self.isAddSubDevice) { //添加子机
        [SVProgressHUD show];
        [[LxmBLEManager shareManager] connectPeripheral:p completed:^(
                                                                      BOOL success, CBPeripheral *per) {
            [SVProgressHUD dismiss];
            if (success) {
                [LxmNetworking networkingPOST:user_verifyChildEqu parameters:@{@"token" : LxmTool.ShareTool.session_token, @"communication":p.tongxinId} success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"key"] intValue] == 1) {
                        if ([responseObject[@"result"][@"isBind"] boolValue]) {
                            [UIAlertController showAlertWithmessage:@"该子机已经被其他主机绑定过!" atVC:self];
                        } else {
                            LxmSetSubInfoVC *vc = [[LxmSetSubInfoVC alloc] init];
                            vc.parentId = self.parentId;
                            vc.peripheral = p;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else {
                        [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
            }
        }];
    } else { //绑定母机
        NSLog(@"token:%@", LxmTool.ShareTool.session_token);
        [SVProgressHUD show];
        [[LxmBLEManager shareManager] connectPeripheral:p completed:^(BOOL success, CBPeripheral *per) {
            [SVProgressHUD dismiss];
            if (success) {
                LxmSetMasterInfoVC * vc = [[LxmSetMasterInfoVC alloc] init];
                vc.p = p;
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
            }
        }];
    }

}

@end
