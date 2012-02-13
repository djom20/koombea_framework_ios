//
//  KBAutoForm.h
//  TrackTopia
//
//  Created by Oscar De Moya on 12/19/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDialog.h"

@interface KBAutoForm : QuickDialogController<QuickDialogStyleProvider> {
    QRootElement *root;
    UIImageView *backgroundView;
}

@property (nonatomic, strong) QRootElement *root;

- (void)createWithJSONFile:(NSString *)jsonFile;
- (void)createWithJSONString:(NSString *)jsonString;
- (void)createWithRoot:(QRootElement *)root;
- (NSArray *)validateForm;
- (NSDictionary *)validateField:(QElement *)element;
- (void)setValue:(id)value forElementWithKey:(NSString *)key;
- (id)elementWithKey:(NSString *)key;

@end
