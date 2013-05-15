//
//  QuadTileTests.m
//  planetmaker
//
//  Created by Dan Baker on 4/17/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "QuadTileTests.h"
#import "QuadTile.h"


@interface QuadTile ()
- (NSInteger)calcDepthAtPoint:(CGPoint)point;
@end

@interface TSTQuadShape : NSObject <QuadTileShape>
@property (nonatomic, assign) CGRect r;
@end
@implementation TSTQuadShape
- (CGRect)bounds
{
    return self.r;
}
@end



@interface QuadTileTests ()
@property (nonatomic, retain) NSMutableArray *shapes;      // Array<TSTQuadShape>
@property (nonatomic, retain) QuadTile *qt;
@end

@implementation QuadTileTests

- (void)setUp
{
    [super setUp];
    self.shapes = [NSMutableArray new];
    for(int i=0; i<100; i++)
    {
        TSTQuadShape *shape = [TSTQuadShape new];
        shape.r = CGRectMake(i,i, 10,10);
        [self.shapes addObject:shape];
    }
    
    CGRect rect = CGRectMake(0,0,100,100);
    CGSize sizeMin = CGSizeMake(11, 11);
    self.qt = [[QuadTile alloc] initWithBounds:rect minimumQuadSize:sizeMin];
}

- (void)addShape:(int)n toQuad:(QuadTile*)qt
{
    id<QuadTileShape> shape = self.shapes[n];
    [qt add:shape];
}

- (void)testQuadEmpty
{
    NSSet* set;
    set = [self.qt findShapesWithPoint:CGPointMake(0,0)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 0 point");
}

- (void)testQuadSimplOneShapeEdges
{
    [self addShape:10 toQuad:self.qt];
    NSSet* set;
    set = [self.qt findShapesWithPoint:CGPointMake(10,10)];
    STAssertTrue([set count] == 1, @"Wanted to find exactly 1 point");
    set = [self.qt findShapesWithPoint:CGPointMake(19,19)];
    STAssertTrue([set count] == 1, @"Wanted to find exactly 1 point");
    set = [self.qt findShapesWithPoint:CGPointMake(9,10)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 0 point");
    set = [self.qt findShapesWithPoint:CGPointMake(10,9)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 0 point");
    set = [self.qt findShapesWithPoint:CGPointMake(19,20)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 0 point");
    set = [self.qt findShapesWithPoint:CGPointMake(20,19)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 0 point");
}

- (void)testQuadSimpleOneShape
{
    [self addShape:20 toQuad:self.qt];
    NSSet* set;
    set = [self.qt findShapesWithPoint:CGPointMake(3,3)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 1 point");
    set = [self.qt findShapesWithPoint:CGPointMake(23,23)];
    STAssertTrue([set count] == 1, @"Wanted to find exactly 1 point");
    set = [self.qt findShapesWithPoint:CGPointMake(43,43)];
    STAssertTrue([set count] == 0, @"Wanted to find exactly 1 point");
}

- (void)testQuadSimpleMultipleShapes
{
    [self addShape:1 toQuad:self.qt];
    [self addShape:3 toQuad:self.qt];
    [self addShape:5 toQuad:self.qt];
    [self addShape:7 toQuad:self.qt];
    NSSet* set;
    set = [self.qt findShapesWithPoint:CGPointMake(9,9)];
    STAssertTrue([set count] == 4, @"Wanted to find exactly 4 point");
    set = [self.qt findShapesWithPoint:CGPointMake(6,6)];
    STAssertTrue([set count] == 3, @"Wanted to find exactly 3 point");
    set = [self.qt findShapesWithPoint:CGPointMake(4,4)];
    STAssertTrue([set count] == 2, @"Wanted to find exactly 2 point");
}

- (void)testQuadLotsShapes
{
    for(id<QuadTileShape> shape in self.shapes)
    {
        [self.qt add:shape];
    }
    NSSet* set;
    set = [self.qt findShapesWithPoint:CGPointMake(50,50)];
    STAssertTrue([set count] == 10, @"Wanted to find exactly 10 point");
    set = [self.qt findShapesWithPoint:CGPointMake(55,50)];
    STAssertTrue([set count] == 5, @"Wanted to find exactly 5 point");
}

- (void)testQuadDepth
{
    NSInteger depth = [self.qt calcDepthAtPoint:CGPointMake(50,50)];
    STAssertEquals(depth, 0, @"Depth wrong");
    for(id<QuadTileShape> shape in self.shapes)
    {
        [self.qt add:shape];
    }
    depth = [self.qt calcDepthAtPoint:CGPointMake(50,50)];
    STAssertEquals(depth, 4, @"Depth wrong");
    depth = [self.qt calcDepthAtPoint:CGPointMake(25,25)];
    STAssertEquals(depth, 4, @"Depth wrong");
    depth = [self.qt calcDepthAtPoint:CGPointMake(12,12)];
    STAssertEquals(depth, 4, @"Depth wrong");
    depth = [self.qt calcDepthAtPoint:CGPointMake(6,6)];
    STAssertEquals(depth, 4, @"Depth wrong");

    depth = [self.qt calcDepthAtPoint:CGPointMake(88,12)];
    STAssertEquals(depth, 2, @"wrong");
}

@end
