//
//  DataProvider.m
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"
#import "KBCore.h"

@implementation KBDataProvider

@synthesize modelName;
@synthesize delegate = _delegate;

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

@end
