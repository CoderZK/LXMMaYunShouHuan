//
//  CBPeripheral+TongXinID.m
//  JawboneUP
//
//  Created by 宋乃银 on 2017/11/18.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "CBPeripheral+MAC.h"
#import <objc/runtime.h>

@implementation CBPeripheral (Callback)

- (BuShuCallBlock)bushuChaXunBack {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBushuChaXunBack:(BuShuCallBlock)bushuChaXunBack {
    objc_setAssociatedObject(self, @selector(bushuChaXunBack), bushuChaXunBack, OBJC_ASSOCIATION_COPY);
}

- (void)cancelBuShuCallBlockAfter:(CGFloat)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runBuShuCallBlock) object:nil];
    [self performSelector:@selector(runBuShuCallBlock) withObject:nil afterDelay:delay];
}

- (void)runBuShuCallBlock {
    if (self.bushuChaXunBack) {
        self.bushuChaXunBack(self, [self.stepDict copy]);
        self.bushuChaXunBack = nil;
        [self.stepDict removeAllObjects];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runBuShuCallBlock) object:nil];
}

- (BuShuCallBlock)distanceChaXunBack {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDistanceChaXunBack:(BuShuCallBlock)distanceChaXunBack {
    objc_setAssociatedObject(self, @selector(distanceChaXunBack), distanceChaXunBack, OBJC_ASSOCIATION_COPY);
}

- (void)cancelDistanceCallbackAfter:(CGFloat)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runDistanceCallback) object:nil];
    [self performSelector:@selector(runDistanceCallback) withObject:nil afterDelay:delay];
}

- (void)runDistanceCallback {
    if (self.distanceChaXunBack) {
        self.distanceChaXunBack(self, [self.distanceDict copy]);
        self.distanceChaXunBack = nil;
        [self.distanceDict removeAllObjects];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runDistanceCallback) object:nil];
}


- (ConnectCallback)connectCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setConnectCallback:(ConnectCallback)connectCallback {
    objc_setAssociatedObject(self, @selector(connectCallback), connectCallback, OBJC_ASSOCIATION_COPY);
}

- (MasterCallback)masterCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMasterCallback:(MasterCallback)masterCallback {
    objc_setAssociatedObject(self, @selector(masterCallback), masterCallback, OBJC_ASSOCIATION_COPY);
}

