//
//  AppDelegate.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";



@interface AppDelegate ()<SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //Initializing Parse and setting server
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"musicSharingApp-Fab";
        configuration.server = @"http://musicsharingapp.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    [self configurate];
    [self initiateSession];
    NSLog(@"DONE");

    return YES;
}
-(void)configurate{
    self.configuration =[[SPTConfiguration alloc]initWithClientID:spotifyClientID redirectURL:[NSURL URLWithString:spotifyRedirectURLString]];
    self.configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
    self.configuration.tokenRefreshURL = [NSURL URLWithString:tokenRefreshURLString];
    self.configuration.playURI = @"";
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self;
}

-(void)initiateSession{
    SPTScope scopes = SPTPlaylistReadPrivateScope | SPTPlaylistModifyPublicScope | SPTPlaylistModifyPrivateScope |SPTUserFollowReadScope | SPTUserFollowModifyScope | SPTUserLibraryReadScope | SPTUserLibraryModifyScope | SPTUserTopReadScope | SPTAppRemoteControlScope;
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:self.configuration delegate:self];
    [self.sessionManager initiateSessionWithScope:scopes options:SPTDefaultAuthorizationOption];
    
}
// called from AppDelegate
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self.sessionManager application:app openURL:url options:options];
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
-(void)applicationWillResignActive:(UIApplication *)application{
    if(self.appRemote.isConnected){
        [self.appRemote disconnect];
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    if(self.appRemote.connectionParameters.accessToken){
        [self.appRemote connect];
    }
}

#pragma mark - SPTSessionManagerDelegate
-(void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"Renewed: %@", session);
}

-(void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
    NSLog(@"Success: %@", session);
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect];
}

-(void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
#pragma mark - SPTAppRemoteDelegate
- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote{
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error{
    NSLog(@"Error connecting to Spotify app %@",error);
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
}


-(void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState{
    NSLog(@"Track name: %@" , playerState.track.name);
}

@end
