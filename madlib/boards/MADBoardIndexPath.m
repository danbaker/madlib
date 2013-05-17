//
//  MADBoardIndexPath.h
//  madlib
//
//  provides grid coordinate support
//
//  Created by Mark Hamilton on 10/4/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADBoardIndexPath.h"

@implementation MADBoardIndexPath

+(MADBoardIndexPath*)indexPathForColumn:(NSInteger)c forRow:(NSInteger)r
{
    return [[MADBoardIndexPath alloc] initForColumn:c forRow:r];
}

-(id)initForColumn:(NSInteger)c forRow:(NSInteger)r
{
    if (!(self = [super init])) return nil;
    _row = r;   // >= 0 ? r : -r;
    _column = c;     // >= 0 ? c : -c;
    return self;
}


- (void) encodeWithCoder:(NSCoder*)encoder
{
    // [super encodeWithCoder:encoder];
    [encoder encodeInteger:self.column forKey:@"column"];
    [encoder encodeInteger:self.row forKey:@"row"];
}

- (id) initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])    // [super initWithCoder:decoder]
    {
        _column = [decoder decodeIntegerForKey:@"column"];
        _row = [decoder decodeIntegerForKey:@"row"];
    }
    return self;
}



-(NSUInteger)hash
{
    return (self.column * 10000) + self.row;
}

-(BOOL)isEqual:(id)object
{
    if (object && [object isMemberOfClass:[MADBoardIndexPath class]])
    {
        MADBoardIndexPath *path = (MADBoardIndexPath*)object;
        if ((self.row == path.row) && (self.column == path.column))
        {
            return YES;
        }
    }
    return NO;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"MADBoardIndexPath:%d,%d", self.column, self.row];
}

@end
