//
//  KBAPIProvider.h
//  Koombea
//
//  Created by Oscar De Moya on 1/17/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"
#import "KBApiClient.h"

@interface KBApiProvider : KBDataProvider<KBApiClientDelegate>

+ (KBApiProvider *)shared;

@end
