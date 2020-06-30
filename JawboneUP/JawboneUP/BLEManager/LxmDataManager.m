//
//  LxmDataManager.m
//  111
//
//  Created by 宋乃银 on 2017/10/21.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmDataManager.h"

@implementation LxmDataManager

+ (NSString *)hexStringFromData:(NSData *)data {
    
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

+ (NSData *)dataWithBytes:(Byte *)bytes {
    return [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
}

+ (NSString *)stringWithBytes:(Byte *)bytes {
    return [[NSString alloc] initWithData:[self dataWithBytes:bytes] encoding:NSUTF8StringEncoding];
}


/**
 0x01 设定安全距离
 */
+ (NSData *)setDistanceForID:(NSString *)ID distance:(NSInteger)distance
{
    NSString * str = [self ToHex:distance];
    str = [NSString stringWithFormat:@"0000%@", str];
    str = [str substringFromIndex:str.length - 4];
    str = [NSString stringWithFormat:@"ee0901%@%@ff",ID,str];
    NSData * data = [LxmDataManager stringToHexData:str];
    return data;
}

/**
 0x02 设定通信ID
 */
+ (NSData *)setHardwareID:(NSString *)ID
{
    NSString * str = [NSString stringWithFormat:@"ee0902%@ff",ID];
    NSData * data = [LxmDataManager stringToHexData:str];
    return data;
}

/**
 0x03 获取通信ID
 */
+(NSData *)getID
{
    NSString * str = [NSString stringWithFormat:@"ee020300ff"];
    NSData *data = [LxmDataManager stringToHexData:str];
    return data;
}
/**
 0x04 添加子机列表，把子机的通信ID添加到母机的列表里
 */
+(NSData *)letSubIDToFather:(NSString *)ID nameData:(NSData *)nameData
{
    NSString * str = [NSString stringWithFormat:@"EE0B04%@",ID];
    NSData * data = [LxmDataManager stringToHexData:str];
    NSData *subData = [LxmDataManager stringToHexData:@"FF"];
    NSMutableData *mdata = [NSMutableData dataWithData:data];
    [mdata appendData:nameData];
    [mdata appendData:subData];
    return mdata;
}

/**
0x19 设备名称的获取和设置
*/
+(NSData *)setDeviceName:(NSString *)ID nameData:(NSData *)nameData {
    NSString * str = [NSString stringWithFormat:@"ee0C1901%@",ID];
    NSData * data = [LxmDataManager stringToHexData:str];
    NSData *subData = [LxmDataManager stringToHexData:@"ff"];
    NSMutableData *mdata = [NSMutableData dataWithData:data];
    [mdata appendData:nameData];
    [mdata appendData:subData];
    return mdata;
}


/**
 0x05 获取角色信息
 */
+ (NSData *)getRoleInfo {
    Byte bytes[] = {0xEE,0x02,0x05,0x00,0xFF};
    NSData *data = [self dataWithBytes:bytes];
    return data;
}

/**
 0x06 打开母机测距开关
 */
+ (NSData *)openDisntanceNoti
{
    NSData * data = [LxmDataManager stringToHexData:@"ee020601ff"];
    return data;
}
/**
0x06 关闭母机测距开关
*/

+ (NSData *)closeDisntanceNoti
{
    NSData * data = [LxmDataManager stringToHexData:@"ee020600ff"];
    return data;
}


/**
 0x07 超出距离报警类型设定
 */
+(NSData *)overDistance:(NSString *)ID
{
    NSData * data = [LxmDataManager stringToHexData:@"ee0207%@ff"];
    return data;
}

/**
 0x08 获取硬件和固件的版本信息
 */
+ (NSData *)getHardwareVersion
{
    Byte bytes[] = {0xEE,0x02,0x08,0x00,0xFF};
    NSData *data = [self dataWithBytes:bytes];
    return data;
}

/**
 0x09 读出授权通信ID列表
 */
+ (NSData *)readAuthorizationIDList
{
    NSData * data = [LxmDataManager stringToHexData:@"ee020900ff"];
    return data;
}
/**
 0x0A 删除授权通信ID
 */
+ (NSData *)deleteIDFromList:(NSString *)deviceId
{
    NSData * data = [LxmDataManager stringToHexData:[NSString stringWithFormat:@"ee070a%@ff",deviceId]];
    return data;
}

/**
 0x0C 打开或关闭母机自动测距功能
 */
+ (NSData *)openOrClose:(BOOL)isOpen tongxinId:(NSString *)tongxinId {
    if (tongxinId.isValid) {
        NSData * data = [LxmDataManager stringToHexData:[NSString stringWithFormat:@"ee080c%@%@ff", isOpen?@"03":@"02", tongxinId]];
        return data;
    } else {
        NSData * data = [LxmDataManager stringToHexData:[NSString stringWithFormat:@"ee080c%@%@ff", isOpen?@"01":@"00",@"000000000000"]];
        return data;
    }
}

/**
 0x0D 多母机针对某个子机测距状态
 */
+ (NSData *)cejustate:(NSString *)ID num:(NSString *)num
{
    NSData * data = [LxmDataManager stringToHexData:[NSString stringWithFormat:@"ee0a0d%@%@ff",ID,num]];
    return data;
}

#pragma ----新版本 增加的指令
/**
 查询步数指令， APP 发送给设备（子机或者母机）
 */
+ (NSData *)chaxunDeviceBuShu {
    NSData * data = [LxmDataManager stringToHexData:@"ee021100ff"];
    return data;
}


/**
0x18 子机设备紧急联系方式设置
*/
+(NSData *)setSubDevicePhone:(NSString *)phone {
  
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < phone.length; i++) {
        NSString *sub = [phone substringWithRange:NSMakeRange(i, 1)];
        [str appendString:[NSString stringWithFormat:@"0%@",sub]];
    }
    NSData * data = [LxmDataManager stringToHexData:[NSString stringWithFormat:@"ee0c18%@ff", str]];
    return data;
}


+ (NSData *)tongbuTimeData {
    // 获取当前时间
    NSDate *now = [NSDate date];
    // 日历
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    // 利用日历类从当前时间对象中获取 年月日时分秒(单独获取出来)
    NSCalendarUnit type = NSCalendarUnitYear |
                          NSCalendarUnitMonth |
                          NSCalendarUnitDay |
                          NSCalendarUnitHour |
                         NSCalendarUnitMinute |
                        NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar1 components:type fromDate:now];
    NSLog(@"year = %ld", cmps.year);
    NSLog(@"month = %ld", cmps.month);
    NSLog(@"day = %ld", cmps.day);
    NSLog(@"hour = %ld", cmps.hour);
    NSLog(@"minute = %ld", cmps.minute);
    NSLog(@"second = %ld", cmps.second);
    NSMutableString *string = [NSMutableString stringWithString:@"ee0716"];
    NSArray *arr = @[@(cmps.year - 2000), @(cmps.month), @(cmps.day), @(cmps.hour), @(cmps.minute), @(cmps.second)];
    for (int i = 0; i < arr.count; i++) {
        int num = [arr[i] intValue];
        NSString * str = [self ToHex:num];
        str = [NSString stringWithFormat:@"00%@", str];
        str = [str substringFromIndex:str.length - 2];
        [string appendString:str];
    }
    [string appendString:@"ff"];
    NSData * data = [self stringToHexData:string];
    return data;
}


