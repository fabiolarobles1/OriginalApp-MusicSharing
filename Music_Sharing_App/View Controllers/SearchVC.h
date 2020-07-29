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

@end

NS_ASSUME_NONNULL_END
