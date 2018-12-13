//
//  NSString+md5.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (md5)

- (NSString *)md5 {
    const char* str = [self UTF8String];
    unsigned char result[16];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    return ret;
}




@end
