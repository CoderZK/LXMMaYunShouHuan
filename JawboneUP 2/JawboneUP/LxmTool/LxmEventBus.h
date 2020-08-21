//
//  LxmEventBus.h
//  54school
//
//  Created by 宋乃银 on 2018/9/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EventBlock)(id data);

@interface LxmEventBus : NSObject

+ (void)sendEvent:(NSString *)eventName data:(id)data;

+ (void)registerEvent:(NSString *)eventName block:(EventBlock)block;

@end
