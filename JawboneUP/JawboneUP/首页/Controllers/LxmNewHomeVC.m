//
//  LxmNewHomeVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmNewHomeVC.h"
#import "LxmMessageBtn.h"

#import "LxmMessageVC.h"
#import "LxmTeacherMessageVC.h"

#import "LxmNewHomeSetSaftyDistanceAlertView.h"

#import "LxmBLEManager.h"
#import "LxmEventBus.h"
#import "LxmDataManager.h"

#import "AudioToolbox/AudioToolbox.h"

#import "LxmDateModel.h"

#import "UIControl+AfterTimeAble.h"

#import "LxmShengJiSheBeiVC.h"

@interface LxmNewHomeVC ()

@property (nonatomic, strong) LxmMessageBtn *rightbtn;

@property (nonatomic, strong) UIImageView *xinShouImgView;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL isAppear;

@property (nonatomic, strong) NSMutableArray<LxmDeviceModel *> *deviceArr;

@property (nonatomic, strong) LxmDeviceModel *mainModel;//主设备

@property (nonatomic, strong) NSTimer *stepTimer;
@property (nonatomic, strong) NSTimer *distanceTimer;
/// 存放已同步的设备
@property (nonatomic, strong) NSMutableArray<NSString *> *yitongbuStepArr;
@property (nonatomic, strong) NSMutableArray<NSString *> *yitongbuDistanceArr;
@property (nonatomic, assign) BOOL isUpdate;
@property(nonatomic,strong)NSArray *serverList;//该账号服务器的数据
@property(nonatomic,strong)CBPeripheral *selectP;

@end

@implementation LxmNewHomeVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImageView *)xinShouImgView {
    if (!_xinShouImgView) {
        _xinShouImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _xinShouImgView.image = [UIImage imageNamed:@"newhome1"];
        _xinShouImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_xinShouImgView addGestureRecognizer:tap];
    }
    return _xinShouImgView;
}

