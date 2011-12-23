//
//  KBTabBarCtrl.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/9/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBTabBarCtrl.h"

@implementation KBTabBarCtrl

- (void)setTabImages:(NSArray *)imageNames
{
    for (int i=0; i<[imageNames count]; i++) {
        UINavigationController *tabNavCtrl = [self.tabBarController.viewControllers objectAtIndex:i];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_active", [imageNames objectAtIndex:i]]];
        UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@", [imageNames objectAtIndex:i]]];
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        tabNavCtrl.tabBarItem = item;
    }
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
    
    UIImage* bgTabBar = [UIImage imageNamed:IMG_BG_TABBAR];
    [[UITabBar appearance] setBackgroundImage:bgTabBar];
    
    CGRect frame = self.tabBar.frame;
    frame.size.height = SIZE_TABBAR_HEIGHT;
    [[UITabBar appearance] setFrame:frame];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
