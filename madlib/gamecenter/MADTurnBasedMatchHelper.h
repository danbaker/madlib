//
//  MADTurnBasedMatchHelper.h
//  MAD
//
//  Created by Dan Baker on 1/11/13.
//
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol MADTurnBasedMatchHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;     // user creating a new game
- (void)layoutMatch:(GKTurnBasedMatch *)match;      // user selected a match, not user's turn
- (void)takeTurn:(GKTurnBasedMatch *)match;         // user selected a match, IS user's turn
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end


@interface MADTurnBasedMatchHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate>

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) GKTurnBasedMatch *currentMatch;
@property (nonatomic, weak) id<MADTurnBasedMatchHelperDelegate> delegate;
@property (nonatomic, weak, readonly) NSString* userAlias;

+ (MADTurnBasedMatchHelper *)sharedInstance;
- (void) authenticateLocalUser;
- (void) findMatchWithMinPlayers:(int)minPlayers
                      maxPlayers:(int)maxPlayers
                  viewController:(UIViewController *)viewController;
- (void) turnBasedMatch:(GKTurnBasedMatch *)match
 endMyTurnWithMatchData:(NSData*)data
        completionBlock:(void (^)(NSError*))block;

- (NSString*)debug_deleteAllGamesFromGameCenter;

@end