- (LxmMessageBtn *)rightbtn {
    if (!_rightbtn) {
        _rightbtn = [[LxmMessageBtn alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _rightbtn.hidden = YES;
    }
    return _rightbtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isAppear = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _isAppear = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (LxmBLEManager.shareManager.centralManager.state == 4) {
        UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙已关闭" preferredStyle:UIAlertControllerStyleAlert];
        [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
    }
    
    
    
    [LxmNetworking networkingPOST:[LxmURLDefine checkMsg] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSNumber * status = [[responseObject objectForKey:@"result"] objectForKey:@"statue"];
            //            _havenewMsg = [status intValue] == 1 ?YES:NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
//    [[LxmBLEManager shareManager] startScan];
 
    [self loadData];
    
    
    //    //提示更新
    //    [self showUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _yitongbuStepArr = [NSMutableArray array];
    _yitongbuDistanceArr = [NSMutableArray array];
    [LxmBLEManager shareManager];
    self.navigationItem.title = @"首页";
    self.deviceArr = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightbtn];
    
    NSNumber *isfirst = [NSUserDefaults.standardUserDefaults objectForKey:@"isfirst"];
    if (!isfirst.boolValue) {
        self.count = 0;
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window addSubview:self.xinShouImgView];
        [NSUserDefaults.standardUserDefaults setObject:@1 forKey:@"isfirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    WeakObj(self);
    
    [LxmEventBus sendEvent:@"UpdateTongXinIdList" data:nil];
    
    [LxmEventBus registerEvent:@"shengji" block:^(NSDictionary * dict) {
        [[LxmBLEManager shareManager] stopScan];
        LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dataDict = dict;
        [selfWeak.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [LxmEventBus registerEvent:@"sjcg" block:^(CBPeripheral * data) {
        
//        [[LxmBLEManager shareManager] startScan];
        
        [selfWeak loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LxmBLEManager shareManager] connectPeripheral:data];
        });

        
    }];
    
    [LxmEventBus registerEvent:@"kssj" block:^(CBPeripheral * data) {
        for (LxmDeviceModel * model  in self.deviceArr) {
            [selfWeak colseAllwtih:model];
        }
      }];
    
    //收到广播
    [LxmEventBus registerEvent:@"deviceListChanged" block:^(id data) {
        NSLog(@"%@",@"chongshi");
        [selfWeak chongXingTishi];
    }];
    

    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadData];
    }];
    
    [LxmEventBus registerEvent:@"modifyUserInfoSuccess" block:^(id data) {
        [selfWeak loadData];
    }];
    
    [self loadData];
    [LxmEventBus registerEvent:LxmDeviceShuaXinDistanceNoti block:^(id data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.distance = @(-1);
                [selfWeak reloadTableViewIfNeed];
//                [selfWeak.tableView reloadData];
                break;
            }
        }
  
    }];
    
    
    // 监听连接状态
    [LxmEventBus registerEvent:LxmDeviceConnectDidChangeNoti block:^(NSDictionary *data) {
        NSString *tongxinId = data[@"tongxinId"];
        BOOL isConnected = [data[@"isConnected"] boolValue];
        // 更新数据
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.isConnect = isConnected;
                [selfWeak reloadTableViewIfNeed];
//                [selfWeak.tableView reloadData];
                break;
            }
        }
        [[LxmBLEManager shareManager] openOrCloseRealDistance:YES peripheral:[LxmBLEManager shareManager].mainPeripheral communication:nil completed:nil];
    }];
    
    //更新安全距离
    [LxmEventBus registerEvent:LxmDeviceSafeDistanceNoti block:^(id data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSNumber *safeDistance = data[@"safeDistance"];
        NSString *isRealTime = data[@"isRealTime"];
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.safeDistance = safeDistance.stringValue;
                device.isRealTime = isRealTime;
                [selfWeak.tableView reloadData];
                break;
            }
        }
    }];
    
    
    // 监听距离
    [LxmEventBus registerEvent:LxmDeviceDistanceDidChangeNoti block:^(NSDictionary *data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSNumber *distance = data[@"distance"];
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.distance = distance;
                NSLog(@"开关状态:%@",device.isRealTime);
                [selfWeak.tableView reloadData];
                break;
            }
        }
    }];
    
    // 监听电量
    [LxmEventBus registerEvent:LxmDevicePowerDidChangeNoti block:^(NSDictionary *data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSInteger power = [data[@"power"] integerValue];
        // 更新数据
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.power = @(power);
                [selfWeak reloadTableViewIfNeed];
                break;
            }
        }
    }];
    
    // 监听步数
    [LxmEventBus registerEvent:LxmDeviceStepDidChangeNoti block:^(NSDictionary *data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSInteger step = [data[@"step"] integerValue];
        // 更新数据
        NSArray *arr = [selfWeak allDevice];
        for (LxmDeviceModel *device in arr) {
            if ([device.communication isEqualToString:tongxinId]) {
                device.step = @(step);
                [selfWeak reloadTableViewIfNeed];
                break;
            }
        }
    }];
    
    
    // 刷新列表
    [LxmEventBus registerEvent:LxmDeviceCeJuSwitchDidChangeNoti1 block:^(NSDictionary *data) {
        [selfWeak.tableView reloadData];
    }];
    
    // 监听测距状态
    [LxmEventBus registerEvent:LxmDeviceCeJuSwitchDidChangeNoti block:^(NSDictionary *data) {
        NSString *tongxinId = data[@"tongxinId"];
        NSString *isRealTime = data[@"isRealTime"];
        CBPeripheral *peripheral = [LxmBLEManager.shareManager peripheralWithTongXinId:tongxinId];
        if (peripheral.isMaster) {
            if (peripheral.powerStatus.intValue != 0) {
                [selfWeak updateDevice1:selfWeak.mainModel info:@{@"isRealTime":isRealTime} completed:^(BOOL success) {
                    if (success) {
                        peripheral.isRealTime = isRealTime;
                        selfWeak.mainModel.isRealTime = isRealTime;
                        
                        NSArray *arr = [selfWeak allDevice];
                        for (LxmDeviceModel *device in arr) {
                            if (device.type.intValue == 2) {//子机
                                CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:device.communication];
                                [LxmBLEManager.shareManager nowCheckPowerForPer:p];
                            }
                        }
                    }}];
            } else {
                [LxmBLEManager.shareManager openOrCloseRealDistance:isRealTime.intValue == 1 ? YES : NO peripheral:peripheral communication:nil completed:^(BOOL success, BOOL isOpen) {
                    if (success) {
                        peripheral.isYanshi = YES;
                        [selfWeak updateDevice1:selfWeak.mainModel info:@{@"isRealTime":isRealTime} completed:^(BOOL success) {
                            if (success) {
                                peripheral.isRealTime = isRealTime;
                                selfWeak.mainModel.isRealTime = isRealTime;
                                [selfWeak.tableView reloadData];
                            }}];
                    }
                }];
            }
        } else {
            NSArray *arr = [selfWeak allDevice];
            for (LxmDeviceModel *device in arr) {
                if ([device.communication isEqualToString:tongxinId]) {
                    if (isRealTime.intValue == 1) {//对子机发开
                        [LxmBLEManager.shareManager openOrCloseRealDistance:YES peripheral:peripheral communication:nil completed:^(BOOL success, BOOL isOpen) {
                            if (success) {
                                peripheral.isYanshi = YES;
                                [selfWeak updateDevice1:device info:@{@"isRealTime":@"1"} completed:^(BOOL success) {
                                    if (success) {
                                        peripheral.isRealTime = @"1";
                                        device.isRealTime = @"1";
                                        [selfWeak.tableView reloadData];
                                    }}];
                            }
                        }];
                    } else {//对主机发对应子机关
                        [LxmBLEManager.shareManager openOrCloseRealDistance:NO peripheral:LxmBLEManager.shareManager.master communication:peripheral.tongxinId completed:^(BOOL success, BOOL isOpen) {
                            if (success) {
                                peripheral.isYanshi = YES;
                                [selfWeak updateDevice1:device info:@{@"isRealTime":isRealTime} completed:^(BOOL success) {
                                    if (success) {
                                        peripheral.isRealTime = isRealTime;
                                        device.isRealTime = isRealTime;
                                        [selfWeak.tableView reloadData];
                                    }
                                }];
                            }
                        }];
                    }
                }
            }
        }
        
    }];
    
    [LxmEventBus registerEvent:@"UpdateTongXinIdList" block:^(id data) {
        [LxmBLEManager.shareManager getCommunicationListForPer:LxmBLEManager.shareManager.master completed:^(BOOL success, CBPeripheral *per) {
            
        }];
    }];
    
    [LxmEventBus registerEvent:@"subdeviceBandSuccess" block:^(id data) {
        [selfWeak loadData];
    }];
    
}

