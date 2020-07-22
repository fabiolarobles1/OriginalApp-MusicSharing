//
//  Post.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic createdAt;
@dynamic userID;
@dynamic author;
@dynamic title;
@dynamic musicLink;
@dynamic caption;
@dynamic image;
@dynamic likesCount;
@dynamic commentsCount;
@dynamic genre;
@dynamic mood;
@dynamic favorited;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) createUserPost: ( NSString *)title
              withGenre: ( NSString *)genre 
               withMood: ( NSString * _Nullable)mood   //maybe is required (delete nullable)
               withLink: ( NSString *)musicLink
            withCaption: ( NSString * _Nullable)caption
              withImage: ( UIImage * _Nullable)image
         withCompletion: ( PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.title = title;
    newPost.genre = genre;
    newPost.mood = mood;
    newPost.musicLink = musicLink;
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.image = [self getPFFileFromImage:image];
    newPost.likesCount = 0;
    newPost.commentsCount = 0;
    newPost.favorited = NO;
    [newPost saveInBackgroundWithBlock: completion];
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

+(void)updatePost:(Post *)post{
    [post saveInBackground];
}
@end
