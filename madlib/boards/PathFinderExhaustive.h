//
//  PathFinderExhaustive.h
//  HexGrid
//
//  Created by Dan Baker on 11/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import "PathFinder.h"

// The object stored and returned for exhaustive path finding
@interface FinderSpot : NSObject
@property (nonatomic, assign) CGPoint point;            // location of this spot
@property (nonatomic, assign) NSInteger Fscore;         // "F" score (G + H)
@property (nonatomic, assign) NSInteger Gscore;         // "G" score (?: total cost to reach here from source)
@property (nonatomic, assign) BOOL closed;              // YES means this spot has been processed
- (NSInteger)Hscore;                                    // ??
//- (HexMapIndexPath*)indexPath;                          // return an index path via the internal "point"
- (CGFloat)cost;                                        // return the cost to move to this spot
- (id)initWithPoint:(CGPoint)point;
@end



@interface PathFinderExhaustive : NSObject

@property (nonatomic, weak) id <PathFinderDelegate> delegate;
@property (nonatomic, weak) id userObject;

+ (id)pathFinderExhaustiveWithPathFinderDelegate:(id<PathFinderDelegate>)delegate;
- (id)initWithPathFinderDelegate:(id<PathFinderDelegate>)delegate;

- (NSSet*)findAllDestinationsFromSource:(CGPoint)source maxDistance:(CGFloat)distance;

+ (void)test;

@end
