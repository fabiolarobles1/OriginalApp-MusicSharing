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

@interface SongInfoVC ()
@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation SongInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWithPost:self.post];

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
    [self.appDelegate.appRemote.userAPI addItemToLibraryWithURI:self.post.songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"Error adding song: %@", error.description);
        }else{
            //show notification on screen
            NSLog(@"Added song to library");
        }
        
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
