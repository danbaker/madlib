//
//  MADPainter.m
//  madlib
//
//  Created by Dan Baker on 3/8/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADPainter.h"

@implementation MADPainter


+ (void) onContext:(CGContextRef)ctx paintXAt:(CGPoint)center radius:(CGFloat)radius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x-radius,center.y-radius);
    CGPathAddLineToPoint(path, NULL, center.x+radius,center.y+radius);
    CGPathMoveToPoint(path, NULL, center.x-radius,center.y+radius);
    CGPathAddLineToPoint(path, NULL, center.x+radius,center.y-radius);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}

+ (void) onContext:(CGContextRef)ctx paintCircleAt:(CGPoint)center radius:(CGFloat)radius
{
    CGContextAddArc(ctx,center.x,center.y,radius,0.0,M_PI*2,YES);
    CGContextStrokePath(ctx);
}


@end