//关闭所有子机测距
- (void)colseAllwtih:(LxmDeviceModel *)model {
    
    CBPeripheral * p = [[LxmBLEManager shareManager] peripheralWithTongXinId:model.communication];;
//    
    if (model.isRealTime.intValue == 1) {
    //准备关上 关  只需要发给主机带上子机的通信id
              p.isYanshi = YES;
              p.isRealTime = @"2";
              model.isRealTime = @"2";
              model.distance = @(-2);
              [self updateDevice:model info:@{@"isRealTime":@"2"} completed:^(BOOL success) {

              }];

        
    }
    
}

- (NSArray *)allDevice {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.mainModel) {
        [arr addObject:self.mainModel];
    }
    [arr addObjectsFromArray:self.deviceArr];
    return arr;
}

- (void)reloadTableViewIfNeed {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableView) object:nil];
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.5 inModes:@[NSRunLoopCommonModes]];
}

- (void)reloadTableView {
    [self.tableView reloadData];
}



- (void)loadData {
    if (self.mainModel == nil) {
        [SVProgressHUD show];
    }
    NSString * str = [LxmURLDefine getBandDeviceListURL];
    NSDictionary * dic = @{
        @"token":[LxmTool ShareTool].session_token,
        @"pageNum":@1,
        @"pageSize": @10
    };
    //slaveCommIds
    WeakObj(self);
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak endRefresh];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            self.mainModel = nil;
            [self.deviceArr removeAllObjects];
            NSArray * arr = responseObject[@"result"][@"list"];
            NSMutableArray *tmpArr = [NSMutableArray array];
            self.serverList = arr;
            for (NSDictionary * dict in arr) {
                LxmDeviceModel * deviceModel = [LxmDeviceModel mj_objectWithKeyValues:dict];
                [tmpArr addObject:deviceModel];
                CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:deviceModel.communication];
                deviceModel.isConnect = [LxmBLEManager.shareManager isConnectWithTongXinId:deviceModel.communication];
                NSString * fv  = p.fVersion;
                NSString * hv  = p.hVersion;
                
                if ([dict[@"new_firmware_version"] intValue] > fv.intValue && fv.intValue != 0) {
                    deviceModel.isCanUp = YES;
                }else {
                    deviceModel.isCanUp = NO;
                }
                deviceModel.hardwareVersion = p.hVersion;
                deviceModel.firmwareVersion = p.fVersion;
                deviceModel.step = p.step;
                deviceModel.power = p.power;
                
                if (deviceModel.type.intValue == 1) {//主机
                    LxmBLEManager.shareManager.masterTongXinId = deviceModel.communication;
                    selfWeak.mainModel = deviceModel;
                    [LxmBLEManager shareManager].mainPeripheral = p;
                } else {//子机
                    [_deviceArr addObject:deviceModel];
                }
            }
            
            
            
            if (LxmBLEManager.shareManager.serverDeviceArr.count > 0) {
                for (LxmDeviceModel *model in _deviceArr) {
                    for (LxmDeviceModel *m in LxmBLEManager.shareManager.serverDeviceArr) {
                        if ([m.communication isEqualToString:model.communication]) {
                            model.isRealTime = m.isRealTime;
                        }
                    }
                }
            }
            
            [selfWeak.tableView reloadData];
            
            
            [self showUpdate];
            
            
            
            
            LxmBLEManager.shareManager.serverDeviceArr = tmpArr;
            [LxmBLEManager.shareManager connectServerDeviceIfNeed];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak endRefresh];
    }];
}

- (void)chongXingTishi {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0;i < self.deviceArr.count+1;i++) {
        LxmDeviceModel * deviceModel = nil;
        if (i == 0 ) {
            if (self.mainModel != nil) {
               deviceModel = self.mainModel;
            }
            
        }else {
            deviceModel = self.deviceArr[i-1];
        }
        
        CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:deviceModel.communication];
        deviceModel.isConnect = [LxmBLEManager.shareManager isConnectWithTongXinId:deviceModel.communication];
        NSString * fv  = p.fVersion;
        NSString * hv  = p.hVersion;
        if (deviceModel.n_firmware_version.intValue > fv.intValue && fv.intValue != 0) {
            deviceModel.isCanUp = YES;
        }else {
            deviceModel.isCanUp = NO;
        }
        
    }
    [self showUpdate];
    
}

