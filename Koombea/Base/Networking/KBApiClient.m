//
//  KBApiClient.m
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBApiClient.h"
#import "KBCore.h"
#import "KBCoreConstants.h"
#import "KBApiResponse.h"
#import "KBRequest.h"

@implementation KBApiClient

@synthesize delegate=_delegate;
@synthesize request=_request;
@synthesize httpMethod;
@synthesize httpProtocol;
@synthesize host;
@synthesize useBasicAuth;
@synthesize basicAuthUsername;
@synthesize basicAuthPassword;
@synthesize useApiKey;
@synthesize apiKeyName;
@synthesize apiKeyValue;

+ (KBApiClient *)apiClient
{
	KBApiClient *instance = [[KBApiClient alloc] init];
	instance.request = [KBRequest request];
    instance.host = [[KBCore settingForKey:API_CONFIG] objectForKey:API_HOST];
    instance.httpProtocol = [[KBCore settingForKey:API_CONFIG] objectForKey:API_PROTOCOL];
    NSDictionary *basicAuth = [[KBCore settingForKey:API_CONFIG] objectForKey:API_BASIC_AUTH];
    instance.useBasicAuth = [[basicAuth objectForKey:@"Enabled"] boolValue];
    if (instance.useBasicAuth) {
        instance.basicAuthUsername = [basicAuth objectForKey:@"Username"];
        instance.basicAuthPassword = [basicAuth objectForKey:@"Password"];
    }
    NSDictionary *apiKey = [[KBCore settingForKey:API_CONFIG] objectForKey:API_KEY];
    instance.useApiKey = [[apiKey objectForKey:@"Enabled"] boolValue];
    if (instance.useApiKey) {
        instance.apiKeyName = [apiKey objectForKey:@"Name"];
        instance.apiKeyValue = [apiKey objectForKey:@"Value"];
    }
    [instance.request addTrustedHost:instance.host];
	return instance;
}

- (int)get:(NSString *)method withData:(NSDictionary *)data
{
    return [self get:method withData:data ids:nil];
}

- (int)get:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids
{
    httpMethod = GET;
    NSString *strURL = [self createUrl:method withData:data ids:ids];
	return [_request get:strURL withData:data andDelegate:self];
}

- (int)post:(NSString *)method withData:(NSDictionary *)data
{
    return [self post:method withData:data ids:nil];
}

- (int)post:(NSString *)method withData:(NSDictionary *)data  ids:(NSArray *)ids
{
    httpMethod = POST;
    NSString *strURL = [self createUrl:method withData:data ids:ids];
    return [_request post:strURL withData:data andDelegate:self];
}

- (int)put:(NSString *)method withData:(NSDictionary *)data
{
    return [self put:method withData:data ids:nil];
}

- (int)put:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids
{
    httpMethod = PUT;
    NSString *strURL = [self createUrl:method withData:data ids:ids];
    return [_request put:strURL withData:data andDelegate:self];
}

- (int)del:(NSString *)method withData:(NSDictionary *)data
{
    return [self del:method withData:data ids:nil];
}

- (int)del:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids
{
    httpMethod = DELETE;
    NSString *strURL = [self createUrl:method withData:data ids:ids];
	return [_request del:strURL withData:data andDelegate:self];
}

- (NSString *)createUrl:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids
{
    NSMutableDictionary *auxData = [NSMutableDictionary dictionary];
    NSString *strURL = @"";
    _request.identifier = method;
    if (useApiKey) {
        [auxData addEntriesFromDictionary:[NSDictionary dictionaryWithObject:apiKeyValue forKey:apiKeyName]];
    }
    data = auxData;
    
	NSString *basicAuth;
	if (useBasicAuth) {
		basicAuth = [NSString stringWithFormat:@"%@:%@@", basicAuthUsername, [self getBasicAuthPassword]];
	} else {
		basicAuth = [NSString stringWithFormat:@""];
	}
    
    NSString *strIds = @"";
    for(NSNumber *id in ids) {
        strIds = [NSString stringWithFormat:@"%@/%@", strIds, id];
    }
    method = [method stringByReplacingOccurrencesOfString:@"/:id" withString:strIds];
    if(httpMethod == GET || httpMethod == DELETE) {
        NSMutableString *paramString = (NSMutableString *)[KBRequest paramsToString:data];
        if ([paramString length] > 0) {
            [paramString insertString:@"?" atIndex:0];
        }
        strURL = [NSString stringWithFormat:@"%@://%@%@/%@%@", httpProtocol, basicAuth, host, method, paramString];

    } else if(httpMethod == POST || httpMethod == PUT) {
        strURL = [NSString stringWithFormat:@"%@://%@%@/%@%@", httpProtocol, basicAuth, host, method, strIds];
    }
    return strURL;
}

- (NSString *)getBasicAuthPassword
{
    return basicAuthPassword;
}

#pragma mark - KBRequestDelegate methods

- (void)requestDone:(KBRequest *)request withData:(id)data
{
    KBApiResponse *response = [[KBApiResponse alloc] init];
    response.method = request.identifier;
    NSLog(@"API response received [%@]", response.method);
    [response fill:data];
    [_delegate requestDone:self withResponse:response];
}

- (void)requestFailed:(KBRequest *)request
{
    KBApiResponse *response = [[KBApiResponse alloc] init];
    response.method = request.identifier;
    NSLog(@"API request failed [%@]", response.method);
    [_delegate requestFailed:self withResponse:response];
}

- (void)requestStart:(KBRequest *)request
{
    [_delegate requestStart:self];
}

- (void)requestAlert:(KBRequest *)request
{
    [_delegate requestAlert:self];
}

@end
