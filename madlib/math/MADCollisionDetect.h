//
//  MADCollisionDetect.h
//  HexGrid
//
//  Created by Dan Baker on 11/8/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADCollisionDetect : NSObject

+(CGFloat)distSquaredFromPoint:(CGPoint)point1 point:(CGPoint)point2;

+(bool)detectCollisionCircleAt:(CGPoint)point1 radius:(CGFloat)radius1 circleAt:(CGPoint)point2 radius:(CGFloat)radius2;
+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius lineStart:(CGPoint)point1 lineEnd:(CGPoint)point2;
+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius trianglePoint1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3;

@end
