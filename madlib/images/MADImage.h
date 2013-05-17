//
//  MADImage.h
//  HexGrid
//
//  Created by Dan Baker on 11/15/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#warning DANB TODO: convert this into a category on UIImage

@interface MADImage : NSObject

+ (UIImage *)makeGrayImageFromImage:(UIImage *)image;
+ (UIImage *)makeGrayImageFromImage:(UIImage *)image addWhite:(NSInteger)nWhite multiplyToWhite:(CGFloat)xWhite;

@end
