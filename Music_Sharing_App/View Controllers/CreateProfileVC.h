//
//  CreateProfileVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/29/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import Parse;


NS_ASSUME_NONNULL_BEGIN

@interface CreateProfileVC : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *profilePicImageButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) UIImage *_Nullable userImage;
@end

NS_ASSUME_NONNULL_END
