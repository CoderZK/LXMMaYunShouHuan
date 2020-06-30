//
//  MGKeepActiveTool.h
//  MGKit
//
//  Created by 宋乃银 on 2020/2/11.
//  Copyright © 2020 宋乃银. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGKeepActiveTool : NSObject

/// 程序保持后台运行开关
+ (void)keepActive:(BOOL)keepActive;

@end

NS_ASSUME_NONNULL_END
