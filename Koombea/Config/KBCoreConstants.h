//
//  KBCoreConstants.h
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Debug */
#define DEBUG_NETWORKING YES

/* Networking Params */
#define REQUEST_TIMEOUT_INTERVAL 30

/* HTTP Request */
#define HTTP_METHOD @"HttpMethod"
#define HTTP_CONTENT_TYPE @"ContentType"
#define HTTP_CONTENT_TYPE_FORM @"application/x-www-form-urlencoded"
#define HTTP_CONTENT_TYPE_MULTIPART @"multipart/form-data"
#define HTTP_CONTENT_TYPE_JSON @"application/json"
#define HTTP_DATA_BOUNDARY @"-----------------KoombeaFrameworkFormBoundary"

typedef enum {
    NO_HTTP_METHOD,
    GET,
    POST,
	PUT,
    DELETE
} HttpMethod;

/* API Config */
#define API_CONFIG @"Config"
#define API_HOST @"Host"
#define API_PROTOCOL @"Protocol"
#define API_RESPONSE_FORMAT @"ResponseFormat"
#define API_RESPONSE_FORMAT_JSON @"JSON"
#define API_RESPONSE_FORMAT_XML @"XML"
#define API_KEY @"Key"
#define API_BASIC_AUTH @"BasicAuth"
#define API_VALIDATE_PARAMS @"ValidateParams"
#define API_METHODS @"Methods"
#define API_PATH @"Path"
#define API_ERRORS @"Errors"

/* Config File Names */
#define APP_SETTINGS @"settings"
#define APP_STYLES @"styles"
#define MODEL_SETTINGS @"models"
#define API_SETTINGS @"api"
#define DEFAULT_MODEL_SETTINGS @"default_models"

/* Settings Plist Keys */
#define TW_SETTINGS @"Twitter"
#define TW_OAUTH_KEY @"OAuthKey"
#define TW_OAUTH_SECRET @"OAuthSecret"
#define FB_SETTINGS @"Facebook"
#define FB_APP_ID @"AppID"
#define FB_APP_SECRET @"AppSecret"
#define UA_SETTINGS @"UrbanAirship"
#define UA_APP_KEY @"AppKey"
#define UA_APP_SECRET @"AppSecret"
#define S3_SETTINGS @"AmazonS3"
#define S3_ACCESS_KEY @"AccessKey"
#define S3_SECRET_ACCESS_KEY @"SecretAccessKey"
#define S3_BUCKET @"Bucket"
#define S3_FILE_PREFIX @"FilePrefix"
#define PARSE_SETTINGS @"Parse"
#define PARSE_APP_ID @"AppID"
#define PARSE_CLIENT_KEY @"ClientKey"
#define PARSE_MASTER_KEY @"MasterKey"
#define PARSE_REST_API_KEY @"RestApiKey"

/* Styles Plist Keys */
#define COLOR_PALETTE @"ColorPalette"
#define DEFAULT_BG @"Default.background"
#define NAVBAR_BG @"NavigationBar.background"
#define NAVBAR_TINT @"NavigationBar.tint"
#define TABBAR_BG @"TabBar.background"
#define TABBAR_HEIGHT @"TabBar.height"

/* Model Attributes */
#define MODEL_KEY @"key"
#define MODEL_VALUE @"value"

/* Model Relationships */
#define MODEL_HAS_ONE @"hasOne"
#define MODEL_HAS_MANY @"hasMany"
#define MODEL_BELONGS_TO @"belongsTo"
#define MODEL_HABTM @"hasAndBelongsToMany"

/* Persistence Operation */
typedef enum {
    KBFind,
    KBSave,
    KBDelete
} KBPersistenceOperation;

/* Quantity Types */
typedef enum {
    KBFindNone,
    KBFindAll,
    KBFindFirst,
    KBFindCount
} KBFindType;

/* Query Parameters */
#define MODEL_ASCENDING @"ascending"
#define MODEL_ATTRIBUTE @"attribute"
#define MODEL_CONDITIONS @"conditions"
#define MODEL_VALIDATE @"validate"
#define MODEL_ORDER @"order"
#define MODEL_RECURSIVE @"recursive"

