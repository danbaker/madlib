//
//  MADAppDelegateHelper.m
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADAppDelegateHelper.h"
#import "MADBannerViewController.h"

@implementation MADAppDelegateHelper

- (void)buildMainWindowWithAdsUsingViewController:(UIViewController*)startViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    [self.navController setNavigationBarHidden:YES animated:NO];
	
	MADBannerViewController *bannerViewController = [[MADBannerViewController alloc] initWithContentViewController:self.navController];
	
    self.window.rootViewController = bannerViewController;
	
    [self.window makeKeyAndVisible];
}

@end
