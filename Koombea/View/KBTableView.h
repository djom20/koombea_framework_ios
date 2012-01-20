//
//  AppTableView.h
//  Koombea
//
//  Created by Oscar De Moya on 6/26/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KBTableView : UITableViewController {
    NSMutableArray *tableData;
}

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NSMutableArray *tableData;

- (void)setDefaultStyles;
- (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle;
- (void)showAlert:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle;
- (void)showErrorAlert:(NSString *)message;

@end
