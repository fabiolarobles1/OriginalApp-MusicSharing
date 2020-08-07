//
//  User.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic username;
@dynamic profilePic;
@dynamic bio;


+(void)updateUser:(User *)user
   withProfilePic:(UIImage *)image
          withBio:(NSString *)bio
   withCompletion:(PFBooleanResultBlock)completion{

    if(image!=nil){
        user.profilePic = [self getPFFileFromImage:image];
    }else{
         user.profilePic = nil;
    }
    user.bio = bio;
    [user saveInBackgroundWithBlock:completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
