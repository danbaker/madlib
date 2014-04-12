//
//  MADAppDelegateHelper.h
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADAppDelegateHelper : NSObject

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, assign) BOOL adPlacedAtTop;
@property (nonatomic, assign) BOOL keepAdRectangleReserved;


- (void)buildMainWindowWithAdsUsingViewController:(UIViewController*)startViewController;

@end
