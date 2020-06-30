//
//  LxmBLEManager+Tongbu.m
//  JawboneUP
//
//  Created by 李晓满 on 2020/1/11.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmBLEManager+Tongbu.h"
#import "LxmDataManager.h"
#import "LxmDateModel.h"

@implementation LxmBLEManager (Tongbu)

- (void)tongbuDataShowHUD:(BOOL)showHUD {
    if (self.isTongbuStep || self.isTongbuDistance) {
        return;
    }
    if (!self.yitongbuDistanceArr) {
        self.yitongbuDistanceArr = [NSMutableArray array];
        NSArray *arr1 = [NSUserDefaults.standardUserDefaults objectForKey:@"yitongbuDistanceArr"];
        if ([arr1 isKindOfClass:NSArray.class] && arr1.count > 0) {
            [self.yitongbuDistanceArr addObjectsFromArray:arr1];
        }
    }
    if (!self.yitongbuStepArr) {
        self.yitongbuStepArr = [NSMutableArray array];
        NSArray *arr2 = [NSUserDefaults.standardUserDefaults objectForKey:@"yitongbuStepArr"];
        if ([arr2 isKindOfClass:NSArray.class] && arr2.count > 0) {
            [self.yitongbuStepArr addObjectsFromArray:arr2];
        }
    }
    if (showHUD) {
        [SVProgressHUD showWithStatus:@"数据正在同步,请稍后..."];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self tongbuStep];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
}

/// 同步步数到后台
- (void)tongbuStep {
    [self tongbuStepFor:self.serverDeviceArr];
}

/// 同步距离到后台
- (void)tongbuDistance {
    [self tongbuDistanceFor:self.serverDeviceArr];
}


- (void)tongbuStepFor:(NSArray<LxmDeviceModel *> *)arr {
    if (arr.count == 0) {
        return;
    }
    LxmBLEManager.shareManager.isTongbuStep = YES;
    // 使用信号量 保证设备按顺序同步  上一个步数获取完成 在获取下一个
    NSLog(@"tongbutongbu : 开始同步步数 - start");
    dispatch_semaphore_t deviceSema = dispatch_semaphore_create(0);
    for (LxmDeviceModel *model in arr) {
        CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:model.communication];
        NSLog(@"tongbutongbu : 查询步数日期-start");
        [LxmBLEManager.shareManager chaxunBuShuSevenDayData:p completed:^(NSDictionary<NSString *,NSString *> *stepDates) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"tongbutongbu : 查询步数日期-end");
                NSDictionary *dates = stepDates.copy;
                if (dates.count > 0) {
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                    for (NSString *dateKey in dates.allKeys) {
                        NSString *date = dates[dateKey];
                        if (date.length != 6) {
                            continue;
                        }
                        NSString *y = [date substringWithRange:NSMakeRange(0, 2)];
                        NSString *m = [date substringWithRange:NSMakeRange(2, 2)];
                        NSString *d = [date substringWithRange:NSMakeRange(4, 2)];
                        NSString *time = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d]];
                        NSString *modelTime = model.time;
                        if (model.time.length >= 10) {
                            modelTime = [model.time substringToIndex:10];
                        }
                        if ([time compare:modelTime] != NSOrderedAscending) {
                            NSLog(@"tongbutongbu : 获取日期步数-start");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *key = [NSString stringWithFormat:@"%@-%@", p.tongxinId, date];
                                if ([self.yitongbuStepArr containsObject:key] && ![self isCurrentDay:date]) {
                                    // 该设备 该天  已同步过 且 不是今天 不需要再同步
                                    NSLog(@"tongbutongbu : 获取日期步数-end1");
                                    dispatch_semaphore_signal(sema);
                                } else {
                                    [LxmBLEManager.shareManager checkStep:p date:date completed:^(CBPeripheral *p, NSDictionary<NSString *, NSString *> *steps) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            NSLog(@"tongbutongbu : 获取日期步数-end2");
                                            dispatch_semaphore_signal(sema);
                                        });
                                        [self uploadStep:steps date:date tongxinId:p.tongxinId];
                                    }];
                                }
                            });
                            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                        }
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_semaphore_signal(deviceSema);
                });
            });
        }];
        dispatch_semaphore_wait(deviceSema, DISPATCH_TIME_FOREVER);
    }
    NSLog(@"tongbutongbu : 开始同步步数 - end");
    LxmBLEManager.shareManager.isTongbuStep = NO;
    [NSThread sleepForTimeInterval:2];
    [self tongbuDistance];
}

