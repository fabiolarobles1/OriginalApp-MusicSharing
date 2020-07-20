//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsVC.h"
#import "AppDelegate.h"
#import "Post.h"
static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";


@interface DetailsVC ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;


@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.delegate.appRemote isConnected];
  
    NSLog(@"Spofify APP instaled? %d", [self.delegate.sessionManager isSpotifyAppInstalled]);
   
}


- (IBAction)didTapPlayButton:(id)sender {
    
    NSString *song = self.post.musicLink;
    song = [song substringWithRange:NSMakeRange(31, 22)];
    NSString *songURI = [@"spotify:track:" stringByAppendingString:song];
    NSLog(@"Song URI: %@", songURI);
    [self.delegate.appRemote connect];
    
    [self.delegate.appRemote.playerAPI play:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
         NSLog(@"Playing song.");
    }];

    [[SpotifyManager shared] getSong:song accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
      
    }];

      NSLog(@"Connected to Spotify? %d", [self.delegate.appRemote isConnected]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
