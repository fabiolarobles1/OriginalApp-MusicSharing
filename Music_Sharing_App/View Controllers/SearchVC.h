//
//  SearchVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/24/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchVC : UIViewController <UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL genreFilter;
@property (nonatomic) BOOL titleFilter;
@property (nonatomic) BOOL moodFilter;
@property (nonatomic) BOOL songFilter;
@property (nonatomic) BOOL artistFilter;
@property (nonatomic) BOOL albumFilter;
@property (nonatomic) BOOL captionFilter;
@property (nonatomic) BOOL usernameFilter;
@property (nonatomic) BOOL filteringActivated;

@end

NS_ASSUME_NONNULL_END
