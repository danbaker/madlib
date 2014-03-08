//
//  MADCollisionDetect.h
//  HexGrid
//
//  Created by Dan Baker on 11/8/12.
//  Copyright (c) 2012 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADCollisionDetect : NSObject

+(CGFloat)distSquaredFromPoint:(CGPoint)point1 point:(CGPoint)point2;

+(bool)detectCollisionCircleAt:(CGPoint)point1 radius:(CGFloat)radius1 circleAt:(CGPoint)point2 radius:(CGFloat)radius2;
+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius lineStart:(CGPoint)point1 lineEnd:(CGPoint)point2;

// NOTE: The triangle points must be in clockwise order
+(bool)detectCollisionCircleAt:(CGPoint)circle radius:(CGFloat)radius trianglePoint1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3;
+(bool)detectCollisionPointAt:(CGPoint)p trianglePoint1:(CGPoint)p0 point2:(CGPoint)p1 point3:(CGPoint)p2;

+ (BOOL) detectCollisionLineAFromPoint1:(CGPoint)p1 toPoint2:(CGPoint)p2 withLineBFromPoint3:(CGPoint)p3 toPoint4:(CGPoint)p4 returnCollision:(CGPoint*)pPoint;

@end
