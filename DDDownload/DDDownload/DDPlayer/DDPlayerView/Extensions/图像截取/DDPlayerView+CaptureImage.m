//
//  DDPlayerView+CaptureImage.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+CaptureImage.h"
#import "DDPlayerManager.h"
#import "DDPlayerView+Private.h"
#import "DDCaptureImageShareView.h"
#import "DDCaptureImageShareSmallView.h"
#import "DDPlayerControlView.h"
#import <objc/runtime.h>
#import "DDPlayerView+ShowSubView.h"
#import <Photos/Photos.h>
#import "DDPlayerView+CaptureVideo.h"
#import <Masonry/Masonry.h>

static void *_captureImageShareSmallViewKey = &_captureImageShareSmallViewKey;
static void *_isShareingCaptureImageKey = &_isShareingCaptureImageKey;

@implementation DDPlayerView (CaptureImage)

- (DDCaptureImageShareSmallView *)captureImageShareSmallView {
    return objc_getAssociatedObject(self, _captureImageShareSmallViewKey);
}
- (void)setCaptureImageShareSmallView:(DDCaptureImageShareSmallView *)captureImageShareSmallView {
    objc_setAssociatedObject(self, _captureImageShareSmallViewKey, captureImageShareSmallView, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isShareingCaptureImage {
    return [objc_getAssociatedObject(self, _isShareingCaptureImageKey) boolValue];
}
- (void)setIsShareingCaptureImage:(BOOL)isShareingCaptureImage {
    objc_setAssociatedObject(self, _isShareingCaptureImageKey, [NSNumber numberWithBool:isShareingCaptureImage], OBJC_ASSOCIATION_RETAIN);
}

- (void)captureImageButtonClick:(UIButton *)captureImageButton {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status != PHAuthorizationStatusAuthorized) {
//                [WTTHUD showCenterHint:@"请前往设置->隐私->照片授权应用相册权限"];
                return;
            }
            
            //截图 一闪 的效果
            UIView *whiteView = [[UIView alloc] initWithFrame:self.bounds];
            whiteView.backgroundColor = UIColor.whiteColor;
            [self addSubview:whiteView];
            [UIView animateWithDuration:0.5 animations:^{
                whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
            } completion:^(BOOL finished) {
                [whiteView removeFromSuperview];
                //开始截取
                UIImage *currentImage = [DDPlayerManager thumbnailImageWithAsset:self.player.currentAsset currentTime:self.player.currentItem.currentTime];
                UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = currentImage;
                [self addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).mas_offset(40);
                    make.right.equalTo(self).mas_offset(-100);
                    make.height.mas_equalTo((DDPlayerTool.screenHeight - 140)*9/16);
                    make.centerY.equalTo(self);
                }];
                [self layoutIfNeeded];
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(captureImageButton);
                    make.width.height.mas_equalTo(0);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
//                    [self._getPlayerControlView show];
                    if (self.captureImageShareSmallView != nil) {
                        [self.captureImageShareSmallView removeFromSuperview];
                        self.captureImageShareSmallView = nil;
                    }
                    
                    self.captureImageShareSmallView = [[DDCaptureImageShareSmallView alloc] initWithImage:currentImage];
                    
                    BOOL lastStausIsPause = self.player.isPause;
                    
                    __weak typeof(self) weakSelf = self;
                    self.captureImageShareSmallView.toShareBlock = ^(UIImage * _Nonnull image) {
                        
                        if (image) {
                            
                            DDCaptureImageShareView *imageShareView = [[DDCaptureImageShareView alloc] initWithImage:image];
                            imageShareView.shareButtonClickBlock = ^(DDShareType shareType) {
                                if ([weakSelf.delegate respondsToSelector:@selector(playerViewShareCaptureImage:shareType:)]) {
                                    [weakSelf.delegate playerViewShareCaptureImage:image shareType:shareType];
                                }
                            };
                            weakSelf.isShareingCaptureImage = YES;
                            weakSelf.player.isNeedCanPlay = NO;
                            [weakSelf show:imageShareView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                                weakSelf.player.isNeedCanPlay = YES;
                                weakSelf.isShareingCaptureImage = NO;
                                if (lastStausIsPause == YES) {
                                    [weakSelf.player pause];
                                }else {
                                    [weakSelf.player play];
                                }
                            }];
                            
                        }
                    };
                    [self addSubview:self.captureImageShareSmallView];
                    [self.captureImageShareSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(captureImageButton.mas_left).mas_offset(-20);
                        make.centerY.equalTo(captureImageButton);
                    }];
                    [self layoutIfNeeded];
                    
                    //这段代码为了处理 截取图像后。立马点击截取视频，截取小图像还存在没有消失的问题
                    if (self.isCapturingVideo || self.isLockScreen) {
                        [self._getPlayerControlView dismiss];
                    }else {
                        [self._getPlayerControlView show];
                    }
//                    if (!self._getPlayerControlView.isVisible) {
//                        [self._getPlayerControlView dismiss];
//                    }
                }];
            }];
            
        });
    }];
    
}

- (void)dismissCaptureImageShareSmallView {
 
    if (self.captureImageShareSmallView != nil) {
        
        [self.captureImageShareSmallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self._getPlayerControlView.captureImageButton.mas_left).mas_offset(250);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self.captureImageShareSmallView removeFromSuperview];
            self.captureImageShareSmallView = nil;
        }];
    }

}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

@end
