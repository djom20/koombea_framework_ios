//
//  AppView.h
//  Koombea
//
//  Created by Oscar De Moya on 6/25/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface KBView : UIViewController {
    UIImageView *backgroundView;
    MBProgressHUD *_loadingIndicator;
    
    NSMutableDictionary *_alert;
}

@property (nonatomic, strong) NSMutableDictionary *alert;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) MBProgressHUD *loadingIndicator;

+ (KBView *)shared;

- (void)setDefaultStyles;
- (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle;
- (void)showAlert:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle;
- (void)showErrorAlert:(NSString *)message;
- (void)showLoading:(UIViewController *)viewCtrl withText:(NSString *)text;
- (void)hideLoading:(UIViewController *)viewCtrl;

@end
