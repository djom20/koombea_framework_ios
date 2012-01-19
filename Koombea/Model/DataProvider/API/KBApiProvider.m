//
//  KBAPIProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/17/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBApiProvider.h"

@implementation KBApiProvider

+ (KBApiProvider *)shared
{
    static KBApiProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBApiProvider alloc] init];
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
    _modelName = className;
    _findType = findType;
    KBApiClient *apiClient = [KBApiClient apiClient];
    apiClient.delegate = self;
    
    _delegate = [params objectForKey:@"delegate"];

    NSDictionary *config = [KBCore settingForKey:API_CONFIG withFile:API_SETTINGS];
    apiClient.request.responseFormat = [config objectForKey:API_RESPONSE_FORMAT];
    
    NSDictionary *methods = [KBCore settingForKey:API_METHODS withFile:API_SETTINGS];
    NSDictionary *method = [methods objectForKey:[params objectForKey:@"method"]];
    NSString *path = [method objectForKey:@"Path"];
    NSString *httpMethod = [method objectForKey:@"HttpMethod"];
    NSDictionary *data = [params objectForKey:@"data"];
    NSArray *ids = [params objectForKey:@"ids"];
    
    NSLog(@"config %@", config);
    NSLog(@"method %@", method);
    
    if ([KBRequest httpMethod:httpMethod] == POST) {
        [apiClient post:path withData:data ids:ids];
    } else if ([KBRequest httpMethod:httpMethod] == GET) {
        [apiClient get:path withData:data ids:ids];
    }
    return nil;
}

- (void)requestDone:(KBApiClient *)apiClient withResponse:(KBApiResponse *)response
{
    NSLog(@"Request Done: %@", response);
    [_delegate findSuccess:_findType model:_modelName withData:response];
}

- (void)requestFailed:(KBApiClient *)apiClient withResponse:(KBApiResponse *)response
{
    NSLog(@"Request Failed: %@", response);
    [_delegate findError:_findType model:_modelName withData:response];
}

- (void)requestStart:(KBApiClient *)apiClient
{
    
}

- (void)requestAlert:(KBApiClient *)apiClient
{
    
}


@end
