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
#import "DDDownloadModel.h"

@interface DDDownloadManager()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSMutableDictionary *downloadTasks;

// 下载文件夹，下载的视频都放在这里
@property(nonatomic, readonly) NSString *downloadDirectory;

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
        [DDDownloadManager creatDirectorys];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.DDDownloadManager"] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.downloadTasks = @{}.mutableCopy;
    }
    return self;
}

#pragma mark public method
- (void)downloadWithUrl:(NSString *)url {
    //1.查询是否加入了下载队列
    if (self.downloadTasks[url]) {
        return;
    }
    
    NSURLSessionDownloadTask *task;
    if ([DDDownloadCache.shared resumeDataForUrl:url]) {
        task = [self.session downloadTaskWithResumeData:[DDDownloadCache.shared resumeDataForUrl:url]];
    }else {
        task = [self.session downloadTaskWithURL:[NSURL URLWithString:url]];
    }
    self.downloadTasks[url] = task;
    
    if ([DDDownloadCache.shared downloadModelForUrl:url] == nil) {
        DDDownloadModel *downloadModel = [[DDDownloadModel alloc] init];
        [downloadModel setValue:url forKey:@"url"];
        [DDDownloadCache.shared setDownloadModel:downloadModel forUrl:url];
    }
    [task resume];
    
}
- (void)cancelDownloadWithUrl:(NSString *)url {
    NSURLSessionDownloadTask *task;
    if ((task = self.downloadTasks[url])) {
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            [DDDownloadCache.shared setResumeData:resumeData forUrl:url];
        }];
    }else {
        NSLog(@"取消异常，不可能走到这里");
    }
}

- (void)deleteDownloadWithUrl:(NSString *)url {
    //如果正在队列中请求，取消请求并删除
    NSURLSessionDownloadTask *task;
    if ((task = self.downloadTasks[url])) {
        [task cancel];
        [self.downloadTasks removeObjectForKey:url];
    }
    //删除resumeData
    [DDDownloadCache.shared removeResumeDataForUrl:url];
    //删除downloadModel
    [DDDownloadCache.shared removeDownloadModelForUrl:url];
    //如果文件下载成功，删除下载的文件
    if ([NSFileManager.defaultManager fileExistsAtPath:[DDDownloadManager downloadFilePathWithUrl:url]]) {
        [NSFileManager.defaultManager removeItemAtPath:[DDDownloadManager downloadFilePathWithUrl:url] error:nil];
    }
    
}

#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *url = downloadTask.currentRequest.URL.absoluteString;
    NSError *error;
    
    [NSFileManager.defaultManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:[DDDownloadManager downloadFilePathWithUrl:url]] error:&error];
    if (error) {
        NSLog(@"%@",error);
        NSLog(@"完成异常，不可能走到这里");
    }

    
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSString *url = downloadTask.currentRequest.URL.absoluteString;
    
    DDDownloadModel *model = [DDDownloadCache.shared downloadModelForUrl:url];
    [model setValue:@(totalBytesWritten*1.0/totalBytesExpectedToWrite) forKey:@"progress"];
    [model setValue:@(totalBytesWritten) forKey:@"bytesWritten"];
    [model setValue:@(totalBytesExpectedToWrite) forKey:@"totalBytes"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:downloadTask.currentRequest.URL.absoluteString.md5 object:nil userInfo:@{@"downloadModel":model}];
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

#pragma mark - 文件夹
/**
 创建存放下载文件的文件夹
 */
+ (void)creatDirectorys {
    [NSFileManager.defaultManager createDirectoryAtPath:DDDownloadManager.downloadDirectory withIntermediateDirectories:NO attributes:nil error:nil];
}

/**
 下载的文件夹地址

 @return 地址
 */
+ (NSString *)downloadDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/DDDownload/"];
}

/**
 根据url生成下载的文件存放地址

 @param url url
 @return 地址
 */
+ (NSString *)downloadFilePathWithUrl:(NSString *)url {
    return [DDDownloadManager.downloadDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",url.md5,url.pathExtension]];
}


@end
