//
//  MADDirectionView.m
//  madlib
//
//  Created by Dan Baker on 11/20/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "MADDirectionView.h"




@interface MADDirectionView ()
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

@implementation MADDirectionView


- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt;
{
    return [self initFromPoint:fromPnt toPoint:toPnt margin:5];
}

- (id)initFromPoint:(CGPoint)fromPnt toPoint:(CGPoint)toPnt margin:(CGFloat)margin
{
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
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.drawRectBlock)
    {
        self.drawRectBlock(rect);
    }
}

- (void)dealloc
{
    self.drawRectBlock = nil;
}

@end
