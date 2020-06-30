//
//  LxmConnectModel.h
//  JawboneUP
//
//  Created by 宋乃银 on 2017/11/4.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmConnectModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *uuidStr;

@property (nonatomic, strong) NSString *tongxinId;

@property (nonatomic, assign) BOOL isMaster;

@end
