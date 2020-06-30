//
//  MGKeepActiveTool.m
//  MGKit
//
//  Created by 宋乃银 on 2020/2/11.
//  Copyright © 2020 宋乃银. All rights reserved.
//

#import "MGKeepActiveTool.h"
#import <AVFoundation/AVFoundation.h>

#define AudioFile @"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"

@interface MGKeepActiveTool ()
@property (nonatomic, assign) BOOL isKeepActive;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation MGKeepActiveTool

+ (instancetype)shared {
    static MGKeepActiveTool *__MGKeepActiveTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __MGKeepActiveTool = [MGKeepActiveTool new];
    });
    return __MGKeepActiveTool;
}

- (void)initIfNeed {
    if (!_player) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSError *playerError = nil;
        NSData *data=[[NSData alloc]initWithBase64EncodedString:AudioFile options:0];
        _player =  [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        _player.volume = 0;
        _player.numberOfLoops = -1;
    }
}

- (void)setIsKeepActive:(BOOL)isKeepActive {
    if (_isKeepActive != isKeepActive) {
        _isKeepActive = isKeepActive;
        [self initIfNeed];
        if (_isKeepActive) {
            [[AVAudioSession sharedInstance] setActive:YES error: nil];
            [self.player play];
        } else {
            [[AVAudioSession sharedInstance] setActive:NO error: nil];
            [self.player stop];
        }
    }
}

+ (void)keepActive:(BOOL)keepActive {
    dispatch_block_t run = ^{
        MGKeepActiveTool.shared.isKeepActive = keepActive;
    };
    if ([NSThread isMainThread]) {
        run();
    } else {
        dispatch_async(dispatch_get_main_queue(), run);
    }
    
}
@end
