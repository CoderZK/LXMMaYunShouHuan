//
//  LxmLocalDataManager.m
//  JawboneUP
//
//  Created by songnaiyin on 2017/12/14.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmLocalDataManager.h"

@implementation LxmLocalDataManager

+ (instancetype)shareManager {
    static LxmLocalDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LxmLocalDataManager alloc] init];
    });
    return manager;
}

- (NSString *)cacheFilePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localMsg.plist"];
}

- (instancetype)init {
    if (self = [super init]) {
        _localMsgs = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFilePath]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (NSInteger)unReadCount {
    NSPredicate *p = [NSPredicate predicateWithBlock:^BOOL(lxmMessageModel * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[lxmMessageModel class]]) {
            return evaluatedObject.isRead.boolValue;
        } else {
            return NO;
        }
    }];
    NSArray *arr = [_localMsgs filteredArrayUsingPredicate:p];
    return arr.count;
}

- (void)appWillTerminate {
    if (_localMsgs) {
        [NSKeyedArchiver archiveRootObject:_localMsgs toFile:[self cacheFilePath]];
    }
}

/**
 清空数据
 */
- (void)clearLocalData {
    [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePath] error:nil];
    _localMsgs = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LxmLocalDataManagerNewMsgNotication object:nil];
}

/**
 增加一条本地消息 会触发新消息通知
 */
- (void)addMsg:(lxmMessageModel *)model {
    if (model) {
        NSMutableArray *arr = [NSMutableArray array];
        if (_localMsgs.count > 0) {
            [arr addObjectsFromArray:_localMsgs];
        }
        [arr addObject:model];
        _localMsgs = arr;
        [[NSNotificationCenter defaultCenter] postNotificationName:LxmLocalDataManagerNewMsgNotication object:nil];
    }
}

/**
 删除消息 会触发新消息通知
 */
- (void)removeMsg:(lxmMessageModel *)model {
    if (model && [_localMsgs containsObject:model]) {
        NSMutableArray *arr = [NSMutableArray array];
        if (_localMsgs.count > 0) {
            [arr addObjectsFromArray:_localMsgs];
        }
        [arr removeObject:model];
        _localMsgs = arr;
        [[NSNotificationCenter defaultCenter] postNotificationName:LxmLocalDataManagerNewMsgNotication object:nil];
    }
}

/**
 设置消息未已读 会触发新消息通知
 */
- (void)readMsg:(lxmMessageModel *)model {
    if (model && [_localMsgs containsObject:model]) {
        model.isRead = @(1);
        [[NSNotificationCenter defaultCenter] postNotificationName:LxmLocalDataManagerNewMsgNotication object:nil];
    }
}

/**
 检测是否有未读消息
 */
- (BOOL)checkMeg:(NSArray *)localMsgs
{
    if (localMsgs.count>0) {
        NSMutableArray * arr = [NSMutableArray new];
        for (lxmMessageModel * model in localMsgs) {
            if ([model.isRead intValue] == 2) {
                [arr addObject:model];
            }
        }
        if (arr.count>0) {
            return YES;
        }else{
            return NO;
        }
    }return NO;
}
@end
