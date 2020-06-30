//
//  UIAlertController+AlertWithKey.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (AlertWithKey)

+(void)showAlertWithKey:(NSNumber *)num message:(NSString *)message atVC:(UIViewController *)vc;

+ (void)showAlertWithmessage:(NSString *)message atVC:(UIViewController *)vc;

@end