//检查电量
+ (NSData *)checkPower {
    NSData * data = [LxmDataManager stringToHexData:@"ee020f00ff"];
    return data;
}

//同步安全距离
+ (NSData *)syncSafeDistance {
    NSData * data = [LxmDataManager stringToHexData:@"ee021700ff"];
    return data;
}


+ (NSData *) stringToHexData:(NSString *)hexStr
{
    int len = [hexStr length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [hexStr length] / 2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}


//将十进制转化为十六进制
+ (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}


//查询硬件记录的步数近7天的日期
+ (NSData *)chaxunBuShuDate {
    Byte bytes[] = {0xEE,0x05,0x14,0x00,0x00,0x00,0x00,0xFF};
    NSData *data = [self dataWithBytes:bytes];
    return data;
}

+ (NSData *)chaxunDistanceDate {
    Byte bytes[] = {0xEE,0x05,0x15,0x00,0x00,0x00,0x00,0xFF};
    NSData *data = [self dataWithBytes:bytes];
    return data;
}


+ (NSData *)chaxunBuShuWithDate:(NSString *)date {
    NSString *str = [NSString stringWithFormat:@"ee051401%@ff", date];
    NSData * data = [LxmDataManager stringToHexData:str];
    return data;
}

+ (NSData *)chaxunDistanceWithDate:(NSString *)date {
    NSString *str = [NSString stringWithFormat:@"ee051501%@ff", date];
    NSData * data = [LxmDataManager stringToHexData:str];
    return data;
}

/// 16进制字符串转10进制数字
+ (NSInteger)str16to10:(NSString *)str16 {
    if (!str16) {
        return 0;
    }
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([str16 UTF8String],0,16)];
    return temp10.integerValue;
}

@end
