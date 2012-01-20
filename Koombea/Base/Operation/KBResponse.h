//
//  KBResponse.h
//  Koombea
//
//  Created by Oscar De Moya on 1/20/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBObject.h"

@interface KBResponse : KBObject {
	NSString *message;
	NSString *status;
	NSString *code;
    NSArray *errors;
	id data;
    id sourceData;
}


@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *errors;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) id sourceData;

- (void)fill:(NSDictionary *)response;

@end