//提示更新操作
- (void)showUpdate {
    
    for (int i = 0 ; i < self.deviceArr.count+1; i++) {
        if (i == 0) {
            
            if (self.mainModel.isCanUp && !self.mainModel.isCancel) {
                
                CBPeripheral * peripheral = [[LxmBLEManager shareManager] peripheralWithTongXinId:self.mainModel.communication];
                
                if ([peripheral.name isEqualToString:[LxmTool ShareTool].perName]) {
                    if (self.mainModel.n_firmware_version.intValue <= [LxmTool ShareTool].fVersion.intValue) {
                        continue;
                    }
                }
                UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"设备\"%@\"有新的固件可以更新,是否更新",self.mainModel.equNickname] preferredStyle:UIAlertControllerStyleAlert];
                [alertcontroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.mainModel.isCancel = YES;
                    [self showUpdate];
                }]];
                [alertcontroller addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString * fv = peripheral.fVersion;
                    NSString * hv = peripheral.hVersion;
                    if (peripheral == nil) {
                        [SVProgressHUD showErrorWithStatus:@"还没有链接上蓝牙,请稍后"];
                        return;
                    }
                    
                    LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
                    vc.noStr = peripheral.hVersion;
                    vc.firmwareNo = [@(peripheral.fVersion.intValue - 1) stringValue];
                    vc.peripheral = peripheral;
                    vc.type = @"1";
                    vc.isComeHome = YES;
                    vc.isZhengChang = YES;
                    WeakObj(self);
                    vc.shengJiChengGongBlock = ^{
                        selfWeak.mainModel.isCanUp = NO;
//                        [selfWeak showUpdate];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }]];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
                break;;;
                
            }
        }else {
            
            
            if (self.deviceArr[i-1].isCanUp && !self.deviceArr[i-1].isCancel) {
                
                CBPeripheral * peripheral = [[LxmBLEManager shareManager] peripheralWithTongXinId:self.deviceArr[i-1].communication];
             

                if ([peripheral.name isEqualToString:[LxmTool ShareTool].perName]) {
                            if (self.deviceArr[i-1].n_firmware_version.intValue <= [LxmTool ShareTool].fVersion.intValue) {
                            continue;
                        }
                    }
                
                UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"设备\"%@\"有新的固件可以更新,是否更新",self.deviceArr[i-1].equNickname] preferredStyle:UIAlertControllerStyleAlert];
                [alertcontroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.deviceArr[i-1].isCancel = YES;
                    [self showUpdate];
                }]];
                [alertcontroller addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    self.selectP = peripheral;
                    NSString * fv = peripheral.fVersion;
                    NSString * hv = peripheral.hVersion;
                    if (peripheral == nil) {
                        [SVProgressHUD showErrorWithStatus:@"还没有链接上蓝牙,请稍后"];
                        return;
                    }
                    
                    LxmShengJiSheBeiVC * vc =[[LxmShengJiSheBeiVC alloc] init];
                    vc.noStr = peripheral.hVersion;
                    vc.firmwareNo = [@(peripheral.fVersion.intValue - 1) stringValue];
                    vc.peripheral = peripheral;
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.type = @"2";
                    vc.isZhengChang = YES;
                    vc.isComeHome = YES;
                    WeakObj(self);
                    vc.shengJiChengGongBlock = ^{
                        selfWeak.deviceArr[i-1].isCanUp = NO;
//                        [selfWeak showUpdate];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }]];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
                break;;
                
            }
            
        }
        
        
    }
    
}


- (void)endRefresh {
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    self.count ++ ;
    if (self.count == 1) {
        self.xinShouImgView.image = [UIImage imageNamed:@"newhome2"];
    } else if (self.count == 2) {
        self.xinShouImgView.image = [UIImage imageNamed:@"newhome3"];
    } else {
        self.count = 0;
        [self.xinShouImgView removeFromSuperview];
    }
}

