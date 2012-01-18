//
//  AppView.h
//  Koombea
//
//  Created by Oscar De Moya on 6/25/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KBView : UIViewController {
    UIImageView *backgroundView;
}

@property (nonatomic, strong) UIImageView *backgroundView;

- (void)setDefaultStyles;

@end
