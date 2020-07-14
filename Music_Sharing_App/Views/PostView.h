//
//  PostView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostView : UIView

-(void)customInit;
-(void) setWithPost:(Post *)post;


@end

NS_ASSUME_NONNULL_END
