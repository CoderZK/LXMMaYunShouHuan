//
//  LxmDataVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDataVC.h"
#import "LxmDataNavView.h"
#import "LxmSelectZiJiAlertView.h"

#import "XMCalendarView.h"
#import "XMCalendarCell.h"
#import "XMCalendarDataSource.h"
#import "XMCalendarManager.h"

#import "ZFChart.h"

#import "LxmBLEManager.h"
#import "LxmDateModel.h"
#import "LxmDataManager.h"
#import "LxmBLEManager+Tongbu.h"

@interface LxmDataVC ()<ZFGenericChartDataSource, ZFBarChartDelegate, ZFGenericChartDataSource, ZFLineChartDelegate, XMCalendarViewDelegate>

@property (nonatomic, strong) UIImageView *xinShouImgView;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) LxmDataNavView *navView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) XMCalendarView *calendarView;

@property (nonatomic, strong) LxmDataSelectView *selectDeviceView;//选择当前设备

@property (nonatomic, strong) UIView *headerView;//表头

@property (nonatomic, strong) ZFBarChart *barChart;//柱状图

//@property (nonatomic, strong) ZFLineChart * lineChart;//折线图

@property (nonatomic, strong) UILabel *textLabel;//超出距离次数记录

@property (nonatomic, strong) UILabel *textLabel1;//超出最远距离

@property (nonatomic, strong) NSArray<LxmDeviceModel *> *deviceArr;

@property (nonatomic, strong) NSNumber *type;//1距离 2 计步

@property (nonatomic, strong) LxmDeviceModel *currentModel;

@property (nonatomic, strong) NSDate *preDate;

@property (nonatomic, strong) NSDate *currentDate;


@property (nonatomic, strong) NSMutableArray *lineTimes;//距离线数组

@property (nonatomic, strong) NSMutableArray *lineDistance;//距离数组

@property (nonatomic, strong) NSMutableArray *jibuDates;//计步三天时间数组

@property (nonatomic, strong) NSMutableArray *jibuBuShuAr;;//三天的计步步数


@property (nonatomic, strong) NSMutableArray<LxmDeviceModel *> *deviceArr1;

@property (nonatomic, strong) LxmDeviceModel *mainModel;//主设备

@property (nonatomic, strong) NSTimer *stepTimer;
@property (nonatomic, strong) NSTimer *distanceTimer;

@property (nonatomic, strong) NSString *jibuTotol;//计步总数

@property (nonatomic, strong) LxmDeviceModel *currentSubModel;

@end

@implementation LxmDataVC
/// 同步数据
- (void)tongbuClick:(UIButton *)btn {
    if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
        [SVProgressHUD showErrorWithStatus:@"正在同步数据，请稍后..."];
        return;
    }
    [LxmBLEManager.shareManager tongbuDataShowHUD:YES];
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
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD dismiss];
            self.mainModel = nil;
            [self.deviceArr1 removeAllObjects];
            NSArray * arr = responseObject[@"result"][@"list"];
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (NSDictionary * dict in arr) {
                LxmDeviceModel * deviceModel = [LxmDeviceModel mj_objectWithKeyValues:dict];
                [tmpArr addObject:deviceModel];
                CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:deviceModel.communication];
                deviceModel.isConnect = [LxmBLEManager.shareManager isConnectWithTongXinId:deviceModel.communication];
                
                deviceModel.step = p.step;
                deviceModel.power = p.power;
                
                if (deviceModel.type.intValue == 1) {//主机
                    LxmBLEManager.shareManager.masterTongXinId = deviceModel.communication;
                    selfWeak.mainModel = deviceModel;
                } else {//子机
                     [_deviceArr1 addObject:deviceModel];
                }
            }
            [selfWeak.tableView reloadData];
            LxmBLEManager.shareManager.serverDeviceArr = tmpArr;
            [LxmBLEManager.shareManager connectServerDeviceIfNeed];
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    _deviceArr = [LxmBLEManager.shareManager.serverDeviceArr copy];
    if (self.currentModel) {
           
       } else {
           self.type = @1;
           if (self.deviceArr.count == 1) {
               self.selectDeviceView.titleLabel.text = @"暂无子机";
           } else {
               self.selectDeviceView.titleLabel.text = self.deviceArr[1].equNickname;
               self.currentModel = self.deviceArr[1];
               [self getAllDate];
               [self getDayDistance:[NSString getFommateYMD:[NSDate date]]];
           }
       }
    
