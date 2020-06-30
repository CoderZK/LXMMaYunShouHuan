//
//  NSString+Size.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "NSString+Size.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Size)

- (BOOL)isContrainsKong {
    if ([self containsString:@" "]) {
        return YES;
    }
    return NO;
}

-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize
{
    CGSize size=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str
{
    const char *fooData = [str UTF8String];//UTF-8编码字符串
    unsigned char result[CC_MD5_DIGEST_LENGTH];//字符串数组，接收MD5
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);//计算并存入数组
    NSMutableString *saveResult = [NSMutableString string];//字符串保存加密结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}
+ (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

+(NSDate *)dataWithStr:(NSString *)str
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    return  [formatter dateFromString:str];
}

+ (NSString *)getFommateYMD:(NSDate *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSArray *tempArr = [dateStr componentsSeparatedByString:@"-"];
    NSString *fomStr = dateStr;
    if (tempArr.count == 3) {
        NSString *year = [NSString stringWithFormat:@"%@",tempArr.firstObject];
        NSString *month = [NSString stringWithFormat:@"%02ld",[tempArr[1] integerValue]];
        NSString *day = [NSString stringWithFormat:@"%02ld",[tempArr[2] integerValue]];
        fomStr = [NSString stringWithFormat:@"%@-%@-%@",year, month, day];
    }
    return  fomStr;
}

+ (NSString *)getFommateCurrentString {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSArray <NSString *>*arr = [dateStr componentsSeparatedByString:@" "];
    NSArray *tempArr = [arr.firstObject componentsSeparatedByString:@"-"];
    NSString *fomStr = dateStr;
    if (tempArr.count == 3) {
        NSString *year = [NSString stringWithFormat:@"%@",tempArr.firstObject];
        NSString *month = [NSString stringWithFormat:@"%02ld",[tempArr[1] integerValue]];
        NSString *day = [NSString stringWithFormat:@"%02ld",[tempArr[2] integerValue]];
        fomStr = [NSString stringWithFormat:@"%@-%@-%@",year, month, day];
        fomStr = [NSString stringWithFormat:@"%@ %@",fomStr,arr.lastObject];
    }
    return  fomStr;
}


+(NSDate *)dataFommatWithStr:(NSString *)str {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}


- (NSUInteger)charactorNumber {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self charactorNumberWithEncoding:encoding];
}

- (BOOL)isValid {
    if (self.length > 0 && ![[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)charactorNumberWithEncoding:(NSStringEncoding)encoding {
    NSUInteger strLength = 0;
    char *p = (char *)[self cStringUsingEncoding:encoding];
    NSUInteger lengthOfBytes = [self lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}

////GB2312转换为UTF-8的方法
//+ (NSData *)UTF8WithGB2312Data:(NSData *)gb2312Data {
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *str = [[NSString alloc] initWithData:gb2312Data encoding:enc];
//    NSData *utf8Data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    return utf8Data;
//}

//UTF-8转换为GB2312的方法：

+ (NSData *)GB2312WithUTF8Data:(NSData *)UTF8Data {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc] initWithData:UTF8Data  encoding:NSUTF8StringEncoding];
    NSData *gb2312Data = [str dataUsingEncoding:enc ];
    return gb2312Data;
}

- (NSData *)GB2312Data {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *gbdata = [NSString GB2312WithUTF8Data:data];
    return gbdata;
}

+ (NSString *)convertToJsonData:(id )dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString = @"";
    if(!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
