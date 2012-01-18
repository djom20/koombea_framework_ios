//
//  KBParseProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/12/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBParseProvider.h"

@implementation KBParseProvider

+ (KBParseProvider *)shared
{
    static KBParseProvider *instance = nil;
    if (nil == instance) {
        NSString* kAppId = [[KBCore settingForKey:PARSE_SETTINGS] objectForKey:PARSE_APP_ID];
        NSString* kClientKey = [[KBCore settingForKey:PARSE_SETTINGS] objectForKey:PARSE_CLIENT_KEY];
        [Parse setApplicationId:kAppId clientKey:kClientKey];
        instance = [[KBParseProvider alloc] init];
    }	
    return instance;
}

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    _modelName = className;
    PFQuery *query = [PFQuery queryWithClassName:className];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(findCallback:error:)];
    return nil;
}

- (void)findCallback:(NSArray *)results error:(NSError *)error {
    if (!error) {
        NSLog(@"Results %@", results);
        [_delegate findSuccess:KBFindFirst model:_modelName withData:results];
    } else {
        NSLog(ERROR_PARSE_PROVIDER, error, [error userInfo]);
        [_delegate findError:KBFindFirst model:_modelName withData:nil];
    }
}

@end
