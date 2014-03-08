//
//  MADPainter.h
//  madlib
//
//  Created by Dan Baker on 3/8/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADPainter : NSObject

+ (void) onContext:(CGContextRef)ctx paintXAt:(CGPoint)center radius:(CGFloat)radius;
+ (void) onContext:(CGContextRef)ctx paintCircleAt:(CGPoint)center radius:(CGFloat)radius;

@end
