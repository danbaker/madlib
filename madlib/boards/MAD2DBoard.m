//
//  MAD2DBoard.m
//  madlib
//
//  Created by Dan Baker on 6/7/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "MAD2DBoard.h"

@interface MAD2DBoard ()
@end

@implementation MAD2DBoard {
    BOARDCELLTYPE* theBoard;
    BOARDCELLTYPE cellOffBoard;
}

- (id)init
{
    self = [super init];
    return self;
}

- (void) dealloc
{
    [self destroyBoard];
}

- (void)setBoardSize:(CGSize)boardSize
{
    if (_boardSize.width != boardSize.width && _boardSize.height != boardSize.height)
    {
        _boardSize = boardSize;
        [self buildBoard];
    }
}

- (BOARDCELLTYPE) valueAtX:(int)x Y:(int)y
{
    BOARDCELLTYPE *ptr = [self calculateBoardPointerAtX:x Y:y];
    return *ptr;
}

- (void)setValue:(BOARDCELLTYPE)value atX:(int)x Y:(int)y
{
    BOARDCELLTYPE *ptr = [self calculateBoardPointerAtX:x Y:y];
    *ptr = value;
}



- (void)buildBoard
{
    [self destroyBoard];
    int arraySize = ((int)self.boardSize.width) * ((int)self.boardSize.height);
    theBoard = (BOARDCELLTYPE*)calloc(arraySize, sizeof(BOARDCELLTYPE));
}

- (void)destroyBoard
{
    if (theBoard)
    {
        free(theBoard);
        theBoard = NULL;
    }
}

- (BOARDCELLTYPE*)calculateBoardPointerAtX:(int)x Y:(int)y
{
    if (x >= 0 && x < self.boardSize.width && y >= 0 && y < self.boardSize.height)
    {
        int ofs = y * ((int)self.boardSize.width) + x;
        return &theBoard[ofs];
    }
    cellOffBoard = self.edgeValue;
    return &cellOffBoard;
}

@end
