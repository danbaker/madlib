//
//  QuadTile.h
//  madlib
//
//  Created by Dan Baker on 4/16/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol QuadTileShape <NSObject>
- (CGRect)bounds;
@optional
- (BOOL)containsPoint:(CGPoint)point;
@end



@interface QuadTile : NSObject

- (id)initWithBounds:(CGRect)bounds minimumQuadSize:(CGSize)minimumQuadSize;
- (void)add:(id<QuadTileShape>)shape;
- (void)clear;
- (NSSet*)findShapesWithPoint:(CGPoint)point;

@end
