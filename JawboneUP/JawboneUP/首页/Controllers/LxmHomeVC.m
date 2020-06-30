//
//  LxmHomeVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmHomeVC.h"
#import "LxmHomeInfoCell.h"
#import "LxmMessageBtn.h"
#import "LxmMessageVC.h"
#import "LxmBLEManager.h"
#import "LxmTeacherMessageVC.h"
#import "LxmJiaZhangModel.h"
#import "CBPeripheral+MAC.h"
#import "LxmLocalDataManager.h"
#import "AudioToolbox/AudioToolbox.h"

@interface LxmHomeVC ()
{
    UIImageView * _bgImgView;
    NSMutableArray<LxmDeviceModel *> *_deviceArr;
    BOOL  _havenewMsg;
    LxmMessageBtn * _rightbtn;
}
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, strong) NSMutableArray<LxmDeviceModel *> *deviceArr;
@end

@implementation LxmHomeVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)bindingListChanged {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
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
    [LxmNetworking networkingPOST:[LxmURLDefine checkMsg] parameters:@{@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSNumber * status = [[responseObject objectForKey:@"result"] objectForKey:@"statue"];
            _havenewMsg = [status intValue] == 1 ?YES:NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingListChanged) name:@"bindingListChanged" object:nil];
    _deviceArr = [NSMutableArray array];
    self.navigationItem.title = @"首页";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64-49)];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView.clipsToBounds = YES;
    [self.view addSubview:_bgImgView];

