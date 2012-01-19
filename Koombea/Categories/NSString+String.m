//
//  NSString+String.m
//  Koombea
//
//  Created by Oscar De Moya on 10/19/11.
//  Copyright (c) 2011 Koombea Inc. All rights reserved.
//

#import "NSString+String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CustomString)

- (int)indexOf:(NSString *)text
{
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return range.location;
    } else {
        return -1;
    }
}

- (NSString*)md5 {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (id)JSONValue
{
    NSError* error;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) NSLog(@"ERROR: Error parsing JSON: %@ - %@", error, [error userInfo]);
    return data;
}

@end