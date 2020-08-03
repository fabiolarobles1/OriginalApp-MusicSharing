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

@interface ProfileView : UIView
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id<ProfileViewDelegate> delegate;
-(void) setWithUser:(User *)user;


@end

@protocol ProfileViewDelegate
-(void)profileView:(ProfileView *)profileView didTap:(UISegmentedControl *)segmentedControl;
@end

NS_ASSUME_NONNULL_END
