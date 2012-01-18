//
//  KBAPIProvider.h
//  Koombea
//
//  Created by Oscar De Moya on 1/17/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"
#import "KBApiClient.h"

@interface KBApiProvider : KBDataProvider<KBApiClientDelegate> {
    KBApiClient *api;
}

@property (nonatomic, strong) KBApiClient *api;

+ (KBApiProvider *)shared;

@end
