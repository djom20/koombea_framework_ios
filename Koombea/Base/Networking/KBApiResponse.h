//
//  KBApiResponse.h
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

@interface KBApiResponse : KBResponse {
    NSString *method;
	NSInteger previousPage;
	NSInteger actualPage;
	NSInteger nextPage;
}

@property (nonatomic, strong) NSString *method;
@property (nonatomic) NSInteger previousPage;
@property (nonatomic) NSInteger actualPage;
@property (nonatomic) NSInteger nextPage;

- (void) fill:(NSDictionary *)response;

@end
