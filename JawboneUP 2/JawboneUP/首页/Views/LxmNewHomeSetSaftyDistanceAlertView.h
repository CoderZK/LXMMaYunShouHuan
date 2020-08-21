//
//  LxmNewHomeSetSaftyDistanceAlertView.h
//  JawboneUP
//
//  Created by 李晓满 on 2019/9/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmNewHomeSetSaftyDistanceAlertView : UIControl

- (void)showWithNumber:(NSInteger)num setBlock:(void(^)(NSInteger num))block;

- (void)dismiss;

@end

