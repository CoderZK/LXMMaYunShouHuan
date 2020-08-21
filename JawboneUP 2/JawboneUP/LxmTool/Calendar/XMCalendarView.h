//
//  XMCalendarView.h
//  日历
//
//  Created by RenXiangDong on 17/3/27.
//  Copyright © 2017年 RenXiangDong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XMCalendarDataSource.h"

@protocol XMCalendarViewDelegate <NSObject>

- (void)xmCalendarSelectDate:(NSDate *)date dateSource:(NSMutableArray<XMCalendarModel*> *)dataSource;


@end

@interface XMCalendarView : UIView

@property (nonatomic, strong) XMCalendarDataSource *dataSourceModel;

@property (nonatomic, weak)id<XMCalendarViewDelegate>delegate;

- (void)setRefreshData;

@property (nonatomic, copy) void(^selectYearBlock)(XMCalendarDataSource *dataSourceModel);

@end
