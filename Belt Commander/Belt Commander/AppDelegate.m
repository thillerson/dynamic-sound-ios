//
//  AppDelegate.m
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "PdAudioController.h"

@interface AppDelegate ()

@property(nonatomic, strong) PdAudioController *pdAudioController;

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.pdAudioController = [PdAudioController new];
    PdAudioStatus status = [self.pdAudioController configurePlaybackWithSampleRate:44100 numberChannels:2 inputEnabled:NO mixingEnabled:NO];
    if (status == PdAudioError) {
        // handle audio initialization error - probably by doing nothing.
    } else {
        self.pdInterface = [PdInterface new];
        [self.pdInterface bullet];
    }

    return YES;
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    UIWindow* window = [application.windows objectAtIndex:0];
    
    RootViewController* rvc = (RootViewController*)[window rootViewController];
    Facebook* facebook = [rvc facebook];
    
    return [facebook handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIWindow* window = [application.windows objectAtIndex:0];
    RootViewController* rvc = (RootViewController*)[window rootViewController];
    [rvc doPause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
