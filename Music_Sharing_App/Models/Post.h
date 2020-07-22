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
@property (nonatomic, strong) PFUser *author; //change to user class
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *musicLink;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic) int likesCount;
@property (nonatomic) int commentsCount;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic) BOOL favorited;


+ (void) createUserPost: ( NSString *)title
              withGenre: ( NSString *)genre //maybe is required (delete nullable)
               withMood: ( NSString * _Nullable)mood   //maybe is required (delete nullable)
               withLink: ( NSString *)musicLink
            withCaption: ( NSString * _Nullable)caption
              withImage: ( UIImage * _Nullable)image
         withCompletion: ( PFBooleanResultBlock  _Nullable)completion;

+(void)updatePost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
