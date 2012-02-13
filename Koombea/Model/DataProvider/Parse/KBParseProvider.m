//
//  KBParseProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/12/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBParseProvider.h"
#import <Parse/Parse.h>

@implementation KBParseProvider

- (id)init
{
    self = [super init];
    if (self) {
        NSString* kAppId = [[KBCore settingForKey:PARSE_SETTINGS] objectForKey:PARSE_APP_ID];
        NSString* kClientKey = [[KBCore settingForKey:PARSE_SETTINGS] objectForKey:PARSE_CLIENT_KEY];
        [Parse setApplicationId:kAppId clientKey:kClientKey];
    }
    return self;
}

+ (KBParseProvider *)shared
{
    static KBParseProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBParseProvider alloc] init];
    }	
    return instance;
}

- (PFObject *)fillObject:(KBModel *)model
{
    NSMutableArray *properties = [NSMutableArray arrayWithArray:[RTCustom rt_properties:[model class]]];
    PFObject *object = [PFObject objectWithClassName:[[model class] description]];
    
    for (RTProperty *prop in properties) {
        @try {
            
            id value = [model valueForKey:prop.name];
            
            if ([value isKindOfClass:[NSArray class]]) {
                // TODO
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                // TODO
            } else {
                [object setObject:value forKey:prop.name];
            }
        }
        @catch (NSException *exception) {
            NSLog(EXCEPTION_MESSAGE, exception);
        }
    }
    return object;
}

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{   
    _modelName = className;
    PFQuery *query = [PFQuery queryWithClassName:className];
    if ([params objectForKey:MODEL_CONDITIONS]) {
        [query whereKey:@"username" equalTo:[params objectForKey:MODEL_CONDITIONS]];
    }
    [query findObjectsInBackgroundWithTarget:self selector:@selector(findCallback:error:)];
    return nil;
}

- (void)findCallback:(id)results error:(NSError *)error {
    if (!error) {
        KBResponse *response = [KBResponse response];
        response.sourceData = results;
        if([results count] > 0) {
            PFObject *pfObject = (PFObject *)[(NSArray *)results objectAtIndex:0];
            NSMutableDictionary *property = [NSMutableDictionary dictionary];
            [property setObject:[pfObject objectForKey:@"username"] forKey:@"username"];
            response.data = property;
        }
        [_delegate findSuccess:KBFindFirst model:_modelName withResponse:response];
    } else {
        NSLog(ERROR_PARSE_PROVIDER, error, [error userInfo]);
        [_delegate findError:KBFindFirst model:_modelName withResponse:nil];
    }
}

- (id)save:(KBModel *)model withParams:(id)params
{
    _modelName = [[model class] description];
    PFObject *object = [self fillObject:model];
    [object saveInBackgroundWithTarget:self selector:@selector(saveCallback:error:)];
    return nil;
}

- (void)saveCallback:(NSArray *)results error:(NSError *)error {
    if (!error) {
        KBResponse *response = [KBResponse response];
        if (_findType == KBFindAll) {
            response.data = results;
        } else if (_findType == KBFindFirst) {
            if([results count] > 0) response.data = [results objectAtIndex:0];
        }
        [_delegate saveSuccess:_modelName withResponse:response];
    } else {
        NSLog(ERROR_PARSE_PROVIDER, error, [error userInfo]);
        [_delegate saveError:_modelName withResponse:nil];
    }
}

@end
