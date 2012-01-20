//
//  KBApiResponse.m
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBApiResponse.h"


@implementation KBApiResponse

@synthesize method;
@synthesize previousPage;
@synthesize actualPage;
@synthesize nextPage;

- (void)fill:(NSDictionary *)response
{
    [super fill:response];
    self.previousPage = [[response objectForKey:@"previous_page"] intValue];
    self.actualPage = [[response objectForKey:@"actual_page"] intValue];
    self.nextPage = [[response objectForKey:@"next_page"] intValue];
}

@end
