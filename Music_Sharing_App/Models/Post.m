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
@dynamic musicLink;//
@dynamic caption;//
@dynamic image;//
@dynamic likesCount;
@dynamic commentsCount;
@dynamic genre;//
@dynamic mood;//
@dynamic album;//
@dynamic artist;//
@dynamic songName;//
@dynamic albumCoverURLString;
@dynamic songURI;//

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) createUserPost: ( NSString *)genre 
               withMood: ( NSString *)mood   
               withLink: ( NSString *)musicLink
            withCaption: ( NSString * _Nullable)caption
              withImage: ( UIImage * _Nullable)image
              withAlbum: ( NSString *)albumName
withAlbumCoverURLString: ( NSString *)albumCoverURLString
               withSong: ( NSString *)songName
             withArtist: ( NSString *)artistName
            withSongURI: ( NSString *)songURI
         withCompletion: ( PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.genre = genre;
    newPost.mood = mood;
    newPost.musicLink = musicLink;
    newPost.author = [User currentUser];
    newPost.caption = caption;
    newPost.image = [self getPFFileFromImage:image];
    newPost.album = albumName;
    newPost.albumCoverURLString = albumCoverURLString;
    newPost.songName = songName;
    newPost.artist = artistName;
    newPost.songURI = songURI;
    newPost.likesCount = 0;
    newPost.commentsCount = 0;
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


@end
