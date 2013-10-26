//
//  UIColor+MAD.h
//  madlib
//
//  Created by Dan Baker on 4/12/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MAD)

+ (UIColor *)randomColor;

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor
                               secondColor:(UIColor *)secondColor
                                   atRatio:(CGFloat)ratio;

@end
