//
//  MADVector.m
//  HexGrid
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADVector.h"

@implementation MADVector
{
}

static BOOL vectorAngleIsCounterClockwise = NO;

+ (void)setAngleDirectionToCounterClockwise:(BOOL)counterClockwise;
{
    vectorAngleIsCounterClockwise = counterClockwise;
}

- (id)initAngle:(CGFloat)angleQ length:(CGFloat)lengthQ;
{
    if (!(self = [self init])) return nil;
    angle = angleQ;
    length = lengthQ;
    polarIsValid = YES;
    return self;
}
- (id)initX:(CGFloat)xx y:(CGFloat)yy;
{
    if (!(self = [self init])) return nil;
    x = xx;
    y = yy;
    rectangularIsValid = YES;
    return self;
}
- (id)initPointA:(CGPoint)point1 pointB:(CGPoint)point2;
{
    if (!(self = [self init])) return nil;
    x = point2.x - point1.x;
    y = point2.y - point1.y;
    rectangularIsValid = YES;
    return self;
}

- (CGPoint)applyToPoint:(CGPoint)point;
{
    [self makeRectangular];
    CGPoint pt = CGPointMake(point.x + x, point.y + y);
    return pt;
}



- (CGFloat)angle
{
    [self makePolar];
    return angle;
}
- (CGFloat)length
{
    [self makePolar];
    return length;
}
- (CGFloat)x
{
    [self makeRectangular];
    return x;
}
- (CGFloat)y
{
    [self makeRectangular];
    return y;
}



- (void)makePolar
{
    if (!polarIsValid) {
        if (!rectangularIsValid) {
            NSLog(@"MADVector ERROR: Can't rectangularToPolar - don't have rectangular values");
        } else {
            length = sqrtf(x*x + y*y);
            angle = atan2(y, x);
            if (vectorAngleIsCounterClockwise)
            {
                angle = -angle;
            }
            polarIsValid = YES;
        }
    }
}
- (void)makeRectangular
{
    if (!rectangularIsValid) {
        if (!polarIsValid) {
            NSLog(@"MADVector ERROR: Can't polarToRectangular - don't have polar values");
        } else {
            x = length * cos(angle);
            y = length * sin(angle);
            if (vectorAngleIsCounterClockwise)
            {
                y = -y;
            }
            rectangularIsValid = YES;
        }
    }
}


@end
