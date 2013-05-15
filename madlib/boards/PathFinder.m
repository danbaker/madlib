//
//  PathFinder.m
//  HexGrid
//
//  Created by Dan Baker on 10/16/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "PathFinder.h"
#import <UIKit/UIKit.h>

@interface ScoreObject : NSObject
@property (nonatomic) NSInteger score;
@property (nonatomic) NSValue* key;
+ (ScoreObject *)itemWithScore:(NSInteger)score key:(NSValue*)key;
@end

@implementation ScoreObject
@synthesize score;
@synthesize key;

+ (ScoreObject *)itemWithScore:(NSInteger)score key:(NSValue*)key
{
    ScoreObject* obj = [[ScoreObject alloc] init];
    obj.score = score;
    obj.key = key;
    return obj;
}

- (NSInteger)getPriority
{
    return score;
}

- (NSObject *)getKey
{
    return key;
}

@end


@implementation PathFinder

@synthesize delegate;
int nNeighbors = 4;

- (id)initWithPathFinderDelegate:(id<PathFinderDelegate>)theDelegate
{
    if (self = [super init])
    {
        self.delegate = theDelegate;
        if ([delegate respondsToSelector:@selector(getMaxNeighbors)]) {
            nNeighbors = [delegate getMaxNeighbors];
        }
    }
    return self;
}

+ (id)pathFinderWithPathFinderDelegate:(id<PathFinderDelegate>)delegate
{
    return [[self alloc] initWithPathFinderDelegate:delegate];
}


- (NSSet*)findAllDestinationsFromSource:(CGPoint)source maxDistance:(CGFloat)distance
{   // find ALL possible destinations from a source, given a max distance can travel
    NSMutableSet *closedSet, *openSet;
    NSMutableDictionary *cameFrom;
    NSMutableDictionary *gScores, *hScores, *fScores;
    
    closedSet = [NSMutableSet set];                                                 // locations checked (will return these)
    openSet = [NSMutableSet setWithObject:[NSValue valueWithCGPoint:source]];       // locations to check
    cameFrom = [NSMutableDictionary dictionary];
    
    gScores = [NSMutableDictionary dictionary];
    hScores = [NSMutableDictionary dictionary];
    fScores = [NSMutableDictionary dictionary];
    
    NSNumber* gScoreStart = [NSNumber numberWithInt:0];
    NSNumber* hScoreStart = [NSNumber numberWithInt:[self heuristicCostEstimateFromSource:source toDestination:source]];
    NSNumber* fScoreStart = [NSNumber numberWithInt:[gScoreStart integerValue] + [hScoreStart integerValue]];
    
    [gScores setObject:gScoreStart forKey:[NSValue valueWithCGPoint:source]];
    [hScores setObject:hScoreStart forKey:[NSValue valueWithCGPoint:source]];
    [fScores setObject:fScoreStart forKey:[NSValue valueWithCGPoint:source]];
    
    while ([openSet count]) {
        // get item from openSet that has the lowest Fscore
        NSValue *currentKey;
        CGPoint current;
        NSInteger minimumFScore = NSIntegerMax;
        for (NSValue *currentValue in openSet)
        {
            NSInteger currentFScore = [[fScores objectForKey:currentValue] integerValue];
            minimumFScore = MIN(currentFScore, minimumFScore);
            if (minimumFScore == currentFScore) {
                currentKey = currentValue;
                current = [currentValue CGPointValue];
            }
        }
        
        [openSet removeObject:[NSValue valueWithCGPoint:current]];
        [closedSet addObject:[NSValue valueWithCGPoint:current]];
        
        for (NSValue* neighbor in [self neighboringNodesForPoint:current])
        {
            if ([closedSet containsObject:neighbor])
                continue;   // ignore neighbors already visited
            int distFromSource = [self distanceBetweenPointA:[neighbor CGPointValue] andPointB:source];
            NSLog(@"distanceFromSource=%i", distFromSource);
            if (distFromSource > distance)
                continue;   // ignore neighbors that are too far away from source
            
            int dist = [self distanceBetweenPointA:[neighbor CGPointValue] andPointB:current];
            int Gcurrent = [[gScores objectForKey:currentKey] integerValue];
            NSInteger tentativeGScore = Gcurrent + dist;
            
            BOOL tentativeIsBetter = NO;
            
            if (![openSet containsObject:neighbor])
            {
                [openSet addObject:neighbor];
                
                NSNumber* hScoreneighbor = [NSNumber numberWithInteger:[self heuristicCostEstimateFromSource:current toDestination:[neighbor CGPointValue]]];
                
                [hScores setObject:hScoreneighbor forKey:neighbor];
                
                tentativeIsBetter = YES;
            } else if (tentativeGScore < [[gScores objectForKey:neighbor] integerValue]) {
                tentativeIsBetter = YES;
            } else {
                tentativeIsBetter = NO;
            }
            
            if (tentativeIsBetter)
            {
                [cameFrom setObject:[NSValue valueWithCGPoint:current] forKey:neighbor];
                [gScores setObject:[NSNumber numberWithInteger:tentativeGScore] forKey:neighbor];
                int f = [[gScores objectForKey:neighbor] integerValue] + [[hScores objectForKey:neighbor] integerValue];
                [fScores setObject:[NSNumber numberWithInteger:f] forKey:neighbor];
            }
        }
    }
    // walk the closed set, and return ALL values that are <= distance
    NSMutableSet* returnSet = [[NSMutableSet alloc] initWithCapacity:openSet.count];
    for (NSValue *currentValue in closedSet)
    {
        NSInteger score = [[gScores objectForKey:currentValue] integerValue];
        CGPoint p = [currentValue CGPointValue];
        NSLog(@"findAllDestinationsFromSource: (%f,%f) score=%i", p.x,p.y, score);
        if (score <= distance) {
            [returnSet addObject:currentValue];
        }
    }
    return returnSet;
}

