//
//  NSDictionary+Dictionary.m
//  Koombea
//
//  Created by luis alberto tovar taboada on 24/01/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "NSDictionary+Dictionary.h"

@implementation NSDictionary (Dictionary)

- (NSDictionary *)dictionaryWithoutCollections
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in [self allKeys]) {
        id value = [self objectForKey:key];
        if (![value isKindOfClass:[NSArray class]] &&
            ![value isKindOfClass:[NSDictionary class]]) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}

@end
