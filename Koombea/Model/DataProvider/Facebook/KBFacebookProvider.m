//
//  KBFacebookProvider.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/13/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBFacebookProvider.h"
#import "KBFacebookModels.h"

@implementation KBFacebookProvider

@synthesize facebook;
@synthesize permissions;

+ (KBFacebookProvider *)shared
{
    static KBFacebookProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBFacebookProvider alloc] init];
    }
    return instance;
}

- (KBFacebookProvider *)init
{
    NSString* kAppId = [[KBCore settingForKey:FB_CREDENTIALS] objectForKey:FB_APP_ID];
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    permissions = [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"email", @"offline_access", nil];
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Setup Error" 
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code." 
                                  delegate:self 
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil, 
                                  nil];
        [alertView show];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] && 
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:@"Setup Error" 
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, 
                                      nil];
            [alertView show];
        }
    }
    
    return self;
}

#pragma mark - DataProvider protocol methods

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    modelName = className;
    if ([className isEqualToString:[[KBFacebookUser class] description]]) {
        [self login];
    }
    return nil;
}

#pragma mark - FacebookProvider methods

- (void)login {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        NSDictionary *result = [defaults objectForKey:@"FBUserData"];
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [_delegate findSuccess:KBFindFirst model:modelName withData:result];
    }
    if (![facebook isSessionValid]) {
        facebook.sessionDelegate = self;
        [facebook authorize:permissions];
    } else {
        [_delegate findError:KBFindFirst model:modelName withData:nil];
    }
}

- (void)logout {
    [facebook logout:self];
}

#pragma mark - Facebook delegate methods <FBSessionDelegate>

- (void)fbDidLogin {
    [facebook requestWithGraphPath:FB_GRAPH_PATH_ME andDelegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    [_delegate findError:KBFindFirst model:modelName withData:nil];
}

- (void)fbDidLogout {
}

#pragma mark - Facebook delegate methods <FBRequestDelegate>

- (void)requestLoading:(FBRequest *)request {
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [_delegate findError:KBFindFirst model:modelName withData:nil];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSString* fullURL = [[request url] description];
    NSString *graphPath = [fullURL stringByReplacingOccurrencesOfString:[Facebook graphBaseURL] withString:@""];
    if ([graphPath isEqualToString:FB_GRAPH_PATH_ME]) {
        //NSLog(@"Facebook result: %@", result);
        //NSLog(@"Facebook authToken: %@", [facebook accessToken]);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:@"FBUserData"];
        [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
        [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        [_delegate findSuccess:KBFindFirst model:modelName withData:result];
    }
}

@end
