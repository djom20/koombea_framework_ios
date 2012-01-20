//
//  KBResponse.m
//  Koombea
//
//  Created by Oscar De Moya on 1/20/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBResponse.h"

@implementation KBResponse

@synthesize message;
@synthesize status;
@synthesize code;
@synthesize errors;
@synthesize data;
@synthesize sourceData;

- (void)fill:(NSDictionary *)response
{
    self.message = [response objectForKey:@"message"];
    self.status = [response objectForKey:@"status"];
    self.code = [response objectForKey:@"code"];
    self.errors = [response objectForKey:@"errors"];
    self.data = [response objectForKey:@"data"];
    self.sourceData = response;
}

@end
