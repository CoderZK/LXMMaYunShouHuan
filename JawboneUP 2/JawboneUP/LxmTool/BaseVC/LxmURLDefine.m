//
//  LxmURLDefine.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmURLDefine.h"

@implementation LxmURLDefine
/**
 用户登录
 */
+ (NSString *)getLoginURL {
    return [Base_URL stringByAppendingString:@"app_login.do"];
}
/**
 获取验证码
 */
+ (NSString *)getCode {
    return [Base_URL stringByAppendingString:@"app_sendMobile.do"];
}

/**
 用户注册
 */
+ (NSString *)getRegisterURL {
    return [Base_URL stringByAppendingString:@"app_register.do"];
}

/**
 忘记密码
 */
+ (NSString *)getpassWordURL {
    return [Base_URL stringByAppendingString:@"app_findPassword.do"];
}

/**
 更改手机
 */
+ (NSString *)getModifyPhoneURL {
    return [Base_URL stringByAppendingString:@"user_modifyPhone.do"];
}










/**
 获取家长身份列表
 */
+ (NSString *)getRoleURL
{
     return [Base_URL stringByAppendingString:@"app_findIdentityList.do"];
}
/**
  上传身份信息和设备信息
 */
+ (NSString *)getInfoURL
{
    return [Base_URL stringByAppendingString:@"user_perfectData.do"];
}

/**
 添加子机
 */
+ (NSString *)getsubDeviceInfoURL
{
    return [Base_URL stringByAppendingString:@"user_insertChildEqu.do"];
}
/**
 获取设置界面信息
 */
+ (NSString *)getSettingInfoURL
{
    return [Base_URL stringByAppendingString:@"user_getInfo.do"];
}
/**
 获取个人信息
 */
+ (NSString *)getUserInfoURL
{
    return [Base_URL stringByAppendingString:@"user_getUserInfo.do"];
}
/**
 修改个人信息
 */
+ (NSString *)getEditUserInfoURL
{
    return [Base_URL stringByAppendingString:@"user_editUserInfo.do"];
}
/**
 获取已绑定设备列表
 */
+ (NSString *)getBandDeviceListURL
{
    return [Base_URL stringByAppendingString:@"user_findOwerEquList.do"];
}
/**
 上传推送token
 */
+ (NSString *)getUploadDeviceTokenURL
{
    return [Base_URL stringByAppendingString:@"user_upUmeng.do"];
}
/**
 反馈意见
 */
+ (NSString *)getAdviceURL
{
    return [Base_URL stringByAppendingString:@"user_feedback.do"];
}
/**
 退出登录
 */
+ (NSString *)getExitLoginURL
{
    return [Base_URL stringByAppendingString:@"user_logout.do"];
}
/**
 获取已绑定设备资料
 */
+ (NSString *)getOwerDeviceURL
{
    return [Base_URL stringByAppendingString:@"user_getOwerEquInfo.do"];
}
/**
 修改已绑定设备资料
 */
+ (NSString *)getModifyDeviceURL
{
    return [Base_URL stringByAppendingString:@"user_editOwerEqu.do"];
}
/**
 获取消息列表
 */
+ (NSString *)getMsgListURL
{
    return [Base_URL stringByAppendingString:@"user_findMsgList.do"];
}




/**
 获取子机列表
 */
+ (NSString *)getuserFindChildEquListURL
{
    return [Base_URL stringByAppendingString:@"user_findChildEquList.do"];
}
/**
 查找好友
 */
+ (NSString *)getSearchUserURL
{
    return [Base_URL stringByAppendingString:@"user_searchUser.do"];
}
/**
 好友申请
 */
+ (NSString *)getApplyFriendURL
{
     return [Base_URL stringByAppendingString:@"user_applyFriend.do"];
}

/**
 好友申请回复
 */
+ (NSString *)getApplyFriendReplyURL
{
    return [Base_URL stringByAppendingString:@"user_replyFriendApply.do"];
}
/**
 获取好友列表
 */
+ (NSString *)getFindFriendListURL
{
    return [Base_URL stringByAppendingString:@"user_findFriendList.do"];
}

/**
 获取消息详情
 */
+ (NSString *)getMessageDetailURL
{
    return [Base_URL stringByAppendingString:@"user_getMsgInfo.do"];
}
/**
 委托申请
 */
+ (NSString *)getApplyEntrustURL
{
    return [Base_URL stringByAppendingString:@"user_applyEntrust.do"];
}
/**
 委托申请回复
 */
+ (NSString *)getApplyEntrustReplyURL
{
    return [Base_URL stringByAppendingString:@"user_replyEntrustApply.do"];
}
/**
 获取子机授权的母机列表
 */
+ (NSString *)getFindMotherEqulistURL
{
     return [Base_URL stringByAppendingString:@"user_findMotherEquList.do"];
}
/**
 解除委托
 */
+ (NSString *)getClearEntrustURL
{
    return [Base_URL stringByAppendingString:@"user_clearEntrust.do"];
}
/**
 删除消息
 */
+ (NSString *)getDeleteMsgURL
{
    return [Base_URL stringByAppendingString:@"user_delMsg.do"];
}
/**
 设置消息为已读
 */
+ (NSString *)setMsgReadURL
{
     return [Base_URL stringByAppendingString:@"user_editMsg.do"];
}

/**
 检测是否有已读消息
 */
+ (NSString *)checkMsg
{
    return [Base_URL stringByAppendingString:@"user_checkMsg.do"];
}
@end
