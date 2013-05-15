//
//  MADLines.m
//  HexGrid
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADLines.h"
#import "math.h"

@implementation MADLines


+ (CGFloat)positiveDegrees:(CGFloat)degrees;
{
    while (degrees >= 360) degrees -= 360;
    while (degrees < 0) degrees += 360;
    return degrees;
}
+ (CGFloat)degreesFromRads:(CGFloat)rads;
{
    return rads * 180 / M_PI;
}
+ (CGFloat)radsFromDegrees:(CGFloat)degrees;
{
    return degrees * M_PI / 180;
}

+ (CGFloat)angleInRadsOfLineBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB;
{
    CGFloat xDiff = pointB.x - pointA.x;
    CGFloat yDiff = pointB.y - pointA.y;
    return -atan2(yDiff, xDiff);
}


//public static double GetAngleOfLineBetweenTwoPoints(Point.Double p1, Point.Double p2)
//{
//    double xDiff = p2.x - p1.x;
//    double yDiff = p2.y - p1.y;
//    return Math.toDegrees(Math.atan2(yDiff, xDiff));
//}
@end
