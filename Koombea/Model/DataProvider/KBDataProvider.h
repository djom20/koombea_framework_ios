//
//  DataProvider.h
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

@class KBDataProvider;
@class KBModel;

@protocol KBDataProvider<NSObject>
@optional
- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params;
- (id)save:(KBModel *)model withParams:(id)params;
- (id)del:(NSString *)className withParams:(id)params;
@end

@protocol KBDataProviderDelegate<NSObject>
@optional
- (void)findSuccess:(KBFindType)findType model:(NSString *)className withData:(id)data;
- (void)findError:(KBFindType)findType model:(NSString *)className withData:(id)data;
- (void)saveSuccess:(NSString *)className withData:(id)data;
- (void)saveError:(NSString *)className withData:(id)data;
- (void)deleteSuccess:(NSString *)className withData:(id)data;
- (void)deleteError:(NSString *)className withData:(id)data;
@end

@interface KBDataProvider : KBObject<KBDataProvider> {
    NSString *_modelName;
    KBFindType _findType;
    id<KBDataProviderDelegate> _delegate;
}

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic) KBFindType findType;
@property (nonatomic, strong) id<KBDataProviderDelegate> delegate;

+ (KBDataProvider *)sharedDataProvider;
+ (NSDictionary *)dataProviders;
+ (KBDataProviderType)dataProviderType:(NSString *)string;
+ (Class)dataProviderClass:(KBDataProviderType)dataProviderType;

@end
