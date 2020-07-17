//
//  ConnectSpotifyVCViewController.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ConnectSpotifyVC.h"
#import "SpotifyManager.h"
static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";

@interface ConnectSpotifyVC ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (assign, nonatomic) BOOL successSession;

@end

@implementation ConnectSpotifyVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.manager = [SpotifyManager shared];
 //   self.configuration = self.manager.configuration;
    // The session manager lets you authorize, get access tokens, and so on.
    self.sessionManager = [[SPTSessionManager alloc]initWithConfiguration:self.configuration delegate:self];
   
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
        SPTScope scopes = SPTPlaylistReadPrivateScope | SPTPlaylistModifyPublicScope | SPTPlaylistModifyPrivateScope |SPTUserFollowReadScope | SPTUserFollowModifyScope | SPTUserLibraryReadScope | SPTUserLibraryModifyScope | SPTUserTopReadScope | SPTAppRemoteControlScope;
        SPTScope  requestedScope = SPTAppRemoteControlScope | SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
        
    }else{
        SPTScope  requestedScope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
        
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
            [self performSegueWithIdentifier:@"toLogin" sender:nil];
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
    self.sessionManager.session = session;
  //  self.manager.sessionManager.session = session;
    self.successSession = YES;
    [self presentAlertControllerWithTitle:@"Authorization Succesful"
                                  message:@"Continue to App"//session.description
                              buttonTitle:@"Play"];
    
    NSLog(@"FINALLY, %@", self.sessionManager.session);
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
