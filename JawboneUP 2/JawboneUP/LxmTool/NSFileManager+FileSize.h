//
//  NSFileManager+FileSize.h
//  
//
//  Created by lxm on 15/5/7.
//  Copyright (c) 2015年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSFileManager (FileSize)
/**
 *  获取路径下的文件或文件夹的大小
 *
 *  @param filePath 文件或文件夹的路径
 *
 *  @return 大小
 */
+(CGFloat)getFileSizeForDir:(NSString*)filePath;
@end
