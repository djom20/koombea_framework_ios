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
    NSString *fileName = [className propertyPluralizedString];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    for (NSString *key in [data allKeys]) {
        id object = [data objectForKey:key];
        id ModelClass = NSClassFromString(className);
        KBModel *model = [[ModelClass alloc] init];
        [self fillModel:model withObject:object];
        model.id = [NSNumber numberWithInt:[key intValue]];
        [modelList addObject:model];     
    }
    if (findType == KBFindFirst) {
        if ([modelList count] > 0) {
            return [modelList objectAtIndex:0];
        } else {
            return nil;
        }
    } else {
        return modelList;
    }
}

@end
