//
//  LxmTool.h
//  FeiQu
//
//  Created by 李晓满 on 2017/3/28.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISLOGIN [LxmTool ShareTool].isLogin

@interface LxmTool : NSObject

+(LxmTool *)ShareTool;
@property(nonatomic,assign)bool isLogin;

@property(nonatomic,assign)bool isconnect;//是否连接

@property(nonatomic,strong)NSString * session_token;
@property(nonatomic,strong)NSString * hasPerfect;
@property(nonatomic,strong)NSString * messageID;
@property(nonatomic,assign)BOOL isTeacher;

@property(nonatomic,assign)bool isClosePush;
@property(nonatomic,assign)NSInteger messageCount;
@property(nonatomic,strong)NSString *perName;
@property(nonatomic,strong)NSString *fVersion;
//推送token
@property(nonatomic,strong)NSString * deviceToken;
-(void)uploadDeviceToken;
- (void)loadMsgInfoData;


@end
