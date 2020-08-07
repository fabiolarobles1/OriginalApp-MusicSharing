//
//  ProfileView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/28/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewDelegate;

/**
 *Custum user profile view
 */
@interface ProfileView : UIView
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

///The user the profile is about
@property (strong, nonatomic) User *user;

///Profile View delegate for protocol
@property (weak, nonatomic) id<ProfileViewDelegate> delegate;

/**
 *Updates view with the user's info
 *@param user the user the profile is about
 */
-(void) setWithUser:(User *)user;


@end

@protocol ProfileViewDelegate
/**
 *Sets delegate of the view when selecting in the segmented control
 */
-(void)profileView:(ProfileView *)profileView didTap:(UISegmentedControl *)segmentedControl;
@end

NS_ASSUME_NONNULL_END
