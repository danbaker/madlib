//
//  MADUIView.m
//  HexGrid
//
//  Created by Dan Baker on 11/26/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADUIView.h"

@implementation MADUIView

@synthesize delegate;
@synthesize delegateAction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Note: remember to set delegate and delegateAction
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSValue *rectValue = [NSValue valueWithCGRect:rect];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate performSelector:delegateAction withObject:rectValue];
#pragma clang diagnostic pop
    //    objc_msgSend(delegate, @selector(initWithFrame:reuseIdentifier:),rect);
}

@end
