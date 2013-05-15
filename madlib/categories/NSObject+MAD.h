//
//  NSObject+MAD.h
//  HexGrid
//
//  Created by Dan Baker on 12/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MAD)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
