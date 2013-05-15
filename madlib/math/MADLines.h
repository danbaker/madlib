//
//  MADLines.h
//  HexGrid
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADLines : NSObject

+ (CGFloat)positiveDegrees:(CGFloat)degrees;
+ (CGFloat)degreesFromRads:(CGFloat)rads;
+ (CGFloat)radsFromDegrees:(CGFloat)degrees;
+ (CGFloat)angleInRadsOfLineBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB;

@end
