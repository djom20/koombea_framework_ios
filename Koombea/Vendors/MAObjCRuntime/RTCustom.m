//
//  RTCustom.m
//  Koombea
//
//  Created by Oscar De Moya on 12/21/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "RTCustom.h"

#import <objc/runtime.h>

#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTProperty.h"
#import "RTMethod.h"
#import "RTUnregisteredClass.h"

@implementation RTCustom

+ (NSArray *)rt_properties:(Class)aClass
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(aClass, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTProperty propertyWithObjCProperty: list[i]]];
    
    free(list);
    return array;
}

+ (RTProperty *)rt_propertyForName:(NSString *)name fromClass:(Class)aClass
{
    objc_property_t property = class_getProperty(aClass, [name UTF8String]);
    if(!property) return nil;
    return [RTProperty propertyWithObjCProperty: property];
}

@end
