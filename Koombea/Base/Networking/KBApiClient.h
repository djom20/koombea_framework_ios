//
//  KBApiClient.h
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBRequest.h"

@class KBApiClient;
@class KBApiResponse;

@protocol KBApiClientDelegate <NSObject>
@required
- (void) requestDone:(KBApiClient *)apiClient withResponse:(KBApiResponse *)response;
- (void) requestFailed:(KBApiClient *)apiClient withResponse:(KBApiResponse *)response;
@optional
- (void) requestStart:(KBApiClient *)apiClient;
- (void) requestAlert:(KBApiClient *)apiClient;
@end

@interface KBApiClient : NSObject<KBRequestDelegate> {
    __weak id<KBApiClientDelegate> _delegate;
    KBRequest *_request;
    HttpMethod httpMethod;
    NSString *httpProtocol;
    NSString *host;
    BOOL useBasicAuth;
    NSString *basicAuthUsername;
    NSString *basicAuthPassword;
    BOOL useApiKey;
    NSString *apiKeyName;
    NSString *apiKeyValue;
}

@property (nonatomic, weak) id<KBApiClientDelegate> delegate;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) BOOL useBasicAuth;
@property (nonatomic, strong) NSString *basicAuthUsername;
@property (nonatomic, strong) NSString *basicAuthPassword;
@property (nonatomic) BOOL useApiKey;
@property (nonatomic, strong) NSString *apiKeyName;
@property (nonatomic, strong) NSString *apiKeyValue;
@property (nonatomic, strong) KBRequest *request;
@property (nonatomic) HttpMethod httpMethod;
@property (nonatomic, strong) NSString *httpProtocol;

+ (KBApiClient *)apiClient;
- (int)get:(NSString *)method withData:(NSDictionary *)data;
- (int)get:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids;
- (int)post:(NSString *)method withData:(NSDictionary *)data;
- (int)post:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids;
- (int)put:(NSString *)method withData:(NSDictionary *)data;
- (int)put:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids;
- (int)del:(NSString *)method withData:(NSDictionary *)data;
- (int)del:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids;
- (NSString *)getBasicAuthPassword;
- (NSString *)createUrl:(NSString *)method withData:(NSDictionary *)data ids:(NSArray *)ids;

- (void) requestDone:(KBRequest *)request withData:(id)data;
- (void) requestFailed:(KBRequest *)request;
- (void) requestStart:(KBRequest *)request;
- (void) requestAlert:(KBRequest *)request;

@end
