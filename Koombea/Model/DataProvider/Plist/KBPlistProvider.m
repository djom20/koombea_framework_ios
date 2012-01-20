//
//  KBPlistProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/5/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBPlistProvider.h"

@implementation KBPlistProvider

+ (KBPlistProvider *)shared
{
    static KBPlistProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBPlistProvider alloc] init];
    }
    return instance;
}

- (void)fillModel:(KBModel *)model withObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        if ([[model class] hasProperty:MODEL_VALUE]) {
            [model setValue:object forKey:MODEL_VALUE];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [object allKeys]) {
            id value = [object objectForKey:key];
            if ([[model class] hasProperty:key]) {
                [model setValue:value forKey:key];
            }
        }
    }
}

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    NSString *fileName = (findType == KBFindFirst ? [className propertyString] : [className propertyPluralizedString]);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    id ModelClass = NSClassFromString(className);
    if (findType == KBFindFirst) {
        KBModel *model = [[ModelClass alloc] init];
        return [KBModel fillModel:model withDictionary:data];
    } else {
        NSMutableArray *modelList = [[NSMutableArray alloc] init];
        for (NSString *key in [data allKeys]) {
            id object = [data objectForKey:key];
            KBModel *model = [[ModelClass alloc] init];
            [KBModel fillModel:model withDictionary:object];
            [modelList addObject:model];     
        }
        return modelList;
    }
}

@end
