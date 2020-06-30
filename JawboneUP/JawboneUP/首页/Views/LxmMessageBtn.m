//
//  LxmMessageBtn.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmMessageBtn.h"


@implementation LxmMessageBtn

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, 6, 6)];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textAlignment =1;
        _countLabel.layer.cornerRadius = 3;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_countLabel];
        
        [self setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];

        
        [[LxmTool ShareTool] addObserver:self forKeyPath:@"messageCount" options:NSKeyValueObservingOptionNew context:nil];
        
    }return self;
}

@end
