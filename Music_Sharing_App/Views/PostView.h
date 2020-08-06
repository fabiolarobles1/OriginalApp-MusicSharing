//
//  PostView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN


/**
 *Custom Post View class with .xib file
 */
@interface PostView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;

///The post the view is about
@property (strong, nonatomic) Post *post;

///The user that created the view's post
@property (strong, nonatomic) User *user;

///The date the post was created
@property (strong, nonatomic) NSDate *date;

/**
 *Custom initialization of view to set up properly with the .xib file
 */
-(void)customInit;

/**
 *This method updates the view to display a particular post info.
 *@param post Post object to display in view.
 */
-(void) setWithPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
