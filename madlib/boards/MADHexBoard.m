//
//  MADHexBoard.m
//  madlib
//
//  Created by Dan Baker on 11/9/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import "MADHexBoard.h"
#import "MADBoardIndexPath.h"
//#import "MADCollisionDetect.h"
//#import "math.h"
//#include "MADVector.h"
//#include "MADMutableVector.h"
//#include "MADLines.h"
//#include "NSArray+MAD.h"

@implementation MADHexBoard
{
    CGFloat A;  // see comments at bottom of this file for documentation about A,B,C
    CGFloat B;
    CGFloat C;
    int debugCollisionCircleLineCount;
    NSMutableArray *arraysOfCellsAtDistances;      // NSArray<NSarray>  (an array of arrays of HexGridIndexPaths)  arraysOfCells[1] = an array containing all cells that are 1 away from the original cell
}

- (id)initWithRadius:(CGFloat)radius
{
    if (!(self = [self init])) return nil;
    [self setRadius:radius];
    self.layoutPointUp = NO;
    self.edgesWrap = NO;
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    C = radius;
    A = C / 2;
    B = sinf(60.0*M_PI/180.0) * C;
}

- (CGPoint)getHexMidpointForCell:(MADBoardIndexPath *)cell;
{
    return [self getHexMidpointForColumn:cell.column Row:cell.row];
}
- (CGPoint)getHexMidpointForColumn:(NSInteger)x Row:(NSInteger)y;
{
    CGPoint pt = [self getPointRightHexTopLeftPointForColumn:x Row:y];
    if (self.layoutPointUp) {
        pt.x += B;
        pt.y += A + C/2;
    } else {
        pt.x += A + C/2;
        pt.y += B;
    }
    return pt;
}
- (CGPoint)getHexTopLeftPointForColumn:(NSInteger)x Row:(NSInteger)y;
{
    if (self.layoutPointUp) {
        return [self getPointUpHexTopLeftPointForColumn:x Row:y];
    } else {
        return [self getPointRightHexTopLeftPointForColumn:x Row:y];
    }
}
- (CGPoint)getPointRightHexTopLeftPointForColumn:(NSInteger)x Row:(NSInteger)y;
{
    bool xIsOdd = (x % 2);
    CGFloat hexx = x * (A + C);
    CGFloat hexy = y * (B + B) + (xIsOdd? B : 0);
    return CGPointMake(hexx, hexy);
}
- (CGPoint)getPointUpHexTopLeftPointForColumn:(NSInteger)x Row:(NSInteger)y;
{
    bool yIsOdd = (y % 2);
    CGFloat hexx = x * (B + B) + (yIsOdd? B : 0);
    CGFloat hexy = y * (A + C);
    return CGPointMake(hexx, hexy);
}


// make sure a direction is one of the known directions (allow direction to wrap around in a circle)
- (NSInteger)normalizeDir:(NSInteger)dir
{
    if (self.layoutPointUp) {
        if (dir > 500) {
            NSLog(@"WARNING: direction(%i) appears to be a LayoutPointSide direction", dir);
        }
        while (dir < DIR_WEST) dir += 6;
        while (dir > DIR_EAST+2) dir -= 6;
    } else {
        if (dir < 500) {
            NSLog(@"WARNING: direction(%i) appears to be a LayoutPointUp direction", dir);
        }
        while (dir < DIR_NORTH) dir += 6;
        while (dir > DIR_SOUTH+2) dir -= 6;
    }
    return dir;
}

// make sure a position is on the screen (handle wrapping edges, iff needed)
- (MADBoardIndexPath*)normalizeIndexPath:(MADBoardIndexPath*)indexPath
{
    if (!self.edgesWrap)
        return indexPath;
    BOOL changedPath = NO;
    NSInteger column = indexPath.column;
    while (column < 0)
    {
        column += self.width;
        changedPath = YES;
    }
    while (column >= self.width)
    {
        column -= self.width;
        changedPath = YES;
    }
    NSInteger row = indexPath.row;
    while (row < 0)
    {
        row += self.height;
        changedPath = YES;
    }
    while (row >= self.height)
    {
        row -= self.height;
        changedPath = YES;
    }
    if (!changedPath)
        return indexPath;
    MADBoardIndexPath *newPath = [[MADBoardIndexPath alloc] initForColumn:column forRow:row];
    return newPath;
}

