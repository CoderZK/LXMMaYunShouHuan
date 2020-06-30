//
//  LxmLocalDataManager.h
//  JawboneUP
//
//  Created by songnaiyin on 2017/12/14.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmJiaZhangModel.h"

/**
 新消息通知
 */
#define LxmLocalDataManagerNewMsgNotication @"LxmLocalDataManagerNewMsgNotication"

@interface LxmLocalDataManager : NSObject

@property (nonatomic, readonly) NSArray<lxmMessageModel *> *localMsgs;

@property (nonatomic, readonly) NSInteger unReadCount;

+ (instancetype)shareManager;

/**
 清空数据
 */
- (void)clearLocalData;

/**
 增加一条本地消息 会触发新消息通知
 */
- (void)addMsg:(lxmMessageModel *)model;

/**
 删除消息 会触发新消息通知
 */
- (void)removeMsg:(lxmMessageModel *)model;

/**
 设置消息未已读 会触发新消息通知
 */
- (void)readMsg:(lxmMessageModel *)model;

/**
 检测是否有已读消息
 */
- (BOOL)checkMeg:(NSArray *)localMsgs;
@end