-(void)rightbarBtnClick {
    BOOL isTeacher = [LxmTool ShareTool].isTeacher;
    if (isTeacher) {//老师
        LxmMessageVC * vc = [[LxmMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isDoubleVC = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//家长
        LxmTeacherMessageVC * vc = [[LxmTeacherMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.deviceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmNewHomeMineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNewHomeMineCell"];
        if (!cell) {
            cell = [[LxmNewHomeMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNewHomeMineCell"];
        }
        cell.deviceModel = self.mainModel;
        return cell;
    } else {
        LxmNewHomeZiJiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNewHomeZiJiCell"];
        if (!cell) {
            cell = [[LxmNewHomeZiJiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNewHomeZiJiCell"];
        }
        cell.mainModel = self.mainModel;
        cell.deviceModel = self.deviceArr[indexPath.row];
        WeakObj(self);
        cell.setSaftyDistanceBlock = ^(LxmDeviceModel *model) {
            [selfWeak setDistanceAction:model];
        };
        cell.setRealOpenBlock = ^(LxmDeviceModel *model) {
            [selfWeak setRealOpenAction:model];
        };
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"view"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"view"];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.mainModel ? 80 : 0;
    } else {
        return 155;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 5 ? 15 : 0.001;
}


/**
 设置安全距离
 */
- (void)setDistanceAction:(LxmDeviceModel *)model {
    if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
        [SVProgressHUD showErrorWithStatus:@"正在同步硬件数据!,所有硬件相关操作暂不能执行!"];
        return;
    }
    //    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:model.communication];
    CBPeripheral *mainP = [LxmBLEManager.shareManager peripheralWithTongXinId:self.mainModel.communication];
    
    if (mainP.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"当前主机设备已经断连!"];
        return;
    }
    LxmNewHomeSetSaftyDistanceAlertView *alerView = [[LxmNewHomeSetSaftyDistanceAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    WeakObj(self);
    [alerView showWithNumber:model.safeDistance.integerValue setBlock:^(NSInteger num) {
        if (num != model.safeDistance.integerValue) {
            [SVProgressHUD show];
            [LxmBLEManager.shareManager setDistance:model.communication distance:num completed:^(BOOL success, NSString *tips) {
                [SVProgressHUD dismiss];
                
                if (success) {
                    [selfWeak updateDevice:model info:@{@"safeDistance":@(num)} completed:^(BOOL success) {
                        if (success) {
                            model.safeDistance = @(num).stringValue;
                            [selfWeak.tableView reloadData];
                            
                            //                            for (LxmDeviceModel *mm  in [LxmBLEManager shareManager].serverDeviceArr) {
                            //                                if ([mm.communication isEqualToString:model.communication]) {
                            //                                    if (model.safeDistance.intValue != 0) {
                            //                                        mm.safeDistance =  @(num).stringValue;
                            //                                        break;
                            //                                    }
                            //
                            //                                }
                            //                            }
                            //
                            //                            [LxmEventBus sendEvent:@"subdeviceBandSuccess" data:nil];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"同步设备信息失败"];
                        }
                    }];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"更新设备信息失败"];
                }
            }];
        }
    }];
}

/**
 打开关闭实施测距
 */
- (void)setRealOpenAction:(LxmDeviceModel *)model {
    NSLog(@"操作:11111");
    //首先要打开主机的自动测距 ee080c01ff 测距 打开 对子机母机都要发指令 关  只需要发给主机带上子机的通信id
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:model.communication];
    CBPeripheral *mainP = [LxmBLEManager.shareManager peripheralWithTongXinId:self.mainModel.communication];
    WeakObj(self);
    if (model.isRealTime.intValue == 1) {
        //准备关上 关  只需要发给主机带上子机的通信id
        [SVProgressHUD show];
        [LxmBLEManager.shareManager openOrCloseRealDistance:NO peripheral:[LxmBLEManager.shareManager peripheralWithTongXinId:selfWeak.mainModel.communication] communication:model.communication completed:^(BOOL success, BOOL isOpen) {
            [SVProgressHUD dismiss];
            if (success) {
                p.isYanshi = YES;
                p.isRealTime = @"2";
                model.isRealTime = @"2";
                model.distance = @(-2);
                [selfWeak.tableView reloadData];
                BOOL ishave = NO;
                for (LxmDeviceModel *m in LxmBLEManager.shareManager.serverDeviceArr) {
                    if (m.isRealTime.intValue == 1) {
                        ishave = YES;
                        break;
                    }
                }
                if (!ishave) {
                    [LxmBLEManager.shareManager closeMasterCeju];
                }
                [selfWeak updateDevice:model info:@{@"isRealTime":@"2"} completed:^(BOOL success) {
                    
                }];
                
            } else {
                [SVProgressHUD dismiss];
            }
        }];
    } else {
        if (p.state != CBPeripheralStateConnected) {
            [SVProgressHUD showErrorWithStatus:@"当前子机设备不在蓝牙连接范围内!"];
            return;
        }
        CBPeripheral * pp = LxmBLEManager.shareManager.master;
        [SVProgressHUD show];
        [LxmBLEManager.shareManager openOrCloseRealDistance:YES peripheral:mainP communication:model.communication completed:^(BOOL success, BOOL isOpen) {
           
            CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:model.communication];
            if (success) {//主机测距已打开
                [LxmBLEManager.shareManager openOrCloseRealDistance:YES peripheral:p communication:nil completed:^(BOOL success, BOOL isOpen) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        p.isYanshi = YES;
                        p.isRealTime = @"1";
                        model.isRealTime = @"1";
                        model.distance = @(-2);
                        [selfWeak.tableView reloadData];
                        NSLog(@"操作:%@",model.isRealTime);
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [LxmBLEManager.shareManager openMasterCeju];
                        });
                        
                        
                        [selfWeak updateDevice:model info:@{@"isRealTime":@"1"} completed:^(BOOL success) {
                            
                        }];
                    } else {
//                        [SVProgressHUD dismiss];
                        [LxmBLEManager.shareManager openOrCloseRealDistance:NO peripheral:mainP communication:model.communication completed:^(BOOL success, BOOL isOpen) {}];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"开启失败"];
            }
        }];
    }
}

- (void)updateDevice:(LxmDeviceModel *)model info:(NSDictionary *)info  completed:(void(^)(BOOL success))completed {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:info];
    NSDictionary *dict1 = @{@"token":[LxmTool ShareTool].session_token,
                            @"userEquId":model.userEquId,
                            @"type":model.type
    };
    [params addEntriesFromDictionary:dict1];
    //    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getModifyDeviceURL] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            if (completed) {
                completed(YES);
            }
        } else {
            if (completed) {
                completed(NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (completed) {
            completed(NO);
        }
    }];
}

- (void)updateDevice1:(LxmDeviceModel *)model info:(NSDictionary *)info  completed:(void(^)(BOOL success))completed {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:info];
    NSDictionary *dict1 = @{@"token":[LxmTool ShareTool].session_token,
                            @"userEquId":model.userEquId,
                            @"type":model.type
    };
    [params addEntriesFromDictionary:dict1];
    [LxmNetworking networkingPOST:[LxmURLDefine getModifyDeviceURL] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            if (completed) {
                completed(YES);
            }
        } else {
            if (completed) {
                completed(NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (completed) {
            completed(NO);
        }
    }];
}

@end


/**
 安全距离计步信息
 */
@interface LxmNewHomeView ()

@end
@implementation LxmNewHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.topLabel];
    [self addSubview:self.bottomLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.setButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self.mas_centerY);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topLabel.mas_trailing).offset(5);
        make.center.equalTo(self);
        make.trailing.equalTo(self.setButton.mas_leading).offset(-5);
    }];
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@32);
        make.height.equalTo(@20);
    }];
    [self.numLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.textColor = UIColor.whiteColor;
        _topLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.textColor = UIColor.whiteColor;
        _bottomLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _bottomLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.textColor = UIColor.whiteColor;
        _numLabel.font = [UIFont boldSystemFontOfSize:16];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [UIButton new];
    }
    return _setButton;
}

