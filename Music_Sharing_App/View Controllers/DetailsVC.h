//
//  DetailsVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/22/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyManager.h"
#import "Post.h"
#import "DetailsView.h"
#import "CommentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsVC : UIViewController <UITableViewDataSource, DetailsViewDelegate, CommentViewDelegate>
@property (strong, nonatomic) Post *post;
@property (nonatomic) BOOL isFavorited;
@property (weak, nonatomic) IBOutlet DetailsView *detailsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)refreshComments;
@end

NS_ASSUME_NONNULL_END
