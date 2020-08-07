//
//  User.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//


@import Parse;

NS_ASSUME_NONNULL_BEGIN
/**
 *User object including profile pic and bio
 */
@interface User : PFUser

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFFileObject *_Nullable profilePic;
@property (nonatomic, strong) NSString *bio;

/**
 *Updates the user info on the database
 */
+(void)updateUser:(User *)user
   withProfilePic:( UIImage * _Nullable)image
          withBio:(NSString * _Nullable)bio
withCompletion: ( PFBooleanResultBlock  _Nullable)completion;

/**
 *Gets File from an image
 */
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
