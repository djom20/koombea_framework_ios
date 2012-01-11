//
//  KBFacebookProvider.h
//  TrackTopia
//
//  Created by Oscar De Moya on 12/13/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"
#import "FBConnect.h"

@interface KBFacebookProvider : KBDataProvider<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    Facebook *facebook;
    NSArray *permissions;
}

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSArray *permissions;

+ (KBFacebookProvider *)shared;
- (KBFacebookProvider *)init;
- (void)login;
- (void)logout;

@end
