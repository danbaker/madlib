//
//  HexMapIndexPath.h
//  madlib
//
//  Created by Mark Hamilton on 10/4/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MADBoardIndexPath : NSObject

@property (nonatomic, readonly) NSInteger column;
@property (nonatomic, readonly) NSInteger row;

+ (MADBoardIndexPath*)indexPathForColumn:(NSInteger)c forRow:(NSInteger)r;

- (id)initForColumn:(NSInteger)c forRow:(NSInteger)r;

@end
