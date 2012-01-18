//
//  KBApiResponse.m
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBApiResponse.h"


@implementation KBApiResponse

@synthesize method, message, status, code, data, previousPage, actualPage, nextPage;

- (void) fill:(NSDictionary *)response {
    self.message = [response objectForKey:@"message"];
    self.status = [response objectForKey:@"status"];
    self.code = [response objectForKey:@"code"];
    self.data = [response objectForKey:@"data"];
    self.previousPage = [[response objectForKey:@"previous_page"] intValue];
    self.actualPage = [[response objectForKey:@"actual_page"] intValue];
    self.nextPage = [[response objectForKey:@"next_page"] intValue];
}

@end
