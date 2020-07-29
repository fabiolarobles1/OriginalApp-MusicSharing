//
//  PostCell.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface HomePostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet PostView *postView;
@property (weak, nonatomic) id<PostCellDelegate> delegate;

- (void) didTapPost:(UITapGestureRecognizer *)sender;
@end

@protocol PostCellDelegate
-(void)postCell:(HomePostCell *) postCell didTap:(Post *)post;
@end



NS_ASSUME_NONNULL_END
