//
//  KBFacebookUser.h
//  TrackTopia
//
//  Created by Oscar De Moya on 12/13/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

@interface KBFacebookUser : KBModel {

    NSString *token;
    NSString *email;
    NSString *username;
    NSString *first_name;
    NSString *last_name;
}

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;

+ (KBFacebookUser *)shared;

@end
