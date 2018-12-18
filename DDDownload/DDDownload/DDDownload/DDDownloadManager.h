//
//  DDDownloadManager.h
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDownloadManager : NSObject

/**
 流量情况下是否能下载
 */
@property(nonatomic, assign) BOOL downloadInWWAN;


+ (instancetype)sharedManager;

- (void)downloadWithUrl:(NSString *)url;
- (void)cancelDownloadWithUrl:(NSString *)url;
- (void)deleteDownloadWithUrl:(NSString *)url;

@end

