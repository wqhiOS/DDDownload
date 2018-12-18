//
//  DDDownloadDatabase.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDDownloadDatabase.h"

@interface DDDownloadDatabase()



@end

@implementation DDDownloadDatabase

static id instance;
+ (instancetype)sharedDatabase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDDownloadDatabase alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
