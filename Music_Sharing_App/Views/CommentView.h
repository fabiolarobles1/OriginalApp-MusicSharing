//
//  CommentView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/23/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommentViewDelegate;

/**
*Custom View with .xib file to create a comment on a post
*/
@interface CommentView : UIView

@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;

///Comment view delegate for protocol
@property (weak, nonatomic) id<CommentViewDelegate> delegate;
@end



@protocol CommentViewDelegate
/**
 *Sets delegate of view when tapping send comment button
 */
-(void)commentView:(CommentView *)commentView didTap:(UIButton *)sendButton;
@end

NS_ASSUME_NONNULL_END
