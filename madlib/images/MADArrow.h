//
//  MADArrow.h
//  madlib
//
//  Created by Dan Baker on 11/5/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MADArrow : NSObject


+ (UIBezierPath *) MADBezierPathWithArrowFromPoint:(CGPoint)startPoint
                                           toPoint:(CGPoint)endPoint
                                         tailWidth:(CGFloat)tailWidth
                                         headWidth:(CGFloat)headWidth
                                        headLength:(CGFloat)headLength;

@end
