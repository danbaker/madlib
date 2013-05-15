//
//  MADMutableVector.m
//  HexGrid
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADMutableVector.h"

@implementation MADMutableVector

- (void)setPoint:(CGPoint)point;
{
}
- (void)setX:(CGFloat)xQ
{
    [self makeRectangular];
    x = xQ;
    polarIsValid = NO;
}
- (void)setY:(CGFloat)yQ
{
    [self makeRectangular];
    y = yQ;
    polarIsValid = NO;
}
- (void)setAngle:(CGFloat)angleQ
{
    [self makePolar];
    angle = angleQ;
    rectangularIsValid = NO;
}
- (void)setLength:(CGFloat)lengthQ
{
    [self makePolar];
    length = lengthQ;
    rectangularIsValid = NO;
}

@end
