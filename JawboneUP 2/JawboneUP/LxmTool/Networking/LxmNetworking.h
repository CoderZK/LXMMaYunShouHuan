//
//  LxmNetworking.h
//  ShareGo
//
//  Created by 李晓满 on 16/4/23.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(NSURLSessionDataTask * task,id responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * task,NSError * error);


@interface LxmNetworking : NSObject

/**
 post_json
 */
+(void)networkingPOST:(NSString *)urlStr parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 get_json
 */
+(void)networkingGET:(NSString *)urlStr parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 上传图片_json
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr image:(UIImage *)image image1:(UIImage *)image1 parameters:(id)parameters name:(NSString *)name name1:(NSString *)name1 success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 多张上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr images:(NSArray<UIImage *> *)images parameters:(id)parameters name:(NSString *)name success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 两个数组上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr imagesFirst:(NSArray<UIImage *> *)imagesFirst imagesSecond:(NSArray<UIImage *> *)imagesSecond parameters:(id)parameters name1:(NSString *)name1 name2:(NSString *)name2 success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
