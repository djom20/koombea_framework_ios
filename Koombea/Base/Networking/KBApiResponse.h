//
//  KBApiResponse.h
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KBApiResponse : NSObject {
    NSString *method;
	NSString *message;
	NSString *status;
	NSString *code;
	id data;
	NSInteger previousPage;
	NSInteger actualPage;
	NSInteger nextPage;
}

@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) id data;
@property (nonatomic) NSInteger previousPage;
@property (nonatomic) NSInteger actualPage;
@property (nonatomic) NSInteger nextPage;

- (void) fill:(NSDictionary *)response;

@end
