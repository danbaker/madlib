//
//  UIScreen+MAD.m
//  madlib
//
//  Created by Dan Baker on 6/6/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "UIScreen+MAD.h"

@implementation UIScreen (MAD)

// get the bounds for the current screen in the current orientation
// takes status bar and rotation into account
+ (CGRect)boundsForCurrentOrientation
{
    return [self boundsForOrientation:[self deviceOrientation]];
}

// get the bounds for the current screen in a specific orientation
+ (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect fullScreenRect = CGRectZero;
    fullScreenRect.size = [[UIScreen mainScreen] applicationFrame].size;
    
    // Note: rect is implicitly in Portrait orientation
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
    {   // swap size in landscape orientations
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    return fullScreenRect;
}

// get the current device orientation
+ (UIInterfaceOrientation)deviceOrientation
{
    return UIApplication.sharedApplication.statusBarOrientation;
}

@end
