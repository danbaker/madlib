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
@end

enum arrowDirection {
    downRight = 0,
    downLeft = 1,
    upRight = 2,
    upLeft = 3
};


@implementation MADArrowView

- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt
{
    CGFloat margin = 6;
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
    
    NSLog(@"ArrowView dir:%i  (%1.1f,%1.1f) to (%1.1f,%1.1f)  size:(%1.1f,%1.1f)", self.direction, toPnt.x,toPnt.y, fromPnt.x,fromPnt.y, w,h);
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor blueColor];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint startPnt = self.fromPoint;
    CGPoint endPnt = self.toPoint;
//    CGFloat w = rect.size.width;
//    CGFloat h = rect.size.height;
//    switch (self.direction)
//    {
//        case downRight:
//            startPnt = CGPointMake(0,0);
//            endPnt = CGPointMake(w,h);
//            break;
//        case downLeft:
//            startPnt = CGPointMake(w,0);
//            endPnt = CGPointMake(0,h);
//            break;
//        case upRight:
//            startPnt = CGPointMake(0,h);
//            endPnt = CGPointMake(w,0);
//            break;
//        case upLeft:
//            startPnt = CGPointMake(w,h);
//            endPnt = CGPointMake(0,0);
//            break;
//    }
    UIBezierPath *arrowPath = [MADArrow MADBezierPathWithArrowFromPoint:startPnt toPoint:endPnt tailWidth:5 headWidth:11 headLength:20];
    [self.fillColor setFill];
    [arrowPath fill];
}

@end
