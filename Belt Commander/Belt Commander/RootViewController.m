//
//  RootViewController.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FBConnect.h"
#import <Twitter/Twitter.h>


@implementation RootViewController


-(void)gameStarted:(BeltCommanderController*)aBeltCommanderController{
    isPlaying = YES;
}
-(void)gameOver:(BeltCommanderController*)aBeltCommanderController{
    if (newGameAlertView == nil){
        newGameAlertView = [[UIAlertView alloc] initWithTitle:@"Your Game Is Over." message:@"Play Again?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    }
    [newGameAlertView show];
      
    [self endOfGameCleanup];
}
-(void)endOfGameCleanup{
    isPlaying = NO;
    [self notifyGameCenter];
    [self notifyFacebook];
}

-(void)notifyGameCenter{
    if ([localPlayer isAuthenticated]){
        GKScore* score = [[GKScore alloc] initWithCategory:@"beltcommander.highscores"];
        score.value = [beltCommanderController score];
        
        [score reportScoreWithCompletionHandler:^(NSError *error){
            if (error){
                //handle error
            }
        }];
    }
}
-(void)notifyFacebook{
    if ([facebook isSessionValid]){
        NSString* desc = [[@"I just scored " stringByAppendingFormat:@"%i", [beltCommanderController score]] stringByAppendingString:@" points, on Belt Commander"];
        
        NSString* appLink = @"http://itunes.apple.com/us/app/belt-commander/id460769032?ls=1&mt=8";
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       FB_APP_ID, @"app_id", 
                                       appLink, @"link",
                                       @"Presented by ClayWare Games, LLC", @"caption",
                                       desc, @"description",
                                       @"A new high score!",  @"message",
                                       nil];
        
        [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == pauseGameAlerTView){
        if (buttonIndex == 0) {
            [self endOfGameCleanup];
            [self popViewControllerAnimated:YES];
        } else {
            [beltCommanderController setIsPaused:NO];
        }
    }
    if (alertView == newGameAlertView){
        if (buttonIndex == 0) {
            [beltCommanderController doNewGame: [extrasController gameParams]];
        } else {
            [self popViewControllerAnimated:YES];
        }
    }
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGameCenter];
    [self initFacebook];
    [self initTwitter];
}

-(void)initGameCenter{
    Class gkClass = NSClassFromString(@"GKLocalPlayer");
    
    BOOL iosSupported = [[[UIDevice currentDevice] systemVersion] compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending;
    
    if (gkClass && iosSupported){
        
        localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.authenticated){
                [leaderBoardButton setEnabled:YES];
            } else {
                [leaderBoardButton setEnabled:NO];
            }
        }];
    }
}

-(void)initFacebook{
    facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    facebook.accessToken = [defaults objectForKey:@"AccessToken"];
    facebook.expirationDate = [defaults objectForKey:@"ExpirationDate"];
    
}
-(void)initTwitter{
    [tweetButton setEnabled:[TWTweetComposeViewController canSendTweet]];
}

-(BOOL)handleOpenURL:(NSURL *)url{
    return [facebook handleOpenURL:url];
}


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:facebook.accessToken forKey:@"AccessToken"];
    [defaults setObject:facebook.expirationDate forKey:@"ExpirationDate"];
    [defaults synchronize];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled{
    
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout{
    
}
-(Facebook*)facebook{
    return facebook;
}


- (IBAction)playButtonClicked:(id)sender {
    [self pushViewController:beltCommanderController animated:YES];
    [beltCommanderController doNewGame: [extrasController gameParams]];
}

- (IBAction)facebookButtonClicked:(id)sender {
    NSMutableArray* permissions = [NSMutableArray new];
    [permissions addObject: @"publish_stream"];
    [permissions addObject:@"publish_checkins"];
    [permissions addObject:@"user_about_me"];
    
    [facebook authorize:permissions];
}

- (IBAction)leaderBoardClicked:(id)sender {
        GKLeaderboardViewController* leaderBoardController = [[GKLeaderboardViewController alloc] init];
        leaderBoardController.category = @"beltcommander.highscores";
        leaderBoardController.leaderboardDelegate = self;
        [self presentModalViewController:leaderBoardController animated:YES];
}
- (IBAction)tweetButtonClicked:(id)sender {
    TWTweetComposeViewController* tweetSheet = [[TWTweetComposeViewController alloc] init];
    
    tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) {
      //view result here  
    };
    
    [tweetSheet setInitialText:@"Check out this iOS game, Belt Commander!"];
    NSURL* url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/belt-commander/id460769032?ls=1&mt=8"];
    [tweetSheet addURL: url];
    
    [self presentModalViewController:tweetSheet animated:YES];
}
- (IBAction)extrasButtonClicked:(id)sender {
    [self pushViewController:extrasController animated:YES];
}
- (IBAction)backFromExtras:(id)sender {
    [self popViewControllerAnimated:YES];
}
- (IBAction)pauseButtonClicked:(id)sender {
    [self doPause];
}
-(void)doPause{
    if (isPlaying){
        [beltCommanderController setIsPaused:YES];
        if (pauseGameAlerTView == nil){
            pauseGameAlerTView = [[UIAlertView alloc] initWithTitle:@"Paused." message:@"Exit Game?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        }
        
        [pauseGameAlerTView show];
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
