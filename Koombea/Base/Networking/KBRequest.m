//
// KBRequest.m
//  Koombea
//
//  Created by Oscar De Moya on 2/10/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBRequest.h"
#import "JSON.h"
#import "XMLReader.h"

@implementation KBRequest

@synthesize delegate = _delegate;
@synthesize contentType = _contentType;
@synthesize sequence, identifier, url, request, _params, connection, receivedData, responseFormat, trustedHosts;

+ (KBRequest *) request {
	KBRequest *instance = [[KBRequest alloc] init];
	instance.receivedData = [[NSMutableData alloc] init];
    instance.trustedHosts = [[NSMutableArray alloc] init];
	return instance;
}

+ (KBRequest *)shared {
    static KBRequest *instance = nil;
    if (nil == instance) {
        instance = [[KBRequest alloc] init];
        instance.sequence = 0;
    }
    return instance;
}

+ (int)nextSequence {
    ([KBRequest shared]).sequence = ([KBRequest shared]).sequence + 1;
    return ([KBRequest shared]).sequence;
}

- (void)addTrustedHost:(NSString *)host {
    [trustedHosts addObject:host];
}

- (int)get:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"GET %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];	
	return [self createRequest:@"GET" withParms:nil];
}

- (int)post:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"POST %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];
	NSString *postString = [KBRequest paramsToString:data withContentType:_contentType];
	return [self createRequest:@"POST" withParms:postString];
}

- (int)put:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {
	NSLog(@"PUT %@", toURL);
    _delegate = delegate;
    _params = data;
	url = [[NSURL alloc] initWithString:toURL];
	NSString *postString = [KBRequest paramsToString:data withContentType:_contentType];
	return [self createRequest:@"PUT" withParms:postString];
}

- (int)del:(NSString *)toURL withData:(NSDictionary *)data andDelegate:(id<KBRequestDelegate>)delegate {	
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
    
    if (_contentType) {
        [_request setValue:[NSString stringWithFormat:@"%@; boundary=%@", _contentType, HTTP_DATA_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    } else {
        _contentType = HTTP_CONTENT_TYPE_FORM;
        [_request setValue:HTTP_CONTENT_TYPE_FORM forHTTPHeaderField:@"Content-Type"];
    }
    NSLog(@"Content-Type: %@", _contentType);

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

- (void)connectionDidFinishLoading:(NSURLConnection*) connection {
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    if(DEBUG_NETWORKING) NSLog(@"Response received: %@", response);
    NSError *error;
    if([responseFormat isEqualToString:API_RESPONSE_FORMAT_JSON]) {
        @try {
            parsedData = [response JSONValue];
            [_delegate requestDone:self withData:parsedData];
        } @catch (NSException *exception) {
            NSLog(@"Error Parsing JSON Response: %@", response);
            NSLog(@"Exception: %@", exception);
            [_delegate requestFailed:self];
        }
    } else if([responseFormat isEqualToString:API_RESPONSE_FORMAT_XML]) {
        parsedData = [XMLReader dictionaryForXMLString:response error:error];
        if (!error) {
            [_delegate requestDone:self withData:parsedData];
        } else {
            NSLog(@"Error Parsing XML Response: %@", response);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [_delegate requestFailed:self];
        }
    }
}

- (id)data {
	return parsedData;
}

+ (NSString *)paramsToString:(NSDictionary *)dict withContentType:(NSString *)contentType {
	NSMutableString *paramStr = [NSMutableString stringWithFormat:@""];
	BOOL first = YES;
    NSLog(@"Content-Type 2: %@", contentType);
	for(NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        
        
        if (!contentType || [contentType isEqualToString:HTTP_CONTENT_TYPE_FORM]) {
            if (first == YES) {
                first = NO;
                [paramStr appendFormat:@"%@=%@", key, value];
            } else {
                [paramStr appendFormat:@"&%@=%@", key, value];
            }
        } else {
            if ([value isKindOfClass:[NSData class]]) {
                //NSString *encodedData = [KBCore base64forData:value];
                [paramStr appendString:[self fileParam:key withData:value fileName:@"temp.jpg"]];
            } else {
                [paramStr appendString:[self inputParam:key withValue:value]];
            }
        }
	}
    if ([contentType isEqualToString:HTTP_CONTENT_TYPE_MULTIPART]) {
        [paramStr appendFormat:@"\r\n--%@--\r\n", HTTP_DATA_BOUNDARY];
    }
	//NSLog(@"Params: %@", paramStr);
	return paramStr;
}

+ (NSString *)fileParam:(NSString *)key withData:(NSData *)data fileName:(NSString *)fileName {
    NSMutableString *postString = [NSMutableString stringWithString:[NSString stringWithFormat:@"\r\n--%@\r\n", HTTP_DATA_BOUNDARY]];
    [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName];
    [postString appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
    [postString appendString:[KBCore base64forData:data]];    
    return postString;
}

+ (NSString *)inputParam:(NSString *)key withValue:(NSString *)value {
    NSMutableString *postString = [NSMutableString stringWithString:[NSString stringWithFormat:@"\r\n--%@\r\n", HTTP_DATA_BOUNDARY]];
    [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
    [postString appendString:value];
    return postString;
}

+ (NSString *)extractValueFromParamString:(NSString *)strParams withKey:(NSString *)strKey {
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
