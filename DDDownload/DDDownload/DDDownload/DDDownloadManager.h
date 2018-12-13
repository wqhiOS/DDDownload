//
//  DDDownloadManager.h
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDownloadManager : NSObject

@property(nonatomic, assign) BOOL autoDownloadInWIFI;
@property(nonatomic, assign) BOOL autoDownloadInWANN;


+ (instancetype)sharedManager;

- (void)downloadWithUrl:(NSString *)url;
- (void)cancelDownloadWithUrl:(NSString *)url;

@end

