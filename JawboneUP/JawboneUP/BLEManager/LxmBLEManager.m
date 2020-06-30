//
//  LxmBLEManager.m
//  JawboneUP
//
//  Created by 宋乃银 on 2017/10/28.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmBLEManager.h"
#import "LxmDataManager.h"
#import "CBPeripheral+MAC.h"
#import "LxmEventBus.h"
#import "AudioToolbox/AudioToolbox.h"
#import "LxmBLEManager+Tongbu.h"
@interface LxmBLEManager ()<CBCentralManagerDelegate,CBPeripheralDelegate> {
    NSMutableArray<CBPeripheral *> *_devices;

    VersionCallBack _versionCallback;
    CommunicationListCallBack _tongxinIdListCallback;

    setPeripheralNameCallBack _setNameCallBack;
    
    setSubPeripheralPhoneCallBack _setPhoneCallBack;

    OpenOrCloseCallBack _openOrCloseCallBack;
    NSTimer *_powerTimer;
    NSTimer *_jibuTimer;
    NSTimer *_tongbuDataTimer;
}



@end


@implementation LxmBLEManager

+ (instancetype)shareManager {
    static LxmBLEManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LxmBLEManager new];
    });
    return manager;
}

//电量2分钟查询一次 计步10分钟查询一次
- (void)starJibuTimer {
    [_jibuTimer invalidate];
    _jibuTimer = nil;
    _jibuTimer = [NSTimer scheduledTimerWithTimeInterval:10*60 target:self selector:@selector(jibuTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_jibuTimer forMode:NSRunLoopCommonModes];
}

- (void)startPowerTimer {
    [_powerTimer invalidate];
    _powerTimer = nil;
    _powerTimer = [NSTimer scheduledTimerWithTimeInterval:2*60 target:self selector:@selector(powerTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_powerTimer forMode:NSRunLoopCommonModes];
}

- (void)startTongbuDataTimer {
    [_tongbuDataTimer invalidate];
    _tongbuDataTimer = [NSTimer scheduledTimerWithTimeInterval:2*60*60 target:self selector:@selector(backgroundTongbuData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_tongbuDataTimer forMode:NSRunLoopCommonModes];
}

- (void)backgroundTongbuData {
    [self tongbuDataShowHUD:NO];
}

// 定时器逻辑 每隔5s 查询一次电量 步数 距离等
- (void)powerTimer:(NSTimer *)timer {
    if (_devices.count > 0 && !self.isTongbuDistance && !self.isTongbuStep) {
        NSArray *arr = [NSArray arrayWithArray:_devices];
        BOOL isHaveDisconnect = NO;
        for (CBPeripheral *p in arr) {
            if (p.state != CBPeripheralStateConnected) {
                isHaveDisconnect = YES;
                break;
            }
        }
        if (isHaveDisconnect) {
           [self nowCheckPowerForPer:LxmBLEManager.shareManager.master];
        } else {
            for (CBPeripheral *p in arr) {
                [self nowCheckPowerForPer:p]; // 查询电量
            }
        }

    }
}

- (void)jibuTimer:(NSTimer *)timer {
    if (_devices.count > 0 && !self.isTongbuDistance && !self.isTongbuStep) {
        NSArray *arr = [NSArray arrayWithArray:_devices];
        for (CBPeripheral *p in arr) {
            [self nowCheckStepForPer:p]; // 查询步数
        }
    }
}

- (void)nowCheckPowerForPer:(CBPeripheral *)p {
    if (p.state != CBPeripheralStateConnected) {
        return;
    }
    CBCharacteristic *fff6 = [self fff6ForPer:p];
    if (fff6) {
        NSData *data = [LxmDataManager checkPower];
        [p writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)nowCheckStepForPer:(CBPeripheral *)p {
    if (p.state != CBPeripheralStateConnected) {
        return;
    }
    CBCharacteristic *fff6 = [self fff6ForPer:p];
    if (fff6) {
        NSData *data = [LxmDataManager chaxunDeviceBuShu];
        [p writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)tongbuDateForPer:(CBPeripheral *)per {
    if (per.state != CBPeripheralStateConnected) {
        return;
    }
    CBCharacteristic *fff6 = [self fff6ForPer:per];
    if (fff6) {
        NSData *data = [LxmDataManager tongbuTimeData];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}

/// 同步安全距离
- (void)tongbuSafeDistance:(CBPeripheral *)per {
    if (per.state != CBPeripheralStateConnected) {
        return;
    }
    CBCharacteristic *fff6 = [self fff6ForPer:per];
    if (fff6) {
        NSData *data = [LxmDataManager syncSafeDistance];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}


- (void)chaxunBuShuSevenDayData:(CBPeripheral *)per completed:(void(^)(NSDictionary<NSString *, NSString *> *dates))completed {
    if (per.state != CBPeripheralStateConnected) {
        per.stepDatesCallback = nil;
        if (completed) {
            completed(nil);
        }
        return;
    }
    if (per.stepDates.count > 0) {
        per.stepDatesCallback = completed;
        [per runStepDatesCallback];
    } else {
        CBCharacteristic *fff6 = [self fff6ForPer:per];
        if (fff6) {
            per.stepDatesCallback = completed;
            NSData *data = [LxmDataManager chaxunBuShuDate];
            [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
            [per cancelStepDatesCallbackAfter:20];
        } else {
            per.stepDatesCallback = completed;
            [per runStepDatesCallback];
        }
    }
}

- (void)chaxunDistanceSevenDayData:(CBPeripheral *)per completed:(void(^)(NSDictionary<NSString *, NSString *> *dates))completed {
    if (per.state != CBPeripheralStateConnected) {
        per.distanceDatesCallback = nil;
        if (completed) {
            completed(nil);
        }
        return;
    }
    if (per.distanceDates.count > 0) {
        per.distanceDatesCallback = completed;
        [per runDistanceDatesCallback];
    } else {
        CBCharacteristic *fff6 = [self fff6ForPer:per];
        if (fff6) {
            per.distanceDatesCallback = completed;
            NSData *data = [LxmDataManager chaxunDistanceDate];
            [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
            [per cancelDistanceDatesCallbackAfter:20];
        } else {
            per.distanceDatesCallback = completed;
            [per runDistanceDatesCallback];
        }
    }
}

// 更新整体连接状态
- (void)connectServerDeviceIfNeed {
    NSArray *array = [self.deviceList copy];
    for (CBPeripheral *p in array) {
        BOOL isExist = NO;
        for (LxmDeviceModel *model in self.serverDeviceArr) {
            if ([p.tongxinId isEqualToString:model.communication]) {
                isExist = YES;
                break;
            }
        }
        if (isExist) {
            [self connectPeripheral:p];
        }
    }
}

- (void)disConnectTempDeviceIfNeed {
    NSArray *array = [self.deviceList copy];
    for (CBPeripheral *p in array) {
        BOOL isExist = NO;
        for (LxmDeviceModel *model in self.serverDeviceArr) {
            if ([p.tongxinId isEqualToString:model.communication]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [self disConnectPeripheral:p];
        }
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    if (@available(iOS 9.0, *)) {
        if (peripheral && (peripheral.state == CBPeripheralStateDisconnected || peripheral.state == CBPeripheralStateDisconnecting)) {
            [self.centralManager connectPeripheral:peripheral options:nil];
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)disConnectPeripheral:(CBPeripheral *)peripheral {
    if (peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _devices = [NSMutableArray array];
        [self centralManager];
        [self startPowerTimer];
        [self starJibuTimer];
        [self startTongbuDataTimer];
    }
    return self;
}

/**
 根据通信Id获取 设备
 */
- (CBPeripheral *)peripheralWithTongXinId:(NSString *)tongXinId {
    if (!tongXinId) {
        return nil;
    }
    CBPeripheral *p = nil;
    if (tongXinId) {
        for (CBPeripheral *temp in self.deviceList) {
            if ([temp.tongxinId isEqualToString:tongXinId]) {
                p = temp;
                break;
            }
        }
    }
    
    return p;
}

/**
 根据通信Id查询该设备是否已经连接
 */
- (BOOL)isConnectWithTongXinId:(NSString *)tongXinId {
    CBPeripheral *p = [self peripheralWithTongXinId:tongXinId];
    return p.state == CBPeripheralStateConnected;
}

- (void)sendConnectStateChangeNotiForPeripheral:(CBPeripheral *)p {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = p.tongxinId;
    dict[@"isConnected"] = @(p.state == CBPeripheralStateConnected);
    [LxmEventBus sendEvent:LxmDeviceConnectDidChangeNoti data:dict];
}

- (void)sendLxmDeviceShuaXinDistanceNotiFor:(NSString *)tongxinId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    [LxmEventBus sendEvent:LxmDeviceShuaXinDistanceNoti data:dict];
}

- (void)sendDistanceChangeNotiForTongXinId:(NSString *)tongxinId distance:(CGFloat)distance {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    dict[@"distance"] = @(distance);
    [LxmEventBus sendEvent:LxmDeviceDistanceDidChangeNoti data:dict];
}

- (void)sendLxmDeviceSafeDistanceNotiForTongXinId:(NSString *)tongxinId safeDistance:(CGFloat)safeDistance isRealTime:(NSString *)isRealTime {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    dict[@"safeDistance"] = @(safeDistance);
    dict[@"isRealTime"] = isRealTime;
    [LxmEventBus sendEvent:LxmDeviceSafeDistanceNoti data:dict];
}

- (void)sendCeJuSwitchChangeNotiForTongXinId:(NSString *)tongxinId isRealTime:(NSString *)isRealTime {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    dict[@"isRealTime"] = isRealTime;
    [LxmEventBus sendEvent:LxmDeviceCeJuSwitchDidChangeNoti data:dict];
}

- (void)sendCeJuSwitchChangeNotiForTongXinId1{
    [LxmEventBus sendEvent:LxmDeviceCeJuSwitchDidChangeNoti1 data:nil];
}


- (void)sendPowerChangeNotiForTongXinId:(NSString *)tongxinId power:(NSInteger)power  {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    dict[@"power"] = @(power);
    [LxmEventBus sendEvent:LxmDevicePowerDidChangeNoti data:dict];
}


- (void)sendStepChangeNotiForTongXinId:(NSString *)tongxinId step:(NSInteger)step {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"tongxinId"] = tongxinId;
    dict[@"step"] = @(step);
    [LxmEventBus sendEvent:LxmDeviceStepDidChangeNoti data:dict];
}

- (CBCentralManager *)centralManager {
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _centralManager;
}

- (void)connectPeripheral:(CBPeripheral *)per completed:(ConnectCallback)completed {
    per.connectCallback = completed;
    [self.centralManager connectPeripheral:per options:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelConnect:) object:per];
    [self performSelector:@selector(cancelConnect:) withObject:per afterDelay:6];
}

- (void)cancelConnect:(CBPeripheral *)per {
    if (per.connectCallback) {
        per.connectCallback(NO,nil);
        per.connectCallback = nil;
    }
}

- (CBCharacteristic *)fff6ForPer:(CBPeripheral *)per {
    if (per.state != CBPeripheralStateConnected) {
        return nil;
    }
    CBCharacteristic *fff6 = nil;
    for (CBService *service in per.services) {
        BOOL have = NO;
        for (CBCharacteristic *chara in service.characteristics) {
            NSLog(@"%@", chara.UUID.UUIDString);
            if ([chara.UUID.UUIDString isEqualToString:@"FFF6"]) {
                fff6 = chara;
                have = YES;
                break;
            }
        }
        if (have) {
            break;
        }
    }
    return fff6;
}

- (void)checkIsMaster:(CBPeripheral *)per completed:(MasterCallback)completed {
    if (per.state != CBPeripheralStateConnected) {
        if (completed) {
            completed(NO, NO);
        }
        return;
    }
    CBCharacteristic *fff6 = [self fff6ForPer:per];
    if (fff6) {
        per.masterCallback = completed;
        NSData *data = [LxmDataManager getRoleInfo];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelCheckIsMaster:) object:per];
        [self performSelector:@selector(cancelCheckIsMaster:) withObject:per afterDelay:6];
    } else {
        if (completed) {
            completed(NO, NO);
        }
    }
}

- (void)cancelCheckIsMaster:(CBPeripheral *)p {
    if (p.masterCallback) {
        p.masterCallback(NO,NO);
        p.masterCallback = nil;
    }
}

/**
 获取版本号
 */
- (void)checkVersion:(CBPeripheral *)per completed:(VersionCallBack)completed {
    if (!per || per.state != CBPeripheralStateConnected || (per.hVersion && per.fVersion)) {
        if (completed) {
            completed(NO, per.hVersion, per.fVersion);
        }
        return;
    }
    CBCharacteristic * fff6 = [self fff6ForPer:per];
    if (fff6) {
        _versionCallback = completed;
        NSData *data = [LxmDataManager getHardwareVersion];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [self performSelector:@selector(cancleGetVersion) withObject:nil afterDelay:6];
    } else {
        if (completed) {
            completed(NO,nil,nil);
        }
    }
}

/**
 新增查询步数指令 查询步数指令，APP 发送给设备（子机或者母机）
 */
- (void)checkStep:(CBPeripheral *)p  date:(NSString *)date completed:(BuShuCallBlock)completed {
    if (p.state != CBPeripheralStateConnected) {
        p.bushuChaXunBack = nil;
        if (completed) {
            completed(p, nil);
        }
        return;
    }
    [p.stepDict removeAllObjects];
    CBCharacteristic * fff6 = [self fff6ForPer:p];
       if (fff6) {
           p.bushuChaXunBack = completed;
           NSData *data = [LxmDataManager chaxunBuShuWithDate:date];
           [p writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
           [p cancelBuShuCallBlockAfter:20];
       } else {
           p.bushuChaXunBack = completed;
           [p runBuShuCallBlock];
       }
}

/**
 新增查询步数指令 查询步数指令，APP 发送给设备（子机或者母机）
 */
- (void)checkDistance:(CBPeripheral *)p  date:(NSString *)date completed:(BuShuCallBlock)completed {
    if (p.state != CBPeripheralStateConnected) {
        p.bushuChaXunBack = nil;
        if (completed) {
            completed(p, nil);
        }
        return;
    }
    [p.distanceDict removeAllObjects];
    CBCharacteristic * fff6 = [self fff6ForPer:p];
       if (fff6) {
           p.distanceChaXunBack = completed;
           NSData *data = [LxmDataManager chaxunDistanceWithDate:date];
           [p writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
           [p cancelDistanceCallbackAfter:20];
       } else {
           p.distanceChaXunBack = completed;
           [p runDistanceCallback];
       }
}

/**
 获取通讯ID列表
 */
- (void)getCommunicationListForPer:(CBPeripheral *)per completed:(CommunicationListCallBack)completed {
    if (!per || per.state != CBPeripheralStateConnected) {
        completed(NO, per);
        return;
    }
    CBCharacteristic * fff6 = [self fff6ForPer:per];
    if (fff6) {
        _tongxinIdListCallback = completed;
        NSData *data = [LxmDataManager readAuthorizationIDList];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [self performSelector:@selector(cancelGetTongxinIDList) withObject:nil afterDelay:6];
    }else{
        if (completed) {
            completed(NO,nil);
        }
    }
}

- (void)cancelGetTongxinIDList {
    if (_tongxinIdListCallback) {
        _tongxinIdListCallback(NO,nil);
        _tongxinIdListCallback = nil;
    }
}

- (void)cancleGetVersion{
    if (_versionCallback) {
        _versionCallback(NO,nil,nil);
        _versionCallback = nil;
    }
}
- (void)setAlert:(CBPeripheral *)per alertType:(int)type completed:(SetValueCallBack)completed {
    if (per.state != CBPeripheralStateConnected) {
        per.bushuChaXunBack = nil;
        if (completed) {
            completed(NO, @"设备未连接");
        }
        return;
    }
    CBCharacteristic * fff6 = [self fff6ForPer:per];
    if (fff6) {
        per.setAlertCallBack = completed;
        NSData *data = [LxmDataManager overDistance:[NSString stringWithFormat:@"0%@",@(type)]];
        [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [self performSelector:@selector(cancelSetAlert:) withObject:per afterDelay:6];
    }else{
        if (completed) {
            completed(NO, @"设备未连接");
        }
    }
}

- (void)cancelSetAlert:(CBPeripheral *)per {
    if (per.setAlertCallBack) {
        per.setAlertCallBack(NO, nil);
        per.setAlertCallBack = nil;
    }
}

- (void)addDevice:(CBPeripheral *)p1 deviceName:(NSString *)name toDevice:(CBPeripheral *)p2 completed:(SetValueCallBack)completed {
    CBCharacteristic * fff6 = [self fff6ForPer:p2];
    if (fff6) {
        p2.addSubDeviceCallback = completed;
        NSData *namedata = [name GB2312Data];
        NSData *data = [LxmDataManager letSubIDToFather:p1.tongxinId nameData:namedata];
        [p2 writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelAddSubDevice:) object:p2];
        [self performSelector:@selector(cancelAddSubDevice:) withObject:p2 afterDelay:6];
    } else{
        if (completed) {
            completed(NO,@"添加子机失败");
        }
    }
}
- (void)cancelAddSubDevice:(CBPeripheral *)p {
    if (p.addSubDeviceCallback) {
        p.addSubDeviceCallback(NO, @"添加子机超时");
        p.addSubDeviceCallback = nil;
    }
}



- (void)delDevice:(CBPeripheral *)p1 fromDevice:(CBPeripheral *)p2 completed:(SetValueCallBack)completed {
    CBCharacteristic * fff6 = [self fff6ForPer:p2];
    if (fff6) {
        p2.deleteSubDeviceCallback = completed;
        NSData *data = [LxmDataManager deleteIDFromList:p1.tongxinId];
        [p2 writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelDelSubDevice:) object:p2];
        [self performSelector:@selector(cancelDelSubDevice:) withObject:p2 afterDelay:6];
    }else{
        if (completed) {
            completed(NO,@"删除子机失败");
        }
    }
}

- (void)cancelDelSubDevice:(CBPeripheral *)p {
    if (p.deleteSubDeviceCallback) {
        p.deleteSubDeviceCallback(NO,@"删除子机超时");
        p.deleteSubDeviceCallback = nil;
    }
}



- (void)setDistance:(NSString *)tongxinID distance:(NSInteger)distance completed:(SetValueCallBack)completed {
    if (!self.master) {
        if (completed) {
            completed(NO,@"设置距离失败");
        }
        return;
    }
    CBCharacteristic * fff6 = [self fff6ForPer:self.master];
    if (fff6) {
        self.master.setDistanceCallback = completed;
        NSData *data = [LxmDataManager setDistanceForID:tongxinID distance:distance];
        [self.master writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
        //暂时取消超时时间
        [self performSelector:@selector(cancelSetDistance:) withObject:self.master afterDelay:6];
    } else{
        if (completed) {
            completed(NO,@"设置距离失败");
        }
    }
}

- (void)cancelSetDistance:(CBPeripheral *)p {
    if (p.setDistanceCallback) {
        p.setDistanceCallback(NO, @"设置距离超时");
        p.setDistanceCallback = nil;
    }
}

/** 打开或关闭测距 */
- (void)openOrCloseRealDistance:(BOOL)isOpen peripheral:(CBPeripheral *)p communication:(NSString *)tongxinID completed:(OpenOrCloseCallBack)completed {
    if (!p) {
        return;
    }
    CBCharacteristic * fff6 = [self fff6ForPer:p];
    if (fff6) {
        _openOrCloseCallBack = completed;
        NSData *data = [LxmDataManager openOrClose:isOpen tongxinId:tongxinID];
        [p writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    } else {
        if (completed) {
            completed(NO, NO);
        }
    }
}

/** 设置设备名称 */
- (void)setDeviceName:(CBPeripheral *)per tongxinID:(NSString *)communication deviceName:(NSString *)name completed:(setPeripheralNameCallBack)completed {
    CBCharacteristic * fff6 = [self fff6ForPer:per];
    if (fff6) {
       _setNameCallBack = completed;
       NSData *namedata = [name GB2312Data];
       NSData * data = [LxmDataManager setDeviceName:communication nameData:namedata];
       [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }else{
       if (completed) {
           completed(NO,@"硬件名称更新失败!");
       }
    }
}

/** 设置子机的紧急联系电话 */
- (void)setSubDevicePhone:(CBPeripheral *)per phone:(NSString *)phone completed:(setSubPeripheralPhoneCallBack)completed {
    CBCharacteristic * fff6 = [self fff6ForPer:per];
    if (fff6) {
       _setPhoneCallBack = completed;
       NSData * data = [LxmDataManager setSubDevicePhone:phone];
       [per writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }else{
       if (completed) {
           completed(NO,@"子机紧急电话设置失败!");
       }
    }
}


- (void)cancelOpenOrClose:(CBPeripheral *)p {
    if (p.setDistanceCallback) {
        p.setDistanceCallback(NO, @"设置距离超时");
        p.setDistanceCallback = nil;
    }
}

- (void)openMasterCeju {
    CBCharacteristic *fff6 = [self fff6ForPer:self.master];
    if (fff6) {
        NSData *data = [LxmDataManager openDisntanceNoti];
        [self.master writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)closeMasterCeju {
    CBCharacteristic *fff6 = [self fff6ForPer:self.master];
    if (fff6) {
        NSData *data = [LxmDataManager closeDisntanceNoti];
        [self.master writeValue:data forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark - 同步数据


#pragma mark - CBCentralManagerDelegate
//蓝牙状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown: {
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙状态未知" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
             [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
        }
            break;
            
        case CBCentralManagerStateResetting:{
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙状态未知" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
             [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
        }
            break;
            
        case CBCentralManagerStateUnsupported: {
                UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"不支持蓝牙" preferredStyle:UIAlertControllerStyleAlert];
                [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
                 [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
            }
            break;
            
        case CBCentralManagerStateUnauthorized:{
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙未认证" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
             [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
        }
            break;
            
        case CBCentralManagerStatePoweredOff:{
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙已关闭" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
             [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
            for (CBPeripheral *peripheral in _devices) {
                [self sendConnectStateChangeNotiForPeripheral:peripheral];
            }
            [_devices removeAllObjects];
            self.deviceList = _devices;
            [LxmEventBus sendEvent:@"deviceListChanged" data:nil];
        }
            break;
            
        case CBCentralManagerStatePoweredOn: {
            UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙已开启" preferredStyle:UIAlertControllerStyleAlert];
            [controller1 addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
             [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:controller1 animated:YES completion:nil];
            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
            [_devices removeAllObjects];
            self.deviceList = _devices;
            [LxmEventBus sendEvent:@"deviceListChanged" data:nil];
        }
            break;
            
        default:
            break;
    }
}

//发现外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {

    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    if (data) {
        NSString *dataString = [LxmDataManager hexStringFromData:data];
        NSString *targetString = nil;
        if (dataString.length == 24) {
            targetString = [dataString substringWithRange:NSMakeRange(4, 20)];
        } else if (dataString.length == 20) {
            targetString = dataString;
        }
        if (targetString) {
            NSString *isMaster = [targetString substringWithRange:NSMakeRange(0, 2)];
            NSString *random = [targetString substringWithRange:NSMakeRange(2, 2)];
//            NSString *power = [targetString substringWithRange:NSMakeRange(4, 2)];
//                NSString *isBind = [targetString substringWithRange:NSMakeRange(6, 2)];
            NSString *tongxinId = [targetString substringWithRange:NSMakeRange(8, 12)];
            peripheral.tongxinId = tongxinId;
            peripheral.isMaster = [isMaster isEqualToString:@"02"];
//            peripheral.power = power;
            peripheral.randomKey = random;
        }
    }
    if (LxmTool.ShareTool.isLogin) {
        if (![_devices containsObject:peripheral]) {
            [_devices addObject:peripheral];
            self.deviceList = _devices;
            [LxmEventBus sendEvent:@"deviceListChanged" data:nil];
          }
          [self connectServerDeviceIfNeed];
    }
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"FFF0"]]];
    [self sendConnectStateChangeNotiForPeripheral:peripheral];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelConnect:) object:peripheral];
    if (peripheral.connectCallback) {
        peripheral.connectCallback(NO,nil);
        peripheral.connectCallback = nil;
    }
    [self sendConnectStateChangeNotiForPeripheral:peripheral];
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self sendConnectStateChangeNotiForPeripheral:peripheral];
}

#pragma mark - CBPeripheralDelegate
//信号强度更新
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
}
//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"FFF0"]) {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"FFF6"]] forService:service];
            break;
        }
    }
}
//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic *cha in service.characteristics) {
        if ([cha.UUID.UUIDString isEqualToString:@"FFF6"]) {
            if ([peripheral.name hasPrefix:@"HT"] || [peripheral.name hasPrefix:@"ht"]) {
                [peripheral setNotifyValue:YES forCharacteristic:cha];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelConnect:) object:peripheral];
                if (peripheral.connectCallback) {
                    peripheral.connectCallback(YES, peripheral);
                    peripheral.connectCallback = nil;
                }
                
                [self nowCheckStepForPer:peripheral]; // 查询实时步数
                [self checkVersion:peripheral completed:nil]; // 查询版本号
                [self tongbuDateForPer:peripheral];// 同步当前时间
                
                [self nowCheckPowerForPer:peripheral]; // 查询电量
                if (peripheral.isMaster) {
                    // 查询子机列表
                    [self getCommunicationListForPer:peripheral completed:^(BOOL success, CBPeripheral *per) {
                        [self tongbuSafeDistance:peripheral];
                    }];
                }
            }
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSData *data = characteristic.value;

    Byte *resultByte = (Byte *)[data bytes];
    
    NSLog(@"datashi%@",data);
    if (data.length > 4) {
        Byte header = resultByte[0];
        if (header == 0x14) { // 查询指定时间的步数
            int xuhao = resultByte[1]; // 总总共3包数据  每包20字节 出去前两字节 剩下的18字节是9条有效数据（高八位和底八位）
            int num = (xuhao == 3 ? 6 : 9);
            for (int i = 0; i < num; i++) {
                Byte byte1 = resultByte[i * 2 + 2];
                Byte byte2 = resultByte[i * 2 + 1 + 2];
                if (byte1 == 0xFF && byte2 == 0xFF) {
                    int index = (xuhao - 1) * 9 + i;
                    peripheral.stepDict[@(index).stringValue] = @(0).stringValue;
                } else {
                    char bytes[]={byte1,byte2};
                    unsigned char by1 = (bytes[0] &0xff);//高8位
                    unsigned char by2 = (bytes[1] &0xff);//低8位
                    int step  = (by2 | (by1 << 8));
                    
                    int index = (xuhao - 1) * 9 + i;
                    if (index == 0) {
                        peripheral.stepDict[@(index).stringValue] = @(step).stringValue;
                    } else {
                        int stNum = 0;
                        for (int i = 0; i < index; i++) {
                            stNum += [peripheral.stepDict[@(i).stringValue] integerValue];
                        }
                        NSString *st = @(stNum).stringValue;
                        int tmpNum = step - st.intValue;
                        if (tmpNum < 0) {
                            tmpNum = 0;
                        }
                        peripheral.stepDict[@(index).stringValue] = @(tmpNum).stringValue;
                    }
                }
            }
            if (xuhao == 3) {
                [peripheral runBuShuCallBlock];
            }
        } else if (header == 0x15) { // 查询指定时间的距离
            int xuhao = resultByte[1]; // 总总共320包数据  每包20字节 出去前两字节 剩下的18字节是9条有效数据（高八位和底八位）
//            if (peripheral.distanceDict.count >= 255*9 && xuhao < 100) {
//                xuhao += 256;
//            }
            NSLog(@"-----序号-----计数:%d",xuhao);
            int num = (xuhao == 3 ? 8 : 9);
            for (int i = 0; i < num; i++) {
                if ((xuhao == 3 && i == 6) || (xuhao == 3 && i == 7)) {
                    //i=6 超出最远距离,i=7 超出最远距离的次数
                    Byte byte1 = resultByte[i * 2 + 2];
                    Byte byte2 = resultByte[i * 2 + 1 + 2];
                    if (byte1 == 0xFF && byte2 == 0xFF) {
                        if (i == 6) {
                            peripheral.farDistance = @"0";
                        } else {
                            peripheral.farNumDistance = @"0";
                        }
                    } else if (byte1 == 0xFF && byte2 == 0xFD) {
                        //无效数据
                        if (i == 6) {
                            peripheral.farDistance = @"0";
                        } else {
                            peripheral.farNumDistance = @"0";
                        }
                    } else {
                        char bytes[]={byte1,byte2};
                        unsigned char by1 = (bytes[0] &0xff);//高8位
                        unsigned char by2 = (bytes[1] &0xff);//低8位
                        int distance  = (by2 | (by1 << 8));
                        if (i == 6) {
                            peripheral.farDistance = @(distance).stringValue;
                        } else {
                            peripheral.farNumDistance = @(distance).stringValue;
                        }
                    }
                } else {
                    Byte byte1 = resultByte[i * 2 + 2];
                    Byte byte2 = resultByte[i * 2 + 1 + 2];
                    
                    int index = (xuhao - 1) * 9 + i;
                    if (byte1 == 0xFF && byte2 == 0xFF) {
                        peripheral.distanceDict[@(index).stringValue] = @(0).stringValue;
                    } else if (byte1 == 0xFF && byte2 == 0xFD) {
                        //无效数据
                        peripheral.distanceDict[@(index).stringValue] = @(0).stringValue;
                    } else {
                        char bytes[]={byte1,byte2};
                        unsigned char by1 = (bytes[0] &0xff);//高8位
                        unsigned char by2 = (bytes[1] &0xff);//低8位
                        int distance  = (by2 | (by1 << 8));
                        NSString *dd = @(distance).stringValue;
                        if (dd.length == 1) {
                            if (dd.intValue == 0) {
                                peripheral.distanceDict[@(index).stringValue] = @"0";
                            } else {
                                NSString *s = [NSString stringWithFormat:@"0.%@",dd];
                                peripheral.distanceDict[@(index).stringValue] = s;
                            }
                        } else if (dd.length == 2) {
                            NSString *one = [dd substringWithRange:NSMakeRange(0, 1)];
                            NSString *two = @".";
                            NSString *three = [dd substringWithRange:NSMakeRange(1, 1)];
                            if (three.intValue == 0) {
                                peripheral.distanceDict[@(index).stringValue] = one;
                            } else {
                                peripheral.distanceDict[@(index).stringValue] = [[one stringByAppendingString:two] stringByAppendingString:three];
                            }
                        } else if (dd.length == 3) {
                            NSString *one = [dd substringWithRange:NSMakeRange(0, 1)];
                            NSString *two = [dd substringWithRange:NSMakeRange(1, 1)];
                            NSString *three = [dd substringWithRange:NSMakeRange(2, 1)];
                            if (three.intValue == 0 ) {
                                 peripheral.distanceDict[@(index).stringValue] = [one stringByAppendingString:two];
                            } else {
                                peripheral.distanceDict[@(index).stringValue] = [[[one stringByAppendingString:two] stringByAppendingString:@"."] stringByAppendingString:three];
                            }
                        }
                    }
                }
            }
            if (xuhao == 3) {
                [peripheral runDistanceCallback];
            }
        }
        if (header == 0xEE)
        {
            NSString *hexString = [LxmDataManager hexStringFromData:data];
            NSLog(@"hexString:%@",hexString);
            Byte type = resultByte[2];
            switch (type) {
                case 0x01:
                {
                    Byte distance = resultByte[data.length-2];
                    BOOL success;
                    NSString *tips;
                    if (distance == 0x00) {
                        tips = @"距离设定成功";
                        success = YES;
                    }
                    else if (distance == 0x0E){
                        tips = @"通信列表中没有该ID";
                        success = NO;
                    }
                    else
                    {
                        tips = @"距离设定失败";
                        success = NO;
                    }
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelSetDistance:) object:nil];
                    if(peripheral.setDistanceCallback) {
                        peripheral.setDistanceCallback(success, tips);
                        peripheral.setDistanceCallback = nil;
                    }
                }
                    break;
                    
                case 0x02: {
//                    Byte hardwareID = resultByte[3];
//                     [NSString stringWithFormat:@"设定通信ID:%@",hardwareID == 0x00 ? @"成功":@"失败"];
                }
                    break;

                case 0x04: { //添加子机 原来resultByte[3]
                    NSString *tips;
                    BOOL success = NO;
                    Byte roleInfo = resultByte[3];
                    if (roleInfo == 0x00) {
                        tips = @"添加子机成功";
                        success = YES;
                    } else if (roleInfo == 0x01){
                        tips = @"该ID已经在列表";
                        success = YES;
                    } else if (roleInfo == 0x02){
                        tips = @"超过数量8";
                    } else {
                        tips = @"添加子机失败";
                    }
                    NSLog(@"123-%@", tips);
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelAddSubDevice:) object:peripheral];
                    if (peripheral.addSubDeviceCallback) {
                        peripheral.addSubDeviceCallback(success,tips);
                        peripheral.addSubDeviceCallback = nil;
                    }
                }
                    break;
                case 0x05: { //获取角色信息
                    Byte roleInfo = resultByte[3];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelCheckIsMaster:) object:peripheral];
                    if (peripheral.masterCallback) {
                        peripheral.masterCallback(YES, roleInfo != 0x01);
                        peripheral.masterCallback = nil;
                    }
                } break;
                    
                case 0x06: { //距离广播
                    int start = 3;
                    for (int i = 0; i < 8; i++) {
                        NSString *ID = peripheral.tongxinIds[[NSString stringWithFormat:@"%d", i]];
                        
                        void(^dataDellCodeBlock)(void) = ^(void){
                            NSLog(@"%@",data);
                            Byte byte1 = resultByte[i * 2 + start];
                             Byte byte2 = resultByte[i * 2 + 1 + start];
                            
                             if (byte1 == 0xFF && byte2 == 0xFF) {
                                 // 未绑定
                             } else if (byte1 == 0xff && byte2 == 0x0E) {
                                 // 已绑定，但未打开测距
                                 for (LxmDeviceModel *model in self.serverDeviceArr) {
                                     if ([model.communication isEqualToString:ID]) {
                                         NSLog(@"上报%@",model.distance);
                                         if (model.distance.intValue != -2 && model.isRealTime.intValue != 2) {
                                             model.isRealTime = @"2";
                                             NSLog(@"上报");
                                             [self sendCeJuSwitchChangeNotiForTongXinId1];
                                         }
                                         break;
                                     }
                                 }
                             } else if (byte1 == 0xff && byte2 == 0xFD) {
                                 // 已绑定，但设备已经掉线 需要报警
                                 CBPeripheral *p = [self peripheralWithTongXinId:ID];
                                 for (LxmDeviceModel *model in self.serverDeviceArr) {
                                     if ([model.communication isEqualToString:ID]) {
                                         p.distance = @"-1";
                                         model.distance = @(-1);
                                         [LxmEventBus sendEvent:@"playSound" data:nil];
                                         if (p.state == CBPeripheralStateConnected) {
                                             [self nowCheckPowerForPer:p];
                                         }
                                         break;
                                     }
                                 }
                             } else {
                                 NSString *subStr = [hexString substringWithRange:NSMakeRange(6, 32)];
                                 if ([subStr isEqualToString:@"f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2"]) {
                                     LxmBLEManager.shareManager.master.powerStatus = @2;
                                 } else if ([subStr isEqualToString:@"f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3"]) {
                                     LxmBLEManager.shareManager.master.powerStatus = @3;
                                 } else if ([subStr isEqualToString:@"f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4"]) {
                                     LxmBLEManager.shareManager.master.powerStatus = @4;
                                 } else {
                                     //正常情况
                                     LxmBLEManager.shareManager.master.powerStatus = @0;
                                     char bytes[]={byte1,byte2};
                                     unsigned char by1 = (bytes[0] &0xff);//高8位
                                     unsigned char by2 = (bytes[1] &0xff);//低8位
                                    
                                     CGFloat distance  = (by2 | (by1 << 8));
                                     CBPeripheral *p = [self peripheralWithTongXinId:ID];
                                     LxmDeviceModel *m = nil;
                                     for (LxmDeviceModel *model in self.serverDeviceArr) {
                                         m = model;
                                         break;
                                     }
                                     NSLog(@"设备:%@",p);
                                     NSLog(@"安全距离:%@",p.safeDistance);
                                     NSLog(@"实时距离:%lf",distance);
                                     
                                     if (m.safeDistance.isValid) {
                                         
                                         if (distance > m.safeDistance.floatValue) {
                                             if (m.safeDistance.intValue == 0) {
                                                 
                                             } else {
                                                 [LxmEventBus sendEvent:@"playSound" data:nil];
                                             }
                                             
                                         }
                                         [self sendDistanceChangeNotiForTongXinId:ID distance:distance];
                                     } else {
                                         for (LxmDeviceModel *model in self.serverDeviceArr) {
                                             if ([model.communication isEqualToString:ID]) {
                                                 if (model.safeDistance.intValue != 0) {
                                                     if (model.safeDistance.intValue < distance) {
                                                         [LxmEventBus sendEvent:@"playSound" data:nil];
                                                     }
                                                 }
                                                 break;
                                             }
                                         }
                                        [self sendDistanceChangeNotiForTongXinId:ID distance:distance];
                                     }
                                 }
                             }
                        };
                        if (![ID isEqualToString:@"000000000000"]) {
                            if (peripheral.isYanshi) {
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    peripheral.isYanshi = NO;
                                });
                            } else {
                                dataDellCodeBlock();
                            }
                        }
                    }
                        
                } break;
                    
                case 0x07: { //设置报警类型
                    Byte baojingleixing = resultByte[3];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelSetAlert:) object:nil];
                    if (peripheral.setAlertCallBack) {
                        peripheral.setAlertCallBack(baojingleixing == 0x00,nil);
                        peripheral.setAlertCallBack = nil;
                    }
                } break;
                    
                    
                case 0x08: //获取版本信息
                {
                    Byte hardwareVersion = resultByte[3];
                    Byte softwareVersion = resultByte[4];
                    
                    NSString *version = [NSString stringWithFormat:@"%hhu",hardwareVersion];
                    NSString *version1 = [NSString stringWithFormat:@"%hhu",softwareVersion];
                    peripheral.hVersion = version;
                    peripheral.fVersion = version1;
                    if (_versionCallback) {
                        _versionCallback(YES, version,version1);
                        _versionCallback = nil;
                    }
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancleGetVersion) object:nil];
                }
                    break;
                    
                case 0x09://获取子机ID列表
                {
                    Byte xuhao = resultByte[3];
                    NSString *tongxinID1 = [hexString substringWithRange:NSMakeRange(8, 12)];
                    NSString *tongxinID2 = [hexString substringWithRange:NSMakeRange(20, 12)];
                    switch (xuhao) {
                        case 0x01: {
                            peripheral.tongxinIds[@"0"] = tongxinID1;
                            peripheral.tongxinIds[@"1"] = tongxinID2;
                        } break;
                        case 0x02: {
                            peripheral.tongxinIds[@"2"] = tongxinID1;
                            peripheral.tongxinIds[@"3"] = tongxinID2;
                        } break;
                        case 0x03: {
                            peripheral.tongxinIds[@"4"] = tongxinID1;
                            peripheral.tongxinIds[@"5"] = tongxinID2;
                        } break;
                        case 0x04: {
                            peripheral.tongxinIds[@"6"] = tongxinID1;
                            peripheral.tongxinIds[@"7"] = tongxinID2;
                            
                            if (_tongxinIdListCallback) {
                                _tongxinIdListCallback(YES, peripheral.tongxinIds.copy);
                                _tongxinIdListCallback = nil;
                            }
                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelGetTongxinIDList) object:nil];
                        } break;
                        default:
                            break;
                    }
                    
                }
                    break;
                    
                case 0x0A: //删除子机 oo of 主机 00 01 
                {
                    Byte deleteID = resultByte[3];
                    BOOL success = NO;
                    NSString *tips = @"";
                    if (deleteID == 0x00 || deleteID == 0x0F) {
                        tips = @"删除子机成功";
                        success = YES;
                    } else if (deleteID == 0x01){
                        tips = @"该ID不在列表中";
                        success = YES;
                    } else {
                        tips = @"删除子机失败";
                        success = NO;
                    }
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelDelSubDevice:) object:peripheral];
                    if (peripheral.deleteSubDeviceCallback) {
                        peripheral.deleteSubDeviceCallback(success, tips);
                        peripheral.deleteSubDeviceCallback = nil;
                    }
                   
                } break;
                    
                case 0x0B: {
                    BOOL isAllow = YES;
                    
                    CBCharacteristic * fff6 = [self fff6ForPer:peripheral];
                    NSString *dataStr = @"ee020b00ff";
                    if (isAllow) {
                        dataStr = @"ee020b01ff";
                    }
                    [peripheral writeValue:[LxmDataManager stringToHexData:dataStr] forCharacteristic:fff6 type:CBCharacteristicWriteWithoutResponse];
                } break;
                    
                case 0x0C://是否打开自动测距
                {
                    
                    NSLog(@"打印:5");
                    
                    BOOL success = NO;
                    BOOL isOpen = NO;
                    Byte baojingID = resultByte[3];
                    if (baojingID == 0x00) { //已经关闭
                        success = YES;
                        isOpen = NO;
                    } else if (baojingID == 0x01) { //已经打开
                        success = YES;
                        isOpen = YES;
                    } else if (baojingID == 0x02) { //主机或子机正在充电
                        success = NO;
                        isOpen = NO;
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@电量低!",peripheral.isMaster ? @"主机" : @"子机"]];
                    } else if (baojingID == 0x03) { //主机或子机正在充电（但已经充满）
                        success = NO;
                        isOpen = NO;
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@电量低!",peripheral.isMaster ? @"主机" : @"子机"]];
                    } else if (baojingID == 0x04) { //主机或子机低电量
                        success = NO;
                        isOpen = NO;
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@电量低!",peripheral.isMaster ? @"主机" : @"子机"]];
                        
                    } else if (baojingID == 0x05) { //操作失败
                        success = NO;
                        isOpen = NO;
                        [SVProgressHUD showErrorWithStatus:@"操作失败!"];
                    }
                    if (_openOrCloseCallBack) {
                        _openOrCloseCallBack(success, isOpen);
                        
                    }
                }
                    break;
                case 0x0D:
                {
                    Byte fatherNum = resultByte[3];
                    if (fatherNum == 0x00) {
                    }
                    else if (fatherNum == 0x01) {
                    }
                    else
                    {
                    }
                }
                    break;
                case 0x0E: {
                    Byte setPinLvNum = resultByte[3];
                    if (setPinLvNum == 0x00) {
                        
                    } else {
                        
                    }
                }
                    break;
                case 0x0F:{
                    if (peripheral.isMaster) {
                        //母机 广播子机h和自己的电量
                        for (int i = 0; i < 9; i++) {
                            NSInteger dianliang = resultByte[3 + i];
                            if (dianliang == 255 ) {
                                continue;
                            }
                            if (i == 8) {
                                peripheral.power = @(dianliang);
                                [self sendPowerChangeNotiForTongXinId:peripheral.tongxinId power:dianliang];
                            }
                            NSInteger powerStatus = resultByte[12];
                            peripheral.powerStatus = @(powerStatus);
                            if (powerStatus != 0) {
                                for (int j = 0; j < 8; j++) {
                                    NSString *ID = peripheral.tongxinIds[[NSString stringWithFormat:@"%d", j]];
                                    if (![ID isEqualToString:@"000000000000"]) {
                                        CBPeripheral *p = [self peripheralWithTongXinId:ID];
                                        if (p.state == CBPeripheralStateConnected) {
                                            [self nowCheckPowerForPer:p];
                                        }
                                    }
                                }
                            }

                        }
                        
                    } else {
                        //子机 只广播子机的电量
                        NSInteger dianliang = resultByte[3];
                        
                        NSInteger switchStatus = resultByte[4];
                        NSInteger powerStatus = resultByte[5];
                        peripheral.powerStatus = @(powerStatus);
                        peripheral.power = @(dianliang);
                        [self sendPowerChangeNotiForTongXinId:peripheral.tongxinId power:dianliang];
                        //这一台子机
                        for (LxmDeviceModel *model in self.serverDeviceArr) {
                            if ([model.communication isEqualToString:peripheral.tongxinId]) {
                                if (powerStatus == 0 && model.distance.intValue == -1 && switchStatus == 0) {
                                    //主机测距已断连 子机测距未打开 则打开子机的测距开关
                                    [self sendCeJuSwitchChangeNotiForTongXinId:peripheral.tongxinId isRealTime:@"1"];
                                }
                                if (model.distance.intValue == -1) {
                                    if (powerStatus == 2 || powerStatus == 3 || powerStatus == 4) {
                                        //子机正在充电 主机已断连 关闭主机测距
                                        model.power = @(dianliang);
                                        if (self.master && self.master.state == CBPeripheralStateConnected) {
                                            [self sendCeJuSwitchChangeNotiForTongXinId:peripheral.tongxinId isRealTime:@"2"];
                                        }
                                    }
                                }
                                
                                if (powerStatus == 0) {
                                    model.isRealTime = switchStatus == 1 ? @"1" : @"2";
                                } else {
                                    model.isRealTime = @"2";
                                }
                                [self sendCeJuSwitchChangeNotiForTongXinId1];
                                break;
                            }
                        }
                }
                    break;
                    
                case 0x10:{//查询步数指令， APP 发送给设备（子机或者母机）
                    
                    
                } break;
                    
                case 0x11:{ // 实时步数
                    Byte byte1 = resultByte[3];
                    Byte byte2 = resultByte[4];
                    
                    char bytes[]={byte1,byte2};
                    unsigned char by1 = (bytes[0] &0xff);//高8位
                    unsigned char by2 = (bytes[1] &0xff);//低8位
                    int step  = (by2 | (by1 << 8));
                    peripheral.step = @(step);
                    [self sendStepChangeNotiForTongXinId:peripheral.tongxinId step:step];
                    
                } break;
                    
                case 0x12:{
                    
                }
                    break;
                    
                case 0x14: // 步数日期
                case 0x15: // 距离日期
                {
                    Byte xuhao = resultByte[3];
                    if (xuhao == 0x01) {
                        NSString *date1 = [hexString substringWithRange:NSMakeRange(8, 6)];
                        NSString *date2 = [hexString substringWithRange:NSMakeRange(14, 6)];
                        NSString *date3 = [hexString substringWithRange:NSMakeRange(20, 6)];
                        NSString *date4 = [hexString substringWithRange:NSMakeRange(26, 6)];
                        NSString *date5 = [hexString substringWithRange:NSMakeRange(32, 6)];
                        NSArray *arr = @[date1,date2,date3,date4,date5];
                        for (int i = 0; i < 5; i++) {
                            if (![arr[i] containsString:@"0000"]) {//无效字符串
//                                dates[@(i).stringValue] = arr[i];
                                if (type == 0x14) {
                                    peripheral.stepDates[@(i).stringValue] = arr[i];
                                } else {
                                    peripheral.distanceDates[@(i).stringValue] = arr[i];
                                }
                            }
                        }
                    } else if (xuhao == 0x02) {
                        NSString *date1 = [hexString substringWithRange:NSMakeRange(8, 6)];
                        NSString *date2 = [hexString substringWithRange:NSMakeRange(14, 6)];
                        NSArray *arr = @[date1,date2];
                        for (int i = 0; i < 2; i++) {
                            if (![arr[i] containsString:@"0000"]) {//无效字符串
//                                dates[@(i+5).stringValue] = arr[i];
                                if (type == 0x14) {
                                    peripheral.stepDates[@(i+5).stringValue] = arr[i];
                                } else {
                                    peripheral.distanceDates[@(i+5).stringValue] = arr[i];
                                }
                            }
                        }
                        if (0x14 == type) { //步数日期
                            [peripheral runStepDatesCallback];
                        } else {
                            [peripheral runDistanceDatesCallback];
                        }
                    }
                } break;
                case 0x17: {
//                    指令23  （主机）查询报警距离
//（1）查询所有子机的安全距离，如果安全距离值的最高位为1。例如：高8位最高位为1时，代表这台子机的测距开关是开启状态.
//                    （2）手环硬件上操作，设置安全距离，硬件主要主动上报新设置的安全距离。
                    //onCharacteristicWrite: ee021700ff
                    //onCharacteristicChanged: ee11178002ffffffffffffffffffffffffffffff
                    //安全距离大于 0x8002 测距开关是开
                    //安全距离是2
                    //0x8000  - > 32768
                    // 测距开关是关 onCharacteristicChanged: ee11170002ffffffffffffffffffffffffffffff
                    
                    int start = 3;
                    bool isCeju = NO;
                    for (int i = 0; i < 8; i++) {
                        // 取出第i个设备的
                        NSString *ID = peripheral.tongxinIds[[NSString stringWithFormat:@"%d", i]];
                        Byte byte1 = resultByte[i * 2 + start];
                        Byte byte2 = resultByte[i * 2 + 1 + start];
                        if (byte1 == 0xFF && byte2 == 0xFF) {
                            // 未绑定
                        } else if (byte1 == 0xff && byte2 == 0x0E) {
                            // 已绑定，但未打开测距
                        } else if (byte1 == 0xff && byte2 == 0xFD) {
                            // 已绑定，但设备已经掉线 需要报警
                            
                        } else {
                            //正常情况
                            char bytes[]={byte1,byte2};
                            unsigned char by1 = (bytes[0] &0xff);//高8位
                            unsigned char by2 = (bytes[1] &0xff);//低8位
                            CGFloat distance  = (by2 | (by1 << 8));
                            CBPeripheral *p = [self peripheralWithTongXinId:ID];
                            
                            if (distance >= 32768) {
                                isCeju = YES;
                                p.isRealTime = @"1";
                                p.safeDistance = @(distance - 32768).stringValue;
                                [self sendLxmDeviceSafeDistanceNotiForTongXinId:ID safeDistance:distance - 32768 isRealTime:@"1"];
                            } else {
                                p.isRealTime = @"2";
                                p.safeDistance = @(distance).stringValue;
                                [self sendLxmDeviceSafeDistanceNotiForTongXinId:ID safeDistance:distance isRealTime:@"2"];
                            }
                        }
                        
                    }
                    if (isCeju) {
                        [self openMasterCeju];
                    } else {
                        [self closeMasterCeju];
                    }
                }
                case 0x18: {
                    Byte shezhi = resultByte[3];
                    if (shezhi == 0x00) {
                        if (_setPhoneCallBack) {
                            _setPhoneCallBack(YES,@"设置成功");
                            _setPhoneCallBack = nil;
                        }
                    } else {
                        if (_setPhoneCallBack) {
                            _setPhoneCallBack(NO,@"设置失败");
                            _setPhoneCallBack = nil;
                        }
                    }
                }
                    break;
                case 0x19: {
                    Byte shezhi = resultByte[3];
                    NSString *name = [hexString substringWithRange:NSMakeRange(8, 8)];
                    if (shezhi == 0x00) {
                    } else if (shezhi == 0x01) {
                        if ([name isEqualToString:@"00000000"]) {
                            if (_setNameCallBack) {
                                _setNameCallBack(NO,@"设置失败");
                            }
                        } else {
                            if (_setNameCallBack) {
                                _setNameCallBack(YES,@"设置成功");
                            }
                        }
                    }
                }
                default:
                    break;
                    
                    
            }
        }
    }
 }
}
@end


@implementation LxmBLEManager(AAA)

- (NSString *)masterTongXinId {
    return [NSUserDefaults.standardUserDefaults objectForKey:@"masterTongXinId"];
}

- (void)setMasterTongXinId:(NSString *)masterTongXinId {
    [NSUserDefaults.standardUserDefaults setObject:masterTongXinId forKey:@"masterTongXinId"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (CBPeripheral *)master {
    return [self peripheralWithTongXinId:self.masterTongXinId];
}

@end
