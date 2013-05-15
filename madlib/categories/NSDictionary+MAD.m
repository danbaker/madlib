//
//  NSDictionary+MAD.m
//  HexGrid
//
//  Created by Mark Hamilton on 11/15/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "NSDictionary+MAD.h"

@implementation NSDictionary (MAD)

- (CGFloat)floatForKey:(NSString*)key defaultValue:(CGFloat)defaultValue
{
    CGFloat value = defaultValue;
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber*)object;
        value = [number floatValue];
    }
    return value;
}

- (NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue
{
    NSInteger value = defaultValue;
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber*)object;
        value = [number integerValue];
    }
    return value;
}

- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
    NSString* value = defaultValue;
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        value = (NSString*)object;
    }
    return value;
}

// treat this dictionary as a two-level-deep (or nested) dictionary
// the first key is used to find the second (or nested, or sub) dictionary
// the sub-key is used to locate the object within the nested dictionary
// if the first key fails or the second key fails, this returns a nil
- (id)objectForKey:(id)aKey subKey:(id)subKey
{
    id object = [self objectForKey:aKey];
    if (object && [object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)object;
        object = [dict objectForKey:subKey];
        return object;
    }
    return nil;
}

// treat this dictionary as a multi-level-deep (nested) dictionary
// assumed it was created from NSJSONSerialization
- (id)objectForKeyPath:(NSString*)keyPath defaultValue:(id)defaultValue;
{
    id object = self;
    NSArray* keys = [keyPath componentsSeparatedByString:@"."];
    for (NSString *key in keys)
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {   // object[key]
            object = [(NSDictionary*)object objectForKey:key];
        }
        else if ([object isKindOfClass:[NSArray class]])
        {   // object[key-as-index]
            int index = [key intValue];
            object = [(NSArray*)object objectAtIndex:index];
        }
    }
    if (object == nil)
    {
        object = defaultValue;
    }
    return object;
}
- (NSInteger) integerForKeyPath:(NSString*)keyPath defaultValue:(NSInteger)defaultValue;
{
    id object = [self objectForKeyPath:keyPath defaultValue:nil];
    if ([object isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber*)object;
        return [number integerValue];
    }
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *str = (NSString*)object;
        return [str integerValue];
    }
    return defaultValue;
}
- (NSString*) stringForKeyPath:(NSString*)keyPath defaultValue:(NSString*)defaultValue;
{
    id object = [self objectForKeyPath:keyPath defaultValue:nil];
    if ([object isKindOfClass:[NSString class]])
    {
        return (NSString*)object;
    }
    return defaultValue;
}


- (void)enumerateKeysAndSubKeysAndObjectsUsingBlock:(void (^)(id, id, id, BOOL *))block;
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *mainDict = (NSDictionary *)obj;
            [mainDict enumerateKeysAndObjectsUsingBlock:^(id subkey, id subobj, BOOL *stop) {
                BOOL stopNow = NO;
                block(key, subkey, subobj, &stopNow);
                if (stopNow) return;
            }];
        }
    }];
}

@end


