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
@synthesize loadingIndicator = _loadingIndicator;
@synthesize alert = _alert;

+ (KBView *)shared
{
    KBView *instance;
    if (instance == nil) {
        instance = [[KBView alloc] init];
        instance.alert = [[NSMutableDictionary alloc] init];
    }
    return instance;
}

- (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
	[alertView show];
}

- (void)showAlert:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle
{
    [self showAlert:title message:message cancelTitle:okTitle okTitle:nil];
}

- (void)showErrorAlert:(NSString *)message
{
    [self showAlert:@"Error" message:message cancelTitle:@"OK" okTitle:nil];
}

- (void)showLoading:(UIViewController *)viewCtrl withText:(NSString *)text
{
    [self.navigationController.view addSubview:_loadingIndicator];
    _loadingIndicator.loadingText = text;
    [_loadingIndicator showLoading:YES];
}

- (void)hideLoading:(UIViewController *)viewCtrl
{
    [_loadingIndicator removeFromSuperview];
}

- (void)setAlertMessage:(NSString *)message ofType:(NSString *)type {
    NSMutableDictionary *alert = [[KBView shared] alert];
    [alert setObject:message forKey:@"message"];
    [alert setObject:type forKey:@"type"];
}

- (void)clearAlertMessage {
    NSMutableDictionary *alert = [[KBView shared] alert];
    [alert removeAllObjects];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_loadingIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self setDefaultStyles];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(interfaceOrientation == UIDeviceOrientationPortrait){
        //        NSLog(@"KBTableView-UIDeviceOrientationPortrait");    
        return YES;
    }
    //if(interfaceOrientation == UIDeviceOrientationLandscapeRight) return YES;
    return NO;
}

@end
