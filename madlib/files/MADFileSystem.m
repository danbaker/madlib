//
//  MADFileSystem.m
//  MAD
//
//  Created by Dan Baker on 1/19/13.
//  Copyright (c) 2013 Mark Hamilton. All rights reserved.
//

#import "MADFileSystem.h"

@implementation MADFileSystem


// get the path to the "Documents" folder (the writable-folder)
+ (NSString *) applicationDocumentsDirectory;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
