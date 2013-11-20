//
//  MADArrowView.m
//  madlib
//
//  Created by Dan Baker on 11/6/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "MADArrowView.h"
#import "MADArrow.h"


@interface MADArrowView ()
@property (nonatomic, assign) enum arrowDirection direction;
@property (nonatomic, assign) CGPoint fromPoint;
@property (nonatomic, assign) CGPoint toPoint;
@property (nonatomic, assign) CGFloat tailWidth;
@property (nonatomic, assign) CGFloat headWidth;
@property (nonatomic, assign) CGFloat headLength;
@end

enum arrowDirection {
    downRight = 0,
    downLeft = 1,
    upRight = 2,
    upLeft = 3
};


@implementation MADArrowView

- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt;
{
    return [self initFromPoint:fromPnt toPoint:toPnt tailWidth:7 headWidth:11 headLength:20];
}

- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt tailWidth:(CGFloat)tailWidth headWidth:(CGFloat)headWidth headLength:(CGFloat)headLength
{
    CGFloat margin = (int)(headWidth / 2 + 0.99);
    self = [self initFromPoint:fromPnt toPoint:toPnt margin:margin];
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor blueColor];
    self.headLength = headLength;
    self.headWidth = headWidth;
    self.tailWidth = tailWidth;
//    {
//        __weak MADArrowView *weakSelf = self;
//        self.drawRectBlock = ^void(CGRect rect) {
//            UIBezierPath *arrowPath = [MADArrow MADBezierPathWithArrowFromPoint:weakSelf.fromPoint toPoint:weakSelf.toPoint tailWidth:weakSelf.tailWidth headWidth:weakSelf.headWidth headLength:weakSelf.headLength];
//            [weakSelf.fillColor setFill];
//            [arrowPath fill];
//        };
//    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrowPath = [MADArrow MADBezierPathWithArrowFromPoint:self.fromPoint toPoint:self.toPoint tailWidth:self.tailWidth headWidth:self.headWidth headLength:self.headLength];
    [self.fillColor setFill];
    [arrowPath fill];
}

@end
