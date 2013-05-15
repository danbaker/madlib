//
//  MADVector.h
//  See: http://en.wikipedia.org/wiki/Vector_notation
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADVector : NSObject
{
    @protected
    // RETANGULAR
    bool rectangularIsValid;
    CGFloat x;
    CGFloat y;
    // POLAR
    bool polarIsValid;
    CGFloat angle;
    CGFloat length;
}

- (id)initAngle:(CGFloat)angle length:(CGFloat)length;
- (id)initX:(CGFloat)x y:(CGFloat)y;
- (id)initPointA:(CGPoint)point1 pointB:(CGPoint)point2;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)angle;
- (CGFloat)length;

- (CGPoint)applyToPoint:(CGPoint)point;

// protected helpers
- (void)makePolar;
- (void)makeRectangular;


@end
