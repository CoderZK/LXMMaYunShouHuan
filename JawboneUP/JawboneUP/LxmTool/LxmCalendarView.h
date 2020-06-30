//
//  LxmCalendarView.h
//  SuoPaiMIS
//
//  Created by 李晓满 on 2017/4/5.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmCalendarViewDelegate;
@interface LxmCalendarView : UIView
@property(nonatomic,weak)id<LxmCalendarViewDelegate>delegate;
-(void)show;
-(void)dismiss;
@end
@protocol LxmCalendarViewDelegate <NSObject>

-(void)LxmCalendarView:(LxmCalendarView *)view data:(NSDate *)date;
-(void)LxmCalendarView:(LxmCalendarView *)view;
@end