- (void)tongbuDistanceFor:(NSArray *)arr {
    if (arr.count == 0) {
        return;
    }
    LxmBLEManager.shareManager.isTongbuDistance = YES;
    // 使用信号量 保证设备按顺序同步  上一个步数获取完成 在获取下一个
    NSLog(@"tongbutongbu : 开始同步距离 - start");
    dispatch_semaphore_t deviceSema = dispatch_semaphore_create(0);
    for (LxmDeviceModel *model in arr) {
        if (![model.communication isEqualToString:self.master.tongxinId]) {
            //主机没有距离
            NSLog(@"tongbutongbu : 查询距离日期-start");
            CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:model.communication];
            [LxmBLEManager.shareManager chaxunDistanceSevenDayData:p completed:^(NSDictionary<NSString *,NSString *> *distanceDates) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"tongbutongbu : 查询距离日期-end");
                    NSDictionary *dates = distanceDates.copy;
                    if (dates.count > 0) {
                        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                        for (NSString *dateKey in dates.allKeys) {
                            NSString *date = dates[dateKey];
                            if (date.length != 6) {
                                continue;
                            }
                            NSString *y = [date substringWithRange:NSMakeRange(0, 2)];
                            NSString *m = [date substringWithRange:NSMakeRange(2, 2)];
                            NSString *d = [date substringWithRange:NSMakeRange(4, 2)];
                            NSString *time = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d]];
                            NSString *modelTime = model.time;
                            if (model.time.length >= 10) {
                                modelTime = [model.time substringToIndex:10];
                            }
                            if ([time compare:modelTime] != NSOrderedAscending) {
                                NSLog(@"tongbutongbu : 获取日期距离-start");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSString *key = [NSString stringWithFormat:@"%@-%@", p.tongxinId, date];
                                    if ([self.yitongbuDistanceArr containsObject:key] && ![self isCurrentDay:date]) {
                                        // 该设备 该天  已同步过 且 不是今天 不需要再同步
                                        NSLog(@"tongbutongbu : 获取日期距离-end1");
                                        dispatch_semaphore_signal(sema);
                                    } else {
                                        [LxmBLEManager.shareManager checkDistance:p date:date completed:^(CBPeripheral *p, NSDictionary<NSString *, NSString *> *distances) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSLog(@"tongbutongbu : 获取日期距离-end2");
                                                dispatch_semaphore_signal(sema);
                                            });
                                            [self uploadDistance:distances date:date tongxinId:p.tongxinId];
                                        }];
                                    }
                                });
                                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                            }
                        }
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        dispatch_semaphore_signal(deviceSema);
                    });
                });
            }];
            dispatch_semaphore_wait(deviceSema, DISPATCH_TIME_FOREVER);
        }
    }
    NSLog(@"tongbutongbu : 开始同步距离 - end");
    LxmBLEManager.shareManager.isTongbuDistance = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [LxmEventBus sendEvent:@"TongbuSuccess" data:nil];
    });
}

// 是否是今天
- (BOOL)isCurrentDay:(NSString *)date {
    NSDate *now = [NSDate date];
   // 日历
   NSCalendar *calendar1 = [NSCalendar currentCalendar];
   // 利用日历类从当前时间对象中获取 年月日时分秒(单独获取出来)
   NSCalendarUnit type = NSCalendarUnitYear |
                         NSCalendarUnitMonth | NSCalendarUnitDay;
   NSDateComponents *cmps = [calendar1 components:type fromDate:now];
   NSMutableString *string = [NSMutableString string];
   NSArray *arr = @[@(cmps.year - 2000), @(cmps.month), @(cmps.day)];
   for (int i = 0; i < arr.count; i++) {
       int num = [arr[i] intValue];
       NSString * str = [LxmDataManager ToHex:num];
       str = [NSString stringWithFormat:@"00%@", str];
       str = [str substringFromIndex:str.length - 2];
       [string appendString:str];
   }
    return [date.lowercaseString isEqualToString:string.lowercaseString];
}

