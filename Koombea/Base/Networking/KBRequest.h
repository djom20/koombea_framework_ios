//
//  KBRequest.h
//  Koombea
//
//  Created by Oscar De Moya on 2/10/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KBRequest;

typedef enum {
    GET,
    POST,
	PUT,
    DELETE
} HttpMethod;

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

@property (nonatomic, retain) id<KBRequestDelegate> delegate;
@property (nonatomic, assign) int sequence;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSDictionary *_params;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *trustedHosts;

+ (KBRequest *) request;
+ (KBRequest *) shared;
+ (int) nextSequence;
- (void) addTrustedHost:(NSString *)host;
- (int) get:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int) post:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int) put:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int) del:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate;
- (int) createRequest:(NSString *)type withParms:(NSString *)params;
- (id) data;
+ (NSString *) paramsToString:(NSDictionary *)data;
+ (NSString *) extractValueFromParamString:(NSString *)strParams withKey:(NSString *)strKey;

@end
