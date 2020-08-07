//
//  Comment.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/23/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//


#import "User.h"
#import "Post.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *Comment object
 */
@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
