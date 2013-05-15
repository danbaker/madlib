//
//  QuadTile.m - See: http://wiki.openstreetmap.org/wiki/QuadTiles
//  madlib
//
//  Created by Dan Baker on 4/16/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "QuadTile.h"
#define MAX_SHAPES_PER_QUAD 3


@interface QuadTile ()
@property (nonatomic, retain) NSMutableArray *quads;    // Array<QuadTile> (or nil)
@property (nonatomic, retain) NSMutableSet *shapes;     // shapes IN this quad (or nil)
@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign, readonly) CGSize minimumQuadSize;
@end



@implementation QuadTile

- (id)initWithBounds:(CGRect)bounds minimumQuadSize:(CGSize)minimumQuadSize
{
    self = [super init];
    if (self)
    {
        _bounds = bounds;
        _minimumQuadSize = minimumQuadSize;
    }
    return self;
}

- (void)add:(id<QuadTileShape>)shape;
{
    // NOTE: IF there are NO child-quads in this quad, add this shape
    //       ELSE create 4 children and add the shape to the appropriate child
    if (![self hasChildQuads])
    {
        [self buildShapes];
        [self.shapes addObject:shape];
        if (self.shapes.count > MAX_SHAPES_PER_QUAD)
        {   // too many shapes in this quad ... break it up
            if (self.bounds.size.width > self.minimumQuadSize.width && self.bounds.size.height > self.minimumQuadSize.height)
            {   // Note: the size of this quad is larger than the minimum -- break into 4 sub-quads
                [self buildQuads];
                for(id<QuadTileShape> s in self.shapes)
                {
                    [self addToChildQuadShape:s];
                }
                self.shapes = nil;
            }
        }
    }
    else
    {
        [self addToChildQuadShape:shape];
    }
}

- (BOOL)hasChildQuads
{
    return self.quads != nil;
}
- (BOOL)thisQuadHasShapes
{
    return self.shapes != nil;
}

- (void)clear;
{
    _quads = nil;
}

- (NSSet*)findShapesWithPoint:(CGPoint)point;
{
    NSMutableSet *shapes = [[NSMutableSet alloc] init];
    if (CGRectContainsPoint(self.bounds, point))
    {   // point IS within this QuadTile ... check children
        if (!_quads)
        {   // If no children-quads, THEN check the shapes
            for(id<QuadTileShape> shape in self.shapes)
            {
                if (CGRectContainsPoint(shape.bounds, point))
                {   // point is within shape's bounding rectangle
                    BOOL addShape = YES;
                    if ([shape respondsToSelector:@selector(containsPoint:)])
                    {
                        if (![shape containsPoint:point])
                        {   // point is NOT within the actual shape
                            addShape = NO;
                        }
                    }
                    if (addShape)
                    {
                        [shapes addObject:shape];
                    }
                }
            }
            return shapes;
        }
        else
        {
            for(int i=0; i<4; i++)
            {
                QuadTile *qt = (QuadTile*)self.quads[i];
                if (qt)
                {
                    NSSet *shapesInQuad = [qt findShapesWithPoint:point];
                    if (shapesInQuad)
                    {
                        [shapes unionSet:shapesInQuad];
                    }
                }
            }
        }
        return shapes;
    }
    return nil; // point is not within this QuadTile
}

#pragma mark - Helpers

- (CGRect)boundsForQuadNumber:(int)n
{
    CGRect r;
    CGFloat w = self.bounds.size.width/2;
    CGFloat h = self.bounds.size.height/2;
    switch(n)
    {
        case 0: return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, w,h);
        case 1: return CGRectMake(self.bounds.origin.x+w, self.bounds.origin.y, w,h);
        case 2: return CGRectMake(self.bounds.origin.x, self.bounds.origin.y+h, w,h);
        case 3: return CGRectMake(self.bounds.origin.x+w, self.bounds.origin.y+h, w,h);
    }
    NSLog(@"Oops -- programmer error.  We only have 4 quads(0 to 3).  Passed in %i", n);
    return r;
}

- (void)buildQuads
{
    if (!_quads)
    {
        _quads = [[NSMutableArray alloc] initWithCapacity:4];
        for(int i=0; i<4; i++)
        {
            CGRect b = [self boundsForQuadNumber:i];
            QuadTile *qt = [[QuadTile alloc] initWithBounds:b minimumQuadSize:self.minimumQuadSize];     // one corner/quad
            _quads[i] = qt;
        }
    }
}

- (void)buildShapes
{
    if (!_shapes)
    {
        _shapes = [[NSMutableSet alloc] init];
    }
}

- (void)addToChildQuadShape:(id<QuadTileShape>)shape
{
    CGRect shapeBounds = shape.bounds;
    CGFloat left = shapeBounds.origin.x;
    CGFloat right = shapeBounds.origin.x + shapeBounds.size.width;
    CGFloat top = shapeBounds.origin.y;
    CGFloat bottom = shapeBounds.origin.y + shapeBounds.size.height;
    for(int i=0; i<4; i++)
    {
        CGRect r = [self boundsForQuadNumber:i];
        if (CGRectContainsPoint(r, shapeBounds.origin) ||
            CGRectContainsPoint(r, CGPointMake(left,bottom)) ||
            CGRectContainsPoint(r, CGPointMake(right,top)) ||
            CGRectContainsPoint(r, CGPointMake(right,bottom)) ||
            CGRectContainsPoint(r, CGPointMake((right+left)/2, (top+bottom)/2)))
        {   // Note: some of shape exists in quad#i
            QuadTile *qt = self.quads[i];
            [qt add:shape];
        }
    }
}

#pragma mark - Test Helpers

- (NSInteger)calcDepthAtPoint:(CGPoint)point
{
    NSInteger depth = 0;
    if (self.hasChildQuads)
    {
        depth++;
        for(int i=0; i<4; i++)
        {
            QuadTile *qt = (QuadTile*)self.quads[i];
            if (qt)
            {
                if (CGRectContainsPoint(qt.bounds, point))
                {
                    depth += [qt calcDepthAtPoint:point];
                    break;
                }
            }
        }
    }
    return depth;
}

@end
