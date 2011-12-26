//
//  KBModel.h
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARTNSObject.h"
#import "RTCustom.h"
#import "RTProperty.h"
#import "KBDataProvider.h"

@class KBObject;

@protocol KBModel <NSObject>
@optional
- (id)find:(KBFindType)findType withParams:(id)params;
- (id)save:(id)params;
- (id)del:(id)params;
@end

@protocol KBModelDelegate <NSObject>
@optional
- (void)findSuccess:(KBFindType)findType withData:(id)data;
- (void)findError:(KBFindType)findType withData:(id)data;
- (void)saveSuccess:(id)data;
- (void)saveError:(id)data;
- (void)deleteSuccess:(id)data;
- (void)deleteError:(id)data;
@end

@interface KBModel : KBObject<KBModel, KBDataProviderDelegate> {
    NSNumber *id;
    NSDate *created_at;
    NSDate *updated_at;
    NSDictionary *_settings;
    __weak id<KBModelDelegate> _delegate;
}

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, strong) NSDictionary *_settings;
@property (nonatomic, weak) id<KBModelDelegate> delegate;

- (KBModel *)init;
+ (KBModel *)shared;
+ (id)model;
+ (id)modelWithDictionary:(NSDictionary *)dict;
+ (KBModel *)fillModel:(KBModel *)model withDictionary:(NSDictionary *)dict;
+ (NSDictionary *)modelSettings;
+ (KBDataProviderType)dataProvider;
- (KBDataProviderType)dataProviderType;
- (BOOL)isNew;
+ (BOOL)hasProperty:(NSString *)key;

@end
