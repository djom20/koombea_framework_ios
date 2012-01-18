//
//  AppView.m
//  Koombea
//
//  Created by Oscar De Moya on 6/25/11.
//  Copyright 2011 Koombea Inc. All rights reserved.
//

#import "KBView.h"


@implementation KBView

@synthesize backgroundView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDefaultStyles];
}

- (void)setDefaultStyles
{
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[KBCore styleForKeyPath:DEFAULT_BG]]];
    backgroundView.contentMode = UIViewContentModeTop;
    [self.view insertSubview:backgroundView atIndex:0];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navBar setBackgroundImage:[UIImage imageNamed:[KBCore styleForKeyPath:NAVBAR_BG]] forBarMetrics:UIBarMetricsDefault];
    }
    navBar.tintColor = [KBCore colorFromPalette:[KBCore styleForKeyPath:NAVBAR_TINT]];
}

#pragma mark - 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
