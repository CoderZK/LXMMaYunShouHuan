//
//  Device.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/27.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject<NSCoding>

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *baojingStyle;
@end
