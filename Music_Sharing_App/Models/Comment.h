//
//  Comment.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/23/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
