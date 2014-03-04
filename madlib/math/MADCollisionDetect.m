//
//  MADCollisionDetect.m
//  HexGrid
//
//  Created by Dan Baker on 11/8/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADCollisionDetect.h"

@implementation MADCollisionDetect

+(bool)detectCollisionCircleAt:(CGPoint)point1 radius:(CGFloat)radius1 circleAt:(CGPoint)point2 radius:(CGFloat)radius2;
{   // check if two circles are touching (colliding)
    CGFloat distanceX = point1.x - point2.x;
    CGFloat distanceY = point1.y - point2.y;
    CGFloat distanceSquared = distanceX*distanceX + distanceY*distanceY;
    CGFloat radiusSquared = (radius1+radius2)*(radius1+radius2);
    return distanceSquared <= radiusSquared;
}

+(CGFloat)distSquaredFromX:(CGFloat)x1 Y:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2;
{
    CGFloat distanceX = x1 - x2;
    CGFloat distanceY = y1 - y2;
    return (distanceX*distanceX) + distanceY*distanceY;
}
+(CGFloat)distSquaredFromPoint:(CGPoint)point1 point:(CGPoint)point2;
{
    CGFloat distanceX = point1.x - point2.x;
    CGFloat distanceY = point1.y - point2.y;
    return (distanceX*distanceX) + distanceY*distanceY;
}

+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius lineStart:(CGPoint)point1 lineEnd:(CGPoint)point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    CGFloat a = dx * dx + dy * dy;
    CGFloat b = 2 * (dx * (point1.x - circle.x) + dy * (point1.y - circle.y));
    CGFloat c = circle.x * circle.x + circle.y * circle.y;
    c += point1.x * point1.x + point1.y * point1.y;
    c -= 2 * (circle.x * point1.x + circle.y * point1.y);
    c -= radius * radius;
    CGFloat bb4ac = b * b - 4 * a * c;
    if (bb4ac < 0) {  // Not intersecting
        return false;
    }
    
    CGFloat mu = (-b + sqrt( b*b - 4*a*c )) / (2*a);
    CGFloat ix1 = point1.x + mu*(dx);
    CGFloat iy1 = point1.y + mu*(dy);
    mu = (-b - sqrt(b*b - 4*a*c )) / (2*a);
    CGFloat ix2 = point1.x + mu*(dx);
    CGFloat iy2 = point1.y + mu*(dy);
    // Figure out which point is closer to the circle
    CGPoint test;
    if ([MADCollisionDetect distSquaredFromPoint:point1 point:circle] < [MADCollisionDetect distSquaredFromPoint:point2 point:circle]) {
        test = point2;
    } else {
        test = point1;
    }
    CGFloat distTestTo1 = [MADCollisionDetect distSquaredFromX:test.x Y:test.y X2:ix1 Y2:iy1];
    CGFloat dist1To2 = [MADCollisionDetect distSquaredFromPoint:point1 point:point2];
    CGFloat distTestTo2 = [MADCollisionDetect distSquaredFromX:test.x Y:test.y X2:ix2 Y2:iy2];
    if (distTestTo1 < dist1To2 || distTestTo2 < dist1To2) {
        return true;
    } else {
        return false;
    }
}

// assume the four rectangle points are either clockwise or counter-clockwise specified (point1 and point3 are opposite corners)
+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius rectanglePoint1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3 point4:(CGPoint)point4;
{
    // @TODO: check if point(circle) is contained WITHIN rectangle (return true)
    if ([MADCollisionDetect detectCollisionCircleAt:circle radius:radius lineStart:point1 lineEnd:point2]) return YES;
    if ([MADCollisionDetect detectCollisionCircleAt:circle radius:radius lineStart:point2 lineEnd:point3]) return YES;
    if ([MADCollisionDetect detectCollisionCircleAt:circle radius:radius lineStart:point3 lineEnd:point4]) return YES;
    if ([MADCollisionDetect detectCollisionCircleAt:circle radius:radius lineStart:point4 lineEnd:point1]) return YES;
    return NO;
}


+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius trianglePoint1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3;
{
    CGFloat radiusSquared = radius * radius;
    // Test 1: is any vertex in the circle (also covers the case of the entire triangle being within the circle)
    if ([self distSquaredFromPoint:circle point:point1] <= radiusSquared) return YES;
    if ([self distSquaredFromPoint:circle point:point2] <= radiusSquared) return YES;
    if ([self distSquaredFromPoint:circle point:point3] <= radiusSquared) return YES;
    // Test 2: is the circle center within the triangle
    
    // Test 3: does circle intersect any edge
    return NO;
}

+ (bool)detectCollisionPointAt:(CGPoint)p trianglePoint1:(CGPoint)p0 point2:(CGPoint)p1 point3:(CGPoint)p2;
{
    CGFloat s = p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y;
    CGFloat t = p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y;
    
    if ((s < 0) != (t < 0))
        return NO;
    
    CGFloat A = -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y;
    if (A < 0.0)
    {
        s = -s;
        t = -t;
        A = -A;
    }
    return s > 0 && t > 0 && (s + t) < A;
}

@end
