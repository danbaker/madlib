//
//  MADOverlayView.m
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADOverlayView.h"
#import "UIScreen+MAD.h"
#import "NSObject+MAD.h"



@interface MADOverlayView ()
@property (nonatomic, retain) UIView *stationaryView;   // resizes during rotation events.  child of window
                                                        // self is-a child of stationaryView
@end


@implementation MADOverlayView

- (id)initWithWindow:(UIWindow*)window
{
    CGRect frame = [UIScreen boundsForOrientation:UIInterfaceOrientationPortrait];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.stationaryView = [[UIView alloc] initWithFrame:frame];
        self.stationaryView.backgroundColor = [UIColor clearColor];
        [window addSubview:self.stationaryView];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

        [self.stationaryView addSubview:self];
        // Note: brief delay to allow for the window size to be correct (else in iOS6 the window isn't tall enough)
        [self performBlock:^{
            [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
        } afterDelay:0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];                // remove self from stationaryView
    [self.stationaryView removeFromSuperview];  // remove stationaryView from the Window
}

#pragma mark Rotation Handling

- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = [MADOverlayView UIInterfaceOrientationAngleOfOrientation:statusBarOrientation];
    CGFloat statusBarHeight = [MADOverlayView getStatusBarHeight];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
    
    [self setIfNotEqualTransform:transform frame:frame];
    
    frame = self.stationaryView.frame;
    switch (statusBarOrientation)
    {
        default:
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            CGRect t = frame;
            t.size.height = frame.size.width;
            t.size.width = frame.size.height;
            frame = t;
        }
        break;
    }
    frame.origin = CGPointZero;
    self.frame = frame;
    [self viewChangedSize];
}

- (void)viewChangedSize
{
    NSLog(@"Programmer should overload MADOverlayView.viewChangedSize -- or just watch when their frame changes size");
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    if(!CGAffineTransformEqualToTransform(self.stationaryView.transform, transform))
    {
        self.stationaryView.transform = transform;
    }
    if(!CGRectEqualToRect(self.stationaryView.frame, frame))
    {
        self.stationaryView.frame = frame;
    }
}

+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{
    CGRect frame = windowBounds;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //  iOS 6.1 or earlier
        frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
        frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
        frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
        frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    } else {
        //  iOS 7 or later
    }
    return frame;
}

+ (CGFloat) UIInterfaceOrientationAngleOfOrientation:(UIInterfaceOrientation) orientation
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}

@end
