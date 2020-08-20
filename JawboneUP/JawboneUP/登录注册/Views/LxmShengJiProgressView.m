//
//  LxmShengJiProgressView.m
//  JawboneUP
//
//  Created by zk on 2020/8/19.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmShengJiProgressView.h"

@interface LxmShengJiProgressView()
@property(nonatomic,strong)UIView *V1,*V2;
@property(nonatomic,strong)UILabel *LB;

@end

@implementation LxmShengJiProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.V1 = [[UIView alloc] initWithFrame:CGRectMake(20, ScreenH / 2 , ScreenW - 40, 5)];
        self.V1.backgroundColor = [UIColor grayColor];
        self.V1.layer.cornerRadius = 2.5;
        self.V1.clipsToBounds = YES;
        [self addSubview:self.V1];
        
        
        self.V2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 0 , 5)];
        self.V2.backgroundColor = [UIColor greenColor];
        self.V2.layer.cornerRadius = 2.5;
        self.V2.clipsToBounds = YES;
        [self.V1 addSubview:self.V2];
        
        self.LB = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenH/2 - 20, ScreenW - 40, 20)];
        self.LB.textColor = [UIColor greenColor];
        self.LB.textAlignment = NSTextAlignmentCenter;
        self.LB.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.LB];
        
    }
    return self;
}

- (void)setProg:(NSInteger)prog {
    _prog = prog;
    
    self.LB.text = [NSString stringWithFormat:@"升级进度%ld%%",(long)prog];
    
    self.V2.mj_w = (ScreenW - 40) / 100.0 * prog;
    
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
