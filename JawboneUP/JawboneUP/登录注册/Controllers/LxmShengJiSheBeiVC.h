//
//  LxmShengJiSheBeiVC.h
//  JawboneUP
//
//  Created by zk on 2020/8/19.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmShengJiSheBeiVC : BaseViewController
@property(nonatomic,assign)BOOL isZhengChang;
@property(nonatomic,assign)BOOL isComeHome;
@property(nonatomic,strong)NSDictionary *dataDict;
@property(nonatomic,strong)NSString *type; //子机或者母机 1,3 母机
@property(nonatomic,strong)CBPeripheral *peripheral;//中心服务
@property(nonatomic,strong)NSString *noStr; //硬件版本号
@property(nonatomic,strong)NSString *firmwareNo;// 软件版本号

@property(nonatomic,copy)void(^shengJiChengGongBlock)();

@end

NS_ASSUME_NONNULL_END