//    这就是列表 代码写这里就好了 每次进去都会更新
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.tableView.bounds.size.width - 30, 20)];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = CharacterGrayColor;
        NSAttributedString *at1 = [[NSAttributedString alloc] initWithString:@" 0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *at2 = [[NSAttributedString alloc] initWithString:@"次" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"超出距离次数记录:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
        [att appendAttributedString:at1];
        [att appendAttributedString:at2];
        _textLabel.attributedText = att;
    }
    return _textLabel;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, self.tableView.bounds.size.width - 30, 20)];
        _textLabel1.font = [UIFont systemFontOfSize:14];
        _textLabel1.textColor = CharacterGrayColor;
        NSAttributedString *at1 = [[NSAttributedString alloc] initWithString:@" 0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *at2 = [[NSAttributedString alloc] initWithString:@"米" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"超出最远距离:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
        [att appendAttributedString:at1];
        [att appendAttributedString:at2];
        _textLabel1.attributedText = att;
    }
    return _textLabel1;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, NavigationSpace + 145 + 44)];
        _topView.backgroundColor = BlueColor;
    }
    return _topView;
}

- (LxmDataNavView *)navView {
    if (!_navView) {
        _navView = [[LxmDataNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, NavigationSpace)];
        _navView.backgroundColor = [UIColor clearColor];
        _navView.backButton.hidden = YES;
        _navView.rightButton.hidden = NO;
        _navView.titleLabel.hidden = YES;
        [_navView.rightButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_navView.rightButton addTarget:self action:@selector(tongbuClick:) forControlEvents:UIControlEventTouchUpInside];
        WeakObj(self);
        _navView.didSelectButton = ^(BOOL isDistance) {
            [selfWeak navClick:isDistance];
        };
    }
    return _navView;
}

- (XMCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[XMCalendarView alloc] initWithFrame:CGRectMake(0, NavigationSpace, ScreenW, 145)];
        _calendarView.delegate = self;
        WeakObj(self);
        _calendarView.selectYearBlock = ^(XMCalendarDataSource *dataSourceModel) {
            [selfWeak getAllDate];
        };
    }
    return _calendarView;
}

- (void)xmCalendarSelectDate:(NSDate *)date  dateSource:(NSMutableArray<XMCalendarModel*> *)dataSource {
    if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
        [SVProgressHUD showErrorWithStatus:@"数据正在同步请稍后..."];
        return;
    }
    
    NSLog(@"%@", date);
    for (XMCalendarModel *model in dataSource) {
        NSString *currentStr = [NSString getFommateYMD:date];
        NSString *dateStr = [NSString getFommateYMD:model.date];
       if ([currentStr isEqualToString:dateStr]) {
           model.isCurrent = YES;
       }else{
           model.isCurrent = NO;
       }
    }
    [self.calendarView setRefreshData];
    NSDate *preDate = self.currentDate;
    self.preDate = preDate;
    self.currentDate = date;
    [self getAllDate];
    if (self.type.intValue == 1) {//距离
        if ([preDate compare:self.currentDate] != NSOrderedSame) {
            [self getDayDistance:[NSString getFommateYMD:date]];
        }
    } else if (self.type.intValue == 2) {//获取指定日期的计步数据
        if ([preDate compare:self.currentDate] != NSOrderedSame) {
            [self getJibuData:[NSString getFommateYMD:date]];
        }
    }
}

