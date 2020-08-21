//
//  LxmDataManager.h
//  111
//
//  Created by 宋乃银 on 2017/10/21.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LxmDataManager : NSObject

+ (NSString *)hexStringFromData:(NSData *)data;
+ (NSData *) stringToHexData:(NSString *)hexStr;

#pragma mark - 获取发送数据
/**
 0x01 设定安全距离
 */
+ (NSData *)setDistanceForID:(NSString *)ID distance:(NSInteger)distance;
/**
 0x02 设定通信ID
 */
+ (NSData *)setHardwareID:(NSString *)ID;

/**
 0x03 获取通信ID
 */
+(NSData *)getID;

/**
 0x04 添加子机列表，把子机的通信ID添加到母机的列表里
 */
+(NSData *)letSubIDToFather:(NSString *)ID nameData:(NSData *)nameData;

/**
0x19 设备名称的获取和设置
*/
+(NSData *)setDeviceName:(NSString *)ID nameData:(NSData *)nameData;

/**
0x18 子机设备紧急联系方式设置
*/
+(NSData *)setSubDevicePhone:(NSString *)phone;

/**
 0x05 获取角色信息
 */
+ (NSData *)getRoleInfo;
/**
 0x06 母机或子机上报距离信息
 */
+ (NSData *)openDisntanceNoti;
/**
0x06 关闭
*/
+ (NSData *)closeDisntanceNoti;
/**
 0x07 超出距离报警类型设定
 */
+(NSData *)overDistance:(NSString *)ID;
/**
 0x08 获取硬件和固件的版本信息
 */
+ (NSData *)getHardwareVersion;

/**
 0x09 读出授权通信ID列表
 */
+ (NSData *)readAuthorizationIDList;
/**
 0x0A 删除授权通信ID
 */
+ (NSData *)deleteIDFromList:(NSString *)deviceId;

/**
 0x0C 打开或关闭母机自动测距功能
 */
+ (NSData *)openOrClose:(BOOL)isOpen tongxinId:(NSString *)tongxinId;

/**
 0x0D 多母机针对某个子机测距状态
 */
+ (NSData *)cejustate:(NSString *)ID num:(NSString *)num;

//检查电量
+ (NSData *)checkPower;

//同步安全距离
+ (NSData *)syncSafeDistance;

//校验时间
+ (NSData *)tongbuTimeData;

/// 查询硬件记录的步数近7天的日期
+ (NSData *)chaxunBuShuDate;

/// 查询硬件记录的距离近7天的日期
+ (NSData *)chaxunDistanceDate;

//查询硬件记录的步数 参数 date 格式为“121212” 长度为6  分别为年月日 刚好取上面chaxunBuShuDate接口返回的
+ (NSData *)chaxunBuShuWithDate:(NSString *)date;

//查询硬件记录的距离 参数 date 格式为“121212” 长度为6  分别为年月日 刚好取上面chaxunBuShuDate接口返回的
+ (NSData *)chaxunDistanceWithDate:(NSString *)date;
/**
 查询步数指令， APP 发送给设备（子机或者母机）
 */
+ (NSData *)chaxunDeviceBuShu;

+ (NSData *)dataWithBytes:(Byte *)bytes;
+ (NSString *)stringWithBytes:(Byte *)bytes;
+ (NSString *)ToHex:(int)tmpid;


/// 16进制字符串转10进制数字
+ (NSInteger)str16to10:(NSString *)str16;
@end



