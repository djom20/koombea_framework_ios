//
//  KBApiResponse.h
//  Koombea
//
//  Created by Oscar De Moya on 3/29/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KBApiResponse : NSObject {
    id sourceData;
    NSString *method;
	NSString *message;
	NSString *status;
	NSString *code;
	id data;
	NSInteger previousPage;
	NSInteger actualPage;
	NSInteger nextPage;
}

@property (nonatomic, strong) id sourceData;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) id data;
@property (nonatomic) NSInteger previousPage;
@property (nonatomic) NSInteger actualPage;
@property (nonatomic) NSInteger nextPage;

- (void) fill:(NSDictionary *)response;

@end
