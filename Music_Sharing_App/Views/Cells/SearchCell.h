//
//  SearchCell.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/24/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"
#import "HomePostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : HomePostCell
//@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet PostView *postView;

@end

NS_ASSUME_NONNULL_END
