//
//  DDCacheManager.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDDownloadCache.h"
#import <YYCache.h>
#import "DDDownloadModel.h"

@interface DDDownloadCache()

@property(nonatomic, strong) YYCache *downloadModelCache;
@property(nonatomic, strong) YYCache *resumeDataCache;

@end

@implementation DDDownloadCache

static id _instance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DDDownloadCache alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.downloadModelCache = [[YYCache alloc]initWithName:@"downloadModel"];
        self.resumeDataCache = [[YYCache alloc] initWithName:@"resumeData"];
    }
    return self;
}

- (void)setDownloadModel:(DDDownloadModel *)dowmloadModel forUrl:(NSString *)url {
    [self.downloadModelCache setObject:dowmloadModel forKey:url];
}
- (DDDownloadModel *)downloadModelForUrl:(NSString *)url {
    return (DDDownloadModel *)[self.downloadModelCache objectForKey:url];
}
- (void)removeDownloadModelForUrl:(NSString *)url {
    [self.downloadModelCache removeObjectForKey:url];
}

- (void)setResumeData:(NSData *)data forUrl:(NSString *)url {
    [self.resumeDataCache setObject:data forKey:url withBlock:nil];
}
- (NSData *)resumeDataForUrl:(NSString *)url {
    return (NSData *)[self.resumeDataCache objectForKey:url];
}
- (void)removeResumeDataForUrl:(NSString *)url {
    return [self.resumeDataCache removeObjectForKey:url];
}



@end
