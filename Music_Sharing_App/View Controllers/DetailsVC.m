//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsVC.h"
static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";


@interface DetailsVC ()<SPTSessionManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:spotifyClientID redirectURL:[NSURL URLWithString:spotifyRedirectURLString]];
    //will resume playback of user's last track
    
    configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
    configuration.tokenRefreshURL = [NSURL URLWithString:tokenRefreshURLString];
    configuration.playURI = @"";
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration delegate:self];
     SPTScope scopes = SPTPlaylistReadPrivateScope | SPTPlaylistModifyPublicScope | SPTPlaylistModifyPrivateScope |SPTUserFollowReadScope | SPTUserFollowModifyScope | SPTUserLibraryReadScope | SPTUserLibraryModifyScope | SPTUserTopReadScope | SPTAppRemoteControlScope;
     [self.sessionManager initiateSessionWithScope:scopes options:SPTDefaultAuthorizationOption];

    
   
    self.appRemote = [[SPTAppRemote alloc]initWithConfiguration:self.manager.configuration logLevel:SPTAppRemoteLogLevelDebug];
   
    self.appRemote.delegate = self;
    self.appRemote.connectionParameters.accessToken = self.manager.sessionManager.session.accessToken;
    [self.appRemote connect];
    
}
#pragma mark - SPTAppRemoteDelegate

- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote{
  NSLog(@"connected");
    
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if(error){
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}
- (IBAction)didTapPlayButton:(id)sender {
    [self.appRemote.playerAPI skipToNext:^(id  _Nullable result, NSError * _Nullable error) {
        NSLog(@"Are you here?");
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(NSError *)error
{
  NSLog(@"disconnected");
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
{
  NSLog(@"failed");
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState{
  NSLog(@"player state changed");
    NSLog(@"Track name: %@", playerState.track.name);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)sessionManager:(nonnull SPTSessionManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"error: %@", error.description);
}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    NSLog(@"success: %@", session.description);
    self.appRemote.connectionParameters.accessToken = session.accessToken;
       self.appRemote.delegate = self;
       [self.appRemote connect];
}



@end
