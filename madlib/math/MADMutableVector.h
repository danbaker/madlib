//
//  MADMutableVector.h
//  HexGrid
//
//  Created by Dan Baker on 11/10/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADVector.h"

@interface MADMutableVector : MADVector

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setAngle:(CGFloat)angle;
- (void)setLength:(CGFloat)length;

@end
