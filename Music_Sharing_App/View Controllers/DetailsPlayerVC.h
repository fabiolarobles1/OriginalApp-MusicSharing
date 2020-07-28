//
//  DetailsVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyManager.h"
#import "Post.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailsPlayerVC : UIViewController
@property (strong, nonatomic) Post *post;

-(void)loadDetails;

@end

NS_ASSUME_NONNULL_END
