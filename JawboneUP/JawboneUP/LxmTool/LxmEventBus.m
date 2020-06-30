//
//  LxmEventBus.m
//  54school
//
//  Created by 宋乃银 on 2018/9/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmEventBus.h"

@interface LxmEventBus()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<EventBlock> *> *dict;

@end

@implementation LxmEventBus

+ (void)sendEvent:(NSString *)eventName data:(id)data {
    [[LxmEventBus shared] sendEvent:eventName data:data];
}

+ (void)registerEvent:(NSString *)eventName block:(EventBlock)block {
    [[LxmEventBus shared] registerEvent:eventName block:block];
}

+ (instancetype)shared {
    static LxmEventBus *__LxmEventBus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __LxmEventBus = [[LxmEventBus alloc] init];
    });
    return __LxmEventBus;
}

- (void)sendEvent:(NSString *)eventName data:(id)data {
    NSArray<EventBlock> *arr = [self.dict objectForKey:eventName];
    for (EventBlock obj in arr) {
        obj(data);
    }
}

- (void)registerEvent:(NSString *)eventName block:(EventBlock)block {
    if (eventName && block) {
        NSMutableArray<EventBlock> *arr = [self.dict objectForKey:eventName];
        if (!arr) {
            arr = [NSMutableArray array];
            [self.dict setObject:arr forKey:eventName];
        }
        [arr addObject:block];
    }
}

- (NSMutableDictionary<NSString *,NSMutableArray<EventBlock> *> *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

@end
