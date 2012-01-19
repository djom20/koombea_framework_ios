//
//  KBCore.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/7/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.

#import "KBCore.h"

@implementation KBCore

+ (id)settingForKey:(NSString *)key withFile:(NSString *)fileName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    id settings = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return [settings objectForKey:key];
}

+ (id)settingForKey:(NSString *)key
{
    return [KBCore settingForKey:key withFile:APP_SETTINGS];
}

+ (id)styleForKey:(NSString *)key
{
    return [KBCore settingForKey:key withFile:APP_STYLES];
}

+ (id)styleForKeyPath:(NSString *)keyPath
{
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    if ([keys count] > 0) {
        id value = [self styleForKey:[keys objectAtIndex:0]];
        for (int i=1; i<[keys count]; i++) {
            value = [value objectForKey:[keys objectAtIndex:i]];
        }
        return value;
    }
    return nil;
}

+ (UIColor *)colorFromPalette:(NSString *)colorName
{
    NSDictionary *palette = [KBCore styleForKey:COLOR_PALETTE];
    NSString *rgb = [palette objectForKey:colorName];
    return [KBCore rgbColor:rgb];
}

+ (UIColor *)rgbColor:(NSString *)rgb
{
    NSString *cleanString = [rgb stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSString *)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end