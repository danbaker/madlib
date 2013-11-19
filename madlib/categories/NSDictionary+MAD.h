//
//  NSDictionary+MAD.h
//  HexGrid
//
//  Created by Mark Hamilton on 11/15/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MAD)

- (CGFloat)floatForKey:(NSString*)key defaultValue:(CGFloat)defaultValue;
- (NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue;
- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (BOOL)boolForKey:(NSString*)key defaultsTo:(BOOL)defaultValue;
- (NSNumber*)numberForKey:(NSString*)key defaultsTo:(NSNumber*)defaultValue;
- (NSArray*)arrayForKey:(NSString*)key defaultsTo:(NSArray*)defaultValue;
- (NSDate*)dateForKey:(NSString*)key defaultsTo:(NSDate*)defaultValue;
- (NSDictionary*)dictionaryForKey:(NSString*)key defaultsTo:(NSDictionary*)defaultValue;

- (id)objectForKey:(id)aKey subKey:(id)subKey;

- (id)objectForKeyPath:(NSString*)keyPath defaultValue:(id)defaultValue;
- (NSInteger) integerForKeyPath:(NSString*)keyPath defaultValue:(NSInteger)defaultValue;
- (NSString*) stringForKeyPath:(NSString*)keyPath defaultValue:(NSString*)defaultValue;

- (void)enumerateKeysAndSubKeysAndObjectsUsingBlock:(void (^)(id key, id subkey, id obj, BOOL * stop))block;

@end
