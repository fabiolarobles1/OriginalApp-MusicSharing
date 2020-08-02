//
//  DetailsView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/21/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "AppDelegate.h"
#import "CommentView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewDelegate;

@interface DetailsView : UIView

@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet PFImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton *songInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet CommentView *commentView;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) id<DetailsViewDelegate> delegate;

-(void)setView:(Post *)post isFavorited:(BOOL)isFavorited;
@end

@protocol DetailsViewDelegate
-(void)detailsView:(DetailsView *)detailsView didTap:(UIButton *)infoButton;
@end

NS_ASSUME_NONNULL_END
