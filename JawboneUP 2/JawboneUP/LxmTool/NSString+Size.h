//
//  NSString+Size.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
/**
 获得字符串的大小
 */

-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize;
+ (NSString *)stringToMD5:(NSString *)str;
+ (NSDate *)getCurrentTime;
+ (NSDate *)dataWithStr:(NSString *)str;

- (BOOL)isContrainsKong;

- (BOOL)isValid;

/**
 获取字符串字节数
 */
- (NSUInteger)charactorNumber;

- (NSData *)GB2312Data;

+ (NSString *)convertToJsonData:(id )dict;

+ (NSString *)getFommateYMD:(NSDate *)date;

//获取当前格式化时间
+ (NSString *)getFommateCurrentString;

+(NSDate *)dataFommatWithStr:(NSString *)str;

@end
