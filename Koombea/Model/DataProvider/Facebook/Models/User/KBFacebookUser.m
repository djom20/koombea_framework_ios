//
//  KBFacebookUser.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/13/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBFacebookUser.h"


@implementation KBFacebookUser

@synthesize email;
@synthesize first_name;
@synthesize last_name;

+ (KBFacebookUser *)shared
{
    static KBFacebookUser *instance = nil;
    if (nil == instance) {
        instance = [[KBFacebookUser alloc] init];
    }
    return instance;
}

@end
