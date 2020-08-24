//
//  LxmBLEManager.h
//  JawboneUP
//
//  Created by 宋乃银 on 2017/10/28.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LxmConnectModel.h"
#import "CBPeripheral+MAC.h"

typedef void(^VersionCallBack) (BOOL success,NSString *hVersion,NSString *fVersion);

typedef void(^CommunicationListCallBack) (BOOL success, CBPeripheral *per);

typedef void(^OpenOrCloseCallBack)(BOOL success, BOOL isOpen);

typedef void(^setPeripheralNameCallBack)(BOOL success, NSString *tips);

typedef void(^setSubPeripheralPhoneCallBack)(BOOL success, NSString *tips);

@interface LxmBLEManager : NSObject

@property (nonatomic, strong) CBCentralManager *centralManager;

- (void)startScan;
- (void)stopScan;

@property (nonatomic, assign) BOOL isTongbuStep;
@property (nonatomic, assign) BOOL isTongbuDistance;

/** 服务器保存的设备 */
@property (nonatomic, strong) NSArray <LxmDeviceModel *> *serverDeviceArr;

- (void)connectServerDeviceIfNeed; // 连接服务器所有的设备
- (void)disConnectTempDeviceIfNeed; // 断开非服务器的其他设备 第一次连接 不要断开主设备

+ (instancetype)shareManager;
+(void)attempDealloc;
//外设列表
@property (nonatomic, copy) NSArray<CBPeripheral *> *deviceList;
@property(nonatomic,strong)CBPeripheral *mainPeripheral;

/** 根据通信Id获取 设备 */
- (CBPeripheral *)peripheralWithTongXinId:(NSString *)tongXinId;

/** 根据通信Id查询该设备是否已经连接 */
- (BOOL)isConnectWithTongXinId:(NSString *)tongXinId;

/*
 设备更新测距开关
 */
#define LxmDeviceCeJuSwitchDidChangeNoti @"LxmDeviceCeJuSwitchDidChangeNoti"

#define LxmDeviceCeJuSwitchDidChangeNoti1 @"LxmDeviceCeJuSwitchDidChangeNoti1"

#define LxmDeviceShuaXinDistanceNoti @"LxmDeviceShuaXinDistanceNoti"

#define LxmDeviceSafeDistanceNoti @"LxmDeviceSafeDistanceNoti"


/*
 设备连接、断开状态 通知 cell监听改通知 可实时刷新连接状态
 名称： LxmDeviceConnectDidChangeNoti
 参数： {@"tongxinId":@"232399234", @"isConnected":@(YES/NO)}
 */
#define LxmDeviceConnectDidChangeNoti @"LxmDeviceConnectDidChangeNoti"

/*
 设备距离通知 cell监听改通知 可实时刷新连接状态
 名称： LxmDeviceDistanceDidChangeNoti
 参数： {@"tongxinId":@"232399234", @"distance":@(5.4)}
 */
#define LxmDeviceDistanceDidChangeNoti @"LxmDeviceDistanceDidChangeNoti"

/*
 设备电量通知 cell监听改通知 可实时刷新连接状态
 名称： LxmDevicePowerDidChangeNoti
 参数： {@"tongxinId":@"232399234", @"power":@(9)}
 */
#define LxmDevicePowerDidChangeNoti @"LxmDevicePowerDidChangeNoti"

/*
 设备步数通知 cell监听改通知 可实时刷新连接状态
 名称： LxmDeviceStepDidChangeNoti
 参数： {@"tongxinId":@"232399234", @"step":@(9)}
 */
#define LxmDeviceStepDidChangeNoti @"LxmDeviceStepDidChangeNoti"

#define LxmZhuJiOpenCeJuNoti @"LxmZhuJiOpenCeJu"

#define LxmKaiGuanStatusChangeNoti @"LxmKaiGuanStatusChangeNoti"
//打开主机测距
- (void)openMasterCeju;
//关闭主机测距
- (void)closeMasterCeju;

//查询设备电量
- (void)nowCheckPowerForPer:(CBPeripheral *)p;

/** 新增查询历史步数指令 */
- (void)checkStep:(CBPeripheral *)p date:(NSString *)date completed:(BuShuCallBlock)completed;

/** 新增查询历史距离指令 */
- (void)checkDistance:(CBPeripheral *)p date:(NSString *)date completed:(BuShuCallBlock)completed;

/** 连接设备 */
- (void)connectPeripheral:(CBPeripheral *)per completed:(ConnectCallback)completed;

// 首页连接设备
- (void)connectPeripheral:(CBPeripheral *)per;
// 断开设备
- (void)disConnectPeripheral:(CBPeripheral *)per;
/// 同步安全距离
- (void)tongbuSafeDistance:(CBPeripheral *)per;

/** 检查是否是主机 */
- (void)checkIsMaster:(CBPeripheral *)per completed:(MasterCallback)completed;

/** 设置报警方式 */
- (void)setAlert:(CBPeripheral *)per alertType:(int)type completed:(SetValueCallBack)completed;

/** 设置报警距离 */
- (void)setDistance:(NSString *)tongxinID distance:(NSInteger)distance completed:(SetValueCallBack)completed;

/** 添加子机 */
- (void)addDevice:(CBPeripheral *)p1 deviceName:(NSString *)name toDevice:(CBPeripheral *)p2 completed:(SetValueCallBack)completed;

/** 删除子机 */
- (void)delDevice:(CBPeripheral *)p1 fromDevice:(CBPeripheral *)p2 completed:(SetValueCallBack)completed;

/** 获取版本号 */
- (void)checkVersion:(CBPeripheral *)per completed:(VersionCallBack)completed;

/** 获取通讯ID列表 */
- (void)getCommunicationListForPer:(CBPeripheral *)per completed:(CommunicationListCallBack)completed;

/** 打开或关闭测距 */
- (void)openOrCloseRealDistance:(BOOL)isOpen peripheral:(CBPeripheral *)p communication:(NSString *)tongxinID completed:(OpenOrCloseCallBack)completed;

/** 设置设备名称 */
- (void)setDeviceName:(CBPeripheral *)per tongxinID:(NSString *)communication deviceName:(NSString *)name completed:(setPeripheralNameCallBack)completed;

/** 设置子机的紧急联系电话 */
- (void)setSubDevicePhone:(CBPeripheral *)per phone:(NSString *)phone completed:(setSubPeripheralPhoneCallBack)completed;

- (void)chaxunBuShuSevenDayData:(CBPeripheral *)per completed:(void(^)(NSDictionary<NSString *, NSString *> *dates))completed;

- (void)chaxunDistanceSevenDayData:(CBPeripheral *)per completed:(void(^)(NSDictionary<NSString *, NSString *> *dates))completed;


/// 存放已同步的设备
@property (nonatomic, strong) NSMutableArray<NSString *> *yitongbuStepArr;
@property (nonatomic, strong) NSMutableArray<NSString *> *yitongbuDistanceArr;
@end

@interface LxmBLEManager (AAA)

@property (nonatomic, copy) NSString *masterTongXinId;

@property (nonatomic, readonly) CBPeripheral *master;

@end