@end


@interface LxmNewHomeCellTopView ()

@property (nonatomic, strong) UIImageView *statusImgView;//在线状态

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UILabel *nameLabel;//主机名称

@property (nonatomic, strong) UIImageView *dianliangImgView;//电量

@property (nonatomic, strong) UILabel *dianlianglabel;//电量

@property (nonatomic, strong) UIImageView *jibuImgView;//计步

@property (nonatomic, strong) UILabel *jibuLabel;//计步

@end

@implementation LxmNewHomeCellTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrians];
    }
    return self;
}

- (void)setDeviceModel:(LxmDeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:deviceModel.communication];
    
    // 连接状态
    self.statusImgView.image = [UIImage imageNamed:_deviceModel.isConnect ? @"bg_3-1" : @"ico_8"];
    if (_deviceModel.power) {
        self.dianliangImgView.hidden = NO;
        self.dianlianglabel.hidden = NO;
    }
    
    // 电量状态
    self.dianliangImgView.hidden = (_deviceModel.power == nil);
    self.dianlianglabel.hidden = (_deviceModel.power == nil);
    if (_deviceModel.power.integerValue < 5) {
        if (p.powerStatus.intValue == 2) {
            self.dianliangImgView.image = [UIImage imageNamed:@"01"];
        } else {
            self.dianliangImgView.image = [UIImage imageNamed:@"0"];
        }
    } else if (_deviceModel.power.integerValue < 25) {
        if (p.powerStatus.intValue == 2) {
            self.dianliangImgView.image = [UIImage imageNamed:@"251"];
        } else {
            self.dianliangImgView.image = [UIImage imageNamed:@"25"];
        }
    } else if (_deviceModel.power.integerValue < 50) {
        if (p.powerStatus.intValue == 2) {
            self.dianliangImgView.image = [UIImage imageNamed:@"501"];
        } else {
            self.dianliangImgView.image = [UIImage imageNamed:@"50"];
        }
    } else if (_deviceModel.power.integerValue < 75) {
        if (p.powerStatus.intValue == 2) {
            self.dianliangImgView.image = [UIImage imageNamed:@"751"];
        } else {
            self.dianliangImgView.image = [UIImage imageNamed:@"75"];
        }
    } else {
        if (p.powerStatus.intValue == 2) {
            self.dianliangImgView.image = [UIImage imageNamed:@"1001"];
        } else {
            self.dianliangImgView.image = [UIImage imageNamed:@"100"];
        }
    }
    
    if (p.powerStatus.intValue == 3) {
        self.dianlianglabel.text = @"已充满";
    } else {
        self.dianlianglabel.text = [NSString stringWithFormat:@"%ld%%", (long)_deviceModel.power.integerValue];
    }
    // 计步
    self.jibuLabel.hidden = (_deviceModel.step == nil);
    self.jibuImgView.hidden = (_deviceModel.step == nil);
    self.jibuLabel.text = [NSString stringWithFormat:@"%ld", (long)_deviceModel.step.integerValue];
    
    // 头像名称
    if (_deviceModel.equHead.isValid) {
        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:_deviceModel.equHead]]];
    }
    
    self.nameLabel.text = _deviceModel.equNickname;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.statusImgView];
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dianliangImgView];
    [self addSubview:self.dianlianglabel];
    [self addSubview:self.jibuImgView];
    [self addSubview:self.jibuLabel];
}

/**
 添加约束
 */