- (SetValueCallBack)setAlertCallBack {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSetAlertCallBack:(SetValueCallBack)setAlertCallBack {
    objc_setAssociatedObject(self, @selector(setAlertCallBack), setAlertCallBack, OBJC_ASSOCIATION_COPY);
}

- (SetValueCallBack)setDistanceCallback {
    return objc_getAssociatedObject(self, _cmd);

}

- (void)setSetDistanceCallback:(SetValueCallBack)setDistanceCallback {
    objc_setAssociatedObject(self, @selector(setDistanceCallback), setDistanceCallback, OBJC_ASSOCIATION_COPY);
}

- (SetValueCallBack)addSubDeviceCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAddSubDeviceCallback:(SetValueCallBack)addSubDeviceCallback {
    objc_setAssociatedObject(self, @selector(addSubDeviceCallback), addSubDeviceCallback, OBJC_ASSOCIATION_COPY);
}

- (SetValueCallBack)deleteSubDeviceCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDeleteSubDeviceCallback:(SetValueCallBack)deleteSubDeviceCallback {
    objc_setAssociatedObject(self, @selector(deleteSubDeviceCallback), deleteSubDeviceCallback, OBJC_ASSOCIATION_COPY);
}



@end

@implementation CBPeripheral (MAC)

- (void)setTongxinId:(NSString *)tongxinId {
    objc_setAssociatedObject(self, "tongxinId", tongxinId, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)tongxinId {
    return objc_getAssociatedObject(self, "tongxinId");
}

- (void)setDistance:(NSString *)distance {
    objc_setAssociatedObject(self, "distance", distance, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)distance {
    return objc_getAssociatedObject(self, "distance");
}


- (void)setFarDistance:(NSString *)farDistance {
    objc_setAssociatedObject(self, "farDistance", farDistance, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)farDistance {
    return objc_getAssociatedObject(self, "farDistance");
}

- (void)setFarNumDistance:(NSString *)farNumDistance {
    objc_setAssociatedObject(self, "farNumDistance", farNumDistance, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)farNumDistance {
    return objc_getAssociatedObject(self, "farNumDistance");
}


- (void)setSafeDistance:(NSString *)safeDistance {
    objc_setAssociatedObject(self, "safeDistance", safeDistance, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)safeDistance {
    return objc_getAssociatedObject(self, "safeDistance");
}

- (BOOL)isYanshi {
    return [objc_getAssociatedObject(self, "isYanshi") boolValue];
}

- (void)setIsYanshi:(BOOL)isYanshi {
    objc_setAssociatedObject(self, "isYanshi", @(isYanshi), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isMaster {
    return [objc_getAssociatedObject(self, "isMaster") boolValue];
}

- (void)setIsMaster:(BOOL)isMaster {
    objc_setAssociatedObject(self, "isMaster", @(isMaster), OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)power {
    return objc_getAssociatedObject(self, "power");
}

- (void)setPower:(NSNumber *)power {
    objc_setAssociatedObject(self, "power", power, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)powerStatus {
    return objc_getAssociatedObject(self, "powerStatus");
}

- (void)setPowerStatus:(NSNumber *)powerStatus {
    objc_setAssociatedObject(self, "powerStatus", powerStatus, OBJC_ASSOCIATION_RETAIN);
}


- (NSString *)randomKey {
    return objc_getAssociatedObject(self, "randomKey");
}

- (void)setRandomKey:(NSString *)randomKey {
    objc_setAssociatedObject(self, "randomKey", randomKey, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)step {
    return objc_getAssociatedObject(self, "step");
}

- (void)setStep:(NSNumber *)step {
    objc_setAssociatedObject(self, "step", step, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)hVersion {
    return objc_getAssociatedObject(self, "hVersion");
}

- (void)setHVersion:(NSString *)hVersion {
    objc_setAssociatedObject(self, "hVersion", hVersion, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)fVersion {
    return objc_getAssociatedObject(self, "fVersion");
}

- (void)setFVersion:(NSString *)fVersion {
    objc_setAssociatedObject(self, "fVersion", fVersion, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)isRealTime {
    return objc_getAssociatedObject(self, "isRealTime");
}

- (void)setIsRealTime:(NSString *)isRealTime {
    objc_setAssociatedObject(self, "isRealTime", isRealTime, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)tongxinIds {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (NSMutableDictionary *)stepDates {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (NSMutableDictionary *)distanceDates {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (void (^)(NSDictionary<NSString *,NSString *> *))stepDatesCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setStepDatesCallback:(void (^)(NSDictionary<NSString *,NSString *> *))stepDatesCallback {
    objc_setAssociatedObject(self, @selector(stepDatesCallback), stepDatesCallback, OBJC_ASSOCIATION_COPY);
}

- (void)runStepDatesCallback {
    if (self.stepDatesCallback) {
        self.stepDatesCallback(self.stepDates);
        self.stepDatesCallback = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runStepDatesCallback) object:nil];
}

- (void)cancelStepDatesCallbackAfter:(CGFloat)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runStepDatesCallback) object:nil];
    [self performSelector:@selector(runStepDatesCallback) withObject:nil afterDelay:delay];
}

- (void (^)(NSDictionary<NSString *,NSString *> *))distanceDatesCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDistanceDatesCallback:(void (^)(NSDictionary<NSString *,NSString *> *))distanceDatesCallback {
    objc_setAssociatedObject(self, @selector(distanceDatesCallback), distanceDatesCallback, OBJC_ASSOCIATION_COPY);
}

- (void)cancelDistanceDatesCallbackAfter:(CGFloat)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runDistanceDatesCallback) object:nil];
    [self performSelector:@selector(runDistanceDatesCallback) withObject:nil afterDelay:delay];
}
- (void)runDistanceDatesCallback {
    if (self.distanceDatesCallback) {
        self.distanceDatesCallback(self.distanceDates);
        self.distanceDatesCallback = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runDistanceDatesCallback) object:nil];
}

- (NSMutableDictionary *)stepDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

- (NSMutableDictionary *)distanceDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}


@end