- (LxmDataSelectView *)selectDeviceView {
    if (!_selectDeviceView) {
        _selectDeviceView = [[LxmDataSelectView alloc] initWithFrame:CGRectMake(0, NavigationSpace + 145, ScreenW, 44)];
        _selectDeviceView.backgroundColor = [UIColor whiteColor];
        [_selectDeviceView addTarget:self action:@selector(selectZiJiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDeviceView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (ZFBarChart *)barChart {
    if (!_barChart) {
        _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0,  0, self.view.bounds.size.width, self.view.bounds.size.height - (NavigationSpace + 145 + 44 + 40 + 64) )];
        _barChart.dataSource = self;
        _barChart.delegate = self;
        _barChart.isShowAxisArrows = NO;
        _barChart.topicLabel.hidden = YES;
        _barChart.unit = @"米";
        _barChart.valueType = kValueTypeDecimal;
        _barChart.isShadow = NO;
        _barChart.xLineNameLabelToXAxisLinePadding = 50;
        _barChart.isShowYLineSeparate = YES;
        _barChart.unitColor = CharacterLightGrayColor;
        _barChart.xAxisColor = LineColor;
        _barChart.yAxisColor = LineColor;
        _barChart.separateColor = LineColor;
        _barChart.axisLineNameColor = CharacterLightGrayColor;
        _barChart.axisLineValueColor = CharacterLightGrayColor;
        [self.view addSubview:_barChart];
        [_barChart strokePath];
    }
    return _barChart;
}

- (UIImageView *)xinShouImgView {
    if (!_xinShouImgView) {
        _xinShouImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _xinShouImgView.image = [UIImage imageNamed:@"datavc1"];
        _xinShouImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_xinShouImgView addGestureRecognizer:tap];
    }
    return _xinShouImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [LxmBLEManager shareManager];
    self.deviceArr1 = [NSMutableArray array];
    [self loadData];
    
    [self newerJiaocheng];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.calendarView];
    [self.topView addSubview:self.selectDeviceView];
    [self.view addSubview:self.navView];

    [self.view addSubview:self.barChart];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.textLabel1];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(15);
        make.leading.equalTo(self.view).offset(15);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(15);
    }];
    [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel1.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    
    self.lineTimes = [NSMutableArray array];
    self.lineDistance = [NSMutableArray array];
    
    self.jibuDates = [NSMutableArray array];
    self.jibuBuShuAr = [NSMutableArray array];
    
    self.preDate = [NSDate date];
    self.currentDate = [NSDate date];
    [self.barChart strokePath];
    WeakObj(self);
    [LxmEventBus registerEvent:@"TongbuSuccess" block:^(id data) {
        [selfWeak getAllDate];
        if (selfWeak.type.intValue == 1) {//距离
            [selfWeak getDayDistance:[NSString getFommateYMD:selfWeak.currentDate]];
        } else if (selfWeak.type.intValue == 2) {//获取指定日期的计步数据
            [selfWeak getJibuData:[NSString getFommateYMD:selfWeak.currentDate]];
        }
    }];
}

- (void)getAllDate {
    NSMutableArray *arr = [NSMutableArray array];
    for (XMCalendarModel *model in self.calendarView.dataSourceModel.dataSource) {
        NSString *date = [NSString getFommateYMD:model.date];
        [arr addObject:date];
    }
    [self isHaveData:arr];
}

