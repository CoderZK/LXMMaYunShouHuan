//
//  LxmJiaZhangModel.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/8.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface LxmJiaZhangModel : NSObject

@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,strong)NSString *kindergarten;
@property (nonatomic,strong)NSNumber *identityId;
@property (nonatomic,strong)NSNumber *sex;
@property (nonatomic,strong)NSString *birthday;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *version;


@end

@interface LxmDeviceModel : NSObject

@property (nonatomic,strong)NSString *time;/* 设备绑定时间 */

@property (nonatomic,strong)NSString *userEquId;/* 用户设备id */
@property (nonatomic,strong)NSString *equId;/* 设备id */
@property (nonatomic,strong)NSString *equHead;/* 设备头像 */

@property (nonatomic,strong)NSString *type;/* 机型 1主机 2子机 */
@property (nonatomic,strong)NSString *equNickname;/* 设备昵称 */
@property (nonatomic,strong)NSString *tel;/* 联系手机 */
@property (nonatomic,strong)NSString *communication;/* 通信ID*/
@property (nonatomic,strong)NSString *safeDistance;/* 安全距离 */
@property (nonatomic,strong)NSString *stepNum;/* 步数 */
@property (nonatomic,strong)NSString *isRealTime;/* 是否实时 */
@property (nonatomic,strong)NSNumber *powerStatus;/* 0 电量正常 2 充电中 3 以充满 4 低电量 */

@property (nonatomic,strong)NSString *hardwareVersion;/* 硬件号 */
@property (nonatomic,strong)NSString *firmwareVersion;/* 固件号 */
@property (nonatomic,strong)NSString *n_firmware_version;/* 最新版本号 */

#pragma mark - local
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL isCanUp;
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, strong) NSNumber *power;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *step;

@property (nonatomic, strong) NSNumber *angle;

@end

@interface LxmEquModel : NSObject

@property (nonatomic,strong)NSString *equHead;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSNumber *vibrationMode;
@property (nonatomic,strong)NSString *safeDistance;
@property (nonatomic,strong)NSString *communication;
@property (nonatomic,strong)NSString *criticalTel;

@end

@interface LxmWeiTuoModel : NSObject

@property (nonatomic,strong)NSString *equId;
@property (nonatomic,strong)NSString *headimg;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,strong)NSNumber *userEquId;
@property (nonatomic,strong)NSNumber *authorizeType;
@property (nonatomic,strong)NSString *communication;
@property (nonatomic,strong)NSString *realname;

@end

@interface lxmFriendModel : NSObject

@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *headimg;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,strong)NSNumber *isFriend;


@end

@interface lxmMessageInforModel : NSObject

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSNumber *userApplyId;
@property (nonatomic,strong)NSNumber *otherUserId;
@property (nonatomic,strong)NSString *otherUserHead;
@property (nonatomic,strong)NSString *otherUserName;
@property (nonatomic,strong)NSString *equId;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSNumber *authorizeType;
@property (nonatomic,strong)NSString *communication;

/**
 实际上是mac
 */
@property (nonatomic,strong)NSString *identifier;
@property (nonatomic,strong)NSNumber *isEffective;

@end


@interface lxmMessageModel : NSObject

@property (nonatomic,strong)NSString *msgId;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSNumber *isRead;
@property (nonatomic,strong)NSString *createTime;
@end



