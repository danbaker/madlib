//
//  MADBannerViewController.m
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADBannerViewController.h"

NSString * const MADBannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const MADBannerViewActionDidFinish = @"BannerViewActionDidFinish";

@interface MADBannerViewController ()  <ADBannerViewDelegate>
@property (nonatomic, retain) UIView *statusBarBackgroundView;
@end

@implementation MADBannerViewController{
    ADBannerView *_bannerView;
    UIViewController *_contentController;
}

- (instancetype)initWithContentViewController:(UIViewController *)contentController
{
    // If contentController is nil, -loadView is going to throw an exception when it attempts to setup
    // containment of a nil view controller.  Instead, throw the exception here and make it obvious
    // what is wrong.
    NSAssert(contentController != nil, @"Attempting to initialize a MADBannerViewController with a nil contentController.");
    
    self = [super init];
    if (self != nil) {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        } else {
            _bannerView = [[ADBannerView alloc] init];
        }
        _contentController = contentController;
        _bannerView.delegate = self;
    }
    return self;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [contentView addSubview:_bannerView];
    
    // Setup containment of the _contentController.
    [self addChildViewController:_contentController];
    [contentView addSubview:_contentController.view];
    [_contentController didMoveToParentViewController:self];

    // Create a background view for the status bar (used when the ad is at the top)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        CGRect fr = CGRectMake(0,0,1024,20);
        self.statusBarBackgroundView = [[UIView alloc] initWithFrame:fr];
        self.statusBarBackgroundView.backgroundColor = self.adPlacedAtTop? [UIColor whiteColor] : [UIColor clearColor];
        [contentView addSubview:self.statusBarBackgroundView];
    }

    self.view = contentView;
}

- (void)setAdPlacedAtTop:(BOOL)adPlacedAtTop
{
    _adPlacedAtTop = adPlacedAtTop;
    self.statusBarBackgroundView.backgroundColor = adPlacedAtTop? [UIColor whiteColor] : [UIColor clearColor];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)setKeepAdRectangleReserved:(BOOL)keepAdRectangleReserved
{
    _keepAdRectangleReserved = keepAdRectangleReserved;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [_contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [_contentController preferredInterfaceOrientationForPresentation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [_contentController supportedInterfaceOrientations];
}

- (void)viewDidLayoutSubviews
{
    // This method will be called whenever we receive a delegate callback
    // from the banner view.
    // (See the comments in -bannerViewDidLoadAd: and -bannerView:didFailToReceiveAdWithError:)
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = CGRectZero;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    // If configured to support iOS <6.0, then we need to set the currentContentSizeIdentifier in order to resize the banner properly.
    // This continues to work on iOS 6.0, so we won't need to do anything further to resize the banner.
    if (contentFrame.size.width < contentFrame.size.height) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    bannerFrame = _bannerView.frame;
#else
    // If configured to support iOS >= 6.0 only, then we want to avoid currentContentSizeIdentifier as it is deprecated.
    // Fortunately all we need to do is ask the banner for a size that fits into the layout area we are using.
    // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
    bannerFrame.size = [_bannerView sizeThatFits:contentFrame.size];
#endif
    
    // Check if the banner has an ad loaded and ready for display.  Move the banner off
    // screen if it does not have an ad.
    CGFloat bannerHeight = bannerFrame.size.height;
    if (_bannerView.bannerLoaded || self.keepAdRectangleReserved) {
        if (self.adPlacedAtTop) {
            CGFloat statusBarHeight = [UIScreen statusBarHeight];
            bannerFrame.origin.y = statusBarHeight;
            contentFrame.origin.y += bannerHeight + statusBarHeight;
            contentFrame.size.height -= bannerHeight + statusBarHeight;
        } else {
            contentFrame.size.height -= bannerHeight;
            bannerFrame.origin.y = contentFrame.size.height;
        }
    } else {
        if (self.adPlacedAtTop) {
            bannerFrame.origin.y = -bannerHeight;
        } else {
            bannerFrame.origin.y = contentFrame.size.height;
        }
    }
    _contentController.view.frame = contentFrame;
    _bannerView.frame = bannerFrame;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView animateWithDuration:0.25 animations:^{
        // -viewDidLayoutSubviews will handle positioning the banner such that it is either visible
        // or hidden depending upon whether its bannerLoaded property is YES or NO (It will be
        // YES if -bannerViewDidLoadAd: was last called).  We just need our view
        // to (re)lay itself out so -viewDidLayoutSubviews will be called.
        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
        // as requiring layout...
        [self.view setNeedsLayout];
        // ...then ask it to lay itself out immediately if it is flagged as requiring layout...
        [self.view layoutIfNeeded];
        // ...which has the same effect.
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView animateWithDuration:0.25 animations:^{
        // -viewDidLayoutSubviews will handle positioning the banner such that it is either visible
        // or hidden depending upon whether its bannerLoaded property is YES or NO (It will be
        // NO if -bannerView:didFailToReceiveAdWithError: was last called).  We just need our view
        // to (re)lay itself out so -viewDidLayoutSubviews will be called.
        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
        // as requiring layout...
        [self.view setNeedsLayout];
        // ...then ask it to lay itself out immediately if it is flagged as requiring layout...
        [self.view layoutIfNeeded];
        // ...which has the same effect.
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MADBannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MADBannerViewActionDidFinish object:self];
}

@end
