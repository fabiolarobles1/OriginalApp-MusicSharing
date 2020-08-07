//
//  SongInfoVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 8/1/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "RecommendedCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) NSString *songSpotifyURL;
@property (weak, nonatomic) IBOutlet UIButton *addToSpotifyButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) RecommendedCell *senderCell;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) NSString *songURI;
-(void)setWithPost:(Post *)post;

-(void)setWithInfo:(NSString *)songname
            artist:(NSString *)artist
             album:(NSString *)album
           songURI:(NSString *)URI
    albumURLString:(NSString *)albumURLString;

@end

NS_ASSUME_NONNULL_END
