//
//  ReccommendedVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 8/3/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
