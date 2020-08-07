//
//  SongInfoVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 8/1/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SongInfoVC.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import <ChameleonFramework/Chameleon.h>
#import "ComposeVC.h"

@interface SongInfoVC ()
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@end

@implementation SongInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *tealBlue = [UIColor colorWithHexString:@"09F0FA"];
    self.backgroudView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.backgroudView.frame
                                                               andColors:@[[UIColor colorWithComplementaryFlatColorOf:tealBlue], tealBlue]];

    self.addToSpotifyButton.layer.cornerRadius = self.addToSpotifyButton.frame.size.height/2;
    
    if(self.post){
        [self setWithPost:self.post];
        [self.playButton setHidden:YES];
    }else{
        [self.playButton setHidden:NO];
        [self setWithInfo:self.senderCell.songname artist:self.senderCell.artist album:self.senderCell.album songURI:self.senderCell.songURI albumURLString:self.senderCell.albumURLString];
    }
    
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate.appRemote connect];
}


-(void)setWithPost:(Post *)post{
    [self.albumCoverImageView setImageWithURL:[NSURL URLWithString:post.albumCoverURLString]];
    self.songNameLabel.text = [@"Song: " stringByAppendingString:post.songName];
    self.artistLabel.text = [@"Artist: " stringByAppendingString:post.artist];
    self.albumLabel.text = [@"Album: " stringByAppendingString:post.album];
}


- (IBAction)didTapAddToSpotify:(id)sender {
    if(self.post){
        [self addToSpotify:self.post.songURI];
    }else{
        [self addToSpotify:self.senderCell.songURI];
    }
    
    
}
-(void)addToSpotify:(NSString *)songURI{
    [self.appDelegate.appRemote.userAPI addItemToLibraryWithURI:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"Error adding song: %@", error.description);
        }else{
            //show notification on screen
            NSLog(@"Added song to library");
        }
    }];
    
}


- (IBAction)didTapPlayButton:(id)sender {
    [self.playButton setSelected:!self.playButton.isSelected];
    [self.appDelegate.appRemote connect];
    if(self.playButton.isSelected){
    [self.appDelegate.appRemote.playerAPI play:self.songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
    }];
    }else{
        [self.appDelegate.appRemote.playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            
        }];
    }
}


-(void)setWithInfo:(NSString *)songname
        artist:(NSString *)artist
         album:(NSString *)album
        songURI:(nonnull NSString *)URI
    albumURLString:(NSString *)albumURLString{
    
    [self.albumCoverImageView setImageWithURL:[NSURL URLWithString:albumURLString]];
       self.songNameLabel.text = [@"Song: " stringByAppendingString:songname];
       self.artistLabel.text = [@"Artist: " stringByAppendingString:artist];
       self.albumLabel.text = [@"Album: " stringByAppendingString:album];
        self.songURI = URI;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]isEqualToString:@"toComposeSegue"]){
        
        UINavigationController *navigationController =[segue destinationViewController];
        ComposeVC *composeViewController = (ComposeVC *) navigationController.topViewController;
        composeViewController.songURL = self.songSpotifyURL;
    }
}


@end
