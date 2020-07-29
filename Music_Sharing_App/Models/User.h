//
//  User.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//


@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFFileObject *profilePic;
@property (nonatomic, strong) NSString *bio;


+(void)createUser:(NSString *)username
   withProfilePic:( UIImage * _Nullable)image
          withBio:(NSString * _Nullable)bio
withCompletion: ( PFBooleanResultBlock  _Nullable)completion;
   
@end

NS_ASSUME_NONNULL_END