- (NSArray*)findPathFromSource:(CGPoint)source toDestination:(CGPoint)destination
{
    NSMutableSet *closedSet, *openSet;
    NSMutableDictionary *cameFrom;
    NSMutableDictionary *gScores, *hScores, *fScores;
    
    closedSet = [NSMutableSet set];
    openSet = [NSMutableSet setWithObject:[NSValue valueWithCGPoint:source]];
    cameFrom = [NSMutableDictionary dictionary];
    
    gScores = [NSMutableDictionary dictionary];
    hScores = [NSMutableDictionary dictionary];
    fScores = [NSMutableDictionary dictionary];
    
    NSNumber* gScoreStart = [NSNumber numberWithInt:0];
    NSNumber* hScoreStart = [NSNumber numberWithInt:[self heuristicCostEstimateFromSource:source toDestination:destination]];
    NSNumber* fScoreStart = [NSNumber numberWithInt:[gScoreStart integerValue] + [hScoreStart integerValue]];
    
    [gScores setObject:gScoreStart forKey:[NSValue valueWithCGPoint:source]];
    [hScores setObject:hScoreStart forKey:[NSValue valueWithCGPoint:source]];
    [fScores setObject:fScoreStart forKey:[NSValue valueWithCGPoint:source]];
    
    while ([openSet count]) {
        // get item from openSet that has the lowest Fscore
        NSValue *currentKey;
        CGPoint current;
        NSInteger minimumFScore = NSIntegerMax;
        for (NSValue *currentValue in openSet)
        {
            NSInteger currentFScore = [[fScores objectForKey:currentValue] integerValue];
            minimumFScore = MIN(currentFScore, minimumFScore);
            if (minimumFScore == currentFScore) {
                currentKey = currentValue;
                current = [currentValue CGPointValue];
            }
        }
        
        if (CGPointEqualToPoint(current, destination))
        {
            NSValue *currentValue = [NSValue valueWithCGPoint:current];
            NSMutableArray *returnValue = [NSMutableArray arrayWithObject:currentValue];
            while ((currentValue = [cameFrom objectForKey:currentValue]))
                [returnValue addObject:currentValue];
            NSMutableArray *returnValue2 = [NSMutableArray arrayWithCapacity:[returnValue count]];
            for (id item in [returnValue reverseObjectEnumerator])
                [returnValue2 addObject:item];
            return returnValue2;
        }
        
        [openSet removeObject:[NSValue valueWithCGPoint:current]];
        [closedSet addObject:[NSValue valueWithCGPoint:current]];
        
        for (NSValue* neighbor in [self neighboringNodesForPoint:current])
        {
            if ([closedSet containsObject:neighbor])
                continue;
            int dist = [self distanceBetweenPointA:[neighbor CGPointValue] andPointB:current];
            int Gcurrent = [[gScores objectForKey:currentKey] integerValue];
            NSInteger tentativeGScore = Gcurrent + dist;
            
            BOOL tentativeIsBetter = NO;
            
            if (![openSet containsObject:neighbor])
            {
                [openSet addObject:neighbor];
                
                NSNumber* hScoreneighbor = [NSNumber numberWithInteger:[self heuristicCostEstimateFromSource:current toDestination:[neighbor CGPointValue]]];
                
                [hScores setObject:hScoreneighbor forKey:neighbor];
                
                tentativeIsBetter = YES;
            } else if (tentativeGScore < [[gScores objectForKey:neighbor] integerValue]) {
                tentativeIsBetter = YES;
            } else {
                tentativeIsBetter = NO;
            }
            
            if (tentativeIsBetter)
            {
                [cameFrom setObject:[NSValue valueWithCGPoint:current] forKey:neighbor];
                [gScores setObject:[NSNumber numberWithInteger:tentativeGScore] forKey:neighbor];
                int f = [[gScores objectForKey:neighbor] integerValue] + [[hScores objectForKey:neighbor] integerValue];
                [fScores setObject:[NSNumber numberWithInteger:f] forKey:neighbor];
            }
        }
    }
    
    return nil;
}

