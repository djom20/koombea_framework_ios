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

@end
