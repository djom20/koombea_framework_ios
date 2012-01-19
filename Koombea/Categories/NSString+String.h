//
//  NSString+String.h
//  DrumGuru
//
//  Created by Oscar De Moya on 10/19/11.
//  Copyright (c) 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)

- (int)indexOf:(NSString *)text;
- (NSString *)md5;
- (id)JSONValue;

@end
