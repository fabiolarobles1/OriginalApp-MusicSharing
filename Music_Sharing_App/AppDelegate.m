//
//  AppDelegate.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "ViewController.h"

static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";


@interface AppDelegate ()
@property(nonatomic, strong) ViewController *rootViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //Initializing Parse and setting server
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"musicSharingApp-Fab";
        configuration.server = @"http://musicsharingapp.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [ViewController new];
    self.rootViewController = [ViewController new];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
 

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    [self.rootViewController.sessionManager application:application openURL:URL options:options];
    NSLog(@"%@ %@", URL, options);
    return YES;
}


#pragma mark - SPTSeeionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
    NSLog(@"success: %@", session);
}

-(void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"fail: %@", error);
}

-(void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"renewed: %@", session);
}

@end