/// 上传步数
- (void)uploadStep:(NSDictionary *)steps date:(NSString *)date tongxinId:(NSString *)tongxinId {
    if (date.length != 6 ) {
        return;
    }
    // 不是当前  而且条数不是288 return
    if (![self isCurrentDay:date] && steps.count != 24) {
        return ;
    }

    NSString *key = [NSString stringWithFormat:@"%@-%@", tongxinId, date];
    NSString *y = [date substringWithRange:NSMakeRange(0, 2)];
    NSString *m = [date substringWithRange:NSMakeRange(2, 2)];
    NSString *d = [date substringWithRange:NSMakeRange(4, 2)];
    
    void(^uploadStepBlock)(void) = ^(){
        NSMutableArray *stepArr = [NSMutableArray array];
        int allStepNum = 0;
        
        NSArray *keys = [steps.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 intValue] > [obj2 intValue];
        }];
        for (NSString *key in keys) {
           NSString *value = steps[key];
            if (value.intValue < 0) {
                value = @"0";
            }
           NSInteger seconds = (key.integerValue + 1) * 60 * 60;
           
           if (key.integerValue == 23) {
               seconds -= 1;
           }
           
           NSInteger h = seconds / 3600;
           NSInteger mm = (seconds % 3600) / 60;
           NSInteger s = seconds % 60;
            allStepNum += [value intValue];
           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
           dict[@"stepNum"] = value;
           dict[@"communication"] = tongxinId;
        dict[@"time"] = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d], (long)h, (long)mm, (long)s];
           [stepArr addObject:dict];
        }

        NSString *stepInfo = [NSString convertToJsonData:stepArr];
        NSLog(@"%@",stepInfo);
        [LxmNetworking networkingPOST:user_intoStepInfo parameters:@{@"stepInfo":stepInfo,@"allStepNum":@(allStepNum),@"token":[LxmTool ShareTool].session_token} success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"%@",responseObject);
            if (![self isCurrentDay:date]) {
                [self.yitongbuStepArr addObject:key]; // 同步后 当前app打开过程中 将不再同步 当天除外
            }
            [NSUserDefaults.standardUserDefaults setObject:self.yitongbuStepArr forKey:@"yitongbuStepArr"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    };
    
    if ([self isCurrentDay:date]) {
        uploadStepBlock();
    } else {
        NSString *tempDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d]];
        //查询服务器是否有当天的数据 数据完整 就不同步 数据不完整就同步
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"communication"] = tongxinId;
        dict[@"isAll"] = @0;
        dict[@"allTime"] = tempDate;
        dict[@"token"] = LxmTool.ShareTool.session_token;
        
        [LxmNetworking networkingPOST:user_getIsHaveData parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSArray *tempArr = responseObject[@"result"][@"isHaveData"];
                if ([tempArr isKindOfClass:NSArray.class]) {
                    if (tempArr.count > 0) {
                        LxmDateModel *model = [LxmDateModel mj_objectWithKeyValues:tempArr.firstObject];
                        if (model.isHaveStep.intValue == 1) {
                            //这天已经 且不是当天 服务器已经有数据  不需要再上传
                            if (![self isCurrentDay:date]) {
                                [self.yitongbuStepArr addObject:key]; // 同步后 当前app打开过程中 将不再同步 当天除外
                            }
                            [NSUserDefaults.standardUserDefaults setObject:self.yitongbuStepArr forKey:@"yitongbuStepArr"];
                        } else {
                            uploadStepBlock();
                        }
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
}

/// 上传距离
- (void)uploadDistance:(NSDictionary *)distances date:(NSString *)date tongxinId:(NSString *)tongxinId {
    
    CBPeripheral *p = [LxmBLEManager.shareManager peripheralWithTongXinId:tongxinId];
    if (p) {
        NSLog(@"通信ID:%@,超出最远距离:%@,超出最远距离次数:%@", p,p.farDistance,p.farNumDistance);
    }
    if (p.state != CBPeripheralStateConnected) {
        return;
    }
    
    if (date.length != 6 ) {
        return;
    }
    // 不是当前  而且条数不是2880 return
    if (![self isCurrentDay:date] && distances.count != 24) {
        return ;
    }

    NSString *key = [NSString stringWithFormat:@"%@-%@", tongxinId, date];
    NSString *y = [date substringWithRange:NSMakeRange(0, 2)];
    NSString *m = [date substringWithRange:NSMakeRange(2, 2)];
    NSString *d = [date substringWithRange:NSMakeRange(4, 2)];
    
    void(^uploadDistanceBlock)(void) = ^(){
        NSMutableArray *distanceArr = [NSMutableArray array];
        NSArray *keys = [distances.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 intValue] > [obj2 intValue];
        }];
        
        for (NSString *key in keys) {
         NSString *value = distances[key];
            if (value.intValue < 0) {
                value = @"0";
            }
         NSInteger seconds = (key.integerValue + 1) * 60 * 60;
            //2879
         if (key.integerValue == 23) {
             seconds -= 1;
         }
         
         NSInteger h = seconds / 3600;
         NSInteger mm = (seconds % 3600) / 60;
         NSInteger s = seconds % 60;
      
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         if ([value containsString:@"."]) {
            dict[@"distance"] = [NSString stringWithFormat:@"%.1f", value.floatValue];
         } else {
             dict[@"distance"] = value;
         }
         dict[@"communication"] = tongxinId;
            dict[@"time"] = [NSString stringWithFormat:@"%d-%02ld-%02ld %02ld:%02ld:%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d], (long)h, (long)mm, (long)s];
         [distanceArr addObject:dict];
        }
        
        NSString *distanceInfo = [NSString convertToJsonData:distanceArr];
        NSLog(@"%@",distanceInfo);
        [LxmNetworking networkingPOST:user_intoDistanceInfo parameters:@{@"distanceInfo":distanceInfo,@"token":[LxmTool ShareTool].session_token,@"maxDistance":p.farDistance,@"overTimes":p.farNumDistance} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            if (![self isCurrentDay:date]) {
                [self.yitongbuDistanceArr addObject:key]; // 同步后 当前app打开过程中 将不再同步 当天除外
            }
            [NSUserDefaults.standardUserDefaults setObject:self.yitongbuDistanceArr forKey:@"yitongbuDistanceArr"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    };
    
    if ([self isCurrentDay:date]) {
        uploadDistanceBlock();
    } else {
        NSString *tempDate = [NSString stringWithFormat:@"%d-%02ld-%02ld", [LxmDataManager str16to10:y] + 2000, (long)[LxmDataManager str16to10:m], (long)[LxmDataManager str16to10:d]];
        //查询服务器是否有当天的数据 数据完整 就不同步 数据不完整就同步
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"communication"] = tongxinId;
        dict[@"allTime"] = tempDate;
        dict[@"token"] = LxmTool.ShareTool.session_token;
        [LxmNetworking networkingPOST:user_getIsHaveData parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSArray *tempArr = responseObject[@"result"][@"isHaveData"];
                if ([tempArr isKindOfClass:NSArray.class]) {
                    if (tempArr.count > 0) {
                        LxmDateModel *model = [LxmDateModel mj_objectWithKeyValues:tempArr.firstObject];
                        if (model.isHaveDistance.intValue == 1) {
                            //这天已经 且不是当天 服务器已经有数据  不需要再上传
                            if (![self isCurrentDay:date]) {
                                [self.yitongbuDistanceArr addObject:key]; // 同步后 当前app打开过程中 将不再同步 当天除外
                            }
                            [NSUserDefaults.standardUserDefaults setObject:self.yitongbuDistanceArr forKey:@"yitongbuDistanceArr"];
                        } else {
                            uploadDistanceBlock();
                        }
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
    
    
}


@end
