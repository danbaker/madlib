//
//  MADBannerViewController.h
//  madlib
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

extern NSString * const MADBannerViewActionWillBegin;
extern NSString * const MADBannerViewActionDidFinish;


@interface MADBannerViewController : UIViewController

@property (nonatomic, assign) BOOL adPlacedAtTop;   // YES means: place the ad view at the top

- (instancetype)initWithContentViewController:(UIViewController *)contentController;

@end
