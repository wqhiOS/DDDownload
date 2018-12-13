//
//  DDDownloadManager.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDDownloadManager.h"
#import "DDDownloadCache.h"
#import "NSString+md5.h"

@interface DDDownloadManager()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSMutableDictionary *downloadTasks;

@end

@implementation DDDownloadManager

static id _instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DDDownloadManager alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.DDDownloadManager"] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

#pragma mark public method
- (void)downloadWithUrl:(NSString *)url {
    //1.查询是否有正在下载中的
    //2.查询是否下载过
    //3.查询是否有resumeData
    
    
}
- (void)cancelDownloadWithUrl:(NSString *)url {
    NSURLSessionDownloadTask *task;
    if ((task = self.downloadTasks[url])) {
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            [DDDownloadCache.shared setResumeData:resumeData forUrl:url];
        }];
    }else {
        NSLog(@"异常，不可能走到这里");
    }
}

#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
}

@end
