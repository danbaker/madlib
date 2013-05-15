//
//  NSObject+MAD.m
//  HexGrid
//
//  Created by Dan Baker on 12/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "NSObject+MAD.h"

@implementation NSObject (MAD)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;
{
    void (^copiedBlock)() = [block copy];
    [self performSelector:@selector(runBlockAfterDelay:) withObject:copiedBlock afterDelay:delay];
}
- (void)runBlockAfterDelay:(void (^)())block;
{
    block();
}

@end
