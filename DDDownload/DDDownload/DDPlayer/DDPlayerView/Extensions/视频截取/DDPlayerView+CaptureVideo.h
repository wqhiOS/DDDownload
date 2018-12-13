//
//  DDPlayerView+CaptureVideo.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

@class DDCaptureVideoView;
@class DDCaptureVideoShareView;

@interface DDPlayerView (CaptureVideo)

@property(nonatomic, strong) DDCaptureVideoView *captureVideoView;
@property(nonatomic, strong) DDCaptureVideoShareView *captureVideoShareView;
@property(nonatomic, assign) CGFloat lastRate;//截取视频前的播放速录。截取结束。继续按照这个速率播放
@property(nonatomic, assign) BOOL isCapturingVideo;


- (void)captureVideoButtonClick:(UIButton *)captureVideoButton;
- (void)finishCapture;

@end


