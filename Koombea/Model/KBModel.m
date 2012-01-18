//
//  KBModel.m
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBModel.h"
#import "KBCore.h"
#import "KBFacebookUser.h"
#import "RTCustom.h"
#import "KBDatabaseProvider.h"
#import "KBApiProvider.h"
#import "KBFacebookProvider.h"
#import "KBJSONProvider.h"
#import "KBParseProvider.h"
#import "KBPlistProvider.h"

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

#pragma mark - KBModel protocol methods

- (id)save:(id)params
{
    KBDataProvider *dataProvider = [self prepareOperation:KBFindNone withParams:params];
    return [dataProvider save:self withParams:params];
}

- (id)find:(KBFindType)findType withParams:(id)params
{
    KBDataProvider *dataProvider = [self prepareOperation:findType withParams:params];
    NSString *className = [[self class] description];
    return [dataProvider find:findType model:className withParams:params];
}

- (id)del:(id)params
{
    KBDataProvider *dataProvider = [self prepareOperation:KBFindNone withParams:params];
    NSString *className = [[self class] description];
    return [dataProvider del:className withParams:params];
}

- (KBDataProvider *)prepareOperation:(KBFindType)findType withParams:(id)params
{
    KBDataProviderType dataProviderType = [[self class] dataProvider];
    id DataProviderClass = [KBDataProvider dataProviderClass:dataProviderType];
    KBDataProvider *dataProvider = [DataProviderClass sharedDataProvider];
    if ([params isKindOfClass:[NSDictionary class]]) {
        self.delegate = [params objectForKey:@"delegate"];
    }
    dataProvider.delegate = self;
    return dataProvider;
}

- (NSArray *)validate
{
    NSMutableArray *errors = [NSMutableArray array];
    NSDictionary *settings = [[self class] modelSettings];
    NSDictionary *validate = [settings objectForKey:MODEL_VALIDATE];
    for (NSString *field in [validate allKeys]) {
        NSDictionary *rules = [validate objectForKey:field];
        id value = [self valueForKey:field];
        for (NSString *type in rules) {
            BOOL invalid = NO;
            if ([type isEqualToString:MODEL_VALIDATE_EMPTY]) {
                BOOL empty = [[rules objectForKey:type] intValue];
                if ((value == nil || [[NSString stringWithFormat:@"%@", value] isEqualToString:@""]) != empty) {
                    invalid = YES;
                }
            } else if ([type isEqualToString:MODEL_VALIDATE_LENGTH]) {
                int length = [[rules objectForKey:type] intValue];
                if (value == nil || [[NSString stringWithFormat:@"%@", value] isEqualToString:@""] ||
                    [[NSString stringWithFormat:@"%@", value] length] != length) {
                    invalid = YES;
                }
            }
            if (invalid) {
                NSMutableDictionary *err = [NSMutableDictionary dictionary];
                [err setObject:field forKey:@"key"];
                [err setObject:type forKey:@"validate"];
                [err setObject:[rules objectForKey:type] forKey:@"condition"];
                if(value) [err setObject:value forKey:@"value"];
                [errors addObject:err];
            }
        }
    }
    return errors;
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