//    _radarView = [[VIGRadarView alloc] initWithFrame:_bgImgView.bounds];
//    _radarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _radarView.homeVC = self;
//    BOOL isTeacher = [LxmTool ShareTool].isTeacher;
//    if (isTeacher) {
//        _bgImgView.image = [UIImage imageNamed:@"white"];
//        _radarView.str = @"老师";
//    } else {
//        //家长
//        _bgImgView.image = [UIImage imageNamed:@"beij_jiazhuang"];
//        _radarView.str = @"家长";
//    }
//    [_bgImgView addSubview:_radarView];
//    [_radarView update];
    
    _rightbtn=[[LxmMessageBtn alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_rightbtn addTarget:self action:@selector(rightbarBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    rightbtn.num = 9;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_rightbtn];
    [self loadData];
       
    __weak typeof(self) selfWeak = self;
#pragma mark - 原来的测距逻辑
//    [[LxmBLEManager shareManager] setDistanceChangeBlock:^(CBPeripheral *p, NSString *tongxinId,CGFloat value) {
//        for (LxmDeviceModel *model in selfWeak.deviceArr) {
//            if ([model.communication isEqualToString:tongxinId]) {
//                if (model.distance > [model.safeDistance floatValue]){
//                    AudioServicesPlaySystemSound(1000);
//                }
//                if (model.distance != value) {
//                    model.distance = value; //这里给model距离赋值
//                    if (model.distance > [model.safeDistance floatValue]) {
//
//                        //
//                        NSString *title = @"距离提醒";
//                        NSString *content = [NSString stringWithFormat:@"%@%@超出安全距离", model.type.intValue == 1 ? @"母机":@"子机",model.equNickname];
//
//                        lxmMessageModel *m = [lxmMessageModel new];
//                        m.isRead = @(0);
//                        m.type = @"2";
//                        m.title = title;
//                        m.content = content;
//                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                        m.createTime = [format stringFromDate:[NSDate date]];
//                        [[LxmLocalDataManager shareManager] addMsg:m];
//                         _rightbtn.countLabel.hidden = NO;
//                    }
//                    [selfWeak reloadData];
//                    break;
//                }
//            }
//        }
//    }];
    
#pragma mark - 原来的电量的处理逻辑
//    [[LxmBLEManager shareManager] setPowerChangeBlock:^(NSString *mac, NSInteger value) {
//        for (LxmDeviceModel *model in selfWeak.deviceArr) {
//            if ([model.communication isEqualToString:mac]) {
//                if (model.power != value)
//                {
//                    model.power = value;
//                    [selfWeak reloadData];
//                    //xiaoxi
//                    if (value < 10) {
//                        NSString *title = @"电量提醒";
//                        NSString *content = [NSString stringWithFormat:@"%@%@的电量是%ld%%,请尽快充电", model.type.intValue == 1 ? @"母机":@"子机",model.equNickname,value];
//                        lxmMessageModel *m = [lxmMessageModel new];
//                        m.isRead = @(0);
//                        m.title = title;
//                        m.content = content;
//                        m.type = @"1";
//                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                        m.createTime = [format stringFromDate:[NSDate date]];
//                        [[LxmLocalDataManager shareManager] addMsg:m];
//                        _rightbtn.countLabel.hidden = NO;
//                        //tanchuang
//                        if (self.isAppear) {
//                            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
//                            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
//                            [self presentViewController:alertController animated:YES completion:nil];
//                        }
//                    }
//                    break;
//                }
//            }
//        }
//    }];
    
//    [[LxmBLEManager shareManager] addConnectBlock:^(BOOL success, CBPeripheral *per) {
//        if (success) {
//            for (LxmDeviceModel *model in selfWeak.deviceArr) {
//                if ([model.communication isEqualToString:per.tongxinId]) {
//                    model.isConnect = YES;
//                    model.peripheral = per;
//                    if (model.type.integerValue == 1) {
//                        [LxmBLEManager shareManager].masterPer = per;
//                    }
//                    [selfWeak reloadData];
//                    break;
//                }
//            }
//            [[LxmBLEManager shareManager] nowCheckPowerForPer:per];
//        }
//    }];
//
//    [[LxmBLEManager shareManager] addDisConnectBlock:^(BOOL success, CBPeripheral *per) {
//        if (success) {
//            for (LxmDeviceModel *model in selfWeak.deviceArr) {
//                if ([model.communication isEqualToString:per.tongxinId]) {
//                    model.isConnect = NO;
//                    model.peripheral = per;
//                    [selfWeak reloadData];
//                    break;
//                }
//            }
//            [[LxmBLEManager shareManager] nowCheckPowerForPer:per];
//        }
//    }];
    BOOL have = [[LxmLocalDataManager shareManager] checkMeg:[LxmLocalDataManager shareManager].localMsgs];
    if (_havenewMsg||have) {
        _rightbtn.countLabel.hidden = NO;
    }else{
        _rightbtn.countLabel.hidden = YES;
    }
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            [NSThread sleepForTimeInterval:1];
//            dispatch_async(dispatch_get_main_queue(), ^{
////               AudioServicesPlaySystemSound(1000);
//                NSLog(@"测试");
//            });
//        }
//    });
}

- (void)reloadData {
 
    NSInteger count = _deviceArr.count > 3 ? 3 : _deviceArr.count;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, 50*count);
        _bgImgView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenW, ScreenH - CGRectGetMaxY(self.tableView.frame)-49-64);
    }];
   [self.tableView reloadData];
//   _radarView.radiusArray = _deviceArr;
//    [_radarView update];
}

- (void)loadData {
    [SVProgressHUD show];
    NSString * str = [LxmURLDefine getBandDeviceListURL];
    NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token?[LxmTool ShareTool].session_token:@"",@"pageNum":@(1)};
    [_deviceArr removeAllObjects];
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSArray * arr = [[responseObject objectForKey:@"result"] objectForKey:@"list"];
            for (NSDictionary * dict in arr) {
                LxmDeviceModel * deviceModel = [LxmDeviceModel mj_objectWithKeyValues:dict];
                [_deviceArr addObject:deviceModel];
            }
            [self reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)rightbarBtnClick {
    BOOL isTeacher = [LxmTool ShareTool].isTeacher;
    if (isTeacher){
        //老师
        LxmMessageVC * vc = [[LxmMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isDoubleVC = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //家长
        LxmTeacherMessageVC * vc = [[LxmTeacherMessageVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeInfoCell"];
    if (!cell) {
        cell = [[LxmHomeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LxmDeviceModel *model = [_deviceArr objectAtIndex:indexPath.row];
    cell.dataModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
