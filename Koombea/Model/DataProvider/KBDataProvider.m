//
//  DataProvider.m
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"
#import "KBCore.h"
#import "KBDatabaseProvider.h"
#import "KBApiProvider.h"
#import "KBFacebookProvider.h"
#import "KBJSONProvider.h"
#import "KBParseProvider.h"
#import "KBPlistProvider.h"

@implementation KBDataProvider

@synthesize modelName = _modelName;
@synthesize findType = _findType;
@synthesize delegate = _delegate;

+ (KBDataProvider *)sharedDataProvider
{
    static KBDataProvider *instance = nil;
    if (nil == instance) {
        instance = [[[self class] alloc] init];
    } else if (![instance isKindOfClass:[self class]]) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

+ (KBDataProviderType)dataProviderType:(NSString *)string
{
    NSDictionary *dataProviders = [KBDataProvider dataProviders];
    return (KBDataProviderType)[[dataProviders objectForKey:string] intValue];
}

+ (NSDictionary *)dataProviders {
    static NSDictionary *dataProviders = nil;
    if (dataProviders == nil) {
        dataProviders = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInteger:KBDataProviderNone], DATA_PROVIDER_NONE,
                         [NSNumber numberWithInteger:KBDataProviderAPI], DATA_PROVIDER_API,
                         [NSNumber numberWithInteger:KBDataProviderRegistry], DATA_PROVIDER_REGISTRY,
                         [NSNumber numberWithInteger:KBDataProviderDatabase], DATA_PROVIDER_DATABASE,
                         [NSNumber numberWithInteger:KBDataProviderFile], DATA_PROVIDER_FILE,
                         [NSNumber numberWithInteger:KBDataProviderTwitter], DATA_PROVIDER_TWITTER,
                         [NSNumber numberWithInteger:KBDataProviderFacebook], DATA_PROVIDER_FACEBOOK,
                         [NSNumber numberWithInteger:KBDataProviderAmazonS3], DATA_PROVIDER_AMAZON_S3,
                         [NSNumber numberWithInteger:KBDataProviderFTP], DATA_PROVIDER_FTP,
                         [NSNumber numberWithInteger:KBDataProviderAudioLocal], DATA_PROVIDER_AUDIO_LOCAL,
                         [NSNumber numberWithInteger:KBDataProviderAudioStream], DATA_PROVIDER_AUDIO_STREAM,
                         [NSNumber numberWithInteger:KBDataProviderVideoLocal], DATA_PROVIDER_VIDEO_LOCAL,
                         [NSNumber numberWithInteger:KBDataProviderVideoStream], DATA_PROVIDER_VIDEO_STREAM,
                         [NSNumber numberWithInteger:KBDataProviderParse], DATA_PROVIDER_PARSE,
                         [NSNumber numberWithInteger:KBDataProviderJSON], DATA_PROVIDER_JSON,
                         [NSNumber numberWithInteger:KBDataProviderPlist], DATA_PROVIDER_PLIST,
                         nil
                         ];
    }
    return dataProviders;
}

+ (Class)dataProviderClass:(KBDataProviderType)dataProviderType {
    switch (dataProviderType) {
        case KBDataProviderNone: return nil;
        case KBDataProviderAPI: return [KBApiProvider class];
        //case KBDataProviderRegistry: return [KBRegistryProvider class];
        case KBDataProviderDatabase: return [KBDatabaseProvider class];
        //case KBDataProviderFile: return [KBFileProvider class];
        //case KBDataProviderTwitter: return [KBTwitterProvider class];
        case KBDataProviderFacebook: return [KBFacebookProvider class];
        //case KBDataProviderAmazonS3: return [KBAmazonS3Provider class];
        //case KBDataProviderFTP: return [KBJFTPProvider class];
        //case KBDataProviderAudioLocal: return [KBAudioLocalProvider class];
        //case KBDataProviderAudioStream: return [KBAudioStreamProvider class];
        //case KBDataProviderVideoLocal: return [KBVideoLocalProvider class];
        //case KBDataProviderVideoStream: return [KBVideoStreamProvider class];
        case KBDataProviderParse: return [KBParseProvider class];
        case KBDataProviderJSON: return [KBJSONProvider class];
        case KBDataProviderPlist: return [KBPlistProvider class];
        default: return nil;
    }
}

@end