- (NSInteger)heuristicCostEstimateFromSource:(CGPoint)source toDestination:(CGPoint)destination
{
    if ([delegate respondsToSelector:@selector(heuristicCostEstimateFromSource:toDestination:)]) {
        return [delegate heuristicCostEstimateFromSource:source toDestination:destination];
    }
    return [self distanceBetweenPointA:source andPointB:destination];
}

- (CGPoint)getNeighbor:(NSInteger)neighborNumber fromPoint:(CGPoint)point
{
    if ([delegate respondsToSelector:@selector(getNeighbor:fromPoint:)]) {
        return [delegate getNeighbor:neighborNumber fromPoint:point];
    }
    switch (neighborNumber) {
        case 0:
            return CGPointMake(point.x + 1, point.y);
        case 1:
            return CGPointMake(point.x - 1, point.y);
        case 2:
            return CGPointMake(point.x, point.y + 1);
    }
    return CGPointMake(point.x, point.y - 1);
}

- (NSSet *)neighboringNodesForPoint:(CGPoint)point
{
    NSMutableSet *returnSet = [NSMutableSet set];
    CGPoint neighbor;
    for (int i = 0; i < nNeighbors; i++) {
        neighbor = [self getNeighbor:i fromPoint:point];
        bool pointOK = true;
        if ([delegate respondsToSelector:@selector(isPointAnObstruction:)]) {
            if ([delegate isPointAnObstruction:neighbor]) {
                pointOK = false;
            }
        }
        if (pointOK) {
            [returnSet addObject:[NSValue valueWithCGPoint:neighbor]];
        }
    }
    
    return returnSet;
}

- (NSInteger)distanceBetweenPointA:(CGPoint)a andPointB:(CGPoint)b
{
    if ([delegate respondsToSelector:@selector(distanceBetweenPointA:andPointB:)]) {
        return [delegate distanceBetweenPointA:a andPointB:b];
    }
    return abs(a.x - b.x) + abs(a.y - b.y);
}


#pragma mark - Tests

- (void) test
{
    NSLog(@"Testing PathFinder...");
    CGPoint src = CGPointMake(5, 5);
    CGPoint dst = CGPointMake(5, 9);
    NSArray* path = [self findPathFromSource:src toDestination:dst];
    int n = 0;
    for (id obj in path) {
        if ([obj isKindOfClass:[NSValue class]]) {
            NSValue* val = (NSValue*)obj;
            CGPoint p = [val CGPointValue];
            NSLog(@"%i: (%1.0f,%1.0f)", n, p.x,p.y);
        } else {
            NSLog(@"%i: WEIRD OBJECT IN PATH", n);
        }
        n++;
    }
}

@end
