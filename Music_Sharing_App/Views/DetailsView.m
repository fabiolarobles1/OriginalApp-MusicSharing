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
#import <ChameleonFramework/Chameleon.h>
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
    
    //setting colors
    UIColor *appDarkBlue = [UIColor colorWithHexString:@"09F0FA"];
    self.songInfoButton.tintColor = appDarkBlue;
    self.playButton.tintColor = appDarkBlue;
    self.favoriteButton.tintColor = [UIColor colorWithComplementaryFlatColorOf:appDarkBlue];
    
    [self setDelegates];
}

-(void)setDelegates{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate.appRemote connect];
}


-(void)setView:(Post *)post isFavorited:(BOOL)isFavorited{
    self.post = post;
    self.commentView.post = post;
    self.artist = post.artist;
    self.album = post.album;
    self.songName = post.songName;
    self.captionLabel.text = post.caption;
    self.moodLabel.text = [@"Mood: " stringByAppendingString:post.mood];
    self.genreLabel.text = [@"Genre: " stringByAppendingString:post.genre];
    [self.post.author fetchIfNeeded];
    self.usernameLabel.text = [@"shared by " stringByAppendingString:post.author.username];
    [self.favoriteButton setSelected:isFavorited];
    [self.albumCoverImageView setImageWithURL:[NSURL URLWithString:post.albumCoverURLString]];
}

- (IBAction)didTapPlayButton:(id)sender {
    if(![self.appDelegate.appRemote isConnected]){
        [self.appDelegate.appRemote connect];
    }
    [self.playButton setSelected:!self.playButton.isSelected];
    
    [[SpotifyManager shared] playSong:self.post.songURI play:self.playButton.isSelected appDelegate:self.appDelegate];
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
    
    [self.post saveInBackground];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Relation succeded.");
        }else{
            NSLog(@"Error on relation: %@", error.description );
        }
    }];
}


/**
 * Calling delegate of info button
 */
- (IBAction)didTapInfoButton:(id)sender {
    [self.delegate detailsView:self didTap:self.songInfoButton];
}




@end