- (void)setConstrians {
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(3);
        make.width.height.equalTo(@18);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.statusImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.dianliangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@20);
        make.height.equalTo(@11);
    }];
    [self.dianlianglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dianliangImgView.mas_trailing).offset(5);
        make.centerY.equalTo(self);
    }];
    [self.jibuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.jibuLabel.mas_leading).offset(-5);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@12);
    }];
    [self.jibuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)statusImgView {
    if (!_statusImgView) {
        _statusImgView = [UIImageView new];
        _statusImgView.image = [UIImage imageNamed:@"ico_8"];
    }
    return _statusImgView;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 25;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.text = @"主机李老师";
    }
    return _nameLabel;
}

- (UIImageView *)dianliangImgView {
    if (!_dianliangImgView) {
        _dianliangImgView = [UIImageView new];
    }
    return _dianliangImgView;
}

- (UILabel *)dianlianglabel {
    if (!_dianlianglabel) {
        _dianlianglabel = [UILabel new];
        _dianlianglabel.textColor = UIColor.whiteColor;
        _dianlianglabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _dianlianglabel;
}

- (UIImageView *)jibuImgView {
    if (!_jibuImgView) {
        _jibuImgView = [UIImageView new];
        _jibuImgView.image = [UIImage imageNamed:@"ico_1"];
    }
    return _jibuImgView;
}

- (UILabel *)jibuLabel {
    if (!_jibuLabel) {
        _jibuLabel = [UILabel new];
        _jibuLabel.textColor = UIColor.whiteColor;
        _jibuLabel.font = [UIFont boldSystemFontOfSize:15];
        _jibuLabel.text = @"0";
    }
    return _jibuLabel;
}

@end


/**
 安全距离计步信息
 */
@interface LxmNewHomeCellBottomView ()

@property (nonatomic, strong) LxmNewHomeView *leftView;

@property (nonatomic, strong) LxmNewHomeView *rightView;

@end
@implementation LxmNewHomeCellBottomView

- (void)setDeviceModel:(LxmDeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    if (_deviceModel.safeDistance.intValue == 0) {
        _leftView.numLabel.text = @"静音";
    } else {
        _leftView.numLabel.text = _deviceModel.safeDistance;
    }
    CBPeripheral *main = LxmBLEManager.shareManager.master;
    if (main.powerStatus.intValue != 0) {
        _rightView.numLabel.text = @"关闭";
    } else {
        if (_deviceModel.isRealTime.intValue == 1) {
            if (_deviceModel.distance.stringValue.isValid) {
                if (_deviceModel.distance.intValue == -1) {
                    _rightView.numLabel.text = @"断连";
                } else {
                    if (_deviceModel.distance.intValue == -2) {
                        _rightView.numLabel.text = @"0";
                    } else {
                        _rightView.numLabel.text = _deviceModel.distance.stringValue;
                    }
                    
                }
            } else {
                _rightView.numLabel.text = @"0";
            }
        } else {
            _rightView.numLabel.text = @"关闭";
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.mas_centerX).offset(-7.5);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_centerX).offset(7.5);
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (LxmNewHomeView *)leftView {
    if (!_leftView) {
        _leftView = [LxmNewHomeView new];
        _leftView.layer.cornerRadius = 5;
        _leftView.layer.borderWidth = 0.5;
        _leftView.layer.borderColor = UIColor.whiteColor.CGColor;
        _leftView.layer.masksToBounds = YES;
        _leftView.topLabel.text = @"安全";
        _leftView.bottomLabel.text = @"距离";
        _leftView.numLabel.text = @"0";
        [_leftView.setButton setTitle:@"设定" forState:UIControlStateNormal];
        _leftView.setButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _leftView.setButton.layer.cornerRadius = 10;
        _leftView.setButton.backgroundColor = UIColor.whiteColor;
        [_leftView.setButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
    }
    return _leftView;
}

- (LxmNewHomeView *)rightView {
    if (!_rightView) {
        _rightView = [LxmNewHomeView new];
        _rightView.layer.cornerRadius = 5;
        _rightView.layer.borderWidth = 0.5;
        _rightView.layer.borderColor = UIColor.whiteColor.CGColor;
        _rightView.layer.masksToBounds = YES;
        _rightView.topLabel.text = @"实时";
        _rightView.bottomLabel.text = @"距离";
        _rightView.numLabel.text = @"0";
    }
    return _rightView;
}

@end


/**
 主机
 */
@interface LxmNewHomeMineCell()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LxmNewHomeCellTopView *topView;//在线状态

@end

@implementation LxmNewHomeMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.bgImgView];
        [self addSubview:self.topView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.backgroundColor = BlueColor;
        _bgImgView.layer.cornerRadius = 10;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (LxmNewHomeCellTopView *)topView {
    if (!_topView) {
        _topView = [[LxmNewHomeCellTopView alloc] init];
    }
    return _topView;
}

- (void)setDeviceModel:(LxmDeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:_deviceModel.communication];
    if (p.state == CBPeripheralStateConnected) {
        _bgImgView.image = [UIImage imageNamed:@"bg_01"];
    } else {
        _bgImgView.image = [UIImage imageNamed:@"bg_02"];
    }
    self.topView.deviceModel = _deviceModel;
}

@end

/**
 子机
 */
@interface LxmNewHomeZiJiCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LxmNewHomeCellTopView *topView;//在线状态

@property (nonatomic, strong) LxmNewHomeCellBottomView *bottomView;//安全距离 事实距离

@end
@implementation LxmNewHomeZiJiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.bgImgView];
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@80);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@46);
        }];
        
    }
    return self;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.layer.cornerRadius = 10;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (LxmNewHomeCellTopView *)topView {
    if (!_topView) {
        _topView = [[LxmNewHomeCellTopView alloc] init];
    }
    return _topView;
}

