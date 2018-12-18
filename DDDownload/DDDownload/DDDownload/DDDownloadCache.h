//
//  DDCacheManager.h
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDDownloadModel;

@interface DDDownloadCache : NSObject

+ (instancetype)shared;

- (void)setDownloadModel:(DDDownloadModel *)dowmloadModel forUrl:(NSString *)url;
- (void)setResumeData:(NSData *)data forUrl:(NSString *)url;

- (DDDownloadModel *)downloadModelForUrl:(NSString *)url;
- (NSData *)resumeDataForUrl:(NSString *)url;

- (void)removeDownloadModelForUrl:(NSString *)url;
- (void)removeResumeDataForUrl:(NSString *)url;

@end


