//
//  KBCore.h
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "AppConfig.h"
#import "AppStyles.h"
#import "NSString+String.h"
#import "NSString+ActiveSupportInflector.h"
#import "QuickDialog.h"
#import "KBAutoForm.h"
#import "KBCoreConstants.h"
#import "KBErrorMessages.h"
#import "KBObject.h"
#import "KBModel.h"
#import "KBOperation.h"
#import "KBTableView.h"
#import "KBTabBarCtrl.h"
#import "KBView.h"

@interface KBCore : KBObject

+ (UIColor *)rgbColor:(NSString *)rgb;
+ (NSString*)base64forData:(NSData*)data;

@end
