//
//  KBModel.m
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBModel.h"
#import "KBCore.h"
#import "KBDatabaseProvider.h"
#import "KBFacebookProvider.h"
#import "KBFacebookUser.h"
#import "RTCustom.h"

@implementation KBModel

@synthesize id;
@synthesize created_at;
@synthesize updated_at;
@synthesize _settings;
@synthesize delegate = _delegate;

+ (KBModel *)shared
{
    static KBModel *instance = nil;
    if (nil == instance) {
        instance = [[[self class] alloc] init];
    } else if (![instance isKindOfClass:[self class]]) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

- (KBModel *)init
{
    self.id = 0;
    return self;
}

+ (id)model
{
    id ModelClass = NSClassFromString([[self class] description]);
    id instance = [[ModelClass alloc] init];
    return instance;
}

+ (id)modelWithDictionary:(NSDictionary *)dict
{
    id instance = [self model];
    [KBModel fillModel:instance withDictionary:dict];
    return instance;
}

+ (KBModel *)fillModel:(KBModel *)model withDictionary:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        @try {
            id value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSArray class]]) {
                id SubModelClass = NSClassFromString([[key singularizeString] capitalizedString]);
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                for (NSDictionary *subData in value) {
                    [subArray addObject:[SubModelClass modelWithDictionary:subData]];
                }
                [model setValue:subArray forKey:key];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                // TODO
            } else {
                if ([[model class] hasProperty:key]) {
                    [model setValue:value forKey:key];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(EXCEPTION_MESSAGE, exception);
        }
    }
    return model;
}

+ (NSDictionary *)modelSettings
{
    static NSMutableDictionary *_settings = nil;
    if (nil == _settings) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:DEFAULT_MODEL_SETTINGS ofType:@"plist"];
        _settings = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        plistPath = [[NSBundle mainBundle] pathForResource:MODEL_SETTINGS ofType:@"plist"];
        [_settings addEntriesFromDictionary:[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath]];
    }
    return [_settings objectForKey:[[self class] description]];
}

+ (KBDataProviderType)dataProvider
{
    NSDictionary *settings = [self modelSettings];
    return [KBDataProvider dataProviderType:[settings objectForKey:DATA_PROVIDER]];
}

- (KBDataProviderType)dataProviderType
{
    NSDictionary *settings = [[self class] modelSettings];
    return [KBDataProvider dataProviderType:[settings objectForKey:DATA_PROVIDER]];
}

#pragma mark - KBModel protocol methods

- (id)save:(id)params
{
    id results = nil;
    if ([[self class] dataProvider] == KBDataProviderDatabase) {
        results = [[KBDatabaseProvider shared] save:self withParams:params];
    }
    return results;
}

- (id)find:(KBFindType)findType withParams:(id)params;
{
    id results = nil;
    if ([[self class] dataProvider] == KBDataProviderDatabase) {
        results = [[KBDatabaseProvider shared] find:findType model:[[self class] description] withParams:params];
    } else if ([[self class] dataProvider] == KBDataProviderFacebook) {
        self.delegate = params;
        KBFacebookProvider *facebookProvider = [KBFacebookProvider shared];
        facebookProvider.delegate = self;
        [facebookProvider find:findType model:[[self class] description] withParams:params];
    }
    return results;
}

- (id)del:(id)params
{
    id results = nil;
    if ([[self class] dataProvider] == KBDataProviderDatabase) {
        results = [[KBDatabaseProvider shared] del:[[self class] description] withParams:params];
    }
    return results;
}

- (BOOL)isNew
{
    return (self.id == 0);
}

+ (BOOL)hasProperty:(NSString *)key
{
    for (RTProperty *prop in [RTCustom rt_properties:[self class]]) {
        if ([key isEqualToString:prop.name]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - KBModelDelegate methods

- (void)findSuccess:(KBFindType)findType model:(NSString *)className withData:(id)data
{
    id ModelClass = NSClassFromString(className);
    id instance = [[ModelClass alloc] init];
    instance = [KBModel fillModel:instance withDictionary:data];
    [_delegate findSuccess:findType withData:instance];
}

- (void)findError:(KBFindType)findType model:(NSString *)className withData:(id)data
{

}

@end
