//
//  HomeFeedVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomePostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeFeedVC : UIViewController <PostCellDelegate>

-(void)logout;
-(void)fetchPosts;
-(PFQuery *)defineQuery;
-(void)checkEmptyData:(NSString *)message;
-(void) scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
