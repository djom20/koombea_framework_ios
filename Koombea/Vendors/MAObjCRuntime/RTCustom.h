//
//  RTCustom.h
//  Koombea
//
//  Created by Oscar De Moya on 12/21/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTProtocol;
@class RTIvar;
@class RTProperty;
@class RTMethod;
@class RTUnregisteredClass;

@interface RTCustom : NSObject

+ (NSArray *)rt_properties:(Class)aClass;
+ (RTProperty *)rt_propertyForName:(NSString *)name fromClass:(Class)aClass;

@end
