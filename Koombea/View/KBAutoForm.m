//
//  KBAutoForm.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/19/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBAutoForm.h"


@implementation KBAutoForm

@synthesize root;

- (void)loadForm:(NSString *)jsonFile
{
    root = [[QRootElement alloc] initWithJSONFile:jsonFile];
    [self setRoot:root];
    QuickDialogTableView *quickformTableView = [[QuickDialogTableView alloc] initWithController:self];
    self.tableView = quickformTableView;
    self.tableView.bounces = YES;
    ((QuickDialogTableView *) self.tableView).styleProvider = self;
    
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_BG_DEFAULT]];
    backgroundView.contentMode = UIViewContentModeTop;
    self.tableView.backgroundView = backgroundView;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - QuickDialogStyleProvider methods

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{  
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
