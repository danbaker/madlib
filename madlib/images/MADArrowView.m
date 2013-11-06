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
    self.fromPoint = fromPnt;
    self.toPoint = toPnt;
    
    CGFloat w = fabsf(fromPnt.x - toPnt.x);
    CGFloat h = fabsf(fromPnt.y - toPnt.y);
    CGRect frame = CGRectMake(fromPnt.x-margin, fromPnt.y-margin, w+margin*2,h+margin*2);
    if (fromPnt.x <= toPnt.x)
    {   // from is LEFT-OF to
        if (fromPnt.y > toPnt.y)
        {
            self.direction = upRight;
            frame.origin.y -= h;
            self.fromPoint = CGPointMake(margin,h+margin);
            self.toPoint = CGPointMake(w+margin,margin);
        }
        else
        {
            self.direction = downRight;
            self.fromPoint = CGPointMake(margin,margin);
            self.toPoint = CGPointMake(w+margin,h+margin);
        }
    }
    else
    {   // from is RIGHT-OF to
        frame.origin.x -= w;
        if (fromPnt.y > toPnt.y)
        {
            self.direction = upLeft;
            frame.origin.y -= h;
            self.fromPoint = CGPointMake(w+margin,h+margin);
            self.toPoint = CGPointMake(margin,margin);
        }
        else
        {
            self.direction = downLeft;
            self.fromPoint = CGPointMake(w+margin,margin);
            self.toPoint = CGPointMake(margin,h+margin);
        }
    }
    
    //NSLog(@"ArrowView dir:%i  (%1.1f,%1.1f) to (%1.1f,%1.1f)  size:(%1.1f,%1.1f)", self.direction, toPnt.x,toPnt.y, fromPnt.x,fromPnt.y, w,h);
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor blueColor];
    self.headLength = headLength;
    self.headWidth = headWidth;
    self.tailWidth = tailWidth;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrowPath = [MADArrow MADBezierPathWithArrowFromPoint:self.fromPoint toPoint:self.toPoint tailWidth:self.tailWidth headWidth:self.headWidth headLength:self.headLength];
    [self.fillColor setFill];
    [arrowPath fill];
}

@end
