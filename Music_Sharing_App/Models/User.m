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


+(void)createUser:(NSString *)username
   withProfilePic:(UIImage * _Nullable)image
          withBio:(NSString * _Nullable)bio
   withCompletion:(PFBooleanResultBlock _Nullable)completion{
    
    User *newUser = [User new];
    newUser.username = username;
    if(image!=nil){
        newUser.profilePic =  [self getPFFileFromImage:image];
    }else{
         newUser.profilePic =  [self getPFFileFromImage:[UIImage systemImageNamed:@"person.fill"]];
    }
    newUser.bio = bio;
    
    [newUser saveInBackgroundWithBlock:completion];
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
