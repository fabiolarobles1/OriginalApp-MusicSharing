//
//  ProfilleVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/28/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "HomeFeedVC.h"
#import "HomePostCell.h"
#import "ProfileView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfilleVC : HomeFeedVC<PostCellDelegate>

@property (weak, nonatomic) IBOutlet ProfileView *profileView;

@end

NS_ASSUME_NONNULL_END
