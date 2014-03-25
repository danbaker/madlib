//
//  MADAppDelegateHelper.m
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADAppDelegateHelper.h"
#import "MADBannerViewController.h"

@interface MADAppDelegateHelper()
@property (nonatomic, weak) MADBannerViewController *bannerViewController;
@end


@implementation MADAppDelegateHelper

- (void)buildMainWindowWithAdsUsingViewController:(UIViewController*)startViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    [self.navController setNavigationBarHidden:YES animated:NO];
	
	MADBannerViewController * bannerViewController = [[MADBannerViewController alloc] initWithContentViewController:self.navController];
    bannerViewController.adPlacedAtTop = self.adPlacedAtTop;
    self.window.rootViewController = bannerViewController;
    self.bannerViewController = bannerViewController;
	
    [self.window makeKeyAndVisible];
}

- (void)setAdPlacedAtTop:(BOOL)adPlacedAtTop
{
    _adPlacedAtTop = adPlacedAtTop;
    self.bannerViewController.adPlacedAtTop = adPlacedAtTop;
}

@end
