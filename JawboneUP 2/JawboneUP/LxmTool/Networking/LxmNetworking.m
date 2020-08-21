//
//  LxmNetworking.m
//  ShareGo
//
//  Created by 李晓满 on 16/4/23.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "LxmNetworking.h"
#import "LxmLoginVC.h"
#import "BaseNavigationController.h"


@implementation LxmNetworking
+(void)networkingPOST:(NSString *)urlStr parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript",@"text/x-chdr", nil];
    [manager.requestSerializer setValue:@"http://iosapi.jkcsoft.com/public/index.html" forHTTPHeaderField:@"Referer"];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LxmNetwrokin :\nurl:\n%@\nparameters:\n%@\nresponseObject:\n%@",urlStr, mDict,responseObject);
        if (success) {
            if ([[responseObject objectForKey:@"key"] intValue] == 7) {
                [LxmTool ShareTool].isLogin = NO;
                [LxmTool ShareTool].session_token = nil;
                [LxmTool ShareTool].isLogin = NO;
                UIApplication.sharedApplication.delegate.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];;
            }
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
            [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
        }
    }];
    
    
}
+(void)networkingGET:(NSString *)urlStr parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript", nil];
    [manager GET:urlStr parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LxmNetwrokin :\nurl:\n%@\nparameters:\n%@\nresponseObject:\n%@",urlStr, mDict,responseObject);
        if (success) {
            if ([[responseObject objectForKey:@"key"] intValue] == 7) {
                [LxmTool ShareTool].isLogin = NO;
                [LxmTool ShareTool].session_token = nil;
                [LxmTool ShareTool].isLogin = NO;
            }
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            failure(task,error);
        }
    }];
    
}
/**
 上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr image:(UIImage *)image image1:(UIImage *)image1 parameters:(id)parameters name:(NSString *)name name1:(NSString *)name1 success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript", nil];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
             [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name fileName:@"123.jpg" mimeType:@"image/jpeg"];
        }
        if (image1) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image1, 0.5) name:name1 fileName:@"456.jpg" mimeType:@"image/jpeg"];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if ([[responseObject objectForKey:@"key"] intValue] == 7) {
                [LxmTool ShareTool].isLogin = NO;
                [LxmTool ShareTool].session_token = nil;
                [LxmTool ShareTool].isLogin = NO;
            }
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            failure(task,error);
        }
    }];
}

/**
 多张上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr images:(NSArray<UIImage *> *)images parameters:(id)parameters name:(NSString *)name success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"http://iosapi.jkcsoft.com/public/index.html" forHTTPHeaderField:@"Referer"];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images) {
            for (UIImage * image in images) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name fileName:@"teswwt1.jpg" mimeType:@"image/jpeg"];
            }
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            failure(task,error);
        }
    }];
}

/**
 两个数组上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr imagesFirst:(NSArray<UIImage *> *)imagesFirst imagesSecond:(NSArray<UIImage *> *)imagesSecond parameters:(id)parameters name1:(NSString *)name1 name2:(NSString *)name2 success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"http://iosapi.jkcsoft.com/public/index.html" forHTTPHeaderField:@"Referer"];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage * image in imagesFirst) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name1 fileName:@"teswwt11111.jpg" mimeType:@"image/jpeg"];
        }
        for (UIImage * image in imagesSecond) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name2 fileName:@"teswwt222222.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            failure(task,error);
        }
    }];
}

@end
