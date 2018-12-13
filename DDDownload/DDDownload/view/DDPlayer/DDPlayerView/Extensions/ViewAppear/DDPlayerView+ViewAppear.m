//
//  DDPlayerView+ViewAppear.m
//  aries
//
//  Created by wuqh on 2018/11/27.
//  Copyright © 2018 Pride_Of_Hiigara. All rights reserved.
//

#import "DDPlayerView+ViewAppear.h"
#import <objc/runtime.h>

@implementation DDPlayerView (ViewAppear)

static void* _isPlayingKey = &_isPlayingKey;
static void* _isDisappearKey = &_isDisappearKey;

- (void)viewWillAppear {
    if ([objc_getAssociatedObject(self, _isDisappearKey) boolValue] == YES && [objc_getAssociatedObject(self, _isPlayingKey) boolValue]) {
        [self.player play];
    }
}
- (void)viewWillDisappear {
    
    objc_setAssociatedObject(self, _isDisappearKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, _isPlayingKey, @(self.player.isPlaying), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.player.isPlaying) {
        [self.player pause];
    }
    
}

@end
