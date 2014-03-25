//
//  UIScreen+MAD.h
//  madlib
//
//  Created by Dan Baker on 6/6/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (MAD)

+ (CGRect)boundsForCurrentOrientation;
+ (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;
+ (UIInterfaceOrientation)deviceOrientation;
+ (CGFloat)statusBarHeight;

+ (void)addToWindowTheView:(UIView*)view;

@end