/* Validations */
#define MODEL_VALIDATE_EMPTY @"Empty"
#define MODEL_VALIDATE_LENGTH @"Length"
#define MODEL_VALIDATE_PRICE_FORMAT @"PriceFormat"

#define MODEL_VALIDATION_MIN_INTEGERS @"MinIntegers"
#define MODEL_VALIDATION_MAX_INTEGERS @"MaxIntegers"
#define MODEL_VALIDATION_MIN_DECIMALS @"MinDecimals"
#define MODEL_VALIDATION_MAX_DECIMALS @"MaxDecimals"
#define MODEL_VALIDATION_SEPARATOR @"Separator"

/* Data Providers */
#define DATA_PROVIDER @"dataProvider"
#define DATA_PROVIDER_NONE @"DATA_PROVIDER_NONE"
#define DATA_PROVIDER_API @"DATA_PROVIDER_API"
#define DATA_PROVIDER_REGISTRY @"DATA_PROVIDER_REGISTRY"
#define DATA_PROVIDER_DATABASE @"DATA_PROVIDER_DATABASE"
#define DATA_PROVIDER_FILE @"DATA_PROVIDER_FILE"
#define DATA_PROVIDER_TWITTER @"DATA_PROVIDER_TWITTER"
#define DATA_PROVIDER_FACEBOOK @"DATA_PROVIDER_FACEBOOK"
#define DATA_PROVIDER_AMAZON_S3 @"DATA_PROVIDER_AMAZON_S3"
#define DATA_PROVIDER_FTP @"DATA_PROVIDER_FTP"
#define DATA_PROVIDER_AUDIO_LOCAL @"DATA_PROVIDER_AUDIO_LOCAL"
#define DATA_PROVIDER_AUDIO_STREAM @"DATA_PROVIDER_AUDIO_STREAM"
#define DATA_PROVIDER_VIDEO_LOCAL @"DATA_PROVIDER_VIDEO_LOCAL"
#define DATA_PROVIDER_VIDEO_STREAM @"DATA_PROVIDER_VIDEO_STREAM"
#define DATA_PROVIDER_PARSE @"DATA_PROVIDER_PARSE"
#define DATA_PROVIDER_JSON @"DATA_PROVIDER_JSON"
#define DATA_PROVIDER_PLIST @"DATA_PROVIDER_PLIST"
#define DATA_PROVIDER_XML @"DATA_PROVIDER_XML"

typedef enum {
    KBDataProviderNone          = 0,
    KBDataProviderAPI           = 1,
    KBDataProviderRegistry      = 2,
    KBDataProviderDatabase      = 3,
    KBDataProviderFile          = 4,
    KBDataProviderTwitter       = 5,
    KBDataProviderFacebook      = 6,
    KBDataProviderAmazonS3      = 7,
    KBDataProviderFTP           = 8,
    KBDataProviderAudioLocal    = 9,
    KBDataProviderAudioStream   = 10,
    KBDataProviderVideoLocal    = 11,
    KBDataProviderVideoStream   = 12,
    KBDataProviderParse         = 13,
    KBDataProviderJSON          = 14,
    KBDataProviderPlist         = 15,
    KBDataProviderXML           = 16
} KBDataProviderType;

/* Facebook */
#define FACEBOOK @"facebook"
#define FB_GRAPH_PATH_ME @"me"

/* Twitter */
#define TWITTER @"twitter"

#define OP_METHOD @"method"
#define OP_MESSAGE @"message"
#define OP_ERRORS @"errors"
#define OP_STATUS @"status"
#define OP_CODE @"code"
#define OP_DATA @"data"
#define OP_SUCCESS @"success"
#define OP_FAILURE @"failure"

/* Tags */
#define TAG_LOADING_INDICATOR 10000001

/* Notifications */
#define NOTE_FB_INFO_READY @"NOTE_FB_INFO_READY"

