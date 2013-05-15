//
//  NSJSONSerialization+MAD.m
//

#import "NSJSONSerialization+MAD.h"

@implementation NSJSONSerialization (MAD)

// convert a json-string into a json-object (NSDictionary or NSArray)
+ (id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    if (string != nil && string.length > 0) {
        NSData *dataString = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSError *er;
        id jsonThing = [NSJSONSerialization JSONObjectWithData:dataString
                                                       options:opt
                                                         error:&er];
        if (error)
        {
            *error = er;
        }
        if (er == nil) {
            return jsonThing;
        }
    }
    return nil;
}

// convert a json-object (NSDictionary or NSArray) into a json-string
+ (NSString*)stringFromJSONObject:(NSObject *)jsonObject options:(NSJSONWritingOptions)options error:(NSError *__autoreleasing *)error;
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:options
                                                         error:error];
    if (!jsonData)
    {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
