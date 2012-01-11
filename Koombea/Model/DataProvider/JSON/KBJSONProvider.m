//
//  KBJSONProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/5/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBJSONProvider.h"

@implementation KBJSONProvider

+ (KBJSONProvider *)shared
{
    static KBJSONProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBJSONProvider alloc] init];
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSError* error;
    NSData *jsonData =[NSData dataWithContentsOfFile:filePath];
    NSArray *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    for (NSDictionary *object in data) {
        id ModelClass = NSClassFromString(className);
        KBModel *model = [[ModelClass alloc] init];
        [self fillModel:model withObject:object];
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
