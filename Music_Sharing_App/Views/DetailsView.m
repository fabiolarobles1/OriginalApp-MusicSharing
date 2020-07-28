//
//  DetailsView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/21/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsView.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "SpotifyManager.h"
@import Parse;

@interface DetailsView()


@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *songName;

@end

@implementation DetailsView

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self customInit];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self customInit];
    }
    return self;
}

-(void) customInit{
    
    //grabbing xib
    [[NSBundle mainBundle] loadNibNamed:@"DetailsView" owner:self options:nil];
    
    //adding the content view as a subview of class
    [self addSubview:self.detailsView];
    
    //contrain xib so it takes entire view
    self.detailsView.frame = self.bounds;
    
    [self setDelegates];
}

-(void)setDelegates{
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.delegate.appRemote connect];
    [self.delegate.appRemote isConnected];
}

-(void)setView:(Post *)post isFavorited:(BOOL)isFavorited{
    self.post = post;
    self.commentView.post = post;
    NSString *song = self.post.musicLink;
    song = [song substringWithRange:NSMakeRange(31, 22)];
//    [[SpotifyManager shared] getSong:song accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
//        NSArray *artist = song[@"artists"];
//        NSDictionary *insideArtists = artist[0];
//        NSDictionary *songName = song[@"name"];
//        NSDictionary *album = song[@"album"];
//        NSDictionary *albumName = album[@"name"];
//        NSArray *albumImage =album[@"images"];
//        NSDictionary *image = albumImage[0];
//        NSString *imageURL = [NSString stringWithFormat:@"%@", image[@"url"]];
//        [self.albumCoverImageView setImageWithURL:[NSURL URLWithString:imageURL]];
//
//        self.artist = [@"ARTIST: " stringByAppendingFormat:@"%@",insideArtists[@"name"]];
//        self.album = [@"ALBUM: " stringByAppendingFormat:@"%@",albumName];
//        self.songName = [@"SONG: " stringByAppendingFormat:@"%@",songName];
//    }];
    [self.albumCoverImageView setImageWithURL:[NSURL URLWithString:post.albumCoverURLString]];
    self.artist = post.artist;
    self.album = post.album;
    self.songName = post.songName;
    
    self.captionLabel.text = post.caption;
    //    self.backgroundImage.file = self.post.image;
    //    [self.backgroundImage loadInBackground];
    self.moodLabel.text = [@"Mood: " stringByAppendingString:post.mood];
    self.genreLabel.text = [@"Genre: " stringByAppendingString:post.genre];
    self.usernameLabel.text = [@"shared by " stringByAppendingString:post.author.username];
    [self.favoriteButton setSelected:isFavorited];
}

- (IBAction)didTapPlayButton:(id)sender {
//    [self.delegate.appRemote connect];
//    NSString *song = self.post.musicLink;
//    song = [song substringWithRange:NSMakeRange(31, 22)];
//    NSString *songURI = [@"spotify:track:" stringByAppendingString:song];
//    NSLog(@"Song URI: %@", songURI);
    [self playSong:self.post.songURI];
    
}

-(void)playSong:(NSString *)songURI{
    [self.playButton setSelected:!self.playButton.isSelected];
    
    if([self.playButton isSelected]){
        [self.delegate.appRemote.playerAPI play:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"Playing song.");
        }];
    }else{
        [self.delegate.appRemote.playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"Paused Song");
        }];
    }
}

- (IBAction)didTapLike:(id)sender {
    [self.favoriteButton setSelected:!self.favoriteButton.selected];
    User *user = [User currentUser];
    PFRelation *relation = [user relationForKey:@"likes"];
    
    if([self.favoriteButton isSelected]){
        self.post.likesCount +=1;
        [relation addObject:self.post];
    }else{
        self.post.likesCount -=1;
        [relation removeObject:self.post];
    }
    
    [Post updatePost:self.post];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Relation succeded.");
        }else{
            NSLog(@"Error on relation: %@", error.description );
        }
    }];
    
    
    
}



@end
