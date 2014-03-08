//
//  MADCircle.m
//  madlib
//
//  Created by Dan Baker on 3/8/14.
//  Copyright (c) 2014 BakerCrew. All rights reserved.
//

#import "MADCircle.h"

@implementation MADCircle


// http://stackoverflow.com/questions/4103405/what-is-the-algorithm-for-finding-the-center-of-a-circle-from-three-points
// http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2#line_line_intersection

+ (CGPoint) circleFromPoint1:(CGPoint)A point2:(CGPoint)B point2:(CGPoint)C returnRadius:(CGFloat*)pRadius
{
//    float yDelta_a = B.y - A.y;
//    float xDelta_a = B.x - A.x;
//    float yDelta_b = C.y - B.y;
//    float xDelta_b = C.x - B.x;
//    CGPoint center = CGPointZero;
//    
//    float aSlope = yDelta_a/xDelta_a;
//    float bSlope = yDelta_b/xDelta_b;
//    center.x = (aSlope*bSlope*(A.y - C.y) + bSlope*(A.x + B.x)
//                - aSlope*(B.x+C.x) )/(2* (bSlope-aSlope) );
//    center.y = -1*(center.x - (A.x+B.x)/2)/aSlope +  (A.y+B.y)/2;
//    
//    return center;
    
    CGFloat yDelta_a = B.y - A.y;
    CGFloat xDelta_a = B.x - A.x;
    CGFloat yDelta_b = C.y - B.y;
    CGFloat xDelta_b = C.x - B.x;
    CGPoint center = CGPointZero;
    
    CGFloat aSlope;
    if (xDelta_a) aSlope = yDelta_a/xDelta_a;
    CGFloat bSlope;
    if (xDelta_b) bSlope = yDelta_b/xDelta_b;
    
    CGPoint AB_Mid = CGPointMake((A.x+B.x)/2, (A.y+B.y)/2);
    CGPoint BC_Mid = CGPointMake((B.x+C.x)/2, (B.y+C.y)/2);
    
    if(yDelta_a == 0)         //aSlope == 0
    {
        center.x = AB_Mid.x;
        if (xDelta_b == 0)         //bSlope == INFINITY
        {
            center.y = BC_Mid.y;
        }
        else
        {
            center.y = BC_Mid.y + (BC_Mid.x-center.x)/bSlope;
        }
    }
    else if (yDelta_b == 0)               //bSlope == 0
    {
        center.x = BC_Mid.x;
        if (xDelta_a == 0)             //aSlope == INFINITY
        {
            center.y = AB_Mid.y;
        }
        else
        {
            center.y = AB_Mid.y + (AB_Mid.x-center.x)/aSlope;
        }
    }
    else if (xDelta_a == 0)        //aSlope == INFINITY
    {
        center.y = AB_Mid.y;
        center.x = bSlope*(BC_Mid.y-center.y) + BC_Mid.x;
    }
    else if (xDelta_b == 0)        //bSlope == INFINITY
    {
        center.y = BC_Mid.y;
        center.x = aSlope*(AB_Mid.y-center.y) + AB_Mid.x;
    }
    else
    {
        center.x = (aSlope*bSlope*(AB_Mid.y-BC_Mid.y) - aSlope*BC_Mid.x + bSlope*AB_Mid.x)/(bSlope-aSlope);
        center.y = AB_Mid.y - (center.x - AB_Mid.x)/aSlope;
    }
    
    if (pRadius)
    {
        CGFloat a = center.x - A.x;
        CGFloat b = center.y - A.y;
        *pRadius = sqrtf(a*a + b*b);
    }
    
    return center;
}

@end
