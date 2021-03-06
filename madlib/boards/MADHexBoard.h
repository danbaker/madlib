//
//  MADHexBoard.h
//  HexGrid
//
//  Created by Dan Baker on 11/9/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MADBoardIndexPath;


//@protocol MADHexBoardVisible <NSObject>
//@required
//- (CGFloat)seeThroughCell:(MADBoardIndexPath*)indexPath;
//@end



@interface MADHexBoard : NSObject

//@property (nonatomic, strong) id<MADHexBoardVisible> delegate;
@property (nonatomic, assign) bool layoutPointUp;
@property (nonatomic, assign) bool edgesWrap;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint margin;
@property (nonatomic, assign, readonly) CGSize hexSize;

- (id)initWithRadius:(CGFloat)radius;

- (MADBoardIndexPath*)indexPathForPoint:(CGPoint)point;
- (CGPoint)getHexMidpointForColumn:(NSInteger)x Row:(NSInteger)y;
- (CGPoint)getHexTopLeftPointForColumn:(NSInteger)x Row:(NSInteger)y;
- (NSInteger)normalizeDir:(NSInteger)dir;
- (MADBoardIndexPath*)normalizeIndexPath:(MADBoardIndexPath*)indexPath;
- (MADBoardIndexPath*)moveIndexPath:(MADBoardIndexPath*)indexPath inDir:(NSInteger)dir;
- (NSInteger)distanceFromCell:(MADBoardIndexPath*)cellA toCell:(MADBoardIndexPath*)cellB;
- (NSInteger)distanceFromCell:(MADBoardIndexPath*)cellA toCell:(MADBoardIndexPath*)cellB maximumDistance:(NSInteger)maxDistance;
- (NSArray*)allCellsDistanceOf:(NSInteger)away fromCell:(MADBoardIndexPath*)indexPath;

- (void)enumerateAllCellsWithBlock:(void (^)(NSInteger column, NSInteger row, BOOL * stop))block;
- (NSInteger) directionFromIndexPath:(MADBoardIndexPath*)fromIndexPath toIndexPath:(MADBoardIndexPath*)toIndexPath;


//- (void)enumerateVisibleCellsFrom:(MADBoardIndexPath*)cell visionDistance:(NSInteger)distance usingBlock:(void (^)(MADBoardIndexPath* indexPath, BOOL *stop))block;
//- (NSSet *)visibleCellsFrom:(MADBoardIndexPath*)cell visionDistance:(NSInteger)distance;

@end




//// Point Up-Down ////
#define DIR_WEST 11
//#define DIR_NORTHWEST 12
//#define DIR_NORTHEAST 13
#define DIR_EAST 14
//#define DIR_SOUTHEAST 15
//#define DIR_SOUTHWEST 16

//// Point Left-Right ////
#define DIR_NORTH 1001
//#define DIR_NORTHEAST 1002
//#define DIR_SOUTHEAST 1003
#define DIR_SOUTH 1004
//#define DIR_SOUTHWEST 1005
//#define DIR_NORTHWEST 1006
