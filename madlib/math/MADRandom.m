//
//  MADRandom.m
//  HexGrid
//
//  Created by Dan Baker on 11/24/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADRandom.h"

@implementation MADRandom

+ (NSInteger)randomIntegerMin:(NSInteger)lo max:(NSInteger)hi;
{
    return (arc4random() % (hi-lo+1)) + lo;
}
+ (double)randomDoubleBetween0and1;
{
    return ((double)arc4random() / ULONG_MAX);
}
+(float)randomFloatBetween0and1;
{
    return [MADRandom randomDoubleBetween0and1];
}

@end
