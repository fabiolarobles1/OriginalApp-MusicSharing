//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsPlayerVC.h"
#import "AppDelegate.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
@import Parse;

static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";


@interface DetailsPlayerVC ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;


@end

@implementation DetailsPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.delegate.appRemote connect];
    
    [self loadDetails];
    
    
    NSLog(@"Spofify APP instaled? %d", [self.delegate.sessionManager isSpotifyAppInstalled]);
    
}
-(void)loadDetails{
    
    self.backgroundImageView.file = self.post.image;
    [self.backgroundImageView loadInBackground];
    self.backgroundImageView.alpha=0.5;
    NSString *song = self.post.musicLink;
    song = [song substringWithRange:NSMakeRange(31, 22)];
    
    [[SpotifyManager shared] getSong:song accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
        NSArray *artist = song[@"artists"];
        NSDictionary *insideArtists = artist[0];
        NSDictionary *songName = song[@"name"];
        NSDictionary *album = song[@"album"];
        NSDictionary *albumName = album[@"name"];
        NSArray *albumImage =album[@"images"];
        NSDictionary *image = albumImage[0];
        NSString *imageURL = [NSString stringWithFormat:@"%@", image[@"url"]];
        self.artistLabel.text = [@"ARTIST: "  stringByAppendingFormat:@"%@",insideArtists[@"name"]];
        [self.albumImageView setImageWithURL:[NSURL URLWithString:imageURL]];
        self.albumLabel.text = [@"ALBUM: " stringByAppendingFormat:@"%@",albumName];
        self.songLabel.text = [@"SONG: " stringByAppendingFormat:@"%@",songName];
        
    }];
    
}


- (IBAction)didTapPlayButton:(id)sender {
    [self.delegate.appRemote connect];
    NSString *song = self.post.musicLink;
    song = [song substringWithRange:NSMakeRange(31, 22)];
    NSString *songURI = [@"spotify:track:" stringByAppendingString:song];
    NSLog(@"Song URI: %@", songURI);
    [self playSong:songURI];
    
    //  NSLog(@"Connected to Spotify? %d", [self.delegate.appRemote isConnected]);
}

-(void)playSong:(NSString *)songURI{
    [self.delegate.appRemote connect];
    
    [self.delegate.appRemote.playerAPI play:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
        NSLog(@"Playing song.");
    }];
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
