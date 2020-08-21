//
//  CBPeripheral+TongXinID.h
//  JawboneUP
//
//  Created by 宋乃银 on 2017/11/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^ConnectCallback)(BOOL success,CBPeripheral *per);
typedef void(^MasterCallback)(BOOL success, BOOL isMaster);
typedef void(^SetValueCallBack)(BOOL success, NSString *tips);
typedef void(^BuShuCallBlock) (CBPeripheral *p, NSDictionary<NSString *, NSString*> *steps);

@interface CBPeripheral (Callback)
@property (nonatomic, copy) BuShuCallBlock bushuChaXunBack;
- (void)cancelBuShuCallBlockAfter:(CGFloat)delay;
- (void)runBuShuCallBlock;
@property (nonatomic, copy) BuShuCallBlock distanceChaXunBack;
- (void)cancelDistanceCallbackAfter:(CGFloat)delay;
- (void)runDistanceCallback;


@property (nonatomic, copy) ConnectCallback connectCallback;
@property (nonatomic, copy) MasterCallback masterCallback;

@property (nonatomic, copy) SetValueCallBack setAlertCallBack;
@property (nonatomic, copy) SetValueCallBack addSubDeviceCallback;
@property (nonatomic, copy) SetValueCallBack deleteSubDeviceCallback;
@property (nonatomic, copy) SetValueCallBack setDistanceCallback;
@end



@interface CBPeripheral (MAC)

/**
 tongxinId
 */
@property (nonatomic, strong) NSString *tongxinId;

/**
 是否延时2s处理测距
 */
@property (nonatomic, assign) BOOL isYanshi;

/**
 是断连
 */
@property (nonatomic, assign) BOOL isDuanLian;

/**
 是否是母鸡
 */
@property (nonatomic, assign) BOOL isMaster;

/**NSN
 随机数 AES-128 加密同步 Key 用
 */
@property (nonatomic, strong) NSString *randomKey;

/**
 电量
 */
@property (nonatomic, strong) NSNumber *power;

/**
 电量状态 主机 0 电量正常 2 充电中 3 以充满 4 低电量
         子机  0 电量正常 2 充电中 3 以充满 4 低电量
 */
@property (nonatomic, strong) NSNumber *powerStatus;

/**
 安全距离
 */
@property (nonatomic, strong) NSString *distance;


/**
 安全距离
 */
@property (nonatomic, strong) NSString *safeDistance;

/**
 步
 */
@property (nonatomic, strong) NSNumber *step;


/**
 超出最远距离
 */
@property (nonatomic, strong) NSString *farDistance;

/**
 超出最远距离次数
 */
@property (nonatomic, strong) NSString *farNumDistance;


//master

/**
 硬件版本号
 */
@property (nonatomic, strong) NSString *hVersion;

/**
 固件版本号
 */
@property (nonatomic, strong) NSString *fVersion;

/**
 测距开关状态
 */
@property (nonatomic, strong) NSString *isRealTime;

@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *tongxinIds;

/// 步数日期
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *stepDates;
@property (nonatomic, copy) void(^stepDatesCallback)(NSDictionary<NSString *, NSString *> *stepDates);
- (void)cancelStepDatesCallbackAfter:(CGFloat)delay;
- (void)runStepDatesCallback;

/// 距离日期
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *distanceDates;
@property (nonatomic, copy) void(^distanceDatesCallback)(NSDictionary<NSString *, NSString *> *stepDates);
- (void)cancelDistanceDatesCallbackAfter:(CGFloat)delay;
- (void)runDistanceDatesCallback;

/// 步数临时变量
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *stepDict;

/// 距离临时变量
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *distanceDict;





@end
