//
//  NSString+String.m
//  DrumGuru
//
//  Created by Oscar De Moya on 10/19/11.
//  Copyright (c) 2011 Koombea Inc. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString (String)

- (int)indexOf:(NSString *)text
{
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return range.location;
    } else {
        return -1;
    }
}

@end
