//
//  LxmURLDefine.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define Base_URL @"http://192.168.1.116:8086/xysh/api/"
//#define Base_img_URL @"http://192.168.1.116:8086/xysh/downloadFile.do?id="

#define Base_URL @"http://47.100.118.115:8080/xysh/api/"
#define Base_img_URL @"http://47.100.118.115:8080/xysh/downloadFile.do?id="

@interface LxmURLDefine : NSObject
//http://192.168.1.222:8086/xysh/api/back_findBaseTypeList.do
/**
 获取验证码
 */
+ (NSString *)getCode;

/**
 用户注册
 */
+ (NSString *)getRegisterURL;
/**
 忘记密码
 */
+ (NSString *)getpassWordURL;
/**
 更改手机
 */
+ (NSString *)getModifyPhoneURL;
/**
 获取消息列表
 */
+ (NSString *)getMsgListURL;


/**
 用户登录
 */
+ (NSString *)getLoginURL;

/**
获取家长身份列表
 */
+ (NSString *)getRoleURL;

/**
 上传身份信息和设备信息
 */
+ (NSString *)getInfoURL;

/**
添加子机
 */
+ (NSString *)getsubDeviceInfoURL;
/**
 获取设置界面信息
 */
+ (NSString *)getSettingInfoURL;

/**
 获取个人信息
 */
+ (NSString *)getUserInfoURL;
/**
 修改个人信息
 */
+ (NSString *)getEditUserInfoURL;
/**
 获取已绑定设备列表
 */
+ (NSString *)getBandDeviceListURL;

/**
 上传推送token
 */
+ (NSString *)getUploadDeviceTokenURL;
/**
 反馈意见
 */
+ (NSString *)getAdviceURL;
/**
退出登录
 */
+ (NSString *)getExitLoginURL;

/**
获取已绑定设备资料
 */
+ (NSString *)getOwerDeviceURL;


/**
 修改已绑定设备资料
 */
+ (NSString *)getModifyDeviceURL;

/**
 获取子机列表
 */
+ (NSString *)getuserFindChildEquListURL;
/**
 查找好友
 */
+ (NSString *)getSearchUserURL;
/**
 好友申请
 */
+ (NSString *)getApplyFriendURL;

/**
 好友申请回复
 */
+ (NSString *)getApplyFriendReplyURL;

/**
 获取好友列表
 */
+ (NSString *)getFindFriendListURL;


/**
 获取消息详情
 */
+ (NSString *)getMessageDetailURL;
/**
 委托申请
 */
+ (NSString *)getApplyEntrustURL;
/**
 委托申请回复
 */
+ (NSString *)getApplyEntrustReplyURL;
/**
获取子机授权的母机列表
 */
+ (NSString *)getFindMotherEqulistURL;
/**
 解除委托
 */
+ (NSString *)getClearEntrustURL;
/**
 删除消息
 */
+ (NSString *)getDeleteMsgURL;
/**
设置消息为已读
 */
+ (NSString *)setMsgReadURL;
/**
 检测是否有已读消息
 */
+ (NSString *)checkMsg;

/**
 同步步数
 */
#define  user_intoStepInfo  Base_URL"user_intoStepInfo.do"
/**
 同步距离
 */
#define  user_intoDistanceInfo  Base_URL"user_intoDistanceInfo.do"
/**
 获取指定时间段（天）内，每一天是否有数据
 */
#define  user_getIsHaveData  Base_URL"user_getIsHaveData.do"

/**
 同步超出距离的机器
 */
#define  user_intoDistanceOverData  Base_URL"user_intoDistanceOverData.do"

/**
 获取最近往前推三天的计步数据
 */
#define  user_getNearStepData  Base_URL"user_getNearStepData.do"
/**
 获取最近往前推三天的计步数据
 */
#define  user_getDistanceData  Base_URL"user_getDistanceData.do"

/**
 判断自己是否被别的主机绑定过
 */
#define  user_verifyChildEqu  Base_URL"user_verifyChildEqu.do"


/**
  获取子机升级信息
 */
#define  get_child_equipment_firmware  Base_URL"get_child_equipment_firmware.do"

/**
 获取母机升级信息
 */
#define  get_equipment_firmware  Base_URL"get_equipment_firmware.do"

@end
