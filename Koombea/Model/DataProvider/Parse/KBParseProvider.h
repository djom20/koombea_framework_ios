//
//  KBParseProvider.h
//  Koombea
//
//  Created by Oscar De Moya on 1/12/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"

@interface KBParseProvider : KBDataProvider

+ (KBParseProvider *)shared;
- (PFObject *)fillObject:(KBModel *)model;

@end
