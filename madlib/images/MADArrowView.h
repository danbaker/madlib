//
//  MADArrowView.h
//  madlib
//
//  Created by Dan Baker on 11/6/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADArrowView : UIView

@property (nonatomic, retain) UIColor *fillColor;
- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt;

@end
