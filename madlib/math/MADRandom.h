//
//  MADRandom.h
//  HexGrid
//
//  Created by Dan Baker on 11/24/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MADRandom : NSObject

+ (NSInteger)randomIntegerMin:(NSInteger)lo max:(NSInteger)hi;
+ (double)randomDoubleBetween0and1;
+ (CGFloat)randomFloatBetween0and1;

@end