- (LxmNewHomeCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmNewHomeCellBottomView alloc] init];
        [_bottomView.leftView.setButton addTarget:self action:@selector(setDistanceClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.rightView.setButton addTarget:self action:@selector(setopenClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomView;
}

- (void)setDeviceModel:(LxmDeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:self.mainModel.communication];
    if (p.state != CBPeripheralStateConnected) {
        [self.bottomView.rightView.setButton setBackgroundImage:[UIImage imageNamed:@"guan"] forState:UIControlStateNormal];
        _bgImgView.image = [UIImage imageNamed:@"bg_02"];
    } else {
        if (_deviceModel.isRealTime.intValue == 1) {
            [self.bottomView.rightView.setButton setBackgroundImage:[UIImage imageNamed:@"kai-"] forState:UIControlStateNormal];
            if (_deviceModel.safeDistance.intValue == 0) {
                if (_deviceModel.type.intValue == 2) {
                    NSLog(@"zi");
                }
                _bgImgView.image = [UIImage imageNamed:@"bg011"];
            } else {
                if (_deviceModel.distance.intValue == -1) {
                    _bgImgView.image = [UIImage imageNamed:@"bg_04"];
                    [self shakeAnimationForView:self];
                } else {
                    if (p.powerStatus.intValue == 0) {
                        if (_deviceModel.distance.doubleValue > _deviceModel.safeDistance.doubleValue) {
                            _bgImgView.image = [UIImage imageNamed:@"bg_04"];
                            [self shakeAnimationForView:self];
                        } else if (_deviceModel.distance.doubleValue > _deviceModel.safeDistance.doubleValue * 0.5){
                            _bgImgView.image = [UIImage imageNamed:@"bg_03"];
                        } else {
                            if (_deviceModel.type.intValue == 2) {
                                NSLog(@"zi");
                            }
                            _bgImgView.image = [UIImage imageNamed:@"bg011"];
                        }
                    } else {
                        [self.bottomView.rightView.setButton setBackgroundImage:[UIImage imageNamed:@"guan"] forState:UIControlStateNormal];
                        _bgImgView.image = [UIImage imageNamed:@"bg_02"];
                    }
                }
            }
        } else {
            [self.bottomView.rightView.setButton setBackgroundImage:[UIImage imageNamed:@"guan"] forState:UIControlStateNormal];
            _bgImgView.image = [UIImage imageNamed:@"bg_02"];
        }
    }
    self.topView.deviceModel = _deviceModel;
    self.bottomView.mainModel = self.mainModel;
    self.bottomView.deviceModel = _deviceModel;
}

- (void)shakeAnimationForView:(UIView *) view {
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}



/**
 设置安全距离
 */
- (void)setDistanceClick {
    if (self.setSaftyDistanceBlock) {
        self.setSaftyDistanceBlock(self.deviceModel);
    }
}

- (void)setopenClick:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
        [SVProgressHUD showErrorWithStatus:@"正在同步硬件数据!,所有硬件相关操作暂不能执行!"];
        return;
    }
    //首先要打开主机的自动测距 ee080c01ff 测距 打开 对子机母机都要发指令 关  只需要发给主机带上子机的通信id
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:_deviceModel.communication];
    CBPeripheral *mainP = [LxmBLEManager.shareManager peripheralWithTongXinId:self.mainModel.communication];
    if (mainP.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"当前主机设备已经断连!"];
        return;
    }
    if (mainP.powerStatus.intValue != 0) {
        UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@,无法打开",mainP.powerStatus.intValue == 2 ? @"充电中":mainP.powerStatus.intValue == 3 ? @"充电中" : @"低电量"] preferredStyle:UIAlertControllerStyleAlert];
        [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
        return;
    } else {
        if (p.powerStatus.intValue != 0) {
            //子机非正常电量状态下，如果用户操作打开测距，提醒用户电量低或者正在充电。然后再给子机主动发条查询电量指令(0F)
            [LxmBLEManager.shareManager nowCheckPowerForPer:p];
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@,无法打开!",p.powerStatus.intValue == 2 ? @"充电中":p.powerStatus.intValue == 3 ? @"充电中":@"低电量"] preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
            return;
        } else {
            [btn enabledAfter:1.5];
            if (self.setRealOpenBlock) {
                self.setRealOpenBlock(self.deviceModel);
            }
        }
    }
    
}

@end
