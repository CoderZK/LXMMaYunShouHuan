//
//  LxmTool.m
//  FeiQu
//
//  Created by 李晓满 on 2017/3/28.
//  Copyright © 2017年 李炎. All rights reserved.
//

#import "LxmTool.h"
static LxmTool * __tool = nil;
@implementation LxmTool
@synthesize isLogin = _isLogin;


+(LxmTool *)ShareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __tool=[[LxmTool alloc] init];
    });
    return __tool;
}
- (instancetype)init
{
    if (self = [super init])
    {
        BOOL isLogin = [self isLogin];
    }
    return self;
}
-(void)setIsClosePush:(BOOL)isClosePush {
    [[NSUserDefaults standardUserDefaults] setBool:isClosePush forKey:@"isClosePush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isClosePush {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isClosePush"];
}

-(void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isLogin
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    });
    return _isLogin;
}

- (void)setMessageID:(NSString *)messageID{
    [[NSUserDefaults standardUserDefaults] setObject:messageID forKey:@"messageID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)messageID{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"messageID"];
}

-(void)setSession_token:(NSString *)session_token {
    [[NSUserDefaults standardUserDefaults] setObject:session_token forKey:@"session_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session_token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_token"];
}

-(void)setHasPerfect:(NSString *)hasPerfect {
    [[NSUserDefaults standardUserDefaults] setObject:hasPerfect forKey:@"hasPerfect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSString *)hasPerfect{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hasPerfect"];
}
-(BOOL)isTeacher {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isTeacher"];
}

-(void)setIsTeacher:(BOOL)isTeacher {
    [[NSUserDefaults standardUserDefaults] setBool:isTeacher forKey:@"isTeacher"];
}

-(void)setSession_uid:(NSString *)session_uid
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",session_uid] forKey:@"id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session_uid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
}
-(void)setMessageCount:(NSInteger)messageCount
{
    if (messageCount<=0) {
        messageCount = 0;
    }
    _messageCount = messageCount;
}

-(void)uploadDeviceToken
{
    if (self.isLogin&&self.session_token&&self.deviceToken)
    {
        NSDictionary * dic = @{
                               @"dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                               @"token":self.session_token,
                               @"dev_token":self.deviceToken,
                               @"dev_type":@1
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine getUploadDeviceTokenURL] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"qqqq%@",responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

@end
