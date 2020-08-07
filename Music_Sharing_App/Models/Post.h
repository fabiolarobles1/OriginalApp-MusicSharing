//
//  Post.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *musicLink;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic) int likesCount;
@property (nonatomic) int commentsCount;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *albumCoverURLString;
@property (nonatomic, strong) NSString *songURI;

+ (void) createUserPost: ( NSString *)genre
               withMood: ( NSString *)mood
               withLink: ( NSString *)musicLink
            withCaption: ( NSString * _Nullable)caption
              withImage: ( UIImage * _Nullable)image
              withAlbum: ( NSString *)albumName
withAlbumCoverURLString: (NSString *)albumCoverURLString
               withSong: ( NSString *)songName
             withArtist: ( NSString *)artistName
            withSongURI: ( NSString *)songURI
         withCompletion: ( PFBooleanResultBlock  _Nullable)completion;

- (void) likePost:(BOOL)like;

@end

NS_ASSUME_NONNULL_END