- (bool)indexPathOnBoard:(MADBoardIndexPath*)indexPath
{
    if (self.edgesWrap) return YES;
    if (indexPath.column < 0 || indexPath.column >= self.width) return NO;
    if (indexPath.row < 0 || indexPath.row >= self.height) return NO;
    return YES;
}


- (MADBoardIndexPath*)moveIndexPath:(MADBoardIndexPath*)indexPath inDir:(NSInteger)dir
{
    NSInteger column = indexPath.column;
    NSInteger row = indexPath.row;
    dir = [self normalizeDir:dir];
    if (self.layoutPointUp)
    {
        BOOL isOddRow = (row & 1);
        switch(dir)
        {
            case DIR_WEST:
                column--;
                break;
            case DIR_EAST:
                column++;
                break;
            case DIR_WEST+1:               // DIR_NORTHWEST:
                row--;
                if (!isOddRow) column--;
                break;
            case DIR_WEST+2:               // DIR_NORTHEAST:
                row--;
                if (isOddRow) column++;
                break;
            case DIR_EAST+1:               // DIR_SOUTHEAST:
                row++;
                if (isOddRow) column++;
                break;
            case DIR_EAST+2:               // DIR_SOUTHWEST:
                row++;
                if (!isOddRow) column--;
                break;
            default:
                NSLog(@"ERROR: direction(%i) unknown value", dir);
                break;
        }
    }
    else
    {
        BOOL isOddCol = (column & 1);
        switch (dir)
        {
            case DIR_NORTH:
                row--;
                break;
            case DIR_NORTH+1:              // DIR_NORTHEAST
                column++;
                if (!isOddCol) row--;
                break;
            case DIR_NORTH+2:              // DIR_SOUTHEAST
                column++;
                if (isOddCol) row++;
                break;
            case DIR_SOUTH:
                row++;
                break;
            case DIR_SOUTH+1:              // DIR_SOUTHWEST
                column--;
                if (isOddCol) row++;
                break;
            case DIR_SOUTH+2:
                column--;
                if (!isOddCol) row--;
                break;
            default:
                NSLog(@"ERROR: direction(%i) unknown value", dir);
                break;
        }
    }
    MADBoardIndexPath *newPath = [[MADBoardIndexPath alloc] initForColumn:column forRow:row];
    return [self normalizeIndexPath:newPath];
};

- (bool)isCell:(MADBoardIndexPath*)cellA touchingCell:(MADBoardIndexPath*)cellB
{
    NSInteger distRow = abs(cellA.row - cellB.row);
    NSInteger distCol = abs(cellA.column - cellB.column);
    if (distRow <= 1 && distCol <= 1) {
        NSInteger dir = (self.layoutPointUp? DIR_WEST : DIR_NORTH);
        for(int n=0; n<6; n++, dir++) {
            MADBoardIndexPath *ip = [self moveIndexPath:cellA inDir:dir];
            if (ip.column == cellB.column && ip.row == cellB.row) {
                return YES;     // cell's are exactly 1 away from each other
            }
        }
    }
    return NO;
}

// Note: this routine is NOT fast
- (NSInteger)distanceFromCell:(MADBoardIndexPath*)cellA toCell:(MADBoardIndexPath*)cellB;
{
    if (cellA.row == cellB.row && cellA.column == cellB.column)
    {   // exact same cell
        return 0;
    }
    NSInteger maxDistance = self.width + self.height;
    for(NSInteger distance=1; distance < maxDistance; distance++)
    {
        NSArray* cellsAtDistance = [self allCellsDistanceOf:distance fromCell:cellA];
        if ([cellsAtDistance containsObject:cellB]) {
            return distance;
        }
    }
    return maxDistance;
}

- (NSArray*)allCellsDistanceOf:(NSInteger)away fromCell:(MADBoardIndexPath*)indexPath
{
    NSMutableArray* cells = [[NSMutableArray alloc] initWithCapacity:6];
    if (away > 0) {
        NSInteger dir;
        MADBoardIndexPath* ip;
        dir = (self.layoutPointUp? DIR_WEST : DIR_NORTH);
        // move N cells from the center
        ip = [self moveIndexPath:indexPath inDir:dir];
        for(int n=1; n<away; n++) {
            ip = [self moveIndexPath:ip inDir:dir];
        }
        // head around in a hex-circle
        dir += 2;
        for(int nn=0; nn<6; nn++, dir++) {
            for(int n=0; n<away; n++) {
                [cells addObject:ip];
                ip = [self moveIndexPath:ip inDir:dir];
            }
        }
    }
    return cells;
}

