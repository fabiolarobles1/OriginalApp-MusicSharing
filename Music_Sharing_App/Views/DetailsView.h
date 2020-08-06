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

/**
 *Custom Details View of Post with .xib file
 */
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

///The post the view is about
@property (strong, nonatomic) Post *post;

///App Delegate to get spotify session instance
@property (strong, nonatomic) AppDelegate *appDelegate;

///Details view delegate for protocol
@property (weak, nonatomic) id<DetailsViewDelegate> delegate;

/**
 *This methods sets the details view with the post information, including the liked by user.
 *@param post Post object to display view
 *@param isFavorited YES if post is liked by user and NO otherwise
 */
-(void)setView:(Post *)post isFavorited:(BOOL)isFavorited;
@end


@protocol DetailsViewDelegate

/**
 *Sets delegate of the view when tapping the info button
 */
-(void)detailsView:(DetailsView *)detailsView didTap:(UIButton *)infoButton;
@end

NS_ASSUME_NONNULL_END
