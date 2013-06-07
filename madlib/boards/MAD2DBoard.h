//
//  MAD2DBoard.h
//  madlib
//
//  Created by Dan Baker on 6/7/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef char BOARDCELLTYPE;

@interface MAD2DBoard : NSObject
@property (nonatomic, assign) CGSize boardSize;             // dimensions of the board
@property (nonatomic, assign) BOARDCELLTYPE edgeValue;      // value of a cell found off-the-board

- (BOARDCELLTYPE) valueAtX:(int)x Y:(int)y;
- (void) setValue:(BOARDCELLTYPE)value atX:(int)x Y:(int)y;

@end
