//
//  PathFinderExhaustive.m
//  HexGrid
//
//  Created by Dan Baker on 11/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//
//
#import "PathFinderExhaustive.h"
#import "NSDictionary+MAD.h"
#import "NSMutableDictionary+MAD.h"
//#import "HexMapIndexPath.h"
//#import "Map.h"         // DEBUG TESTING
//#import "MapDefs.h"     // DEBUG TESTING

@implementation FinderSpot
@synthesize point;
- (id)initWithPoint:(CGPoint)pointX;
{
    if (self = [super init])
    {
        self.point = pointX;
        self.Fscore = 99999;
        self.Gscore = 99999;
    }
    return self;
}
- (NSInteger)Hscore;
{
    return self.Fscore + self.Gscore;
}
- (CGFloat)cost
{
    return self.Gscore/100.0;
}
//- (HexMapIndexPath*)indexPath
//{
//    return [HexMapIndexPath indexPathForColumn:point.x forRow:point.y];
//}
- (NSString *)description
{
    return [NSString stringWithFormat: @"FinderSpot(%i,%i) cost(%f) --- F(%i) G(%i) H(%i)", (int)point.x,(int)point.y, self.cost, self.Fscore, self.Gscore, self.Hscore];
}
@end



@implementation PathFinderExhaustive
{
    NSInteger maxNeighbors;         // on a hex board, every cell has, at most, 6 neighbors (a square grid has either 4 or 8 neighbors)
    NSMutableSet *closedSet;        // <FinderSpot> that have been processed (cost to neighbors calculated)
    NSMutableSet *openSet;          // <FinderSpot> that need to be processed
    NSMutableDictionary *allSpots;  // <FinderSpot> every spot created ... with quick accessor method
}

@synthesize delegate;
@synthesize userObject;

+ (id)pathFinderExhaustiveWithPathFinderDelegate:(id<PathFinderDelegate>)delegate
{
    return [[self alloc] initWithPathFinderDelegate:delegate];
}

- (id)initWithPathFinderDelegate:(id<PathFinderDelegate>)theDelegate
{
    if (self = [super init])
    {
        self.delegate = theDelegate;
        maxNeighbors = 6;               // default to a hex board which has 6 neighbors
        if ([delegate respondsToSelector:@selector(getMaxNeighbors)]) {
            maxNeighbors = [delegate getMaxNeighbors];
        }
    }
    return self;
}

- (NSSet*)findAllDestinationsFromSource:(CGPoint)source maxDistance:(CGFloat)distance;
{
    distance *= 100;
    allSpots = [[NSMutableDictionary alloc] init];
    closedSet = [[NSMutableSet alloc] initWithCapacity:maxNeighbors * distance/100];
    openSet = [[NSMutableSet alloc] initWithCapacity:maxNeighbors * maxNeighbors / 2];
    FinderSpot *currentSpot = [self findOrMakeSpotWithPoint:source];
    currentSpot.Fscore = 0;
    currentSpot.Gscore = 0;
    [openSet addObject:currentSpot];
    while ([openSet count])
    {   // get item from openSet that has the lowest Fscore
        FinderSpot *spot = [self getNextSpotToProcess];
        if (spot.Gscore < distance+100)
        {
            spot.closed = YES;
            NSSet *neighbors = [self neighboringNodesForPoint:spot.point];
            currentSpot = spot;
            for(FinderSpot *neighbor in neighbors)
            {
                if (!neighbor.closed)
                {
                    [openSet addObject:neighbor];
                    NSInteger dist = [delegate distanceBetweenPointA:currentSpot.point andPointB:neighbor.point];   // distance + cost
                    NSInteger Gcurrent = currentSpot.Gscore;
                    NSInteger tentativeGScore = Gcurrent + dist;
                    if (tentativeGScore < neighbor.Gscore)
                    {
                        neighbor.Gscore = tentativeGScore;
                        neighbor.Fscore = dist;
                    }
                }
            }
        }
    }
    return [self makeSetOfSpotsWithinDistance:distance];
}

- (NSSet *)makeSetOfSpotsWithinDistance:(CGFloat)distance;
{
    NSMutableSet *spots = [[NSMutableSet alloc] init];
    [allSpots enumerateKeysAndSubKeysAndObjectsUsingBlock:^(id key, id subkey, id obj, BOOL *stop) {
        FinderSpot *spot = obj;
        if (spot.Gscore <= distance && spot.Gscore >= 100)
        {   // Note: never return the starting location (caller can add that cell if they want to)
            [spots addObject:obj];
        }
    }];
    return spots;
}

- (FinderSpot*)getNextSpotToProcess
{
    FinderSpot *spotReturn = nil;
    NSInteger spotScore = 9999999;
    for (FinderSpot *spot in openSet)
    {
        if (spot.Gscore < spotScore)
        {
            spotReturn = spot;
            spotScore = spot.Gscore;
        }
    }
    [openSet removeObject:spotReturn];
    return spotReturn;
}

- (NSSet *)neighboringNodesForPoint:(CGPoint)point
{
    NSMutableSet *returnSet = [NSMutableSet set];
    CGPoint neighbor;
    for (int i = 0; i < maxNeighbors; i++) {
        neighbor = [delegate getNeighbor:i fromPoint:point];
        bool pointOK = true;
        if ([delegate respondsToSelector:@selector(isPointAnObstruction:)]) {
            if ([delegate isPointAnObstruction:neighbor])
            {
                pointOK = false;
            }
        }
        if (pointOK) {
            FinderSpot *spot = [self findOrMakeSpotWithPoint:neighbor];
            [returnSet addObject:spot];
        }
    }
    
    return returnSet;
}

- (FinderSpot *)findOrMakeSpotWithPoint:(CGPoint)point
{
    FinderSpot *spot;
    NSNumber *x = [NSNumber numberWithInteger:point.x];
    NSNumber *y = [NSNumber numberWithInteger:point.y];
    spot = [allSpots objectForKey:x subKey:y];
    if (!spot)
    {
        spot = [[FinderSpot alloc] initWithPoint:point];
        [allSpots setObject:spot forKey:x subKey:y];
    }
    return spot;
}

#pragma mark - Unit Tests

+ (void)test
{
// NOTE: the following code is for personal testing, not unit testing
//    Map *map = [[Map alloc] init];
//    PathFinderExhaustive *pfe = [[PathFinderExhaustive alloc] initWithPathFinderDelegate:map];
//    map.mapDefs = [MapDefs sharedInstance];
//    NSSet *spots = [pfe findAllDestinationsFromSource:CGPointMake(5, 5) maxDistance:4];
//    int cntrs[100];
//    for(int i=0; i<100; i++) {
//        cntrs[i] = 0;
//    }
//    int totalWant = 1 + 6*1 + 6*2;
//    int totalSeenSoFar = 0;
//    int total = spots.count;
//    int maxIdx = 0;
//    for(FinderSpot *spot in spots)
//    {
//        int idx = (int)(spot.Gscore/100);
//        cntrs[idx]++;
//        if (idx > maxIdx) maxIdx = idx;
//        NSLog(@"%@ :: %i :: %i/%i", spot, cntrs[idx], ++totalSeenSoFar, total);
//    }
//    int nWanted = 0;
//    for(int i=0; i<=maxIdx; i++) {
//        NSLog(@"%i : %i/%i   ::   %i/%i", i, cntrs[i],nWanted,  totalSeenSoFar, total);
//        nWanted += 6;
//    }
//    NSLog(@" ------------------------------- MISSING %i", (totalWant-total));
}
@end
