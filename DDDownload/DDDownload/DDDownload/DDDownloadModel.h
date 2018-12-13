//
//  DDDownloadModel.h
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 下载状态

 - DDDownloadStateNone: 未开始
 - DDDownloadStatePlaying: 下载中
 - DDDownloadStatePause: 暂停
 - DDDownloadStateWait: 等待
 - DDDownloadStateSuccess: 成功
 - DDDownloadStateFaild: 失败
 */
typedef NS_ENUM(NSInteger,DDDownloadState) {
    DDDownloadStateNone,
    DDDownloadStatePlaying,
    DDDownloadStatePause,
    DDDownloadStateWait,
    DDDownloadStateSuccess,
    DDDownloadStateFaild
};

/**
 下载模型
 */
@interface DDDownloadModel : NSObject<NSCoding>

/**
 下载地址
 */
@property(nonatomic, copy) NSString *url;

/**
 下载成功文件存放地址
 */
@property(nonatomic, copy) NSString *filePath;

/**
 下载进度
 */
@property(nonatomic, assign) CGFloat *progress;

/**
 下载文件总大小
 */
@property(nonatomic, assign) int64_t totalBytes;

/**
 已下载文件大小
 */
@property(nonatomic, assign) int64_t totalBytesWritten;

/**
 下载状态
 */
@property(nonatomic, assign) DDDownloadState *downloadState;

@end

