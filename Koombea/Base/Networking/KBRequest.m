//
// KBRequest.m
//  Koombea
//
//  Created by Oscar De Moya on 2/10/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBRequest.h"
#import "JSON.h"

@implementation KBRequest

@synthesize delegate = _delegate;
@synthesize sequence, identifier, url, request, _params, connection, receivedData, trustedHosts;

+ (KBRequest *) request {
	KBRequest *instance = [[KBRequest alloc] init];
	instance.receivedData = [[NSMutableData alloc] init];
    instance.trustedHosts = [[NSMutableArray alloc] init];
	return instance;
}

+ (KBRequest *) shared {
    static KBRequest *instance = nil;
    if (nil == instance) {
        instance = [[KBRequest alloc] init];
        instance.sequence = 0;
    }
    return instance;
}

+ (int) nextSequence {
    ([KBRequest shared]).sequence = ([KBRequest shared]).sequence + 1;
    return ([KBRequest shared]).sequence;
}

- (void) addTrustedHost:(NSString *)host {
    [trustedHosts addObject:host];
}

- (int) get:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"GET %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];	
	return [self createRequest:@"GET" withParms:nil];
}

- (int) post:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"POST %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];
	NSString *postString = [KBRequest paramsToString:data];
	return [self createRequest:@"POST" withParms:postString];
}

- (int) put:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"PUT %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];
	NSString *postString = [KBRequest paramsToString:data];
	return [self createRequest:@"PUT" withParms:postString];
}

- (int) del:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {	
	NSLog(@"DELETE %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];	
	return [self createRequest:@"DELETE" withParms:nil];
}

- (int) createRequest:(NSString *)type withParms:(NSString *)params {
	NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
	NSString *paramsLength = [NSString stringWithFormat:@"%d", [params length]];
	[_request setHTTPMethod:type];
	[_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	if ([type isEqualToString:@"POST"] || [type isEqualToString:@"PUT"]) {
		[_request setValue:paramsLength forHTTPHeaderField:@"Content-Length"];
		[_request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	} else if ([type isEqualToString:@"GET"] || [type isEqualToString:@"DELETE"]) {
		// Do nothing
	}
    [_request setHTTPMethod:type];
	self.request = _request;
    self.sequence = [KBRequest nextSequence];
    
    [self.delegate requestStart:self];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (!connection) {
        [_delegate requestFailed:self];
    }
    return self.sequence;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Authentication challenge received");
    [_delegate requestAlert:self];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            NSLog(@"Trusted host found");
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                 forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate requestFailed:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", response);
	@try {
        parsedData = [response JSONValue];
        [_delegate requestDone:self withData:parsedData];
    } @catch (NSException *exception) {
        NSLog(@"Error Parsing JSON Response: %@", response);
        NSLog(@"Exception: %@", exception);
        [_delegate requestFailed:self];
    }
}

- (id) data {
	return parsedData;
}

+ (NSString *) paramsToString:(NSDictionary *)data {
	NSMutableString *paramStr = [NSMutableString stringWithFormat:@""];
	BOOL first = YES;
	for(NSString *key in data) {
		if (first == YES) {
			first = NO;
			[paramStr appendFormat:@"%@=%@", key, [data objectForKey:key]];
		} else {
			[paramStr appendFormat:@"&%@=%@", key, [data objectForKey:key]];
		}
	}
	NSLog(@"Params: %@", paramStr);
	return paramStr;
}

+ (NSString *) extractValueFromParamString:(NSString *)strParams withKey:(NSString *)strKey {
	if (!strParams) return nil;
	NSArray	*tuples = [strParams componentsSeparatedByString: @"&"];
	if (tuples.count < 1) return nil;
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		if (keyValueArray.count == 2) {
			NSString *key = [keyValueArray objectAtIndex: 0];
			NSString *value = [keyValueArray objectAtIndex: 1];
			if ([key isEqualToString:strKey]) return value;
		}
	}
	return nil;
}


+ (HttpMethod)httpMethod:(NSString *)methodName {
    if ([methodName isEqualToString:@"POST"]) {
        return POST;
    } else if ([methodName isEqualToString:@"GET"]) {
        return GET;
    } else if ([methodName isEqualToString:@"DELETE"]) {
        return DELETE;
    } else if ([methodName isEqualToString:@"PUT"]) {
        return PUT;
    } else {
        return NO_HTTP_METHOD;
    }
}

@end
