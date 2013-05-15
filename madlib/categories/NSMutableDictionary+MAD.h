//
//  NSMutableDictionary+MAD.h
//  HexGrid
//
//  Created by Dan Baker on 11/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MAD)

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey subKey:(id<NSCopying>)subKey;

@end
