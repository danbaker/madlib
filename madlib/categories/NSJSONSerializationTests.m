//
//  NSJSONSerializationTests.m
//  HexGrid
//
//  Created by Dan Baker on 10/26/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "NSJSONSerializationTests.h"
#import "NSJSONSerialization+MAD.h"

@implementation NSJSONSerializationTests


+ (void) runUnitTests
{
    NSJSONSerializationTests* tests = [[NSJSONSerializationTests alloc] init];
    [tests unittestJSONSerialization];
}

- (void) assertjsonDictionary:(id)jsonObject matchKey:(NSString*)key value:(id)value
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        id objectA = [jsonDictionary objectForKey:key];
        if ([objectA isKindOfClass:[NSString class]]) {
            NSString* stringA = (NSString*)objectA;
            if (![stringA isEqual:value]) {
                NSLog(@"UNITTEST FAIL: NSJSONSerialization. key(%@) wasn't the right value. wanted(%@) got(%@)", key, value, stringA);
            }
        } else if ([objectA isKindOfClass:[NSNumber class]] && [value isKindOfClass:[NSNumber class]]){
            NSNumber *numberA = (NSNumber*)objectA;
            NSInteger intA = [numberA integerValue];
            NSInteger intValue = [(NSNumber*)value integerValue];
            if (intA != intValue) {
                NSLog(@"UNITTEST FAIL: NSJSONSerialization. key(%@) wasn't the right number. wanted(%i) got(%i)", key, intA, intValue);
            }
        } else {
            NSLog(@"UNITTEST FAIL: NSJSONSerialization. failed to find key(%@) as a string. value wanted=(%@)", key, value);
        }
    } else {
        NSLog(@"UNITTEST FAIL: NSJSONSerialization. didn't parse object into dictionary. key=(%@) value wanted=(%@)", key, value);
    }
}

- (void) unittestJSONSerialization
{
    NSString* str = @"{\"a\":\"letter a\", \"b\":123, \"c\":{\"a\":\"sub-a\"}}";
    NSError* err = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithString:str options:0 error:&err];
    [self assertjsonDictionary:jsonObject matchKey:@"a" value:@"letter a"];
    [self assertjsonDictionary:jsonObject matchKey:@"b" value:[NSNumber numberWithInt:123]];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        id jsonCObject = [jsonDictionary objectForKey:@"c"];
        [self assertjsonDictionary:jsonCObject matchKey:@"a" value:@"sub-a"];
    }
    
    
//    if ([jsonObject isKindOfClass:[NSArray class]]) {
//        NSLog(@"its an array!");
//        NSArray *jsonArray = (NSArray *)jsonObject;
//        NSLog(@"jsonArray - %@",jsonArray);
//    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
//        NSLog(@"its a dictionary");
//        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
//        NSLog(@"jsonDictionary - %@",jsonDictionary);
//    } else {
//        NSLog(@"failure");
//    }
}


@end
