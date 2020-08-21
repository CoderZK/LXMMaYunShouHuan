//
//  LxmDateModel.h
//  JawboneUP
//
//  Created by 李晓满 on 2019/10/12.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmDateModel : NSObject

@property (nonatomic, strong) NSString *communication;

@property (nonatomic, strong) NSString *isDistanceAll;/*这一天的距离是否完整*/

@property (nonatomic, strong) NSString *isHaveDistance;/*这一天是否有距离数据*/

@property (nonatomic, strong) NSString *isStepAll;/*这一天的计步是否完整*/

@property (nonatomic, strong) NSString *isHaveStep;/*这一天是否有计步数据*/

@property (nonatomic, strong) NSString *time;/*时间*/

@property (nonatomic, strong) NSDate *date;/*时间对应的日期*/

@end


@interface LxmDateDistanceModel : NSObject

@property (nonatomic, strong) NSString *communication;/*通信id*/

@property (nonatomic, strong) NSString *distance;/*距离*/

@property (nonatomic, strong) NSString *distanceDouble;/*距离*/

@property (nonatomic, strong) NSString *timeStr;/*时间*/

@end


@interface LxmDateJibuModel : NSObject

@property (nonatomic, strong) NSString *time;/*时间*/

@property (nonatomic, strong) NSString *stepNum;/*计步*/

@end
