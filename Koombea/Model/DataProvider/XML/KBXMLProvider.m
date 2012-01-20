//
//  KBXMLProvider.m
//  Koombea
//
//  Created by Oscar De Moya on 1/20/12.
//  Copyright (c) 2012 Koombea S.A.S. All rights reserved.
//

#import "KBXMLProvider.h"
#import "XMLReader.h"

@implementation KBXMLProvider

+ (KBXMLProvider *)shared
{
    static KBXMLProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBXMLProvider alloc] init];
    }
    return instance;
}

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    NSString *fileName = (findType == KBFindFirst ? [className propertyString] : [className propertyPluralizedString]);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *data = [XMLReader dictionaryForXMLData:xmlData error:error];
    if (error) {
        NSLog(ERROR_XML_PROVIDER, error, [error userInfo]);
        return nil;
    }
    
    id ModelClass = NSClassFromString(className);
    if (findType == KBFindFirst) {
        KBModel *model = [[ModelClass alloc] init];
        return [KBModel fillModel:model withDictionary:data];
    } else {
        NSMutableArray *modelList = [[NSMutableArray alloc] init];
        for (NSString *key in [data allKeys]) {
            id object = [data objectForKey:key];
            KBModel *model = [[ModelClass alloc] init];
            [KBModel fillModel:model withDictionary:object];
            [modelList addObject:model];     
        }
        return modelList;
    }
}


@end
