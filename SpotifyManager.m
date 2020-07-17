//
//  SpotifyManager.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SpotifyManager.h"

static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";

@implementation SpotifyManager

+ (instancetype) shared{
    static dispatch_once_t once;
    static SpotifyManager *sharedObject = nil;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
        
        sharedObject.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL: [NSURL URLWithString:spotifyRedirectURLString]];
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        sharedObject.configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
        sharedObject.configuration.tokenRefreshURL = [NSURL URLWithString:tokenRefreshURLString];
        
        //will resume playback of user's last track
        sharedObject.configuration.playURI = @"";
        
        // The session manager lets you authorize, get access tokens, and so on.
       
    });
    return sharedObject;
}


 - (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
     NSLog(@"success: %@", session);
 //    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
 //                                  message:session.description
 //                              buttonTitle:@"Nice"];
 }

 - (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
     NSLog(@"fail: %@", error);
 //    [self presentAlertControllerWithTitle:@"Authorization Failed"
 //                                  message:error.description
 //                              buttonTitle:@"Bummer"];
 }

 - (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"renewed: %@", session);
 //    [self presentAlertControllerWithTitle:@"Session Renewed"
 //                                  message:session.description
 //                              buttonTitle:@"Sweet"];
 }
     

@end
