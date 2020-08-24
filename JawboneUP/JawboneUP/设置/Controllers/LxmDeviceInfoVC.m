//
//  LxmDeviceInfoVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmDeviceInfoVC.h"
#import "LxmModifyDeviceInforVC.h"
#import "LxmStyleSelectView.h"
#import "LxmJiaZhangModel.h"
#import "LxmBLEManager.h"
#import "LxmParentInfoVC.h"
#import "LxmSearchDeviceVC.h"
#import "AppDelegate.h"
#import "CBPeripheral+MAC.h"
#import "LxmEventBus.h"
#import "LxmShengJiSheBeiVC.h"
#import "BaseNavigationController.h"
#import "LxmLoginVC.h"


@interface LxmDeviceInfoVC ()<LxmStyleSelectView,DFUServiceDelegate,DFUProgressDelegate,LoggerDelegate>
{
    UILabel * _juliLab;
    UILabel * _styleLab;
    LxmStyleSelectView *_selectView;
    LxmEquModel * _deviceModel;
}
@end

@implementation LxmDeviceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设备信息";
    _selectView = [[LxmStyleSelectView alloc] initWithFrame:self.view.bounds];
    _selectView.str = @"4";
    _selectView.delegate = self;
    [self loadData];
}

- (void)loadData
{
    [SVProgressHUD show];
    NSNumber *type = @0;
    if ([self.role isEqualToString:@"主机"]){
        type = @1;
    } else {
        type = @2;
    }
    [LxmNetworking networkingPOST:[LxmURLDefine getOwerDeviceURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"userEquId":self.userEquId,@"type":type} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
            _deviceModel = [LxmEquModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            NSString * str = nil;
            switch ([_deviceModel.vibrationMode intValue]) {
                case 0:
                    str = @"无振动方式";
                    break;
                case 1:
                    str = @"声音";
                    break;
                case 2:
                    str = @"光";
                    break;
                case 3:
                    str = @"震动";
                    break;
                case 4:
                    str = @"声音和光";
                    break;
                case 5:
                    str = @"声音和震动";
                    break;
                case 6:
                    str = @"光和震动";
                    break;
                case 7:
                    str = @"声音、光、震动";
                    break;
                default:
                    break;
            }
            _styleLab.text =str;
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)LxmStyleSelectViewWillDismiss:(LxmStyleSelectView *)view {
    [view dismiss];
}

-(void)LxmStyleSelectView:(LxmStyleSelectView *)view text:(NSString *)text index:(NSInteger)index {
    //报警方式选择的代理
    [_selectView dismiss];
    [SVProgressHUD show];
    [[LxmBLEManager shareManager] setAlert:[LxmBLEManager.shareManager peripheralWithTongXinId:self.tongxunID] alertType:(int)index completed:^(BOOL success, NSString *tips) {
        [SVProgressHUD dismiss];
        if (success){
            [self setDeviceInfowithAlertType:(int)index];
        }else{
            [SVProgressHUD showErrorWithStatus:@"设置报警方式失败"];
        }
    }];
    [self.tableView reloadData];
}

- (void)setDeviceInfowithAlertType:(int)type {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
    
    [dict setObject:@(type) forKey:@"vibrationMode"];
    [dict setObject:self.userEquId forKey:@"userEquId"];
    if ([self.role isEqualToString:@"主机"]){
        [dict setObject:@1 forKey:@"type"];
    } else {
        [dict setObject:@2 forKey:@"type"];
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getModifyDeviceURL] parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
            [SVProgressHUD showSuccessWithStatus:@"报警方式设置成功"];
            NSString * str = @"";
            switch (type) {
                case 0:
                    str = @"无振动方式";
                    break;
                case 1:
                    str = @"声音";
                    break;
                case 2:
                    str = @"光";
                    break;
                case 3:
                    str = @"震动";
                    break;
                case 4:
                    str = @"声音和光";
                    break;
                case 5:
                    str = @"声音和震动";
                    break;
                case 6:
                    str = @"光和震动";
                    break;
                case 7:
                    str = @"声音、光、震动";
                    break;
                default:
                    break;
            }
            _styleLab.text =str;
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



-(void)setdistance:(NSString *)disatace {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
    [dict setObject:disatace forKey:@"safeDistance"];
    [dict setObject:self.userEquId forKey:@"userEquId"];
    if ([self.role isEqualToString:@"主机"]){
        [dict setObject:@1 forKey:@"type"];
    } else {
        [dict setObject:@2 forKey:@"type"];
    }
    [LxmNetworking networkingPOST:[LxmURLDefine getModifyDeviceURL] parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
            [SVProgressHUD showSuccessWithStatus:@"距离设置成功"];
            _juliLab.text = [NSString stringWithFormat:@"%@m",disatace];
            
        }else{
            
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.role isEqualToString:@"主机"]){
        return 2 + 1;
    }else{
        return 3 +1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.role isEqualToString:@"主机"]){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            UIImageView * AImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 13, 24, 24)];
            AImgView.image = [UIImage imageNamed:@"ico_9"];
            [cell addSubview:AImgView];
        }
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"shebei_1"];
            cell.textLabel.text = @"修改资料";
        } else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"shebei_2"];
            cell.textLabel.text = @"解除绑定";
        }else if (indexPath.row ==2) {
            cell.imageView.image = [UIImage imageNamed:@"shebei_2"];
            cell.textLabel.text = @"升级";
        }
        return cell;
    } else {
        if (indexPath.row == 0||indexPath.row == 1 || indexPath.row == 3) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                UIImageView * AImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 13, 24, 24)];
                AImgView.image = [UIImage imageNamed:@"ico_9"];
                [cell addSubview:AImgView];
            }
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"shebei_1"];
                cell.textLabel.text = @"修改资料";
            } else if (indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"shebei_2"];
                cell.textLabel.text = @"解除绑定";
            }else if (indexPath.row == 3) {
                cell.imageView.image = [UIImage imageNamed:@"shebei_2"];
                cell.textLabel.text = @"升级";
            }
            return cell;
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                
                UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, ScreenW-115-15-20, 20)];
                
                _juliLab = titleLab;
                titleLab.font = [UIFont systemFontOfSize:16];
                titleLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:titleLab];
                
                UIImageView * aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-15-20, 13, 24, 24)];
                aImgView.image = [UIImage imageNamed:@"ico_9"];
                [cell addSubview:aImgView];
                
            }
            cell.textLabel.text = @"安全距离";
            cell.imageView.image = [UIImage imageNamed:@"shebei_1"];
            _juliLab.text = [NSString stringWithFormat:@"%@m",self.distance];
            return cell;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.role isEqualToString:@"主机"]) {
        if (indexPath.row == 0) {
            //跳转主机修改资料页
            LxmModifyDeviceInforVC * vc = [[LxmModifyDeviceInforVC alloc] init];
            vc.model = _deviceModel;
            vc.userEquId = self.userEquId;
            vc.role = @"主机";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //解除绑定
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"是否解绑主机？" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [LxmNetworking networkingPOST:[Base_URL stringByAppendingString:@"user_clearOwerEqu.do"] parameters:@{@"token":[LxmTool ShareTool].session_token,@"userEquId":self.userEquId,@"communication":_deviceModel.communication} success:^(NSURLSessionDataTask *task, id responseObject) {
                    [SVProgressHUD dismiss];
                    if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                        [LxmBLEManager.shareManager disConnectPeripheral:[LxmBLEManager.shareManager peripheralWithTongXinId:_deviceModel.communication]];
                        
                        [LxmTool ShareTool].isLogin = NO;
                        LxmBLEManager.shareManager.masterTongXinId = nil;
                        
                        
                        LxmLoginVC *loginVC = [LxmLoginVC new];
                        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                        
                        LxmSearchDeviceVC * vc = [[LxmSearchDeviceVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                        [nav pushViewController:vc animated:YES];
                        
                    }else if ([[responseObject objectForKey:@"key"] integerValue] == 30001){
                        UIAlertController *controller2 = [UIAlertController alertControllerWithTitle:nil message:@"已绑定子机，该母机不可解绑" preferredStyle:UIAlertControllerStyleAlert];
                        [controller2 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:controller2 animated:YES completion:nil];
                    }else{
                        [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD dismiss];
                }];
                
                
            }]];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:controller1 animated:YES completion:nil];
            
        }else if (indexPath.row == 2){
            //升级操作
            self.tableView.userInteractionEnabled= NO;
            CBPeripheral * periPheral = [LxmBLEManager.shareManager peripheralWithTongXinId:self.tongxunID];
            
            [[LxmBLEManager shareManager] nowCheckPowerForPer:periPheral];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"%@",@"123456");
                
                if (periPheral.power.intValue < 5 && periPheral.power.intValue != 0) {
                    [SVProgressHUD showErrorWithStatus:@"升级必须电量大于5%"];
                    self.tableView.userInteractionEnabled= YES;
                    return;
                }else {
                    
                    [[LxmBLEManager shareManager] checkVersion:periPheral  completed:^(BOOL success, NSString *hVersion, NSString *fVersion) {
                        self.tableView.userInteractionEnabled= YES;
                        LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.type = @"1";
                        vc.noStr = hVersion;
                        vc.firmwareNo = fVersion;
                        vc.peripheral = periPheral;
                        vc.isZhengChang = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        self.tableView.userInteractionEnabled= YES;
                        
                        
                    }];
                }
                
                
            });
            
            
            
            
        }
    } else {
        if (indexPath.row == 0) {
            //跳转子机修改资料页
            LxmModifyDeviceInforVC * vc = [[LxmModifyDeviceInforVC alloc] init];
            vc.model = _deviceModel;
            vc.mainModel = _mainModel;
            vc.userEquId = self.userEquId;
            vc.role = @"子机";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //解除绑定
            if (!self.isConnectWork) {
                [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
                return;
            }
            CBPeripheral *master = LxmBLEManager.shareManager.master;
            CBPeripheral *subDevice = [LxmBLEManager.shareManager peripheralWithTongXinId:self.tongxunID];
            if (master.state != CBPeripheralStateConnected) {
                [SVProgressHUD showErrorWithStatus:@"当前主设备已断开连接!"];
                return;
            }
            if (subDevice.state != CBPeripheralStateConnected) {
                [SVProgressHUD showErrorWithStatus:@"当前要解绑的子机设备已断开连接!"];
                return;
            }
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"是否解绑子机？" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD show];
                // 1.从母机中删除子机
                [LxmBLEManager.shareManager delDevice:subDevice fromDevice:master completed:^(BOOL success, NSString *tips) {
                    // 1.从子机中删除母机
                    [LxmBLEManager.shareManager delDevice:master fromDevice:subDevice completed:^(BOOL success, NSString *tips) {
                        // 3.发通知更新子机列表
                        [LxmEventBus sendEvent:@"UpdateTongXinIdList" data:nil];
                        // 4.调用接口同步
                        [LxmNetworking networkingPOST:[Base_URL stringByAppendingString:@"user_clearOwerEqu.do"] parameters:@{@"token":[LxmTool ShareTool].session_token,@"userEquId":self.userEquId,@"communication":_deviceModel.communication} success:^(NSURLSessionDataTask *task, id responseObject) {
                            [SVProgressHUD dismiss];
                            if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                                [LxmBLEManager.shareManager disConnectPeripheral:[LxmBLEManager.shareManager peripheralWithTongXinId:_deviceModel.communication]];
                                LxmTool.ShareTool.isLogin = NO;
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
                                [LxmEventBus sendEvent:@"subdeviceBandSuccess" data:nil];
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [SVProgressHUD dismiss];
                        }];
                        
                        //                       [LxmBLEManager.shareManager addDevice:subDevice deviceName:_deviceModel.nickname toDevice:master completed:^(BOOL success, NSString *tips) {
                        //                       }];
                        
                    }];
                }];
            }]];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:controller1 animated:YES completion:nil];
            
        } else if (indexPath.row == 2){
            //安全距离设置
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"设置安全距离" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = @"请输入0m~50m之间的数值";
            }];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (!self.isConnectWork) {
                    [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
                    return;
                }
                UITextField *tf = controller1.textFields.firstObject;
                if (tf.text.intValue < 0 || tf.text.intValue > 50) {
                    [SVProgressHUD showErrorWithStatus:@"请输入0m~50m之间的数值!"];
                    return;
                }
                CBPeripheral *subDevice = [LxmBLEManager.shareManager peripheralWithTongXinId:self.tongxunID];
                if (subDevice.state != CBPeripheralStateConnected) {
                    [SVProgressHUD showErrorWithStatus:@"当前要解绑的子机设备已断开连接!"];
                    return;
                }
                [[LxmBLEManager shareManager] setDistance:self.tongxunID distance:[tf.text intValue] completed:^(BOOL success, NSString *tips) {
                    if (success) {
                        subDevice.safeDistance =  tf.text;
                        [self setdistance:tf.text];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"距离设置失败"];
                    }
                }];
            }]];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:controller1 animated:YES completion:nil];
        }else if (indexPath.row == 3) {
            
            //升级操作
            self.tableView.userInteractionEnabled= NO;
            CBPeripheral * periPheral = [LxmBLEManager.shareManager peripheralWithTongXinId:self.tongxunID];
            
            [[LxmBLEManager shareManager] nowCheckPowerForPer:periPheral];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"%@",@"123456");
                
                if (periPheral.power.intValue < 5 && periPheral.power.intValue != 0) {
                    [SVProgressHUD showErrorWithStatus:@"升级必须电量大于5%"];
                    self.tableView.userInteractionEnabled= YES;
                    return;
                }else {
                    
                    [[LxmBLEManager shareManager] checkVersion:periPheral  completed:^(BOOL success, NSString *hVersion, NSString *fVersion) {
                        self.tableView.userInteractionEnabled= YES;
                        LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.type = @"2";
                        vc.noStr = hVersion;
                        vc.firmwareNo = fVersion;
                        vc.peripheral = periPheral;
                        vc.isZhengChang = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        self.tableView.userInteractionEnabled= YES;
                        
                        
                    }];
                }
                
                
            });
            
        }
    }
}

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    NSLog(@"\n\n\n %d",progress);
    
    NSLog(@"%@",@"123");
    
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    NSLog(@"\n\nmessage ===== %@",message);
    
    NSLog(@"%@",@"");
    
    
}

- (void)logWith:(enum LogLevel)level message:(NSString *)message {
    
    NSLog(@"\n\nmessage =yyyyy==== %@",message);
    
    NSLog(@"%@",@"");
    
}

- (void)dfuStateDidChangeTo:(enum DFUState)state {
    
    NSLog(@"%d",state);
    
    
    NSLog(@"%@",@"123");
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
