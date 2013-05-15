//
//  NSJSONSerialization+MAD.h
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (MAD)

+ (id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)opt error:(NSError **)error;

+ (NSString*)stringFromJSONObject:(NSObject*)jsonObject options:(NSJSONWritingOptions)options error:(NSError**)error;

@end

