//
//  ViewController.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ViewController.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "ConnectButton.h"
#import "ConnectView.h"

static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";



@interface ViewController ()<SPTSessionManagerDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:spotifyClientID
                                                                      redirectURL:[NSURL URLWithString:spotifyRedirectURLString]];

    // Set these url's to your backend which contains the secret to exchange for an access token
    // You can use the provided ruby script spotify_token_swap.rb for testing purposes
    configuration.tokenSwapURL = [NSURL URLWithString: @"http://localhost:1234/swap"];
    configuration.tokenRefreshURL = [NSURL URLWithString: @"http://localhost:1234/refresh"];
    configuration.playURI = @"";

    /*
     The session manager lets you authorize, get access tokens, and so on.
     */
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                    delegate:self];
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
//     self.configuration.tokenRefreshURL = [NSURL URLWithString:tokenSwapURLString];
//     self.configuration.playURI = @"";
//
//     self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:[NSURL URLWithString:spotifyRedirectURLString]];
//
//     SPTScope requestedScope = SPTAppRemoteControlScope;
//     [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
}
//
//
//- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
//    NSLog(@"success: %@", session);
//}
//
//-(void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"fail: %@", error);
//}
//
//-(void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
//    NSLog(@"renewed: %@", session);
//}
- (void)didTapAuthButton:(ConnectButton *)sender
{
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;

    /*
     Start the authorization process. This requires user input.
     */
    if (@available(iOS 11, *)) {
        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
                                  message:session.description
                              buttonTitle:@"Nice"];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    [self presentAlertControllerWithTitle:@"Authorization Failed"
                                  message:error.description
                              buttonTitle:@"Bummer"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Session Renewed"
                                  message:session.description
                              buttonTitle:@"Sweet"];
}

#pragma mark - Set up view

- (void)loadView
{
    ConnectView *view = [ConnectView new];
    [view.connectButton addTarget:self action:@selector(didTapAuthButton:) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            buttonTitle:(NSString *)buttonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:dismissAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    });
}

@end