//
//#pragma mark - vision method to find all visible cells within a given distance from a given cell
//
//- (NSSet *)visibleCellsFrom:(MADBoardIndexPath*)cell visionDistance:(NSInteger)distance;
//{
//    __block NSMutableSet *visibleCells = [[NSMutableSet alloc] initWithCapacity:30];
//    [self enumerateVisibleCellsFrom:cell visionDistance:distance usingBlock:^(MADBoardIndexPath *indexPath, BOOL *stop) {
//        [visibleCells addObject:indexPath];
//    }];
//    return visibleCells;
//}
//
//- (void)enumerateVisibleCellsFrom:(MADBoardIndexPath*)cell visionDistance:(NSInteger)distance usingBlock:(void (^)(MADBoardIndexPath* indexPath, BOOL *stop))block;
//{
//    debugCollisionCircleLineCount = 0;
//    BOOL stop = NO;
//    block(cell, &stop);     // can see starting cell
//    if (stop) return;
//    [self generateArraysOfCellsWithMaxDistance:distance fromCell:(MADBoardIndexPath*)cell];
//    for(MADBoardIndexPath *cellTouching in arraysOfCellsAtDistances[1])
//    {   // can see all cells that are exactly 1 away (touching)
//        block(cellTouching, &stop);
//        if (stop) return;
//    }
//    for(NSInteger dist = 2; !stop && dist<=distance; dist++)
//    {   // check every cell a distance of "dist" away from the cell -- check if each cell is visible
//        NSArray *cellsDistAway = arraysOfCellsAtDistances[dist];
//        for(MADBoardIndexPath *cellB in cellsDistAway)
//        {   // check if vision between "cell" and "cellB"
//            if ([self checkVisibilityFromCell:cell toCell:cellB visionDistance:distance])
//            {
//                block(cellB, &stop);
//                if (stop) break;
//            }
//        }
//    }
//}
//
//- (void)generateArraysOfCellsWithMaxDistance:(NSInteger)distance fromCell:(MADBoardIndexPath*)cell;
//{   // generate all "circles of cells" given a distance from a cell
//    arraysOfCellsAtDistances = [[NSMutableArray alloc] initWithCapacity:distance+1];
//    arraysOfCellsAtDistances[0] = [NSArray arrayWithObject:cell];                           // [0] = collection of all cells that are "zero" away from the cell (which contains just the cell itself)
//    for(NSInteger dist = 1; dist<=distance; dist++)
//    {
//        NSArray *cellsAtDistanceN = [self allCellsDistanceOf:dist fromCell:cell];
//        arraysOfCellsAtDistances[dist] = cellsAtDistanceN;
//    }
//}
//
//- (bool)checkVisibilityFromCell:(MADBoardIndexPath *)cellA toCell:(MADBoardIndexPath *)cellB visionDistance:(NSInteger)distance;
//{
//    CGFloat circleRadius = C * 0.87;    // try to get a circle that touches the hex-edges
//    CGFloat visionLeft = distance;      // amount of vision left for seeing
//    CGFloat percent = 0.25;             // amount from center of hex to edge of hex to create the middle-rectangle that must be clear for vision to be ok
//    CGPoint aPoint = [self getHexMidpointForColumn:cellA.column Row:cellA.row];
//    CGPoint bPoint = [self getHexMidpointForColumn:cellB.column Row:cellB.row];
//    // generate two lines (aPnt1 -> bPnt1, and aPnt2 -> bPnt2) that are parallel to main line
//    MADMutableVector *vector = [[MADMutableVector alloc] initPointA:aPoint pointB:bPoint];
//    vector.length = C * percent;    // 0.5 means: 1/2 away from center toward edge of hex
//    vector.angle -= M_PI / 2;       // 90-degrees
//    CGPoint aPnt1 = [vector applyToPoint:aPoint];
//    CGPoint bPnt1 = [vector applyToPoint:bPoint];
//    vector.angle += M_PI;           // other 90-degrees
//    CGPoint aPnt2 = [vector applyToPoint:aPoint];
//    CGPoint bPnt2 = [vector applyToPoint:bPoint];
//    // generate the angle of the line between cellA and cellB (which is used to know where to start looking for the cell that intersects the line)
//    CGFloat angleRads = ([MADLines angleInRadsOfLineBetweenPointA:aPoint pointB:bPoint]);
//    CGFloat angleDegs = [MADLines positiveDegrees:[MADLines degreesFromRads:angleRads]-90];
//    CGFloat asPercent = angleDegs / 360;
//    
//    // interate over every distance from 1-away-from-cellA to max-distance-away-from-cellA
//    for(NSInteger dist=1; dist<distance; dist++)
//    {   // check if both lines can see from cellA dist away
//        NSArray *cellsDistAway = arraysOfCellsAtDistances[dist];
//        bool line1OK = NO;          // YES means aPnt1-to-bPnt1 is visible
//        bool line2OK = NO;          // YES means aPnt2-to-bPnt2 is visible
//        CGFloat line1Cost = 0;
//        CGFloat line2Cost = 0;
//        NSInteger nextIndex = cellsDistAway.count * -asPercent;
//        NSInteger indexDirection = -1;
//        NSInteger indexDistance = 1;
//        int maxTimeToTry = 3;//cellsDistAway.count;
//        for(int nTimes=0; nTimes<maxTimeToTry && (!line1OK || !line2OK); nTimes++)
//        {
//            MADBoardIndexPath *cell = [cellsDistAway objectAtWrapIndex:nextIndex];
//            nextIndex += indexDirection * indexDistance;        // select the next nearest item to original index
//            indexDirection = -indexDirection;                   // try the item theother side of the original index
//            indexDistance++;                                    // distance is further each time
//            // check if can see from "cellA" to "cell"
//
//            
//            CGPoint cellPoint = [self getHexMidpointForCell:cell];
//            if (!line1OK)
//            {   // haven't found a cell that "a" line sees through (yet)
//                debugCollisionCircleLineCount++;
//                if ([MADCollisionDetect detectCollisionCircleAt:cellPoint radius:circleRadius lineStart:aPnt1 lineEnd:bPnt1])
//                {   // Note: "cell" is between cellA and cellB -- unit must be able to see through this cell for cellB to be visible
//                    line1Cost = 1;
//                    if (self.delegate)
//                    {
//                        line1Cost += [self.delegate seeThroughCell:cell];
//                        if (line1Cost > visionLeft)
//                        {   // can't see through this cell -- can't see
//                            return NO;
//                        }
//                    }
//                    line1OK = YES;
//                }
//            }
//            if (!line2OK)
//            {   // haven't found a cell that "a" line sees through (yet)
//                debugCollisionCircleLineCount++;
//                if ([MADCollisionDetect detectCollisionCircleAt:cellPoint radius:circleRadius lineStart:aPnt2 lineEnd:bPnt2])
//                {   // Note: "cell" is between cellA and cellB -- unit must be able to see through this cell for cellB to be visible
//                    line2Cost = 1;
//                    if (self.delegate)
//                    {
//                        line2Cost += [self.delegate seeThroughCell:cell];
//                        if (line2Cost > visionLeft)
//                        {
//                            return NO;
//                        }
//                    }
//                    line2OK = YES;
//                }
//            }
//        }
//        // reduce "visionLeft"
//        NSInteger intLine1 = line1Cost;
//        CGFloat percentLine1 = line1Cost - intLine1;
//        NSInteger intLine2 = line2Cost;
//        CGFloat percentLine2 = line2Cost - intLine2;
//        visionLeft -= MAX(intLine1, intLine2);
//        visionLeft -= visionLeft * MAX(percentLine1, percentLine2);
//        if (visionLeft < 0)
//        {   // too much obscuring stuff between cellA and cellB -- not visible
//            return NO;
//        }
//    }
//    return YES;
//}

@end


/*
 See: http://www.rdwarf.com/lerickson/hex/index.html
 

 C = radius (the length of one of the six sides of the hex
 A = 1/2 * C
 B = sin(60) * C

 
 .   +
 . / | \
 .   |    \    C
 .   | A     \
 .   |          \
 .   |      B      \
 .   + - - - - - - - -+
 .                    |
 .                    |

 
 .               C
 .        + - - - - - - +
 .       /|              \
 .      / |               \
 .   C /  |                \  C
 .    /   | B               \
 .   /    |                  \
 .  /     |                   \
 . +------+                    +
 .  \  A                      /
 .   \                       /
 .
 
 
 
 
*/


