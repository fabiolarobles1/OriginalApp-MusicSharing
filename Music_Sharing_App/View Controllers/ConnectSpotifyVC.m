//
//  ConnectSpotifyVCViewController.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ConnectSpotifyVC.h"
static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";

@interface ConnectSpotifyVC ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ConnectSpotifyVC

- (void)viewDidLoad {
    
    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL: [NSURL URLWithString:spotifyRedirectURLString]];
    
    // Set these url's to your backend which contains the secret to exchange for an access token
    self.configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
    self.configuration.tokenRefreshURL = [NSURL URLWithString:tokenRefreshURLString];
    
    //will resume playback of user's last track
    self.configuration.playURI = @"";
    
    
    // The session manager lets you authorize, get access tokens, and so on.
    self.sessionManager = [[SPTSessionManager alloc]initWithConfiguration:self.configuration delegate:self];
    
    
    [super viewDidLoad];

}
- (IBAction)didTapConnect:(id)sender {
    
    NSLog(@"Spotify AVAILABLE: %d", [self.sessionManager isSpotifyAppInstalled]);
    
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    
    if([self.sessionManager isSpotifyAppInstalled]){
        //invoke authorization screen
        SPTScope  requestedScope = SPTAppRemoteControlScope;
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
        NSLog(@"SESSION: %@", self.sessionManager.session);
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
    }
  
}

//to go login directly if not app TEST ONLY!!!!!!
- (IBAction)didTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:dismissAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


//For when app is not installed
#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
    NSLog(@"success: %@", session);
    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
                                  message:session.description
                              buttonTitle:@"Nice"];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"fail: %@", error);
    [self presentAlertControllerWithTitle:@"Authorization Failed"
                                  message:error.description
                              buttonTitle:@"Bummer"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"renewed: %@", session);
    [self presentAlertControllerWithTitle:@"Session Renewed"
                                  message:session.description
                              buttonTitle:@"Sweet"];
}

@end
