//
//  MADTurnBasedMatchHelper.m
//  MAD
//
//  Created by Dan Baker on 1/11/13.
//
//

#import "MADTurnBasedMatchHelper.h"

@interface MADTurnBasedMatchHelper ()

@property (nonatomic, assign) BOOL userAuthenticated;
@property (nonatomic, retain) UIViewController *presentingViewController;


@end

@implementation MADTurnBasedMatchHelper

#pragma mark Initialization

static MADTurnBasedMatchHelper *sharedHelper = nil;
+ (MADTurnBasedMatchHelper *) sharedInstance
{
    if (!sharedHelper)
    {
        sharedHelper = [[MADTurnBasedMatchHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable
{   // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init
{
    if ((self = [super init]))
    {
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (self.gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChangedNotification)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChangedNotification
{   // got a notification that authentication changed (? logged in or out ?)
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !self.userAuthenticated)
    {
        NSLog(@"Authentication changed: player authenticated.");
        self.userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && self.userAuthenticated)
    {
        NSLog(@"Authentication changed: player not authenticated");
        self.userAuthenticated = FALSE;
    }
}

- (NSString*)userAlias
{
    if (self.userAuthenticated)
    {
        return [[GKLocalPlayer localPlayer] alias];
    }
    return nil;
}

#pragma mark User functions

- (void)authenticateLocalUser
{   // Make sure the local user has authenticated to Game Center (at least give them the chance)
    if (!self.gameCenterAvailable)
    {   // no GameCenter available
        return;
    }
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO)
    {   // request to authenticate (we will get a notification when they login)
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
{   // Show the GameCenter view with all their games, and a [+] button to create a new game
    if (!self.gameCenterAvailable) return;
    
    self.presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [self.presentingViewController presentModalViewController:mmvc animated:YES];
}


#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match
{   // is fired when the user selects a match from the list of matches. This match could be one where it’s currently our player’s turn, where it’s another player’s turn, or where the match has ended.
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    // user selected a game, or created a game (? where it is now user's turn ?)
    self.currentMatch = match;
    // NOTE: match.matchID = (NSString)("0x092b8b30 ac73e351-3b81-474a-9399-4bbbb8a97378")
    //          .matchData =
    //          .matchDataMaximumSize = (NSInteger) (64K)
    //          .currentParticipant
    //          .message = (NSString) (shown in GameCenter about the match, maybe Battle name)
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL)
    {   // It's a new game (user needs to set up game and take their turn)
        [self.delegate enterNewGame:match];
    }
    else
    {   // It's an existing game
        NSString *localPlayerID = [GKLocalPlayer localPlayer].playerID;
        if ([match.currentParticipant.playerID isEqualToString:localPlayerID])
        {   // It's your turn!
            [self.delegate takeTurn:match];
        }
        else
        {   // It's not your turn, just display the game state.
            [self.delegate layoutMatch:match];
        }
    }
}

-(void)turnBasedMatchmakerViewControllerWasCancelled: (GKTurnBasedMatchmakerViewController *)viewController
{   // will fire when the cancel button is clicked.
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error
{   // Error. maybe network issue
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match
{   // method is fired when a player swipes a match (while it’s their turn) and quits it. 
    NSLog(@"playerquitforMatch, %@, %@", match, match.currentParticipant);
}

- (void)turnBasedMatch:(GKTurnBasedMatch *)match endMyTurnWithMatchData:(NSData*)data completionBlock:(void (^)(NSError*))block
{   // Current Player finished their turn with "data".  This will send the data to GameCenter so other player can play.
    // Note: "blocK" is called with an NSError (nil or set) after GameCenter responds. Should have spinner till block is called.
    NSUInteger totalParticipants = [match.participants count];
    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % totalParticipants;
    nextParticipant = [match.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [match.participants count]; i++) {
        nextParticipant = [match.participants objectAtIndex:((currentIndex + 1 + i) % totalParticipants)];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit)
        {
            break;
        }
    }
    
    [match endTurnWithNextParticipant:nextParticipant
                            matchData:data
                    completionHandler:^(NSError *error) {
                                if (error) {
                                    NSLog(@"ERROR: %@", error);
                                    //statusLabel.text = @"Oops, there was a problem.  Try that again.";
                                } else {
                                    NSLog(@"Turn over, and sent to GameCenter");
                                    //statusLabel.text = @"Your turn is over.";
                                    //textInputField.enabled = NO;
                                }
                                block(error);
                            }];
    NSLog(@"Turn sent to GameCenter, waiting for response: %@, %@", data, nextParticipant);
}


#pragma mark - Debug Methods

- (NSString*)debug_deleteAllGamesFromGameCenter;
{
    NSMutableString *msg = [[NSMutableString alloc] init];
    [msg appendString:@"Deleting All GameCenter Games for YOU\n"];
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:
     ^(NSArray *matches, NSError *error)
     {
         for (GKTurnBasedMatch *match in matches)
         {
             [msg appendFormat:@"..Match %@\n", match.matchID];
             [match removeWithCompletionHandler:
              ^(NSError *error)
              {
                  if (error)
                  {
                      [msg appendFormat:@".. ERROR: %@\n", error];
                  }
              }];
         }
     }];
    NSLog(@"%@", msg);
    return msg;
}


@end
