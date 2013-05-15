//
//  NSArray+MAD.m
//  HexGrid
//
//  Created by Dan Baker on 11/17/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "NSArray+MAD.h"

@implementation NSArray (MAD)

// Force the index to be a valid index -- wrap it within the objects of the array
// Make the array a circle of objects
// Iterating off the end of the array will wrap back to the beginning
// Iterating off the begeinning of the array will wrap around to the end
-(id)objectAtWrapIndex:(NSInteger)index;
{
    if (self.count <= 0) return nil;                        // empty list ... return nil
    while (index < 0) index += self.count;                  // index before beginning ... wrap to end
    while (index >= self.count) index -= self.count;        // index past end ... wrap to beginning
    return [self objectAtIndex:index];
}

@end
