//
//  PathFinder.h
//  madlib
//
//  Created by Dan Baker on 10/16/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PathFinderDelegate <NSObject>

@optional
- (NSInteger)heuristicCostEstimateFromSource:(CGPoint)source toDestination:(CGPoint)destination;

@required
- (BOOL) isPointAnObstruction:(CGPoint)point;
- (NSInteger)distanceBetweenPointA:(CGPoint)a andPointB:(CGPoint)b;
- (NSInteger)getMaxNeighbors;
- (CGPoint)getNeighbor:(NSInteger)neighborNumber fromPoint:(CGPoint)point;

@end



@interface PathFinder : NSObject

+ (id)pathFinderWithPathFinderDelegate:(id<PathFinderDelegate>)delegate;
- (id)initWithPathFinderDelegate:(id<PathFinderDelegate>)delegate;

- (NSSet*)findAllDestinationsFromSource:(CGPoint)source maxDistance:(CGFloat)distance;
- (NSArray*)findPathFromSource:(CGPoint)source toDestination:(CGPoint)destination;
- (NSInteger)heuristicCostEstimateFromSource:(CGPoint)source toDestination:(CGPoint)destination;
- (NSSet*)neighboringNodesForPoint:(CGPoint)point;
- (NSInteger)distanceBetweenPointA:(CGPoint)a andPointB:(CGPoint)b;

- (void)test;

@property (nonatomic, retain) id <PathFinderDelegate> delegate;
@property (nonatomic, retain) id userObject;

@end
