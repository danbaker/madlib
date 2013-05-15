//
//  NSMutableDictionary+MAD.m
//  HexGrid
//
//  Created by Dan Baker on 11/22/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "NSMutableDictionary+MAD.h"

@implementation NSMutableDictionary (MAD)

// treat this dictionary as a two-level-deep (or nested) dictionary
// the first key is used to find the second (or nested, or sub) dictionary
// the sub-key is used to locate the object within the nested dictionary
// if the object for the first key doesn't exist, an NSMutableDictionary is created and place into this dictionary under the key "aKey"
// NOTE: If the aKey object exists but is NOT an NSDictionary ... this call throws an exception
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey subKey:(id<NSCopying>)subKey;
{
    id object = [self objectForKey:aKey];
    if (!object)
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [self setObject:newDict forKey:aKey];
        object = newDict;
    }
    if ([object isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary *dict = object;
        [dict setObject:anObject forKey:subKey];
    }
    else
    {
        NSLog(@"ERROR: NSMutableDictiony+MAD.setObject:forKey:subKey: failed. object(forKey) is NOT an NSMutableDictionary");
        [NSException raise:@"first object is not an NSMutableDictionary" format:@"NSMutableDictiony+MAD.setObject:forKey:subKey:"];
    }
}

@end
