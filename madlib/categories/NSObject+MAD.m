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

- (void)performBlockInBackground:(void (^)())block;
{
    if ([NSThread isMainThread])
    {
        void (^copiedBlock)() = [block copy];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            copiedBlock();
        });
    }
    else
    {
        block();
    }
}

- (void)performBlockOnMainThread:(void (^)())block;
{
    if (![NSThread isMainThread])
    {
        void (^copiedBlock)() = [block copy];
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            copiedBlock();
        });
    }
    else
    {
        block();
    }
}

@end
