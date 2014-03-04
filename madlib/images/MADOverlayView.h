//
//  MADOverlayView.h
//  madlib
//      Use the property "baseView" to add all children to (it rotates and resizes)
//      Setup the property "actionWhenViewChangesSize" to get notified of size changes
//
//  Created by Dan Baker on 3/4/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADOverlayView : UIView
@property (nonatomic, retain, readonly) UIView *baseView;

- (id)initOnWindow:(UIWindow*)window;

- (void)viewChangedSize;

@end
