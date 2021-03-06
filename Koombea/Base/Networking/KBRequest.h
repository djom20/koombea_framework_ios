//
//  KBRequest.h
//  Koombea
//
//  Created by Oscar De Moya on 2/10/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KBRequest;

@protocol KBRequestDelegate <NSObject>
@required
- (void) requestDone:(KBRequest *)request withData:(id)data;
- (void) requestFailed:(KBRequest *)request;
@optional
- (void) requestStart:(KBRequest *)request;
- (void) requestAlert:(KBRequest *)request;
@end

@interface KBRequest : KBObject {
    id<KBRequestDelegate> _delegate;
	id parsedData;
    NSString *responseFormat;
    NSString *_contentType;
    int sequence;
    NSString *identifier;
    NSDictionary *_params;
@private
	NSURL *url;
	NSURLRequest *request;
	NSURLConnection *connection;
	NSMutableData *receivedData;
    NSMutableArray *trustedHosts;
}

@property (nonatomic, strong) id<KBRequestDelegate> delegate;
@property (nonatomic, strong) NSString *responseFormat;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic) int sequence;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSDictionary *_params;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableArray *trustedHosts;

+ (KBRequest *) request;
+ (KBRequest *) shared;
+ (int)nextSequence;
- (void)addTrustedHost:(NSString *)host;
- (int)get:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int)post:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int)put:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int)del:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int)createRequest:(NSString *)type withHttpBody:(NSData *)httpBody;
- (id)data;
+ (NSString *)stringWithParams:(NSDictionary *)params;
+ (NSData *)httpBodyWithParams:(NSDictionary *)params withContentType:(NSString *)contentType;
+ (NSData *)fileParam:(NSString *)key withData:(NSData *)data fileName:(NSString *)fileName;
+ (NSData *)inputParam:(NSString *)key withValue:(NSString *)value;
+ (NSString *)extractValueFromParamString:(NSString *)strParams withKey:(NSString *)strKey;
+ (HttpMethod)httpMethod:(NSString *)methodName;

@end