//获取 本月每一天是否有数据
- (void)isHaveData:(NSArray *)arr {
    NSString *allTime = [arr componentsJoinedByString:@","];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"communication"] = self.currentModel.communication;
    dict[@"allTime"] = allTime;
    dict[@"token"] = LxmTool.ShareTool.session_token;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:user_getIsHaveData parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 这里写耗时操作
                NSArray *tempArr = responseObject[@"result"][@"isHaveData"];
                if ([tempArr isKindOfClass:NSArray.class]) {
                    for (NSDictionary *d in tempArr) {
                        LxmDateModel *model = [LxmDateModel mj_objectWithKeyValues:d];
                        model.date = [NSString dataFommatWithStr:model.time];
                        for (XMCalendarModel *m in selfWeak.calendarView.dataSourceModel.dataSource) {
                            if ([model.date compare:m.date] == NSOrderedSame) {
                                m.type = selfWeak.type;
                                m.isHaveDistanceDate = model.isHaveDistance.boolValue;
                                m.isHaveJiBuDate = model.isHaveStep.boolValue;
                            }
                        }
                    }
                }
               dispatch_async(dispatch_get_main_queue(), ^{
                   // 这里回到主线程刷新table
                   [selfWeak.calendarView setRefreshData];
               });
            });
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//获取最近三天的计步数据
- (void)getJibuData:(NSString *)time {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"time"] = time;
    dict[@"token"] = LxmTool.ShareTool.session_token;
    dict[@"communication"] = self.currentModel.communication;
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_getNearStepData parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                WeakObj(self);
                NSString *maxStepNum = responseObject[@"result"][@"maxStepNum"];
                _jibuTotol = maxStepNum;
                
                NSAttributedString *at1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @" %d",maxStepNum.intValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:CharacterDarkColor}];
                NSAttributedString *at2 = [[NSAttributedString alloc] initWithString:@"步" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"计步总数:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
                [att appendAttributedString:at1];
                [att appendAttributedString:at2];
                _textLabel.attributedText = att;
                
                // 这里写耗时操作
                NSArray *arr = responseObject[@"result"][@"stepNum"];
                [selfWeak.jibuDates removeAllObjects];
                [selfWeak.jibuBuShuAr removeAllObjects];
                for (NSDictionary *d in arr) {
                LxmDateJibuModel *model = [LxmDateJibuModel mj_objectWithKeyValues:d];
                [selfWeak.jibuDates addObject:model.time];
                [selfWeak.jibuBuShuAr addObject:model.stepNum];
            }
            // 这里回到主线程刷新table
            [selfWeak.jibuDates addObject:@"h"];
            [selfWeak.jibuBuShuAr addObject:@"0"];
            [selfWeak.barChart strokePath];
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//获取指定日期的距离数据
- (void)getDayDistance:(NSString *)day {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"time"] = day;
    dict[@"token"] = LxmTool.ShareTool.session_token;
    dict[@"communication"] = self.currentModel.communication;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:user_getDistanceData parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            NSString *time = responseObject[@"result"][@"overTimes"];
            NSString *maxDistance = responseObject[@"result"][@"overMaxDistance"];
            NSAttributedString *at1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @" %d",time.intValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *at2 = [[NSAttributedString alloc] initWithString:@"次" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"超出距离次数记录:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
            [att appendAttributedString:at1];
            [att appendAttributedString:at2];
            _textLabel.attributedText = att;
            
            NSAttributedString *at3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @" %@",maxDistance] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:CharacterDarkColor}];
            NSAttributedString *at4 = [[NSAttributedString alloc] initWithString:@"米" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:@"超出最远距离:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CharacterGrayColor}];
            [att1 appendAttributedString:at3];
            [att1 appendAttributedString:at4];
            _textLabel1.attributedText = att1;
            
            // 这里写耗时操作
            NSArray *arr = responseObject[@"result"][@"distanceList"];
//            NSDictionary *dict = [str mj_JSONObject];
            if ([arr isKindOfClass:NSArray.class]) {
                [selfWeak.lineTimes removeAllObjects];
                [selfWeak.lineDistance removeAllObjects];
               
                for (NSDictionary *d in arr) {
                    LxmDateDistanceModel *model = [LxmDateDistanceModel mj_objectWithKeyValues:d];
                    [selfWeak.lineTimes addObject:model.timeStr];
                    [selfWeak.lineDistance addObject:model.distanceDouble];
                }
                // 这里回到主线程刷新table
                [selfWeak.lineTimes addObject:@"h"];
                [selfWeak.lineDistance addObject:@"0"];
                [selfWeak.barChart strokePath];
            }
            
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 新手教程
 */
- (void)newerJiaocheng {
    NSNumber *isfirst = [NSUserDefaults.standardUserDefaults objectForKey:@"dataIsfirst"];
    if (!isfirst.boolValue) {
        self.count = 0;
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window addSubview:self.xinShouImgView];
        [NSUserDefaults.standardUserDefaults setObject:@1 forKey:@"dataIsfirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 点击事件
 */
- (void)tapClick:(UITapGestureRecognizer *)tap {
    self.count ++ ;
    if (self.count == 1) {
        self.xinShouImgView.image = [UIImage imageNamed:@"datavc2"];
    } else {
        self.count = 0;
        [self.xinShouImgView removeFromSuperview];
    }
}


- (void)selectZiJiClick {
    if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
        [SVProgressHUD showErrorWithStatus:@"数据正在同步,请稍后..."];
        return;
    }
    
    LxmSelectZiJiAlertView *alertView = [[LxmSelectZiJiAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    alertView.type = self.type;
    alertView.deviceArr = self.deviceArr;
    
    WeakObj(self);
    alertView.didSelectSubDeviceClick = ^(LxmDeviceModel *device) {
        if (device.type.intValue == 1) {//主机
            selfWeak.currentSubModel = selfWeak.currentModel;
        }
        selfWeak.currentModel = device;
        [selfWeak getAllDate];
        selfWeak.selectDeviceView.titleLabel.text = device.equNickname;
        if (selfWeak.type.intValue == 1) {//距离
            [selfWeak getDayDistance:[NSString getFommateYMD:selfWeak.currentDate]];
        } else if (selfWeak.type.intValue == 2) {//获取指定日期的计步数据
            [selfWeak getJibuData:[NSString getFommateYMD:selfWeak.currentDate]];
        }
    };
    [alertView show];
}

/**
 导航栏点击的是距离还是计步

 @param isjuli yes 距离 no 计步
 */
- (void)navClick:(BOOL)isjuli {
    if (isjuli) {
          if (self.currentModel.type.intValue == 1) {
              self.selectDeviceView.titleLabel.text = self.currentSubModel.equNickname;
              self.currentModel = self.currentSubModel;
           }
        [self getAllDate];
        self.type = @1;
        _barChart.valueType = kValueTypeDecimal;
        _barChart.unit = @"米";
        _textLabel1.hidden = NO;
        for (XMCalendarModel *m in self.calendarView.dataSourceModel.dataSource) {
            m.type = @1;
        }
        [self.calendarView setRefreshData];
        
        if (self.deviceArr.count == 1) {
            self.selectDeviceView.titleLabel.text = @"暂无子机";
        } else {
            [self getDayDistance:[NSString getFommateYMD:self.currentDate]];
        }
        self.navView.juliButton.selected = YES;
        self.navView.jibuButton.selected = NO;
        
    } else {
        [self getAllDate];
        self.type = @2;
        _barChart.valueType = kValueTypeInteger;
        _barChart.unit = @"步";
        _textLabel1.hidden = YES;
        if (!self.currentModel) {
            [self getJibuData:[NSString getFommateYMD:self.currentDate]];
        }
        
        for (XMCalendarModel *m in self.calendarView.dataSourceModel.dataSource) {
            m.type = @2;
        }
        [self.calendarView setRefreshData];
        [self getJibuData:[NSString getFommateYMD:self.currentDate]];
        self.navView.juliButton.selected = NO;
        self.navView.jibuButton.selected = YES;
        
    }
}

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart {
    if (self.type.intValue == 1) {
        return self.lineDistance;
    } else {
        return self.jibuBuShuAr;
    }
}

//返回名称数组(NSArray必须存储NSString类型)
- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    if (self.type.intValue == 1) {
        return self.lineTimes;
    } else {
        return self.jibuDates;
    }
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    if (chart == _barChart) {
        NSMutableArray *colorArr = [NSMutableArray array];
        for (int i = 0; i < self.lineTimes.count; i++) {
            [colorArr addObject:BlueColor];
        }
        return colorArr;
        
    } else {
        UIColor *color = [UIColor colorWithRed:250/255.0 green:208/255.0 blue:110/255.0 alpha:1];
        NSMutableArray *colorArr = [NSMutableArray array];
        for (int i = 0; i < self.jibuDates.count; i++) {
            [colorArr addObject:color];
        }
        return colorArr;
    }
    
}

/**
 *  bar宽度(若不设置，默认为25.f)
 */
- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart {
    return 10;
}

/**
 *  每组里面，bar与bar之间的间距(若不设置，默认为5.f)(当只有一组数组时，此方法无效)
 */
- (CGFloat)paddingForBarInBarChart:(ZFBarChart *)barChart {
    return 1;
}

#pragma mark - ZFGenericChartDataSource

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

@end
