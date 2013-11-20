//
//  MADDirectionView.h
//  madlib
//
//  Created by Dan Baker on 11/20/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADDirectionView : UIView

@property (nonatomic, copy) void (^drawRectBlock)(CGRect rect);

- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt;
- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt margin:(CGFloat)margin;

@end
