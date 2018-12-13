//
//  DDPlayerView+CaptureVideo.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+CaptureVideo.h"
#import "DDCaptureVideoView.h"
#import "DDCaptureVideoShareView.h"
#import "DDPlayerView+ShowSubView.h"
#import <objc/runtime.h>

static void *_isCapturingVideoKey = &_isCapturingVideoKey;
static void *_captureVideoViewKey = &_captureVideoViewKey;
static void *_captureVideoShareViewKey = &_captureVideoShareViewKey;
static void *_lastRateKey = &_lastRateKey;

@implementation DDPlayerView (CaptureVideo)

- (CGFloat)lastRate {
    return [objc_getAssociatedObject(self, _lastRateKey) floatValue];
}
- (void)setLastRate:(CGFloat)lastRate {
    objc_setAssociatedObject(self, _lastRateKey, @(lastRate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDCaptureVideoView *)captureVideoView {
    return objc_getAssociatedObject(self, _captureVideoViewKey);
}
- (void)setCaptureVideoView:(DDCaptureVideoView *)captureVideoView {
    objc_setAssociatedObject(self, _captureVideoViewKey, captureVideoView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDCaptureVideoShareView *)captureVideoShareView {
    if (objc_getAssociatedObject(self, _captureVideoShareViewKey)) {
        return objc_getAssociatedObject(self, _captureVideoShareViewKey);
    }else {
        __weak typeof(self) weakSelf = self;
        DDCaptureVideoShareView *captureVideoShareView = [[DDCaptureVideoShareView alloc] init];
        self.captureVideoShareView = captureVideoShareView;
        self.captureVideoShareView.confirmCommentBlock = ^(NSString * _Nonnull comment, void (^ _Nonnull success)(void), void (^ _Nonnull failure)(void)) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewCaptureVideoSendComment:success:failure:)]) {
                [weakSelf.delegate playerViewCaptureVideoSendComment:comment success:^{
                    success();
                } failure:^{
                    failure();
                }];
            }
        };
        self.captureVideoShareView.shareBlock = ^(DDShareType shareType) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewShareCaptureVideoWithShareType:)]) {
                [weakSelf.delegate playerViewShareCaptureVideoWithShareType:shareType];
            }
        };
        return captureVideoShareView;
    }
}
- (void)setCaptureVideoShareView:(DDCaptureVideoShareView *)captureVideoShareView {
    objc_setAssociatedObject(self, _captureVideoShareViewKey, captureVideoShareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)isCapturingVideo {
    return [objc_getAssociatedObject(self, _isCapturingVideoKey) boolValue];
}
- (void)setIsCapturingVideo:(BOOL)isCapturingVideo {
    objc_setAssociatedObject(self, _isCapturingVideoKey, [NSNumber numberWithBool:isCapturingVideo], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showCaptureVideoShareView {
    __weak typeof(self) weakSelf = self;
    self.player.isNeedCanPlay = NO;
    [self show:self.captureVideoShareView origin:DDPlayerShowOriginCenter isDismissControl:NO isPause:YES dismissCompletion:^{
        [weakSelf dismissCaptureVideoShareView];
    }];
}
- (void)dismissCaptureVideoShareView {
    if (objc_getAssociatedObject(self, _captureVideoShareViewKey)) {
        self.player.isNeedCanPlay = YES;
        self.isCapturingVideo = NO;
        [self.captureVideoShareView removeFromSuperview];
        self.captureVideoShareView = nil;
        [self.player playImmediatelyAtRate:self.lastRate];
        if ([self.delegate respondsToSelector:@selector(playerViewCancelUploadCaptureVideo)]) {
            [self.delegate playerViewCancelUploadCaptureVideo];
        }
    }
}

- (void)captureVideoButtonClick:(UIButton *)captureVideoButton {
    
    if (self.player.duration - self.player.currentTime < 5) {
        return;
    }
    
    //记录截取前的播放器状态
    BOOL lastPlayerIsPlaying = self.player.isPlaying;
    CGFloat lastTime = self.player.currentTime;
    CMTime lastCMTime = self.player.currentItem.currentTime;
    self.lastRate = self.player.rate;
    
    self.captureVideoView = [[DDCaptureVideoView alloc] init];
    
     __weak typeof(self) weakSelf = self;
    self.captureVideoView.finishBlock = ^{
        
        [weakSelf toCaptureVideoWithStartTime:lastCMTime duration:weakSelf.captureVideoView.currentTime];
        [weakSelf.captureVideoView removeFromSuperview];
        weakSelf.captureVideoView = nil;
    };
    //设置可截取的最大长度
    if (self.player.duration - lastTime <= 15) {
        //-1 的操作是为了 视频播放结束 播放下一个视频 和 截取完成这两个操作同时进行。-1就是为了保证视频截取完成 肯定比视频结束先操作。
        self.captureVideoView.captureMaxDuration = floor(self.player.duration - lastTime)-1;
    }else {
        self.captureVideoView.captureMaxDuration = self.captureMaxDuration > 0 ? self.captureMaxDuration : 15;
    }
    
    self.isCapturingVideo = YES;
    self.player.isCanPlayOnWWAN = YES;//截取时 设置为能够使用流量播放。不然 会被打断啊
    [self.player playImmediatelyAtRate:1.0];
    
    [self show:self.captureVideoView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:^{
        //截取视频取消
        weakSelf.player.isCanPlayOnWWAN = NO;
        weakSelf.isCapturingVideo = NO;
        [weakSelf.player seekToTime:lastTime isPlayImmediately:lastPlayerIsPlaying completionHandler:^(BOOL isComplete) {
            [weakSelf.player playImmediatelyAtRate:weakSelf.lastRate];
        }];
        [weakSelf.captureVideoView removeFromSuperview];
        weakSelf.captureVideoView = nil;
    }];
    
}
- (void)toCaptureVideoWithStartTime:(CMTime)startTime duration:(CGFloat)duration{
    
    __weak typeof(self) weakSelf = self;
    
    [self showCaptureVideoShareView];
    [self.captureVideoShareView captureVideoWithAsset:self.player.currentAsset startTime:startTime duration:duration success:^(NSString * _Nonnull captureVideoPath) {
        
        //截取成功
        
        if ([weakSelf.delegate respondsToSelector:@selector(playerViewUploadCaptureVideo:startTime:duration:progress:success:failure:)]) {
            
            [weakSelf.delegate playerViewUploadCaptureVideo:captureVideoPath startTime:CMTimeGetSeconds(startTime) duration:duration progress:^(CGFloat progress) {
                
                [weakSelf.captureVideoShareView uploadCaptureVideoProgress:progress];
                
            } success:^{
                
                [weakSelf.captureVideoShareView uploadCaptureVideoSuccess:[NSURL fileURLWithPath:captureVideoPath]];
                
            } failure:^(NSError * _Nonnull error) {
                [weakSelf dismissCaptureVideoShareView];
            }];
            
        }else {
            [weakSelf.captureVideoShareView uploadCaptureVideoSuccess:[NSURL fileURLWithPath:captureVideoPath]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        //截取失败
        [weakSelf dismissCaptureVideoShareView];
    }];
}

- (void)finishCapture {
    if (self.captureVideoView.finishBlock) {
        self.captureVideoView.finishBlock();
    }
}

@end
